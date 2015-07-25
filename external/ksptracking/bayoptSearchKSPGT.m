function result = bayoptSearchKSPGT(params)

% cd('/home/amilan/research/projects/dctracking')
% % grid search
global sceneInfo detections opt gtInfo
% addpath(genpath('.'));
% addpath(genpath('../motutils'));

allscen=2200+[23,25,27,71,72,42];  % raw detections


% scenario=2127;
% allscen = [2172,2142]
allexp=[];
expcnt=0;
scnt=0;
for scenario=allscen
    scnt=scnt+1;

    [metrics2d,metrics3d,stateInfo]=ksptrackerGT(scenario,params);
    allexp(scnt).params=params;
    allexp(scnt).m2d=metrics2d;
    allexp(scnt).m3d=metrics3d;
    allexp(scnt).scenario = scenario;
    allexp(scnt).stateInfo = stateInfo;
%     allexp(scnt).sceneInfo = sceneInfo;
end
resdir='bayesoptGT/';
resfiles = dir(resdir)
resfile=sprintf('%s/j%05d.mat',resdir,numel(resfiles)+1);
if ~exist('resdir','dir'), mkdir(resdir); end
fprintf('saving to %s...\n',resfile);
save(resfile,'allexp');

% final result is negative MOTA because of minimizing
mets2d = reshape([allexp(:).m2d],14,scnt)';
mets3d = reshape([allexp(:).m3d],14,scnt)';

% allexp
mets3d

metrics2d = mean(mets2d)
metrics3d = mean(mets3d)

% metrics3d
result = metrics2d(12)
if opt.track3d, result=metrics3d(12); end


result = 1 - result / 100