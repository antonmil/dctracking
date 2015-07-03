function [metrics, metricsInfo, additionalInfo]=evaluateDetectionsAllscen(allscen)


global gtInfo

allm2d=[];
allm3d=[];

for scenario=allscen
    opt.track3d=howToTrack(scenario);
    opt.cutToTA = 0;
    sceneInfo = getSceneInfo(scenario);
    detections = parseDetections(sceneInfo);
    detMatrices=getDetectionMatrices(detections);
    [metrics, metricsInfo, additionalInfo, metrics3d, metricsInfo3d, additionalInfo3d] ...
        =evaluateDetections(detMatrices,gtInfo, sceneInfo, opt);
    
    allm2d=[allm2d; metrics];
    allm3d=[allm3d; metrics3d];
end

meanm2d = mean(allm2d); meanm2d(4:11)=round(meanm2d(4:11));
meanm3d = mean(allm3d); meanm3d(4:11)=round(meanm3d(4:11));

printMessage(1,'\n--- Detections Evaluation (2D): ---\n');
printMetrics(meanm2d,metricsInfo,1,[1 2 3 8 9]);
printMessage(1,'\n');

printMessage(1,'\n--- Detections Evaluation (3D): ---\n');
printMetrics(meanm3d,metricsInfo,1,[1 2 3 8 9]);
printMessage(1,'\n');
