% grid search
global sceneInfo detections opt gtInfo
addpath(genpath('.'));
addpath(genpath('../motutils'));


allscen=2100+[23,25,27,71,72,42];


% scenario=2127;
expcnt=0;
allexp=[];

pp1=linspace(1,10,3);
pp2=linspace(1,10,3);
pp3=linspace(0.05,0.3,3);
pp4=linspace(0.05,0.5,3);
pp5=linspace(15,25,3);
for scenario=allscen
    sceneInfo=getSceneInfo(scenario);
    detections=parseDetections(sceneInfo);
    conffile='config/default3d.ini';
    opt=readDCOptions(conffile);
    opt=getAuxOpt(conffile,opt,sceneInfo,length(sceneInfo.frameNums));
    opt.track3d=howToTrack(scenario);
    
    
    
    
    for p1=pp1
        for p2=pp2
            for p3=pp3
                for p4=pp4
                    for p5=pp5
                        
                        expcnt=expcnt+1;
                        
                        pirOpt=getPirOptions;
                        
                        %%% setting parameters for tracking
                        pirOpt.c_en      = p1;     %% birth cost
                        pirOpt.c_ex      = p2;     %% death cost
                        pirOpt.c_ij      = p3;      %% transition cost
                        pirOpt.betta     = p4;    %% betta
                        pirOpt.max_it    = 100;    %% max number of iterations (max number of tracks)
                        pirOpt.thr_cost  = p5;     %% max acceptable cost for a track (increase it to have more tracks.)
                        
                        pirOpt
                        stateInfo=runDP(detections,pirOpt,opt);
                        if opt.track3d
                            [stateInfo.X,stateInfo.Y]=projectToGroundPlane(stateInfo.Xi,stateInfo.Yi,sceneInfo);
                            stateInfo.Xgp=stateInfo.X;stateInfo.Ygp=stateInfo.Y;
                        end
                        % evaluate
                        [metrics2d, metrics3d]=printFinalEvaluation(stateInfo, gtInfo, sceneInfo, opt);
                        
                        resfile=sprintf('external/dptracking/gridSearchRaw/e%04d.mat',expcnt);
                        
                        allexp(expcnt).pirOpt=pirOpt;
                        allexp(expcnt).m2d=metrics2d;
                        allexp(expcnt).m3d=metrics3d;
                        allexp(expcnt).scenario = scenario;
                        
                        save(resfile,'stateInfo','metrics*','pirOpt');
                        
                        
                        
                    end
                end
            end
        end
    end
    save('allexp-0612.mat','allexp');
    
end