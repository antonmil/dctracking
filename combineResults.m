addpath(genpath('../motutils'))

resdir='results/1124c-2';
if exist('setting','var')
	resdir=sprintf('results/%s',setting);
end
if ~exist(resdir,'dir'), mkdir(resdir); end

disp(resdir)

resfiles=dir(sprintf('%s/res_*.mat',resdir));
if length(resfiles)<20
    fprintf('copying...\n');
    remfld='amilan@moby.cs.adelaide.edu.au:/home/h3/amilan/research/projects/dctracking/';    
    copcommand= sprintf('!rcp -q %s%s/* %s',remfld,resdir,resdir);
    
    eval(copcommand);
    fprintf('done \n');
end

%%
allmets=[];
fullmota=[];
for r=1:20
    resfile=sprintf('%s/res_%03d.mat',resdir,r);
    if exist(resfile,'file')
        load(resfile);
        allmets(r,:)=mean(mets2d(allscen,:),1);
        fullmota(:,r)=mets2d(allscen,12);
        if howToTrack(allscen(1))
                allmets(r,:)=mean(mets3d(allscen,:),1);
                fullmota(:,r)=mets3d(allscen,12);
        end

    end
    
end
%%
% best MOTA
allmota=allmets(:,12)';
fprintf('%4d  ',1:20); fprintf('\n');
fprintf('%4.1f  ',allmota); fprintf('\n');
[mm, mr]=max(allmota);


% load best
allres=load(sprintf('%s/res_%03d.mat',resdir,mr));
fprintf('Best: %d\n',mr);

%%
bestmets=[];
for s=allscen    
    if howToTrack(s)
        tmp=allres.mets3d(s,:);
    else
        tmp=allres.mets2d(s,:);        
    end
    printMetrics(tmp);
    bestmets=[bestmets; tmp];
end

fprintf('--------------------------------------------------------\n');
intmets=4:11;
meanmets=mean(bestmets);
meanmets(:,intmets)=round(meanmets(:,intmets));

printMetrics(meanmets);
diary off
