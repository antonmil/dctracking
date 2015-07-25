function [metrics2d, metrics3d, stateInfo, sceneInfo] =...
    runKSPonScen(scenario, conffile)

addPaths;
global opt sceneInfo detections gtInfo
% prepare sequence
opt=readDCOptions('config/default2d.ini');

opt.track3d=1; opt.cutToTA=1;
sceneInfo=getSceneInfo(scenario,opt);
[detections, nPoints]=parseDetections(sceneInfo);
[detections, nPoints]=cutDetections(detections,nPoints,sceneInfo, opt);
F = length(sceneInfo.frameNums); frames=1:F;

% get KSP options
options = parseKSPOptions(conffile); 

% load detections
detections=parseDetections(sceneInfo); 

% sigmoidify
% for t=1:F
    % detections(t).sc = 1./ (1 + exp(-options.sigB * detections(t).sc + options.sigA*options.sigB));
% end

% unique folder (date-host) for parallel cluster jobs
[~,hname]=system('hostname'); hname=hname(1:end-1);
dv = datevec(now);
ufol = sprintf('%02d',round(dv(2:end))); ufol=[ufol,'-',hname];

outdir=sprintf('external/ksptracking/output/%s/s%04d',ufol,scenario);
if ~exist(outdir,'dir'),    mkdir(outdir);end
indir=sprintf('external/ksptracking/input/%s/s%04d',ufol,scenario);
if ~exist(indir,'dir'),    mkdir(indir);end
detdir=fullfile(indir,'detmaps');
if ~exist(detdir,'dir'),    mkdir(detdir);end


% fill in empty output
[metrics2d, metrics3d]=getMetricsForEmptySolution();
stateInfo=getStateForEmptySolution(sceneInfo,opt);


sceneInfo.targetSize=350;
gridType=1; % rectangular
[gridX, gridY]=computeGridSize(sceneInfo, gridType);
GridPositions=generateGridPositions(gridX,gridY,gridType);
[WorldPositionsOnGrid, areaLimits]= ...
    generateWorldPositionsOnGrid(GridPositions,sceneInfo.targetSize,sceneInfo.trackingArea(1),sceneInfo.trackingArea(3));
ImagePositionsOnGrid=generateImagePositionsOnGrid(WorldPositionsOnGrid,sceneInfo);

gridX=size(WorldPositionsOnGrid,1); gridY=size(WorldPositionsOnGrid,2);
numcells=gridX*gridY;

% if forced to recomputde
if isfield(options,'forceDM')
	Detmaps=generateDetmaps(WorldPositionsOnGrid,detections,sceneInfo,options.SIG);
else
	detmapfile=sprintf('external/ksptracking/detmaps/Detmap-s%04d',scenario);
	load(detmapfile);
	Detmaps = DetMap;
end
	
Detmaps = 1./ (1 + exp(-options.sigB * Detmaps + options.sigA*options.sigB));
Detmaps(isnan(Detmaps))=0;

fprintf('Parameters\n');
options

for t=0:F-1
    if ~mod(t,10), fprintf('.'); end
    fname=fullfile(detdir,sprintf('frame-%04d.dat',t));
    dets=Detmaps(:,:,t+1);
    % detim=imresize(dets,10,'nearest'); detim=imrotate(detim,90);
%         clf;  imshow(detim); pause(0.01);
    A=[(1:numcells)' reshape(dets,numcells,1)];
    dlmwrite(fname,A,' ');
%     sum(A(:,2)),    pause(.01)
end
fprintf('\n');

%% prepare ksp
locs=gridX*gridY;
siz=[gridX gridY];
topidx = sub2ind(siz,2:gridX-1,gridY*ones(1,gridX-2));
bottomidx = sub2ind(siz,2:gridX-1,ones(1,gridX-2));
leftidx = sub2ind(siz,ones(1,gridY-2),2:gridY-1);
rightidx = sub2ind(siz,gridX*ones(1,gridY-2),2:gridY-1);
llcorner = sub2ind(siz,1,1);
lrcorner = sub2ind(siz,gridX,1);
ulcorner = sub2ind(siz,1,gridY);
urcorner = sub2ind(siz,gridX,gridY);
border = [llcorner leftidx ulcorner topidx urcorner rightidx lrcorner bottomidx]-1;
% border=0:locs-1;

kspfile=fullfile(indir,sprintf('s%04d.ksp',scenario));
fidout=fopen(kspfile,'w');
fprintf(fidout,'GRID %d %d\n',gridX,gridY);
fprintf(fidout,'FRAMES %d %d\n',0,F-1);
fprintf(fidout,'ACCESS_POINTS ');
fprintf(fidout,'%d,',border(1:end-1));
fprintf(fidout,'%d\n',border(end));
fprintf(fidout,'DEPTH 1\n');
fprintf(fidout,'MAX_TRAJ 255\n');
informat=fullfile(indir,'detmaps','frame-%04d.dat');
fprintf(fidout,'INPUT_FORMAT %s\n',informat);
fclose(fidout)

%% tracking
outfile=fullfile(outdir,sprintf('s%04d.dat',scenario));
comnd=sprintf('./external/ksptracking/ksp -o %s %s',outfile,kspfile);
eval(sprintf('!%s',comnd))

%%
fid=fopen(outfile);
out2file=fullfile(outdir,sprintf('s%04d-2.dat',scenario));
fid2=fopen(out2file,'w');
tline = fgetl(fid);
N=sscanf(tline,'%i',1);
while ischar(tline)    
    tline = fgetl(fid);
    fprintf(fid2,'%s\n',tline);
%     pause
end
fclose(fid);
fclose(fid2);


B=dlmread(out2file,'\t');

B=B(:,2:N+1);
B=B+1;
F=size(B,1);

%% 
clear stateInfo
X=zeros(size(B)); Y=zeros(size(B));
for t=1:F
    extar=find(B(t,:));
    for id=extar
        [x y]=ind2sub([gridX gridY],B(t,id));
        X(t,id)=WorldPositionsOnGrid(x,y,1);Y(t,id)=WorldPositionsOnGrid(x,y,2);
    end
end
stateInfo.X=X; stateInfo.Y=Y;
[stateInfo.F, stateInfo.N]=size(X);
stateInfo.frameNums=sceneInfo.frameNums;
stateInfo.targetsExist=getTracksLifeSpans(X);
stateInfo=matricesToVector(X,Y,stateInfo);

stateInfo.Xgp=stateInfo.X; stateInfo.Ygp=stateInfo.Y;
[stateInfo.Xi, stateInfo.Yi]=projectToImage(stateInfo.X,stateInfo.Y,sceneInfo);


% get bounding boxes from corresponding detections
% stateInfo=getBBoxesFromStateVector(stateInfo);

stateInfo.opt.track3d=1;stateInfo.opt.cutToTA=1;
stateInfo=postProcessState(stateInfo);


%%
metfile=sprintf('%s/metrics.txt',outdir);
[metrics2d, metrics3d]=printFinalEvaluation(stateInfo, gtInfo, sceneInfo, opt);
% infos(scenario).stateInfo=stateInfo;
% mets3d(scenario,:)=metrics3d;

% clearn up (remove temp files)
scendir=sprintf('%s/s%04d',ufol,scenario);
rmdir(fullfile('external','ksptracking','input',scendir),'s')
rmdir(fullfile('external','ksptracking','output',scendir),'s')


end