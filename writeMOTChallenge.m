function writeMOTChallenge(setting)

allscen=1051:1061;


alltimes=[];
for scen=allscen
    %     sceneInfo=getSceneInfo(scen);
    resfile=sprintf('results/%s/prt_res-scen%04d.mat',setting,scen);
    load(resfile);
    finfo=dir(resfile);
    alltimes=[alltimes,finfo.datenum];
    
    
    switch(scen)
        case 1051
            seqname='TUD-Crossing';
        case 1052
            seqname='PETS09-S2L2';
        case 1053
            seqname='ETH-Jelmoli';
        case 1054
            seqname='ETH-Linthescher';
        case 1055
            seqname='ETH-Crossing';
        case 1056
            seqname='AVG-TownCentre';
        case 1057
            seqname='ADL-Rundle-1';
        case 1058
            seqname='ADL-Rundle-3';
        case 1059
            seqname='KITTI-16';
        case 1060
            seqname='KITTI-19';
        case 1061
            seqname='Venice-1';
        otherwise
            error('unknown scenario');
    end
    
    convertSTInfoToTXT(stateInfo,sprintf('results/%s/%s.txt',setting,seqname));
    
end

datestr(max(alltimes)-min(alltimes))