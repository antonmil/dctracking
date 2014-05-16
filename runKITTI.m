%%
allscen=[500:520 550:578];
for s=allscen
    try
        scenario=s;
        [metrics2d, metrics3d, allens, stateInfo]=dcTracker(s);
%         startPT=stateInfo;
        save(sprintf('/home/amilan/research/projects/dctracking/out/s%04d.mat',s),'stateInfo','metrics*');
    catch
    end
end