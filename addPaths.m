function addPaths()
% add necessary paths

utilsdir='/home/amilan/visinf/projects/ongoing/contracking/utils/';
if exist('/home/aanton','dir')
  utilsdir='/home/aanton/visinf/projects/ongoing/contracking/utils/';
elseif exist('/gris','dir')
  utilsdir='/gris/gris-f/home/aandriye/visinf/projects/ongoing/contracking/utils/';
end

% utils, mex
if ~isdeployed
    addpath(genpath(utilsdir));     
    addpath('mex/bin/'); 
end
homefolder=getHomeFolder();

% openGM
pathToOpenGM=fullfile(homefolder,'software','opengm2','Release');
if exist('/home/aanton','dir')
    pathToOpenGM=fullfile(homefolder,'software','opengm-master','Release');
elseif exist('/gris','dir')
%     pathToOpenGM=fullfile(homefolder,'software','opengm2','src','interfaces','matlab','opengm','matlab-examples');
    pathToOpenGM='opengm';
end
if ~isdeployed, addpath(pathToOpenGM); end

% LBFGS
if ~isdeployed
    addpath('fminlbfgs');
end



% we are using GCO and Lightspeed
if ~isdeployed
    addpath(genpath(fullfile(homefolder,'software','gco-v3.0')));
    addpath(genpath(fullfile(homefolder,'software','lightspeed')));
end

end