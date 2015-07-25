jdir = 'bayesoptHOG';
allmets=zeros(1,14);
for j=1:1000
    jfile = [jdir,filesep,sprintf('j%05d.mat',j)];
    if exist(jfile,'file')
        load(jfile)
        if length(allexp)==6
            allmets(j,:)=mean(reshape([allexp(:).m3d],14,6)');
        end
    end
end
allmota=allmets(:,12);
[bestmota,bestexp]=max(allmota)