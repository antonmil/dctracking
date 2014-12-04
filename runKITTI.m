%%
allscen=[500:520 550:578];
allscen=[550:578];
allscen=1550:1578;
for s=allscen
    try
        scenario=s;
%         [metrics2d, metrics3d, allens, stateInfo]=dcTracker(scenario);
        [metrics2d, metrics3d, allens, stateInfo]=swDCTracker(s,'config/1202Kc-2/0001.ini')
%         startPT=stateInfo;
        save(sprintf('/home/amilan/research/projects/dctracking/out/s%04d.mat',s),'stateInfo','metrics*');
    catch err
         fprintf('%s\n',err.identifier);
    end
end

%%
addpath('/home/amilan/storage/databases/KITTI/tracking/devkit_tracking/matlab');
for s=allscen
    try
        load(sprintf('/home/amilan/research/projects/dctracking/out/s%04d.mat',s));
        tracklets=convertToKITTI(stateInfo);
        writeLabels(tracklets,'./out',s-allscen(1));
    catch err
        fprintf('%s\n',err.identifier);
    end
end