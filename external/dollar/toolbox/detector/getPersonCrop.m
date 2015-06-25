function [left,top,right,bottom]=getPersonCrop(WorldPositionsOnGrid,sceneInfo)

[rowCells,colCells,~]=size(WorldPositionsOnGrid);

left    =zeros(rowCells,colCells);
top     =zeros(rowCells,colCells);
right   =zeros(rowCells,colCells);
bottom  =zeros(rowCells,colCells);

pHeight = 1800; % person height is 1.8 m
for y=1:colCells
    for x=1:rowCells
        % world location of grid
        xw=WorldPositionsOnGrid(x,y,1);
        yw=WorldPositionsOnGrid(x,y,2);
        
        % project
        [Xbi,Ybi]=projectToImage(xw,yw,sceneInfo);
        % project head pt
        [Xti,Yti]=projectToImage(xw,yw,sceneInfo,pHeight); 
        H=Ybi-Yti;
        W=H/2;
        Xi=mean([Xbi,Xti]);
        
        left(x,y)  = Xi-W/2;
        top(x,y)   = Yti;
        right(x,y) = Xi+W/2;
        bottom(x,y)= Ybi;
        
    end
end