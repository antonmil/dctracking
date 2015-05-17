function convertSTInfoToTXT(stInfo, txtFile)
% convert Anton's struct format to simple CSV file


stInfo.Xi=stInfo.Xi';
stInfo.Yi=stInfo.Yi';
stInfo.W=stInfo.W';
stInfo.H=stInfo.H';

numBoxes = numel(find(stInfo.Xi(:)));
exGT = find(stInfo.Xi(:));
[id,fr]=find(stInfo.Xi);
wd = stInfo.W(exGT);
ht = stInfo.H(exGT);
bx = stInfo.Xi(exGT)-wd/2;
by = stInfo.Yi(exGT)-ht;

allData = [fr, id, bx, by, wd, ht, -1*ones(numBoxes,1), -1*ones(numBoxes,1), -1*ones(numBoxes,1), -1*ones(numBoxes,1)];


dlmwrite(txtFile,allData);
