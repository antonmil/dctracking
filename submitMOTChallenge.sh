#!/bin/sh
#echo $1

# precomp helper structures 
#matlab -nodesktop -nosplash -r "precomputeForCluster('$PBS_JOBNAME'); quit;";

if [[ $# -eq 2 ]]; then
	qsub -t 1-11 -j oe -l walltime=10:00:00 -l vmem=24GB -W depend=afterokarray:$2[] -o logs -N $1 runMOTChallenge.sh
elif [[ $# -eq 1 ]]; then
	qsub -t 1-11 -j oe -l walltime=10:00:00 -l vmem=24GB -o logs -N $1 runMOTChallenge.sh
else 
	echo "Illegal number of parameters"
fi
