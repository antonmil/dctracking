function [gridX gridY]=computeGridSize(sceneInfo, gridType)
% compute how many cells are needed for a given area and
% a  given cell size

rangeX=diff(sceneInfo.trackingArea(1:2));
rangeY=diff(sceneInfo.trackingArea(3:4));

gridStep=sceneInfo.targetSize;

if gridType, fprintf('rectilinear grid...\n');
else fprintf('hexagonal grid...\n');
end
gridX=floor(rangeX/gridStep)+1;
if gridType
    gridY=floor(rangeY/gridStep)+1;
else
    gridY=floor(rangeY/gridStep/0.86602540378443864676372317075294)+1;
end

%     fprintf('creating a %i x %i grid\n',gridX,gridY);
%     fprintf('area limits: (%f %f) (%f %f)\n',minX,maxX,minY,maxY);

end