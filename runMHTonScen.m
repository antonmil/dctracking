function [metrics2d, metrics3d, stateInfo, sceneInfo] =...
    runMHTonScen(scenario, conffile)

addPaths;
%% Configuration
tracker_instalation_path = eval('pwd');
tracker_instalation_path=[tracker_instalation_path,filesep,'external',filesep,'mhttracking'];
edge_treshold = 0.35; % The lower the value, the more edges are detected
morphological_closing_square_size = 5; % The value should be greater if the targets are bigger
binary_threshold = 0.5; % The threshold for creating the binary image
min_blob_area = 100; % Minimum blob area
use_blob_colors = false;
%% Add required files to java classpath
files= {
    'dist/lib/collections-generic-4.01.jar'
    'dist/lib/jaxb-api.jar'
    'dist/lib/jung-algorithms-2.0.jar'
    'dist/lib/jung-graph-impl-2.0.jar'
    'dist/lib/jung-visualization-2.0.jar'
    'dist/lib/junit-4.5.jar'
    'dist/lib/LisbonMHL-1.0.jar'
    'dist/lib/log4j-1.2.15.jar'
    'dist/lib/MHL2.jar'
    'dist/lib/Murty.jar'
    'dist/MatlabExampleApp.jar'};

for i=1:length(files)
    eval(['javaaddpath ' tracker_instalation_path '/' files{i}]);
end



global opt sceneInfo detections gtInfo
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
options = parseMHTOptions(conffile); 

fprintf('MHT\n');
options

% Create tracker

tracker = com.multiplehypothesis.simpletracker.tracker.MTracker(...
    options.maxNumLeaves,... % int maxNumLeaves
    options.maxDepth,... % int maxDepth
    options.timeUndetected,... % int timeUndetected
    options.bestK,... % int bestK
    options.probUndetected,... % double probUndetected
    options.probNewTarget,... % double probNewTarget
    options.probFalseAlarm,... % double probFalseAlarm
    options.gateSize ... % double gateSize
    );




%% Tracking loop
% do 10 runs to mitigate randomness influence
nruns = 10;
allm2d=zeros(nruns,14);allm3d=zeros(nruns,14);
for r=1:nruns
    alltars={};
    fprintf(1, 'Starting tracking...\n');
    for i=1:length(frames)

        if ~mod(i,10), fprintf('.'); end

        dets=[detections(i).xp' detections(i).yp'];

        targets = tracker.newScan(dets);
        alltars{i}=targets;

    end

    stateInfo=getStateInfo(alltars);
    stateInfo.frameNums=sceneInfo.frameNums;
    stateInfo.opt=options;
    stateInfo.sceneInfo=sceneInfo;

    [F, N]=size(stateInfo.X);
    fprintf('solution has %i frames and %i targets\n',F,N);
    [m2d, m3d]=printFinalEvaluation(stateInfo, gtInfo, sceneInfo, opt);
    allm2d(r,:)=m2d; allm3d(r,:)=m3d;    
end
rm=4:11;
metrics2d=mean(allm2d); metrics2d(rm)=round(metrics2d(rm));
metrics3d=mean(allm3d); metrics3d(rm)=round(metrics3d(rm));

fprintf('-----\nAveraged 3d\n');
printMetrics(metrics3d)

end