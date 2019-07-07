#!/bin/bash -l

#SBATCH --nodes=1 -p batch
#SBATCH --ntasks=32
#SBATCH --mem 64G
#SBATCH --time=3-00:00:00   
#SBATCH --output=logs/annot_02.%A.log
#SBATCH --job-name="Funnannotate"

module unload python
module unload perl
module unload miniconda2
module load miniconda3
module load funannotate/git-live
module list
which perl

export AUGUSTUS_CONFIG_PATH=$(realpath augustus/config)
CPUS=$SLURM_CPUS_ON_NODE

if [ ! $CPUS ]; then
 CPUS=2
fi

if [ ! -f config.txt ]; then
 echo "need a config file for parameters"
 exit
fi

source config.txt
if [ ! $SORTED ]; then 
 echo "NEED TO EDIT CONFIG FILE TO SPECIFY THE INPUT GENOME AS VARIABLE: SORTED=GENOMEFILEFFASTA"
 exit
fi

if [ ! $BUSCO ]; then
 echo "NEED TO PROVIDE A BUSCO FOLDER NAME eg. ascomycota_odb9 fungi_odb9 dikarya_odb9 etc"
 exit
elif [ ! -e $BUSCO ]; then
  ln -s /opt/linux/centos/7.x/x86_64/pkgs/funannotate/share/$BUSCO .
fi

#if [ ! -f uniprot_sprot.fasta ]; then
# ln -s /opt/linux/centos/7.x/x86_64/pkgs/funannotate/share/uniprot_sprot.fasta .
#fi
if [ ! $PROTEINS ]; then
 PROTEINS=uniprot_sprot.fasta
fi

if [ ! "$EXTRA" ]; then
 EXTRA="--ploidy 1"
fi
if [ ! $ODIR ]; then
 ODIR=$(basename `pwd`)."funannot"
fi

funannotate predict -i $MASKED -s "$SPECIES" -o $ODIR --isolate "$ISOLATE"  --name $PREFIX --busco_db $BUSCO --genemark_mod $GENEMARK $AUGUSTUSOPTS \
  --AUGUSTUS_CONFIG_PATH $AUGUSTUS_CONFIG_PATH --transcript_evidence $TRANSCRIPTS --cpus $CPUS $EXTRA --protein_evidence $PROTEINS $FUNANNOTATE_DB/uniprot_sprot.fasta 
