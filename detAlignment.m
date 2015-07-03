%%
scenario=27;
t=100;
sceneInfo=getSceneInfo(scenario);
detHOG = parseDetections(sceneInfo);

scenario=scenario+2000; sceneInfo=getSceneInfo(scenario);
detACF=parseDetections(sceneInfo);
clf
imshow(getFrame(sceneInfo,t))
hold on
d=1;
dets = detHOG(t);
for d=1:length(dets.bx)
    x=dets.bx(d); y=dets.by(d); w=dets.wd(d); h=dets.ht(d);
    rectangle('Position',[x,y,w,h],'EdgeColor','r');
    text(x,y-10,sprintf('%.2f',dets.sc(d)),'color',[.5 0 0]);
end
figure(2)
clf
hold on
plot(dets.sc,'r.')
figure(1)

dets = detACF(t);
for d=1:length(dets.bx)
    x=dets.bx(d); y=dets.by(d); w=dets.wd(d); h=dets.ht(d);
    rectangle('Position',[x,y,w,h],'EdgeColor','b');
    text(x,y+h+10,sprintf('%.2f',dets.sc(d)),'color',[0 0 .5]);
end

figure(2)
plot(dets.sc,'.')
% figure(1)