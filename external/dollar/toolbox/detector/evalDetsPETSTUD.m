addpath(genpath('../../../../../motutils'));

allscen=[23,25,27,71,72,42];
% allscen=72;

global sceneInfo detections gtInfo scenario
%%
allFrCnt=0;
for scenario=allscen
    sceneInfo=getSceneInfo(scenario);
    detections = parseDetections(sceneInfo);
    
    detMat = getDetectionMatrices(detections);
    detRaw = convertDetInfoToTXT(detMat);
    gtRaw = convertGTInfoToTXT(gtInfo);
    F = length(sceneInfo.frameNums);
        
    for t=1:F
        allFrCnt=allFrCnt+1;
        exdet=find(detRaw(:,1)==t);
        bbox=detRaw(exdet,3:7);
        dt0{allFrCnt}=bbox;
        
        exgt=find(gtRaw(:,1)==t);
        gt0{allFrCnt}=[gtRaw(exgt,3:6) zeros(length(exgt),1)];
        
    end
end

allscen=allscen+2000;
allFrCnt1=0;
for scenario=allscen
    sceneInfo=getSceneInfo(scenario);
    detections = parseDetections(sceneInfo);
    
    detMat = getDetectionMatrices(detections);
    detRaw = convertDetInfoToTXT(detMat);
    gtRaw = convertGTInfoToTXT(gtInfo);
    F = length(sceneInfo.frameNums);
        
    for t=1:F
        allFrCnt=allFrCnt+1;
        exdet=find(detRaw(:,1)==t);
        bbox=detRaw(exdet,3:7);
        dt1{allFrCnt}=bbox;
        
        exgt=find(gtRaw(:,1)==t);
        gt1{allFrCnt}=[gtRaw(exgt,3:6) zeros(length(exgt),1)];
        
    end
end


% lims=[3.1e-3 1e1 .05 1];
lims=[0 1 0 1];
ref=10.^(-2:.25:0);
ref=0:.1:1;

%%
clf; hold on; box on;
[gt,dt]=bbGt('evalRes',gt0,dt0);
[fp,tp,score,miss] = bbGt('compRoc',gt,dt,0,ref);

[gt,dt]=bbGt('evalRes',gt1,dt1);
[fp1,tp1,score1,miss1] = bbGt('compRoc',gt,dt,0,ref);

set(gca,'FontSize',12)
plot(fp,tp,'linewidth',2,'linesmoothing','on');
plot(fp1,tp1,'linewidth',2,'linesmoothing','on','color','r');

opX=fp(end); opY=tp(end);
plot(opX,opY,'.','MarkerSize',25);
opX1=fp1(end); opY1=tp1(end);
plot(opX1,opY1,'.','MarkerSize',25,'color','r');


%%
fs=22;
set(gca,'FontSize',fs);
text(opX+.25,opY+.1,sprintf('Rcll: %.1f %%\nPrc: %.1f %%',opX*100,opY*100),'VerticalAlignment','top','HorizontalAlignment','right','FontSize',fs-4,'color','b');
text(opX1-.05,opY1-.025,sprintf('Rcll: %.1f %%\nPrc: %.1f %%',opX1*100,opY1*100),'VerticalAlignment','top','HorizontalAlignment','right','FontSize',fs-4,'color','r');
xlim(lims(1:2)); ylim(lims(3:4));


xlabel('Recall'); ylabel('Precision');
title('Detector Performance');
legend('HOG','ACF');