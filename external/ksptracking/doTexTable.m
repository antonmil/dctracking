allscen=[23 42 80 25 27 71 72];
allmets=zeros(0,14);
allmets_ae=zeros(0,14);

doae=0;
scncnt=0;

fid=fopen('/home/aanton/diss/tracking/PAMI2011/berclaztable.tex','w');
for scenario=allscen
    scncnt=scncnt+1;
    metfile=sprintf('%s/output/s%04d/metrics.txt',kspfolder,scenario);
    metfile_ae=sprintf('%s/output/s%04d/metrics-allentry.txt',kspfolder,scenario);
    metrics=dlmread(metfile);
    allmets(scncnt,:)=metrics;    
    fprintf(fid,'\\textbf{%s} & KSP \\cite{Berclaz2011PAMI} & %.1f & %.1f & %d & %d & %d & %d & %d & %d & %d & %.1f & %.1f & %.2f \\\\ \n', ...
        getSequenceFromScenario(scenario),metrics(12),metrics(13), metrics(4),metrics(5),metrics(7), ...
        metrics(8),metrics(9),metrics(10),metrics(11),metrics(1),metrics(2),metrics(3));
    
    if doae
    metrics=dlmread(metfile_ae);
    allmets_ae(scncnt,:)=metrics;
    fprintf(fid,'\\rowcolor{gray90}\n');
    fprintf(fid,'\\textbf{%s} & KSP (all entry)\\cite{Berclaz2011PAMI} & %.1f & %.1f & %d & %d & %d & %d & %d & %d & %d & %.1f & %.1f & %.2f \\\\ \n', ...
        getSequenceFromScenario(scenario),metrics(12),metrics(13), metrics(4),metrics(5),metrics(7), ...
        metrics(8),metrics(9),metrics(10),metrics(11),metrics(1),metrics(2),metrics(3));
    end
    
end
fprintf(fid,'\\hline\n');
meaneasy=mean(allmets(1:3,:));
meanhard=mean(allmets(4:7,:));

if doae
meaneasy_ae=mean(allmets_ae(1:3,:));
meanhard_ae=mean(allmets_ae(4:7,:));
end
fprintf(fid,'mean (G1) & KSP \\cite{Berclaz2011PAMI} & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f \\\\ \n', ...
    meaneasy(12),meaneasy(13), meaneasy(4),meaneasy(5),meaneasy(7), ...
    meaneasy(8),meaneasy(9),meaneasy(10),meaneasy(11),meaneasy(1),meaneasy(2),meaneasy(3));

if doae
fprintf(fid,'\\rowcolor{gray90}\n');

fprintf(fid,'mean (G1) & KSP (all entry)\\cite{Berclaz2011PAMI} & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f \\\\ \n', ...
    meaneasy_ae(12),meaneasy_ae(13), meaneasy_ae(4),meaneasy_ae(5),meaneasy_ae(7), ...
    meaneasy_ae(8),meaneasy_ae(9),meaneasy_ae(10),meaneasy_ae(11),meaneasy_ae(1),meaneasy_ae(2),meaneasy_ae(3));
end


fprintf(fid,'mean (G2) & KSP \\cite{Berclaz2011PAMI} & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f \\\\ \n', ...
    meanhard(12),meanhard(13), meanhard(4),meanhard(5),meanhard(7), ...
    meanhard(8),meanhard(9),meanhard(10),meanhard(11),meanhard(1),meanhard(2),meanhard(3));

if doae
fprintf(fid,'\\rowcolor{gray90}\n');

fprintf(fid,'mean (G2) & KSP (all entry) \\cite{Berclaz2011PAMI} & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f & %.1f \\\\ \n', ...
    meanhard_ae(12),meanhard_ae(13), meanhard_ae(4),meanhard_ae(5),meanhard_ae(7), ...
    meanhard_ae(8),meanhard_ae(9),meanhard_ae(10),meanhard_ae(11),meanhard_ae(1),meanhard_ae(2),meanhard_ae(3));
end

fclose(fid);