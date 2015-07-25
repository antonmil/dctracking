function GridPositions=generateGridPositions(gridX,gridY,gridType)

GridPositions=zeros(gridX,gridY,2);

if gridType==1
    [GridPositions(:,:,2) GridPositions(:,:,1)]=meshgrid(1:gridY,1:gridX);
else
    sin_60=0.86602540378443864676372317075294;

    for y=1:gridY
        for x=1:gridX
            GridPositions(x,y,1)=x;
            GridPositions(x,y,2)=y;
            if gridType~=1
                GridPositions(x,y,2)=(y-1)*sin_60+1;
                if ~mod(y,2)
                    GridPositions(x,y,1)=x+0.5;
                end
            end
        end
    end
end

end