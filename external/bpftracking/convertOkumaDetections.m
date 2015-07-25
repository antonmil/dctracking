%%
lines=textread('detections.txt', '%s','delimiter','\n');

F=length(lines);
clear detections

for t=1:F
    tmp_line=lines{t};
    numboox=0;
    numfigure=0;
    last=1;
    current=[];
    for j = 1:length(tmp_line),
        if tmp_line(j) == ' ',
            numfigure = numfigure + 1;
            numboost = ceil(numfigure/3);
            entry = mod(numfigure, 3);
            if entry == 0,
                entry = 3;
            end
            current(entry, numboost) = str2num(tmp_line(last:j-1));
            last = j + 1;
        end        
    end
%     for id=1:size(current,2)
    if size(current,2)
        detections(t).bx=current(1,:);
        detections(t).by=current(2,:);
        detections(t).wd=current(3,:)*24;
        detections(t).ht=current(3,:)*24;
        
        detections(t).xp=detections(t).bx+detections(t).wd/2;
        detections(t).yp=detections(t).by+detections(t).ht;
        
        detections(t).xi=detections(t).xp;detections(t).yi=detections(t).yp;
        
        detections(t).sc=ones(1,size(current,2));
        
    end
end