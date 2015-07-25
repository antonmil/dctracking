function options = parsePBFOptions(options)
% get options for BPF tracker

try
    if isstr(options)

        options=readBPFOptions(options);
        % options
    end
    

catch err
%     default options
    fprintf('Error parsing options: %s\n',err.message);
    fprintf('Using defaults\n');
    options=[];
    options.abclambda      = -1;     %% detections confidence shift
    options.BPFalpha      = 1;     %% detections confidence multiplier
    options.pcnums      = 20;      %% Gauss variance
    
end

end


function opt=readBPFOptions(inifile)
    % parse configuration for DP Tracking

    if ~exist(inifile,'file')
        fprintf('WARNING! Config file %s does not exist! Using default setting...\n',inifile);
        inifile='external/bpftracking/config/default.ini';
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