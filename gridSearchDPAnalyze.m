pp1=linspace(40,80,3);
pp2=linspace(40,80,3);
pp3=linspace(0.05,0.5,3);
pp4=linspace(0.05,0.5,3);
pp5=linspace(5,25,3);
expcnt=0;

allscen=[23,25,27,71,72,42];
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
                        resfile=sprintf('external/dptracking/gridSearchRaw/e%04d.mat',expcnt);
                        
                        load(resfile);
                        pause
                        
                    end
                end
            end
        end
    end
    
    
end

%%
emota=[];
for ppp=1:242
    tmp=mean(reshape([allexp(ppp:243:end).m3d],14,6)');
    emota(ppp)=tmp(12);
end
plot(emota)
max(emota)