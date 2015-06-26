function result = matlab_wrapper(job_id, params)

cd('/home/amilan/research/projects/dctracking')
% grid search
global sceneInfo detections opt gtInfo
addpath(genpath('.'));
addpath(genpath('../motutils'));

allscen=2100+[23,25,27,71,72,42];  % raw detections


% scenario=2127;
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
pirOpt.c_en      = params.c_en;     %% birth cost
pirOpt.c_ex      = params.c_ex;     %% death cost
pirOpt.c_ij      = params.c_ij;      %% transition cost
pirOpt.betta     = params.betta;    %% betta
pirOpt.max_it    = Inf;    %% max number of iterations (max number of tracks)
pirOpt.thr_cost  = params.thr_cost;     %% max acceptable cost for a track (increase it to have more tracks.)

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

resfile=sprintf('external/dptracking/gridSearchRaw/j%d.mat',job_id);
save(resfile,'allexp');

% final result is negative MOTA because of minimizing
mets2d = reshape([allexp(:).m2d],14,scnt)';
mets3d = reshape([allexp(:).m3d],14,scnt)';

% allexp
% mets3d

metrics2d = mean(mets2d);
metrics3d = mean(mets3d);
% metrics3d
result = -metrics2d(12);
if opt.track3d, result=-metrics3d(12); end

end
