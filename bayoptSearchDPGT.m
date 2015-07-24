function result = bayoptSearchDP(params)

cd('/home/amilan/research/projects/dctracking')
% grid search
global sceneInfo detections opt gtInfo
addpath(genpath('.'));
addpath(genpath('../motutils'));

allscen=2200+[23,25,27,71,72,42];  % raw detections


% scenario=2127;
% allscen = [2172,2142]
expcnt=0;
allexp=[];


% defaults
% c_en      = 5;     %% birth cost
% c_ex      = 5;     %% death cost
% c_ij      = .1;      %% transition cost
% betta     = 0.2;    %% betta
% max_it    = Inf;    %% max number of iterations (max number of tracks)
% thr_cost  = 18;     %% max acceptable cost for a track (increase it to have more tracks.)


pirOpt=getPirOptions;

%%% setting parameters for tracking
pirOpt.c_en      = params(1);     %% birth cost
pirOpt.c_ex      = params(2);     %% death cost
pirOpt.c_ij      = params(3);      %% transition cost
pirOpt.betta     = params(4);    %% betta
pirOpt.max_it    = Inf;    %% max number of iterations (max number of tracks)
pirOpt.thr_cost  = params(5);     %% max acceptable cost for a track (increase it to have more tracks.)

pirOpt

expcnt=0;
scnt=0;
for scenario=allscen
    scnt=scnt+1;
    sceneInfo=getSceneInfo(scenario);
    detections=parseDetections(sceneInfo);
    conffile='config/default3d.ini';
    opt=readDCOptions(conffile);
    opt=getAuxOpt(conffile,opt,sceneInfo,length(sceneInfo.frameNums));
    opt.track3d=howToTrack(scenario);
    
    stateInfo=runDP(detections,pirOpt,opt);
    if opt.track3d
        [stateInfo.X,stateInfo.Y]=projectToGroundPlane(stateInfo.Xi,stateInfo.Yi,sceneInfo);
        stateInfo.Xgp=stateInfo.X;stateInfo.Ygp=stateInfo.Y;
    end
    % evaluate
    [metrics2d, metrics3d]=printFinalEvaluation(stateInfo, gtInfo, sceneInfo, opt);
    
    allexp(scnt).pirOpt=pirOpt;
    allexp(scnt).m2d=metrics2d;
    allexp(scnt).m3d=metrics3d;
    allexp(scnt).scenario = scenario;
    allexp(scnt).stateInfo = stateInfo;
    allexp(scnt).sceneInfo = sceneInfo;
end
resdir='external/dptracking/bayesoptGT/';
resfiles = dir(resdir)
resfile=sprintf('%s/j%05d.mat',resdir,numel(resfiles)+1);
if ~exist('resdir','dir'), mkdir(resdir); end
fprintf('saving to %s...\n',resfile);
save(resfile,'allexp');

% final result is negative MOTA because of minimizing
mets2d = reshape([allexp(:).m2d],14,scnt)';
mets3d = reshape([allexp(:).m3d],14,scnt)';

% allexp
% mets3d

metrics2d = mean(mets2d)
metrics3d = mean(mets3d)

% metrics3d
result = metrics2d(12)
if opt.track3d, result=metrics3d(12); end


result = 1 - result / 100

end
