function stateInfo = resultToXY(objhist)
%
% load('/home/aanton/diss/others/okuma/BPF_1_3/result.mat');
F=length(objhist);
global sceneInfo gtInfo opt
% F = length(sceneInfo.frameNums);

X=zeros(F,0); Y=zeros(size(X));
W=zeros(F,0); H=zeros(size(X));

for t=1:F
    tars=get(objhist{t},'targets');
    width=get(objhist{t},'box_width');
    height=get(objhist{t},'box_height');
    for id=find(~isemptycell(tars))
        if tars{id}.status
        W(t,id)=tars{id}.scale*width;
        H(t,id)=tars{id}.scale*height;
        X(t,id)=tars{id}.center_img(1);
        Y(t,id)=tars{id}.center_img(2)+H(t,id)/2;
        end
    end
end
stateInfo.Xi=X; stateInfo.Yi=Y; stateInfo.W=W; stateInfo.H=H; 
stateInfo.X = X; stateInfo.Y = Y;
stateInfo.frameNums=sceneInfo.frameNums(2:end);
% stateInfo.frameNums = sceneInfo.frameNums;


if opt.track3d
    [stateInfo.Xgp,stateInfo.Ygp]=projectToGroundPlane(stateInfo.Xi,stateInfo.Yi,sceneInfo);
    stateInfo.X=stateInfo.Xgp;stateInfo.Y=stateInfo.Ygp;
end
stateInfo.opt=opt;


% save(sprintf('%ss%04d.mat',outdir,scenario),'stateInfo');

% global gtInfo opt
% gtInfo=cropFramesFromGT(sceneInfo,gtInfo,frames(2:end),opt);
% displayTrackingResult(sceneInfo,stateInfo);