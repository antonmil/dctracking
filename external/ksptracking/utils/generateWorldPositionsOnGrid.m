function [WorldPositionsOnGrid areaLimits]=generateWorldPositionsOnGrid(GridPositions,gridStep,minX,minY)

[gridX,gridY,~]=size(GridPositions);
WorldPositionsOnGrid=zeros(gridX,gridY,2);
for y=1:gridY
    for x=1:gridX
        xw=gridStep*GridPositions(x,y,1)+minX-gridStep;
        yw=gridStep*GridPositions(x,y,2)+minY-gridStep;

        WorldPositionsOnGrid(x,y,1)=xw;
        WorldPositionsOnGrid(x,y,2)=yw;
        
        %         [xw yw]
        %         [xi yi]=worldToImage(xw,yw,0,mR,mT,camPar.mInt,camPar.mGeo);
        %         [xi yi]
        %         plot(xi,yi,'.b','MarkerSize',1);
        %         pause
    end
    %     drawnow
end
        areaLimits=[WorldPositionsOnGrid(1,1,1) WorldPositionsOnGrid(end,end,1) ...
            WorldPositionsOnGrid(1,1,2) WorldPositionsOnGrid(end,end,2)];

end