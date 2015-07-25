function xticklabelRot(xTickLabels, angle, fontsize)
% function xticklabelRot(xTickLabels, angle, fontsize)
% Angle defaults to 90
% fontsize defaults to current
%
% Example:
% figure(1); clf; bar([1 2 3]); xticklabelRot({'foo','bar',22}, 90)
%
% Kevin Murphy, 8 June 2006
% Based on xticklabel_rotate90 by Denis Gilbert
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=3150&objectType=file

if nargin < 2, angle = 90; end
if nargin < 3, fontsize = get(gca, 'fontsize'); end

XTick = get(gca,'xtick');
XTick = XTick(:);
%xTickLabels = num2str(XTick);

set(gca,'XTick',XTick,'XTickLabel','')

% Determine the location of the labels based on the position
% of the xlabel
hxLabel = get(gca,'XLabel');  % Handle to xlabel
xLabelString = get(hxLabel,'String');

if ~isempty(xLabelString)
   warning('You may need to manually reset the XLABEL vertical position')
end

set(hxLabel,'Units','data');
xLabelPosition = get(hxLabel,'Position'); 
y = xLabelPosition(2);

%CODE below was modified following suggestions from Urs Schwarz
y=repmat(y,size(XTick,1),1);

% Place the new xTickLabels by creating TEXT objects
hText = text(XTick, y, xTickLabels,'fontsize',fontsize);

% Rotate the text objects by 90 degrees
%set(hText,'Rotation',90,'HorizontalAlignment','right',varargin{:})
set(hText,'Rotation',angle,'HorizontalAlignment','right')


