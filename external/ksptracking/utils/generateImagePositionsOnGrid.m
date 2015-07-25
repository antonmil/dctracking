function ImagePositionsOnGrid=generateImagePositionsOnGrid(WorldPositionsOnGrid,sceneInfo)

[gridX,gridY,~]=size(WorldPositionsOnGrid);
ImagePositionsOnGrid=zeros(gridX,gridY,2);

%     clf
%     im=double(imread([sceneInfo.imgFolder sprintf(sceneInfo.imgFileFormat,sceneInfo.frameNums(1))]))/255;
%     imshow(im,'Border','tight')
%     hold on
    
for y=1:gridY
    for x=1:gridX        
        xw=WorldPositionsOnGrid(x,y,1);
        yw=WorldPositionsOnGrid(x,y,2);
        
        [xi yi]=projectToImage(xw,yw,sceneInfo);
        ImagePositionsOnGrid(x,y,1)=xi;
        ImagePositionsOnGrid(x,y,2)=yi;
%         plot(xi,yi,'.');
        
        

    end
%     pause(.01);
end
end