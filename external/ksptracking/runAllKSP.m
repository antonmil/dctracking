allscen=[301:303 311:313];
global scenario
allmets=[];
mets3d=[];mets2d=[]; infos=[];
for s=allscen
    scenario=s;
    [metrics2d, metrics3d, stateInfo]=ksptracker(scenario);
    allmets=[allmets; metrics3d]
    mets3d(s,:)=metrics3d;
    mets2d(s,:)=metrics2d;
    infos(s).stateInfo=stateInfo;
end

%%
intmets=4:11;
meanmetsS=mean(allmets(1:3,:));
meanmetsR=mean(allmets(4:6,:));
meanmetsS(intmets)=round(meanmetsS(intmets));
meanmetsR(intmets)=round(meanmetsR(intmets));
printMetrics(meanmetsS);
printMetrics(meanmetsR);

% save('ksp.mat','mets*','infos');