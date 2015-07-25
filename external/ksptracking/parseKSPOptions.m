function options = parseKSPOptions(options)
% get options for KSP tracker

% options to be set
params={'c_en','c_ex','c_ij','betta','max_it','thr_cost'};
    

try
    if isstr(options)

        options=readDPOptions(options);
        % options
    end
    

catch err
%     default options
    fprintf('Error parsing options: %s\n',err.message);
    fprintf('Using defaults\n');
    options=[];
    options.sigA      = 0;     %% detections confidence shift
    options.sigB      = 1;     %% detections confidence multiplier
    options.SIG      = 0.0002;      %% Gauss variance
    
end

end


function opt=readDPOptions(inifile)
    % parse configuration for DP Tracking

    if ~exist(inifile,'file')
        fprintf('WARNING! Config file %s does not exist! Using default setting...\n',inifile);
        inifile='external/ksptracking/config/default.ini';
    end


    ini=IniConfig();
    ini.ReadFile(inifile);

    opt=[];


    % Main Parameters
    opt=fillInOpt(opt,ini,'Parameters');
    opt=fillInOpt(opt,ini,'Miscellaneous');
end


function opt = fillInOpt(opt, ini, sec)
% loop through all keys in section and
% append to struct

keys = ini.GetKeys(sec);
for k=1:length(keys)
    key=char(keys{k});
    val=ini.GetValues(sec,key);
    
    % parameters are numeric
    if isstr(val) && strcmpi(sec,'Parameters')
        val=str2double(val);
    end
    opt = setfield(opt,key,val);
end

end