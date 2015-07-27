function opt=getMHTOptions()
%
% (C) Anton Andriyenko, 2012
%
% The code may be used free of charge for non-commercial and
% educational purposes, the only requirement is that this text is
% preserved within the derivative work. For any other purpose you
% must contact the authors for permission. This code may not be
% redistributed without written permission from the authors.

global scenario;


% tracking on image or on ground plane?
opt.track3d=howToTrack(scenario);

% general
opt.verbosity=3;                % 0=silent, 1=short info, 2=long info, 3=all
opt.visOptim=0;                 % visualize optimization
opt.met2d=1;                    % always compute metrics in 2d (slower)
opt.maxModels=20000;            % max number of trajectory hypotheses
opt.keepHistory=2;              % keep unused models for n iterations
opt.cutToTA=0;                  % cut detections, ground truth and result to tracking area
opt.randrun=1;                  % random seed
opt.remOcc=0;                   % remove occluded GT and result
opt.maxItCount=100;             % abort after max iterations reached
opt.occ=0;                      % turn on / off occlusion reasoning

opt.remOcc=0;
opt.detThreshold=0;

opt.maxNumLeaves	= 10;
opt.maxDepth		= 10;
opt.timeUndetected =10;
opt.bestK			= 10;
opt.probUndetected	= 0.1;
opt.probNewTarget	= 0.01;
opt.probFalseAlarm	= 0.01;
opt.gateSize			= 50;


if opt.track3d
	opt.gateSize = 1000;
end


end