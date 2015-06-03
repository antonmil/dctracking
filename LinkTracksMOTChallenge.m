% Link Tracks MOTChallenge

if ~exist('tmp/linkde/simres','dir'), mkdir('tmp/linked/simres'); end

setting='0513a-1';
allscen=[1001:1011];
% allscen=1005;

% save tracklet similarity
global gtInfo
%%
allsceneInfos=[];
for scenario=allscen
    % scenario=1001;
    stateInfo=infos(scenario).stateInfo;
    sceneInfo=getSceneInfo(scenario);
    allsceneInfos(scenario).sceneInfo=sceneInfo;
    saveTrackletSim;
end
%%

% save normalized features
D=[]; S=[]; B=[]; G=[];
for scenario=allscen
    simmatfile=sprintf('tmp/linked/simMat-%s-s%d.mat',setting,scenario);
    load(simmatfile);
    
    nrmlzDist=sumdist.^2;nrmlzScale=sumdistS.^2;
    nrmlzBhat=distBhatt;nrmlzGaps=gaps;
    
    
    D1=nrmlzDist(:);S1=nrmlzScale(:);
    B1=nrmlzBhat(:);G1=nrmlzGaps(:);
    
    
    D=[D;D1];S=[S;S1];
    B=[B;B1];G=[G;G1];
    
    
    [min(D(isfinite(D))) max(D(isfinite(D)))]
    [D featmeanD stddevD]=normMean(D);
    [S featmeanS stddevS]=normMean(S);
    [B featmeanB stddevB]=normMean(B);
    [G featmeanG stddevG]=normMean(G);
    [min(D(isfinite(D))) max(D(isfinite(D)))]
    
end
save(sprintf('tmp/linked/simMat-%s-featnorm.mat',setting),'featmean*','stddev*');


%% now compute
maxexper=99;
savesim=1;

for scenario=allscen
    sceneInfo=allsceneInfos(scenario).sceneInfo;
    stateInfo=infos(scenario).stateInfo;
    
    for exper=0:maxexper
        
        allm2dallscen=[];
        
        if exper==0, recompIm=1;
        else recompIm=0;
        end
        computeTrackletSimilarityMOTChallenge;
    end
    
    %      mets = fastCLEAR(mets2d, numel(find(gtInfoAll.Xi)),size(gtInfoAll.Xi,2),size(gtInfoAll.Xi,1));
end


%
savesim=0;

%%
allScales=[];
allThetas=[];
allWT=[];
for scenario=allscen
    fprintf('Training...\n');
    clf;
    hold on
    allmax=0; allmaxi=0;
    for exper=0:maxexper %%%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        resfile=sprintf('tmp/linked/simres/%s/exp%03d-s%02d.mat',setting,exper,scenario);
        load(resfile)
        plot(allm2d(:,12),'.-','color',getColorFromID(exper));
        %     allm2d
        [maxmota, atiter]=max(allm2d(:,12));
        if maxmota>allmax
            allmax=maxmota;
            allmaxi=exper;
        end
        %     pause
    end
    
    bestexp=allmaxi;
    resfile=sprintf('tmp/linked/simres/%s/exp%03d-s%02d.mat',setting,bestexp,scenario);
    load(resfile)
    [maxmota atiter]=max(allm2d(:,12));
    upToFactor=allmind(atiter)/firstmin;
    fprintf('best exper: %d, theta: %f, upToFactor: %f (at iteration %i)\n',bestexp, allmind(atiter),upToFactor, atiter);
    
    allWT=[allWT, wt];
    allScales=[allScales,upToFactor];
    allThetas=[allThetas,allmind(atiter)];
end

%% test (validate)

allm2dallscen=[];

for scenario=allscen
    sceneInfo=allsceneInfos(scenario).sceneInfo;
    stateInfo=infos(scenario).stateInfo;
    
        
        
    recompIm=1;
    computeTrackletSimilarityValidate;
    mets2d=allm2d(end,:);
    
    allm2dallscen=[allm2dallscen;mets2d];
    %      mets = fastCLEAR(mets2d, numel(find(gtInfoAll.Xi)),size(gtInfoAll.Xi,2),size(gtInfoAll.Xi,1));
end

%%
gtInfoSingle=[];
gtInfoAll=[];
gtInfoAll.Xi=[];

seqCnt=0;

for scen=allscen
    seqCnt=seqCnt+1;
    sceneInfo=getSceneInfo(scen);
    
    Fgt=size(gtInfo.X,1);
    gtInfo.frameNums=1:Fgt;
    gtI = gtInfo;
        
    [Fgt,Ngt] = size(gtInfoAll.Xi);
    [FgtI,NgtI] = size(gtI.Xi);
    newFgt = Fgt+1:Fgt+FgtI;
    newNgt = Ngt+1:Ngt+NgtI;
    
    gtInfoAll.Xi(newFgt,newNgt) = gtI.Xi;
    gtInfoAll.Yi(newFgt,newNgt) = gtI.Yi;
    gtInfoAll.W(newFgt,newNgt) = gtI.W;
    gtInfoAll.H(newFgt,newNgt) = gtI.H;
    
    gtInfoSingle(seqCnt).wc=0;
    
    % fill in world coordinates if they exist
    if isfield(gtI,'Xgp') && isfield(gtI,'Ygp')
        gtInfoAll.Xgp(newFgt,newNgt) = gtI.Xgp;
        gtInfoAll.Ygp(newFgt,newNgt) = gtI.Ygp;
        gtInfoSingle(seqCnt).wc=1;
    end
    
    % check if bounding boxes available in gt
    imCoord=1;
    
    gtInfoAll.X=gtInfoAll.Xi;gtInfoAll.Y=gtInfoAll.Yi;
    
    allFgt(seqCnt) = FgtI;
    
    gtInfoSingle(seqCnt).gtInfo=gtI;
    
end
gtInfoAll.frameNums=1:size(gtInfoAll.Xi,1);
%%
mets = fastCLEAR(allm2dallscen, numel(find(gtInfoAll.Xi)),size(gtInfoAll.Xi,2),size(gtInfoAll.Xi,1));
printMetrics(mets);


%% test
allscen2=1051:1061;
setting='0513aT-1';

allsceneInfos=[];
for scenario=allscen2
    % scenario=1001;
    resfile=sprintf('results/%s/prt_res-scen%04d.mat',setting,scen);
    load(resfile);
    sceneInfo=getSceneInfo(scenario);
    allsceneInfos(scenario).sceneInfo=sceneInfo;
    saveTrackletSim;
end

%%
for scen=allscen2
    scenario=scen;
    sceneInfo=getSceneInfo(scen);
    
    resfile=sprintf('results/%s/prt_res-scen%04d.mat',setting,scen);
    load(resfile);
        
        
    recompIm=1;
    computeTrackletSimilarityValidate;
    stateInfo=stInfo;
    resfile=sprintf('results/%s/prt_res-linked-scen%04d.mat',setting,scen);
    save(resfile,'stateInfo');

    
end
