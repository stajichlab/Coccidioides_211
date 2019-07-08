#!/usr/bin/bash
#SBATCH -p short --mem 16gb -N 1 -n 8 --out ragoo.log

module unload miniconda2
module unload perl
module unload python
module load miniconda3
module load AAFTF

source activate shovill
IN=211.sorted.fasta
FINAL=211.ragoo.fasta
FINALSORTED=211.ragoo.sorted.fasta

ragoo.py -t 8 -C $IN FungiDB-38_CimmitisRS_Genome.fasta

cp ragoo_output/ragoo.fasta $FINAL
AAFTF sort -i $FINAL -o $FINALSORTED
AAFTF assess -i $FINALSORTED -r 211.ragoo.stats.txt

cp $FINALSORTED ../annotation
