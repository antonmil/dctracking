% jdir = 'bayesoptHOG';
% allmets=zeros(1,14);
% for j=1:1000
%     jfile = [jdir,filesep,sprintf('j%05d.mat',j)];
%     if exist(jfile,'file')
%         load(jfile)        
%         if length(allexp)==6
%             allmets(j,:)=mean(reshape([allexp(:).m3d],14,6)');
%         end
%     end
% end
% allmota=allmets(:,12);
% [bestmota,bestexp]=max(allmota)

% bestDP

intmets=4:11;

% DP
fprintf('DP\n');
% RAW
load('external/dptracking/bayesopt/j00089.mat')
meanmets=mean(reshape([allexp(:).m3d],14,6)');

meanmets(intmets)=round(meanmets(intmets));
printMetrics(meanmets);

% GT
load('external/dptracking/bayesoptGT/j00003.mat')
meanmets=mean(reshape([allexp(:).m3d],14,6)');

meanmets(intmets)=round(meanmets(intmets));
printMetrics(meanmets);


% HOG
load('external/dptracking/bayesoptHOG/j00187.mat')
meanmets=mean(reshape([allexp(:).m3d],14,6)');

meanmets(intmets)=round(meanmets(intmets));
printMetrics(meanmets);


fprintf('KSP\n');

% RAW
load('../../external/ksptracking/bayesopt2/j00005.mat')
meanmets=mean(reshape([allexp(:).m3d],14,6)');

meanmets(intmets)=round(meanmets(intmets));
printMetrics(meanmets);

% GT
load('../../external/ksptracking/bayesoptGT/j00046.mat')
meanmets=mean(reshape([allexp(:).m3d],14,6)');

meanmets(intmets)=round(meanmets(intmets));
printMetrics(meanmets);