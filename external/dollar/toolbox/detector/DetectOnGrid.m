%%
addpath(genpath('d:\research\projects\ilptracking'));
addpath(genpath('../../../../../motutils'));

global opt
opt.track3d=1; opt.cutToTA=1;


% allscen=[23 25 27 71 72];
% scenario=23;
allscen=42;
for scenario=allscen
sceneInfo=getSceneInfo(scenario);


load('models/AcfInriaDetector.mat')

% detScale=1;
detScale=0.6;

blowUp=1;
fprintf('RESCALING DETECTOR: %f\n',detScale);
detector = acfModify(detector,'rescale',detScale);


gridType=1; % rectangular
[gridX, gridY]=computeGridSize(sceneInfo, gridType);
GridPositions=generateGridPositions(gridX,gridY,gridType);
[WorldPositionsOnGrid, areaLimits]= ...
    generateWorldPositionsOnGrid(GridPositions,sceneInfo.targetSize, ...
    sceneInfo.trackingArea(1),sceneInfo.trackingArea(3));

% get image coordinates for all grid crops

[left,top,right,bottom]=getPersonCrop(WorldPositionsOnGrid,sceneInfo);

pPad=.0;

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
%                         clf;
%                         imshow(imgc);
%                         bbApply('draw',bbx);
%                         pause
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

save(sprintf('data/Detmap-s%04d.mat',scenario),'DetMap');

end