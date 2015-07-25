function Detmaps=generateDetmaps(WorldPositionsOnGrid,detections,sceneInfo,SIG)

F=length(detections);
[gridX,gridY,~]=size(WorldPositionsOnGrid);
Detmaps=zeros(gridX,gridY,F);

wpx=reshape(WorldPositionsOnGrid(:,:,1),gridX*gridY,1)/1000;
wpy=reshape(WorldPositionsOnGrid(:,:,2),gridX*gridY,1)/1000;

SIGS=.2e-4;
if nargin>=4, SIGS = SIG; end
SIGMA=SIGS * sceneInfo.targetSize *  eye(2); % meters
factors=1/sqrt(det(SIGMA)*(2*pi)^2);

showimage=0;
for t=1:F
    if ~mod(t,10), fprintf('.'); end
    a=zeros(gridX,gridY);
    
    ndets=length(detections(t).xp);
    
    for nd=1:ndets
        xw=detections(t).xp(nd);yw=detections(t).yp(nd);
        sc=detections(t).sc(nd);
%         sc=1;
        allgrids=mvnpdf([wpx wpy],[xw/1000 yw/1000],SIGMA);
%         allgrids=allgrids./factors;
        if sum(allgrids)
            allgrids=allgrids/sum(allgrids);
        end
        allgrids=sc*allgrids;
        a=a+reshape(allgrids,gridX,gridY);
    end
    a(~isfinite(a))=0;
    a(a>1)=1;
    if showimage, imshow(imrotate(imresize(a,10,'nearest'),90)); drawnow; pause(.1); end
    Detmaps(:,:,t)=a;
end

end
