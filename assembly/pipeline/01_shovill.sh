#!/usr/bin/bash
#SBATCH -p batch -N 1 -n 16 --mem 64gb --out logs/shovill.%A.log --time 2-0:00:00

MEM=64

CPUS=$SLURM_CPUS_ON_NODE
if [ ! $CPUS ]; then
 CPUS=2
 fi
module unload miniconda2
module load miniconda3
module unload perl
module unload python
conda activate shovill
source activate shovill

shovill --R1 raw/SRR1292227_1.fastq.gz --R2 raw/SRR1292227_2.fastq.gz --outdir shovill_211 --minlen 500 --trim \
--cpus $CPUS --ram $MEM
