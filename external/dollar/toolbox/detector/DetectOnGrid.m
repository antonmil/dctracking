%%
addpath(genpath('d:\research\projects\ilptracking'));
addpath(genpath('../../../../../motutils'));

global opt
opt.track3d=1; opt.cutToTA=1;


allscen=[23 25 27 71 72 42];
% scenario=23;
% allscen=42;
for scenario=allscen
sceneInfo=getSceneInfo(scenario);


load('models/AcfInriaDetector.mat')

% detScale=1;
detScale=0.6;

blowUp=1;
fprintf('RESCALING DETECTOR: %f\n',detScale);
detector = acfModify(detector,'rescale',detScale);
detector.opts.pNms.type='none';
detector.opts.pNms.thr=-100;
detector.opts.cascThr = -Inf;
% detector.opts.pPyramid.pChns.shrink=1;
detector.opts.pPyramid.nPerOct = 1;
% detector.opts.pPyramid.nApprox = 1;
% detector.opts.stride = 1;

gridType=1; % rectangular
[gridX, gridY]=computeGridSize(sceneInfo, gridType);
GridPositions=generateGridPositions(gridX,gridY,gridType);
[WorldPositionsOnGrid, areaLimits]= ...
    generateWorldPositionsOnGrid(GridPositions,sceneInfo.targetSize, ...
    sceneInfo.trackingArea(1),sceneInfo.trackingArea(3));

% get image coordinates for all grid crops

[left,top,right,bottom]=getPersonCrop(WorldPositionsOnGrid,sceneInfo);

pPad=.2;

[rowCells,colCells,~]=size(WorldPositionsOnGrid);
F=length(sceneInfo.frameNums);
imscale=1.5;
left=left*imscale;
top=top*imscale;
right=right*imscale;
bottom=bottom*imscale;

widths=right-left; heights=bottom-top;
DetMap=zeros(rowCells,colCells,F);
    
for t=1:F
    % t=1;
    
    img=getFrame(sceneInfo,t);
    img=imresize(img,imscale,'bilinear');
%     img=imPad(img,50,'replicate');
    

    cnt=0;
    for y=1:colCells
        for x=1:rowCells
            extBox=(mean([widths(x,y),heights(x,y)])*pPad);
            
            
            imgc=imcrop(img,[left(x,y)-extBox,top(x,y)-extBox,widths(x,y)+2*extBox,heights(x,y)+2*extBox]);
%             rectangle('Position',[left(x,y)-extBox,top(x,y)-extBox,widths(x,y)+2*extBox,heights(x,y)+2*extBox]);
%             pause
            try
%                 imgc=imresize(imgc,1.5,'bilinear');
                bbx = acfDetect(imgc,detector);
                
                verbose = 0;
                if verbose
                    foundBoxes = size(bbx,1);
                    fprintf('%d boxes found\n',foundBoxes)
                    if foundBoxes > 0
                    
                        % find all overlaps
                        biou=zeros(1,foundBoxes);
                        for b=1:foundBoxes
                            biou(b) = boxiou(bbx(b,1), bbx(b,2), bbx(b,3), bbx(b,4), 1, 1, size(imgc,2), size(imgc,1));
                        end
                        
                        % closest to full window (max IoU)
                        [maxbiou, bestbox]=max(biou);
                        fprintf('best fit (%.1f %%): %.1f %.1f %.1f %.1f - %.1f\n',maxbiou*100, ... 
                            bbx(bestbox,1),bbx(bestbox,2),bbx(bestbox,3),bbx(bestbox,4),bbx(bestbox,5))
                        
                        % if several, closest to center
                        closestBoxes = find(biou==maxbiou)';
                        nClosestBoxes = numel(closestBoxes);
                        if nClosestBoxes > 1
                            % center of subwindow
                            cx=size(imgc,2)/2; cy=size(imgc,1)/2; 
                            cx = repmat(cx,nClosestBoxes,1); cy = repmat(cy,nClosestBoxes,1);
                            
                            % center of all bboxes
                            bcx = bbx(closestBoxes,1) + bbx(closestBoxes,3)/2;
                            bcy = bbx(closestBoxes,2) + bbx(closestBoxes,4)/2;
                            
                            % distances squared
                            D = (bcx - cx).^2 + (bcy - cy).^2;
                            [cl,cli]=min(D);
                            bestbox = closestBoxes(cli);
%                             D
%                             pause
                        end
                        
                        % draw box
                        clf;
                        imshow(imgc);
%                         bbApply('draw',bbx);
                        rectangle('Position',bbx(bestbox,1:4),'EdgeColor','g','linewidth',2)
                        text(bbx(bestbox,1)+5,bbx(bestbox,2)+5,sprintf('%.2f',bbx(bestbox,5)),'color','w');
                        pause

                    end
                end  
                if size(bbx,1)>=1                    
                    DetMap(x,y,t)=bbx(1,5);
                end
                cnt=cnt+1;
            catch err
%                 fprintf('Detector failed: %s\n',err.message);
%                 pause
            end
        end
        if ~mod(y,10), fprintf('.'); end
    end
%     cnt
%     x*y
    
%     thisDM=DetMap(:,:,t);
%     imshow(flipud(thisDM),[min(thisDM(:)),max(thisDM(:))])
%     pause
    fprintf('\n');
end
%%

save(sprintf('data/20150722/Detmap-s%04d.mat',scenario),'DetMap');

end

%% remove zeros, i.e. set to min, and make zero mean
for scenario=allscen
    load(sprintf('data/20150722/raw/Detmap-s%04d.mat',scenario));
    DetMap(DetMap==0)=min(DetMap(:));
    DetMap = DetMap - mean(DetMap(:));
    save(sprintf('data/20150722/Detmap-s%04d.mat',scenario),'DetMap');
end