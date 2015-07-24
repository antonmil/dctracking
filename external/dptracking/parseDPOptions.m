function options = parseDPOptions(options)
% get options for DP tracker

% options to be set
params={'c_en','c_ex','c_ij','betta','max_it','thr_cost'};
    

try
    if isstr(options)

        options=readDPOptions(options);
        options




    end
    

catch err
%     default options
    fprintf('Error parsing options: %s\n',err.message);
    fprintf('Using defaults\n');
    options=[];
    options.c_en      = 10;     %% birth cost
    options.c_ex      = 10;     %% death cost
    options.c_ij      = 0;      %% transition cost
    options.betta     = 0.2;    %% betta
    options.max_it    = inf;    %% max number of iterations (max number of tracks)
    options.thr_cost  = 18;     %% max acceptable cost for a track (increase it to have more tracks.)
    options.mode      = 2;      %% DP with NMS in the loop
    
end

end


function opt=readDPOptions(inifile)
    % parse configuration for DP Tracking

    if ~exist(inifile,'file')
        fprintf('WARNING! Config file %s does not exist! Using default setting...\n',inifile);
        inifile='external/dptracking/config/default.ini';
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