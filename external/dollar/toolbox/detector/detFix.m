%%
scenario=25;
sceneInfo=getSceneInfo(scenario);
detHOG = parseDetections(sceneInfo);

scenario=scenario+2000; sceneInfo=getSceneInfo(scenario);
detACF=parseDetections(sceneInfo);
scpairs=[];

tt=1:240;
% tt=150:154;
for t=tt
    % t=100;
    
    detsHOG = detHOG(t);
    detsACF = detACF(t);
    
    
    
    % figure(1); clf; hold on; imshow(getFrame(sceneInfo,t));
    olcnt=0;
    for dH=1:length(detsHOG.bx)
        xH=detsHOG.bx(dH); yH=detsHOG.by(dH); wH=detsHOG.wd(dH); hH=detsHOG.ht(dH);
        %     rectangle('Position',[xH,yH,wH,hH],'EdgeColor','r');
        alliou=zeros(1,length(detsACF.bx));
        for dA=1:length(detsACF.bx)
            xA=detsACF.bx(dA); yA=detsACF.by(dA); wA=detsACF.wd(dA); hA=detsACF.ht(dA);
            iou = boxiou(xH,yH,wH,hH,xA,yA,wA,hA);
            %         rectangle('Position',[xA,yA,wA,hA],'EdgeColor','b');
            alliou(dA)=iou;
        end
        [iou,dA]=max(alliou);
        if iou>.5
            scpairs=[scpairs; [detsHOG.sc(dH), detsACF.sc(dA)]];
            olcnt=olcnt+1;
            %             break;
        end
        
    end
%     fprintf('Recall: %.2f%%\n',olcnt/length(detsHOG.bx)*100);
    
end

% sort ascending in HOG
[srt1,srtidx]=sort(scpairs(:,1));
srt2=scpairs(srtidx,2);
srtpairs=[srt1,srt2];

% sort ascending in ACF
[srt2,srtidx]=sort(scpairs(:,2)); 
srt1=scpairs(srtidx,1);
% srtpairs=[srt1,srt2];

figure(2);
clf;
% plot(srtpairs,'.')
% plot(scpairs(:,1),scpairs(:,2),'.');