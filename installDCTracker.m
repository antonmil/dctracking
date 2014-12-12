%% installs all necessary dependencies

format compact;

dcdir = pwd;
%%%% MOT Utils %%%
try
    fprintf('Installing MOT Utils...\n');
    if ~exist('../motutils')
        cd ..
        
        fprintf('Sucess!\n');
    else
        fprintf('IGNORE. Already exist\n');
    end
    
catch err
    fprintf('FAILED: MOT Utils not installed! %s\n',err.message);
end

cd(dcdir)