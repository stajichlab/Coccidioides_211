#!/usr/bin/bash

mkdir -p raw logs
curl -o raw/SRR1292227_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR129/007/SRR1292227/SRR1292227_1.fastq.gz
curl -o raw/SRR1292227_2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR129/007/SRR1292227/SRR1292227_2.fastq.gz


curl -O https://fungidb.org/common/downloads/release-38/CimmitisRS/fasta/data/FungiDB-38_CimmitisRS_Genome.fasta
