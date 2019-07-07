#!/usr/bin/bash
#SBATCH --ntasks 16 --mem 64gb --out logs/aaftf.log -p batch

module load AAFTF

CPU=$SLURM_CPUS_ON_NODE
if [ ! $CPUS ]; then
 CPU=2
fi

DIR=shovill_211
FINAL=211.sorted.fasta
LEFT=raw/SRR1292227_1.fastq.gz
RIGHT=raw/SRR1292227_2.fastq.gz
ASM=$DIR/spades.fasta
VEC=$DIR/vectrim.fasta
SOUR=$DIR/sour.fasta
DUP=$DIR/rmdup.fasta
PILON=$DIR/polish.fasta

if [ ! -f $VEC ]; then
	AAFTF vecscreen -i $ASM -o $VEC -c $CPU
fi

#if [ ! -f $SOUR ]; then
#	AAFTF sourpurge -c $CPU --left $LEFT --right $RIGHT -i $VEC -o $SOUR --phylum Ascomycota
#fi

if [ ! -f $DUP ]; then
	AAFTF rmdup -i $VEC -o $DUP -c $CPU 
fi

if [ ! -f $PILON ]; then
	AAFTF pilon --left $LEFT --right $RIGHT -i $DUP -o $PILON -c $CPU -it 5
fi

if [ ! -f $FINAL ]; then
	AAFTF sort -i $PILON -o $FINAL
fi
