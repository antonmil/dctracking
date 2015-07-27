%%
function stateInfo=getStateInfo(alltars)

stateInfo=[];
global detections sceneInfo opt
[detections nPoints]=parseDetections(sceneInfo);


F=length(alltars);

X=[];
Y=[];

for t=1:F
    if isempty(alltars{t})
        X(t,:)=0;Y(t,:)=0;
    else
        extars=alltars{t}(:,3)'+1;
        if ~isempty(extars)
            X(t,extars)=alltars{t}(:,1)';
            Y(t,extars)=alltars{t}(:,2)';
        end
    end
end

[X Y stateInfo]=cleanState(X,Y,stateInfo);
stateInfo=postProcessState(stateInfo);

end
%
