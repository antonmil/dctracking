%% pairwise parameter analysis

parlet={'a','b','c','d','e','f','g','h','i'};
parnames={'outlierCost','labelCost','unaryFactor', ...
    'persistenceFactor','curvatureFactor','slopeFactor',...
    'proxcostFactor','exclusionFactor','pairwiseFactor'};

addpath(genpath('./motutils/external'))

np=length(parlet);
baseConf='0530P';
templateDir='config/1125Pab-1/';
for p1=1:np
    for p2=p1+1:np        
        p1name=char(parlet{p1});
        p2name=char(parlet{p2});
        setting=['0530P',p1name,p2name,'-1'];
        allmets=combineResults(setting);
        
        metsfile=sprintf('results/mets-%s.mat',setting);
        save(metsfile,'allmets');
    end
end