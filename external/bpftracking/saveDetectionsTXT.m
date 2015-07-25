function saveDetectionsTXT(detections,filename)

fid=fopen(filename,'w');

F=length(detections);
for t=1:F
    ndets=numel(detections(t).bx);
    for det=1:ndets
        fprintf(fid,'%f %f %f ',detections(t).bx(det), detections(t).by(det), detections(t).wd(det)/64);
    end
    fprintf(fid,'\n');
end

fclose(fid);

end