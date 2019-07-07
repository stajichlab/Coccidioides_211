#!/usr/bin/bash
#SBATCH --ntasks 12 --nodes 1 --mem 96G --time 2:00:00 -p short --out logs/run_genemark.log
module load parallel
module load genemarkESET
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
fi

CPUS=$SLURM_CPUS_ON_NODE
TMPDIR=genemark_run
OUTFILE=genemark.gtf
if [[ -f "config.txt" ]]; then
	source config.txt
else
	echo "Need a config file"
	exit
fi

if [[ -z $MASKED || ! -f $MASKED ]]; then
	echo "NEED TO EDIT CONFIG FILE TO SPECIFY THE INPUT GENOME AS VARIABLE: MASKED=GENOMEFILEFFASTA"
 	exit
fi

if [[ -z $GENEMARK || ! -f $GENEMARK ]]; then
	echo "need to edit config and provide GENEMARK variable to point to gmes.mod file"
	exit
fi
if [ ! -d $TMPDIR ]; then
	mkdir -p $TMPDIR
	pushd $TMPDIR
 	bp_seqretsplit.pl ../$MASKED
popd
fi
cmdfile=genemark.jobs
if [ ! -f $cmdfile ]; then
	for file in $TMPDIR/*.fa;
	do 
		scaf=$(basename $file .fa)
		GTF="$TMPDIR/$scaf.gtf"
		if [ ! -f $GTF ]; then
		#reformat_fasta.pl --up --soft_mask --native --in $file --out $TMPDIR/$scaf.masked
 			probuild --reformat_fasta --mask_soft 100 --up --allow_x --letters_per_line 60 --in $file --out $TMPDIR/$scaf.masked
    #unlink $file
			perl -i -p -e "s/^>(\S+)/>$scaf/" $TMPDIR/$scaf.masked
			echo "gmhmme3 -s $scaf -f gtf -m $GENEMARK -o $GTF $TMPDIR/$scaf.masked"
		fi 
	done > $cmdfile

	parallel -j$CPUS -a $cmdfile 
	perl -p -e 'if( ! /^#/ ) { my @row = split(/\t/,$_); my $scaf = $row[0]; $row[-1] =~ s/gene_id\s+"([^"]+)"; transcript_id\s+"([^"]+)"/gene_id "$scaf.$1"; transcript_id "$scaf.$2"/; $_ = join("\t",@row)}' $TMPDIR/*.gtf > genemark.gtf
fi
