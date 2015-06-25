%% 
addpath(genpath('../../../../../motutils'));
% scenario=27;
sceneInfo=getSceneInfo(scenario);

load('models/AcfInriaDetector.mat')

detScale=1;
detScale=0.6;

blowUp=1;
fprintf('RESCALING DETECTOR: %f\n',detScale);
detector = acfModify(detector,'rescale',detScale);


F=length(sceneInfo.frameNums);
filecells=cell(1,F);
for t=1:F
    filecells{t} = getFrameFile(sceneInfo,t);
end

% detect all images
bbx = acfDetect(filecells,detector);

%%
% write out
detFile=sprintf('data/acf-s%04d.txt',scenario);
writeDets(bbx,detFile);
detFile=[sceneInfo.detfile,'-acf.txt'];
writeDets(bbx,detFile);


% raw detector
detector.opts.pNms.type='none';
% detect all images
bbx = acfDetect(filecells,detector);

% write out
detFile=sprintf('data/acf-raw-s%04d.txt',scenario);
writeDets(bbx,detFile);
detFile=[sceneInfo.detfile,'-acf-raw.txt'];
writeDets(bbx,detFile);
