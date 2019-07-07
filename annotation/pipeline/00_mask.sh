#!/bin/bash
#SBATCH -p batch --time 2-0:00:00 --ntasks 8 --nodes 1 --mem 24G --out logs/mask.%A.log

CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
    CPU=$SLURM_CPUS_ON_NODE
fi
if [[ -f config.txt ]]; then
	source config.txt
else
	echo "Must have a config.txt"
	exit
fi

if [ ! -f $SORTED ]; then
     echo "Cannot find $SORTED - may not have been run yet"
     exit
 fi

if [ ! -f $OUTDIR/$MASKED ]; then
    module load funannotate/git-live
    echo "$RMLIB $SORTED $MASKED"
    export AUGUSTUS_CONFIG_PATH=$(realpath augustus/config)
    funannotate mask --cpus $CPU --repeatmodeler_lib $RMLIB-i $SORTED -o $MASKED
fi

