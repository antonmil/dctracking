function options = parseMHTOptions(options)
% get options for MHT tracker

try
    if isstr(options)

        options=readMHTOptions(options);
        % options
    end
    

catch err
%     default options
    fprintf('Error parsing options: %s\n',err.message);
    fprintf('Using defaults\n');
    options=[];
	
	options.maxNumLeaves =     	6; %  int maxNumLeaves
	options.maxDepth =     		6; % int maxDepth
	options.timeUndetected=    	10; % int timeUndetected
	options.bestK=    			6; % int bestK
	options.probUndetected=    	0.1; % double probUndetected
	options.probNewTarget=    	0.001; % double probNewTarget
	options.options.probFalseAlarm=    	0.01; % double probFalseAlarm
	options.gateSize=    		30;  % double gateSize

    
end

end


function opt=readMHTOptions(inifile)
    % parse configuration for DP Tracking

    if ~exist(inifile,'file')
        fprintf('WARNING! Config file %s does not exist! Using default setting...\n',inifile);
        inifile='external/mhttracking/config/default.ini';
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