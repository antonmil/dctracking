function [metrics2d, metrics3d, stateInfo, sceneInfo] =...
    runDPonScen(scenario, conffile)

addPaths;
global opt sceneInfo detections gtInfo
% prepare sequence
opt=readDCOptions('config/default2d.ini');

sceneInfo=getSceneInfo(scenario,opt);
[detections, nPoints]=parseDetections(sceneInfo);
[detections, nPoints]=cutDetections(detections,nPoints,sceneInfo, opt);

% fill in empty output
[metrics2d, metrics3d]=getMetricsForEmptySolution();
stateInfo=getStateForEmptySolution(sceneInfo,opt);
F = length(sceneInfo.frameNums);
frames=1:F;


% get DP options
options = parseDPOptions(conffile); 

% datadir  = 'data/';
cachedir = 'cache/';
if ~exist(cachedir,'dir'), mkdir(cachedir);end
vid_name = sceneInfo.sequence;
dres=detectionsToPirsiavash(detections);
%%% Adding transition links to the graph by fiding overlapping detections in consequent frames.
display('in building the graph...')
% fname = [cachedir vid_name '_graph_res.mat'];
dres = build_graph(dres);

if options.mode == 1
    display('in DP tracking ...')
    tic
    dres_dp       = tracking_dp(dres, options.c_en, options.c_ex, options.c_ij, options.betta, options.thr_cost, options.max_it, 0);
    dres_dp.r     = -dres_dp.id;
    toc
elseif options.mode == 2
    tic
    display('in DP tracking with nms in the loop...')
    dres_dp_nms   = tracking_dp(dres, options.c_en, options.c_ex, options.c_ij, options.betta, options.thr_cost, options.max_it, 1);
    dres_dp_nms.r = -dres_dp_nms.id;
    toc
end

%%
fnum = max(dres.fr);
bboxes_tracked = dres2bboxes(dres_dp_nms, fnum);  %% we are visualizing the "DP with NMS in the lop" results. Can be changed to show the results of DP or push relabel algorithm.
% quick hack
% if scenario==72
%     bboxes_tracked(201).bbox=[];
% end
%% pad rest
if length(bboxes_tracked)<F
    for pp=length(bboxes_tracked)+1:F
        bboxes_tracked(pp).bbox=[];
    end
end


% bboxes_tracked
% sceneInfo
stateInfo=boxesToStateInfo(bboxes_tracked,sceneInfo);

stateInfo=postProcessState(stateInfo);
stateInfo.sceneInfo=sceneInfo;
stateInfo.opt = opt;
% myopt.conOpt

opt=getAuxOpt('aa',opt,sceneInfo,stateInfo.F);
alldpoints=createAllDetPoints(detections);
stateInfo.splines=getSplinesFromGT(stateInfo.X,stateInfo.Y,frames,alldpoints,stateInfo.F);
stateInfo.labeling=getGreedyLabeling(alldpoints,stateInfo.splines,stateInfo.F);
stateInfo.outlierLabel=length(stateInfo.splines)+1;
stateInfo.opt = opt;

[metrics2d, metrics3d]=printFinalEvaluation(stateInfo, gtInfo, sceneInfo, opt);

end