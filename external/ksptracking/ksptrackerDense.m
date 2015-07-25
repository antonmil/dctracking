%% ksptracker
function [metrics2d, metrics3d, stateInfo]=ksptrackerDense(scenario, params)
addpath('/home/amilan/research/projects/contracking/');
addpath('/home/amilan/research/projects/ilptracking/');
addpath(genpath('/home/amilan/research/projects/motutils/'));

kspfolder=[getHomeFolder '/research/external/ksptracking'];
cd(kspfolder);


global detections sceneInfo opt gtInfo
opt.cutToTA=1; opt.track3d=1;
sceneInfo=getSceneInfo(scenario-2100);

%% load detections
detections=parseDetections(sceneInfo); 

outdir=sprintf('output/s%04d',scenario);
if ~exist(outdir,'dir'),    mkdir(outdir);end

indir=sprintf('input/s%04d',scenario);
if ~exist(indir,'dir'),    mkdir(indir);end

detdir=fullfile(indir,'detmaps');
if ~exist(detdir,'dir'),    mkdir(detdir);end
% sceneInfo.targetSize=750;
frameNums=sceneInfo.frameNums;

gridType=1; % rectangular
[gridX, gridY]=computeGridSize(sceneInfo, gridType);
GridPositions=generateGridPositions(gridX,gridY,gridType);
[WorldPositionsOnGrid, areaLimits]= ...
    generateWorldPositionsOnGrid(GridPositions,sceneInfo.targetSize,sceneInfo.trackingArea(1),sceneInfo.trackingArea(3));
ImagePositionsOnGrid=generateImagePositionsOnGrid(WorldPositionsOnGrid,sceneInfo);
    F=length(frameNums);
    gridX=size(WorldPositionsOnGrid,1); gridY=size(WorldPositionsOnGrid,2);
    numcells=gridX*gridY;

load(sprintf('input/Detmap-s%04d',scenario-2100));
Detmaps=DetMap;
maxDet=max(Detmaps(:));
% Detmaps=Detmaps./maxDet;

% load(getGriddataFile(scenario,1));
    F=length(frameNums);
    gridX=size(WorldPositionsOnGrid,1); gridY=size(WorldPositionsOnGrid,2);
    numcells=gridX*gridY;


    % Detmaps=generateDetmaps(WorldPositionsOnGrid,detections,sceneInfo,params(3));
    Detmaps(isnan(Detmaps))=0;


sigA=0; sigB=1;
if nargin>1
    sigA=params(1); sigB=params(2);
	
end
[sigA, sigB]
Detmaps = 1./ (1 + exp(-sigB * Detmaps + sigA*sigB));
[min(Detmaps(:)), mean(Detmaps(:)), max(Detmaps(:))]

fprintf('Parameters\n');
params

for t=0:F-1
    if ~mod(t,10), fprintf('.'); end
    fname=fullfile(detdir,sprintf('frame-%04d.dat',t));
%	if ~exist(fname,'file')
    dets=Detmaps(:,:,t+1);
    detim=imresize(dets,10,'nearest'); detim=imrotate(detim,90);
    %         clf;  imshow(detim); pause(0.01);
    A=[(1:numcells)' reshape(dets,numcells,1)];
    dlmwrite(fname,A,' ');
%	end
    %     sum(A(:,2)),    pause(.01)
end
fprintf('\n');

%% prepare ksp
fprintf('Preparing KSP config\n')
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


kspfile=fullfile('input',sprintf('s%04d.ksp',scenario));
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

%% tracking
fprintf('Running KSP...\n')
outfile=fullfile('output',sprintf('s%04d.dat',scenario));
comnd=sprintf('./ksp -o %s %s',outfile,kspfile);
eval(sprintf('!%s',comnd))


%%
fprintf('Writing result\n')
fid=fopen(outfile);
out2file=fullfile('output',sprintf('s%04d-2.dat',scenario));
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
fprintf('Project back to image\n')
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
stateInfo.frameNums=frameNums;
stateInfo.targetsExist=getTracksLifeSpans(X);
stateInfo=matricesToVector(X,Y,stateInfo);

stateInfo.Xgp=stateInfo.X; stateInfo.Ygp=stateInfo.Y;
[stateInfo.Xi, stateInfo.Yi]=projectToImage(stateInfo.X,stateInfo.Y,sceneInfo);


% get bounding boxes from corresponding detections
% stateInfo=getBBoxesFromStateVector(stateInfo);

stateInfo.opt.track3d=1;stateInfo.opt.cutToTA=1;
stateInfo=postProcessState(stateInfo);



%%
metfile=sprintf('%s/output/s%04d/metrics.txt',kspfolder,scenario);
[metrics2d, metrics3d]=printFinalEvaluation(stateInfo, gtInfo, sceneInfo, opt, [0,1]);
infos(scenario).stateInfo=stateInfo;
mets3d(scenario,:)=metrics3d;

% % metfile=sprintf('%s/output/s%04d/metrics-allentry.txt',kspfolder,scenario);
% cd ~/visinf/projects/ongoing/contracking/utils
% if sceneInfo.gtAvailable
%     global gtInfo
% %     cutGTToTrackingArea;
%     printMessage(1,'\nEvaluation 3D:\n');
%     evopt.eval3d=1;
%
%     [metrics metricsInfo]=CLEAR_MOT(gtInfo,stateInfo,evopt);
%     printMetrics(metrics,metricsInfo,1);
%
%     fprintf('\\textbf{%s} & KSP \\cite{Berclaz2011PAMI} & %.1f & %.1f & %d & %d & %d & %d & %d & %d & %d & %.1f & %.1f & %.2f \\\\ \n', ...
%         getSequenceFromScenario(scenario),metrics(12),metrics(13), metrics(4),metrics(5),metrics(7), ...
%         metrics(8),metrics(9),metrics(10),metrics(11),metrics(1),metrics(2),metrics(3));
%     dlmwrite(metfile,metrics);
% end
% cd(kspfolder);
% end
%%
% for t=1:F
%     clf
% %     xlim([0 gridX+1]); ylim([0 gridY+1]);
%     xlim(areaLimits(1:2));ylim(areaLimits(3:4));
%     hold on
%     extar=find(B(t,:));
%     for id=extar
%         [x y]=ind2sub([gridX gridY],B(t,id));
%         xw=WorldPositionsOnGrid(x,y,1);yw=WorldPositionsOnGrid(x,y,2);
%         X(t,xw_
%         plot(xw,yw,'.','color',getColorFromID(id));
%     end
%     pause(.01);
% end

