%%
for s=0:28
    cd /home/amilan/storage/databases/KITTI/tracking/devkit_tracking/matlab
    tracklets=readLabels('../../testing/label_02',s);
    cd /home/amilan/research/projects/dctracking
    convertKITTIToCVML(tracklets,sprintf('/home/amilan/storage/databases/KITTI/tracking/testing/label_02/%04d.xml',s),{'Car','Van'});
end