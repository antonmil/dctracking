function dataDir=getDataDir()
% set data directory

dataDir='/export/data1/data/';
if exist('/home/amilan','dir')
	dataDir='/home/amilan/research/projects/bmtt-data/';
end
if exist('d:/','dir')
    dataDir=fullfile('d:','storage','databases','2DMOT2015','train',filesep);
end
if exist('/home/h3','dir')
	dataDir='/home/h3/amilan/storage/databases/2DMOT2015/train/';
end
