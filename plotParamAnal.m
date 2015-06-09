%%%
parlet={'a','b','c','d','e','f','g','h','i'};
parnames={'outlierCost','labelCost','unaryFactor', ...
    'persistenceFactor','curvatureFactor','slopeFactor',...
    'proxcostFactor','exclusionFactor','pairwiseFactor'};

% addpath(genpath('./motutils/external'))

np=length(parlet);
cnt=0;
confdir='config';resdir='results';
maxexper=81;
for p1=1:np
    for p2=p1+1:np        
        cnt=cnt+1;
        p1let=char(parlet{p1});
        p2let=char(parlet{p2});
        
        p1name=char(parnames{p1});
        p2name=char(parnames{p2});
        
        setting=['0530P',p1let,p2let,'-1'];
        load(sprintf('results/mets-%s.mat',setting));
        plotMOTA
        
        figname = sprintf('tmp\\paramAnal\\pix\\%02d.pdf',cnt);
        export_fig(figname,'-transparent');
        pause(.1);
    end
end