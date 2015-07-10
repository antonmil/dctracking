function visDetExc()
%% vis direct comparison of full model and no exclusion
global outdir

dispResults = 0;
allscen=[23,25,27,71,72,42];

if dispResults
res001=load('d:\research\projects\dctracking\results\1125Ph-1\res_001.mat');
res005=load('d:\research\projects\dctracking\results\1125Ph-1\res_005.mat');

for scenario=allscen
    sceneInfo=getSceneInfo(scenario);
    outdir='tmp/visdetexc/noexc';
    displayTrackingResult(sceneInfo,res001.infos(scenario).stateInfo)
    outdir='tmp/visdetexc/exc';
    displayTrackingResult(sceneInfo,res005.infos(scenario).stateInfo)
end

res001=load('d:\research\projects\dctracking\results\1125Pb-1\res_001.mat');
res005=load('d:\research\projects\dctracking\results\1125Pb-1\res_005.mat');

for scenario=allscen
    sceneInfo=getSceneInfo(scenario);
    outdir='tmp/visparsimony/nopar';
    displayTrackingResult(sceneInfo,res001.infos(scenario).stateInfo)
    outdir='tmp/visparsimony/par';
    displayTrackingResult(sceneInfo,res005.infos(scenario).stateInfo)
end

%% concat images
for scenario=allscen
    sceneInfo=getSceneInfo(scenario);
    od1='tmp/visdetexc/noexc';
    od2='tmp/visdetexc/exc';
    od='tmp/visdetexc';
    for t=sceneInfo.frameNums
        try
            im1f=sprintf('%s/s%d-f%04d.jpg',od1,scenario,t);
            im1=imread(im1f);
            impad=zeros(size(im1,1),10,3);
            im2f=sprintf('%s/s%d-f%04d.jpg',od2,scenario,t);
            im2=imread(im2f);
            imcat = cat(2,im1,impad,im2);
            imwrite(imcat,sprintf('%s/s%d-f%04d.jpg',od,scenario,t));
        catch err
            fprintf('frame %d skipped: %s\n',t,err.message)
        end
    end
end

for scenario=allscen
    sceneInfo=getSceneInfo(scenario);
    od1='tmp/visparsimony/nopar';
    od2='tmp/visparsimony/par';
    od='tmp/visparsimony';
    for t=sceneInfo.frameNums
        try
            im1f=sprintf('%s/s%d-f%04d.jpg',od1,scenario,t);
            im1=imread(im1f);
            impad=zeros(size(im1,1),10,3);
            im2f=sprintf('%s/s%d-f%04d.jpg',od2,scenario,t);
            im2=imread(im2f);
            imcat = cat(2,im1,impad,im2);
            imwrite(imcat,sprintf('%s/s%d-f%04d.jpg',od,scenario,t));
        catch err
            fprintf('frame %d skipped: %s\n',t,err.message)
        end
    end
end


end

%% crop out interesting examples
od1='tmp/visdetexc/noexc';
od2='tmp/visdetexc/exc';

od='tmp/visdetexc/samples'; if ~exist(od,'dir'), mkdir(od); end
scenario=23; t=171; crp=[658,81,66,91];
saveCrop(scenario,t,crp,od1,od2,od);

scenario=23; t=255; crp=[608,109,79,98];
saveCrop(scenario,t,crp,od1,od2,od);

scenario=23; t=525; crp=[384,387,131,189];
saveCrop(scenario,t,crp,od1,od2,od);

scenario=25; t=102; crp=[671,78,62,85];
saveCrop(scenario,t,crp,od1,od2,od);

scenario=25; t=87; crp=[613,257,96,127];
saveCrop(scenario,t,crp,od1,od2,od);

scenario=27; t=196; crp=[6,145,68,93];
saveCrop(scenario,t,crp,od1,od2,od);

end


function saveCrop(scenario,t,crp,od1,od2,od)
    im1f=sprintf('%s/s%d-f%04d.jpg',od1,scenario,t);
    im2f=sprintf('%s/s%d-f%04d.jpg',od2,scenario,t);
    im1=imread(im1f); im1=imcrop(im1,crp);
    im2=imread(im2f); im2=imcrop(im2,crp);
    imcat = cat(2,im1,255*ones(size(im1,1),5,3),im2);
    imwrite(imcat,sprintf('%s/s%d-f%04d.jpg',od,scenario,t));
end