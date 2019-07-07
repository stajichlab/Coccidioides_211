#!/bin/bash

#SBATCH --job-name=train
#SBATCH --ntasks=24
#SBATCH --time=80:00:00
#SBATCH --mem 240G
#SBATCH --nodes 1
#SBATCH -p intel

MEM=240
module load funannotate
PASAHOMEPATH=$(dirname `which Launch_PASA_pipeline.pl`)
TRINITYHOMEPATH=$(dirname `which Trinity`)
export AUGUSTUS_CONFIG_PATH=/bigdata/stajichlab/shared/pkg/augustus/3.2.2/config
CPUS=$SLURM_CPUS_ON_NODE

MEM=48G

if [ ! $CPUS ]; then
 CPUS=2
fi
MASKED=211.masked.fasta
funannotate train -i $MASKED -o funannotate --PASAHOME $PASAHOMEPATH \
 --TRINITYHOME $TRINITYHOMEPATH \
  -s RNASeq_fwd.fq \
     --stranded no --jaccard_clip --species "coccidioides_immitis" --cpus $CPUS --memory $MEM

#old marcus
#funannotate train -i 211.masked.fasta -o funannotate 
#--PASAHOME /opt/linux/centos/7.x/x86_64/pkgs/PASA/2.3.3/ 
#--TRINITYHOME /opt/linux/centos/7.x/x86_64/pkgs/trinity-rnaseq/2.6.6/ -s RNASeq_fwd.fq --stranded no 
#--jaccard_clip --species "coccidioides_immitis" --cpus 8 --memory 54
