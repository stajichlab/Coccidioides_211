#!/usr/bin/bash
mkdir -p RNASeq
for SRA in $(cat lib/RNASeq_SRA.txt)
do
	if [ ! -f RNASeq/${SRA}_1.fq.gz ]; then
		curl -o RNASeq/${SRA}_1.fq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR516/$SRA/$SRA.fastq.gz
	fi
done

pigz -dc RNASeq/*.fq.gz | pigz -c > RNASeq_fwd.fq.gz
