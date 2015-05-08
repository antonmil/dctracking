function runMOTChallenge(jobname,jobid)

%% determine paths for config, logs, etc...
addpath(genpath('../motutils/'));
format compact

[~,hname]=system('hostname')
settingsDir=strsplit(jobname,'-');
runname=char(settingsDir{1})
learniter=char(settingsDir{2})
jid=char(settingsDir{3}); % unused

settingsDir=[runname '-' learniter];

confdir=sprintf('config/%s',settingsDir);

jobid=str2double(jobid);
confdir

resdir=sprintf('results/%s',settingsDir);
if ~exist(resdir,'dir'), mkdir(resdir); end
resdir


conffile=fullfile(confdir,sprintf('%04d.ini',1));
conffile

inifile=fullfile(confdir,'0001.ini');
inifile
if ~exist(inifile,'file')
    error('You must provide initial options file 0001.ini');
end

% take care of parameters
jobid
rng(1);


allscen=1051:1061

learniter=str2double(learniter)

mets2d=zeros(max(allscen),14);
mets3d=zeros(max(allscen),14);
ens=zeros(max(allscen),1);

scenario=jobid+1050
fprintf('jobid: %d,   learn iteration %d\n',jobid,learniter);
scensolfile=sprintf('%s/prt_res-scen%02d.mat',resdir,scenario)

try
    load(scensolfile);
catch err
    fprintf('Could not load result: %s\n',err.message);
    [metrics2d, metrics3d, energies, stateInfo]=swDCTracker(scenario,conffile);
    save(scensolfile,'stateInfo','metrics2d','metrics3d','energies');
end


