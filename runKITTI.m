%%
allscen=[500:520 550:578];
allscen=[550:578];
allscen=1550:1578;
setting='1202Kc-2';
outdir=sprintf('results/%s',setting);
if ~exist(outdir,'dir'), mkdir(outdir); end


for s=allscen
    try
        scenario=s;
%         [metrics2d, metrics3d, allens, stateInfo]=dcTracker(scenario);
        conffile=sprintf('config/%s/0001.ini',setting);
        outfile=fullfile(outdir,sprintf('s%04d.mat',s));
        [metrics2d, metrics3d, allens, stateInfo]=swDCTracker(s,conffile)
%         startPT=stateInfo;
        save(outfile,'stateInfo','metrics*');
    catch err
         fprintf('%s\n',err.identifier);
    end
end

%%
addpath('/home/amilan/storage/databases/KITTI/tracking/devkit_tracking/matlab');

for s=allscen
    try
        outfile=fullfile(outdir,sprintf('s%04d.mat',s));
        load(outfile);
        tracklets=convertToKITTI(stateInfo);
        writeLabels(tracklets,outdir,s-allscen(1));
    catch err
        fprintf('%s\n',err.identifier);
    end
end