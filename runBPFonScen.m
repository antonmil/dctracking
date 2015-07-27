function [metrics2d, metrics3d, stateInfo, sceneInfo] =...
    runDPonScen(scenario, conffile)

addPaths;

global opt sceneInfo detections gtInfo obj
% prepare sequence
opt=readDCOptions('config/default2d.ini');

opt.track3d=howToTrack(scenario); opt.cutToTA=0;
sceneInfo=getSceneInfo(scenario,opt);
[detections, nPoints]=parseDetections(sceneInfo);
[detections, nPoints]=cutDetections(detections,nPoints,sceneInfo, opt);

% fill in empty output
[metrics2d, metrics3d]=getMetricsForEmptySolution();
stateInfo=getStateForEmptySolution(sceneInfo,opt);
F = length(sceneInfo.frameNums);
frames=1:F;


% get BPF options
options = parseBPFOptions(conffile); 

fprintf('Okuma BPF 1.3\n');
options

%%
[~,hname]=system('hostname'); hname=hname(1:end-1);
dv = datevec(now);
uname = sprintf('%02d',round(dv(2:end))); uname=[uname,'-',hname];
detfile = fullfile('external','bpftracking','dets'); if ~exist(detfile,'dir'), mkdir(detfile); end
detfile = fullfile(detfile,sprintf('%s-s%04d.txt',uname,scenario));
saveDetectionsTXT(detections,detfile);


obj=TrackerBPF;
obj=set(obj, ...
    'BPF_alpha', options.BPFalpha, ...
    'abc_lambda',options.abclambda, ...
    'pc_num', options.pcnums);

obj=set(obj, ...
    'online_detector',0, ...
    'img_width',sceneInfo.imgWidth, ...
    'img_height',sceneInfo.imgHeight, ...
    'box_height',128,'box_width',64, ...
    'max_num_targets',256, ...
    'detfile', detfile ...
    );
obj
mydemo(obj, ...
    'name', 'test1', ...
    'BPF_alpha', options.BPFalpha, ...
    'abc_lambda',options.abclambda, ...
    'pc_num', options.pcnums);
obj

global objhist
stateInfo = resultToXY(objhist);
stateInfo.opt = options;
stateInfo.sceneInfo = sceneInfo;
% stateInfo.frameNum
% pad if not long enough
% if size(stateInfo.X,1)<F
gtInfo=cropFramesFromGT(sceneInfo,gtInfo,frames(2:end),opt);
[metrics2d, metrics3d]=printFinalEvaluation(stateInfo, gtInfo, sceneInfo, opt);

%%
% clean up
delete(detfile)

%         resultToXY;
end
