#!/bin/sh
#echo $1

# precomp helper structures 
#matlab -nodesktop -nosplash -r "precomputeForCluster('$PBS_JOBNAME'); quit;";

#qsub -t 1-20 -j oe -l walltime=08:00:00 -l vmem=16GB -W depend=afterokarray:69420 -o logs -N $1 trainModel.sh
#qsub -t 1-20 -j oe -l nodes=acvt-node00+acvt-node01+acvt-node02+acvt-node03+acvt-node04+acvt-node05+acvt-node06+acvt-node07+acvt-node08+acvt-node09+acvt-node10+acvt-node11+acvt-node20+acvt-node11+acvt-node22+acvt-node23+acvt-node24+acvt-node25+acvt-node26+acvt-node27+acvt-node28+acvt-node29+acvt-node30+acvt-node31+acvt-node32+acvt-node33 -l walltime=32:00:00 -l vmem=6GB -o logs -N $1 trainModel.sh

qsub -t 1-20 -j oe -l walltime=2:00:00 -l vmem=4GB -o logs -N $1 trainKSP.sh

