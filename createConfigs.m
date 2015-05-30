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
        
        inifile=[templateDir,'default.ini'];
        ini=IniConfig();
        ini.ReadFile(inifile);
        
%         [char(parlet{p1}) char(parlet{p2})]
        p1name=char(parnames{p1});
        p2name=char(parnames{p2});
        
        newdir=['config/',baseConf,char(parlet{p1}),char(parlet{p2}),'-1'];
        if ~exist(newdir,'dir'), mkdir(newdir); end
        newconffile=[newdir,filesep,'default.ini'];
        
        p1v=ini.GetValues('Miscellaneous',p1name);
        p2v=ini.GetValues('Miscellaneous',p2name);
        
        % add to parameters
        ini.AddKeys('Parameters', p1name, p1v);
        ini.AddKeys('Parameters', p2name, p2v);
        
        % remove from misc
        ini.RemoveKeys('Miscellaneous',p1name);
        ini.RemoveKeys('Miscellaneous',p2name);                
        
        % copy other files
        copyfile([templateDir,'*.txt'],newdir);
        
        ini.WriteFile(newconffile);
    end
end

