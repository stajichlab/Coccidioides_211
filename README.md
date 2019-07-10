Assembly and annotation pipeline for Coccidioides immitis 211

Run assembly first and then annotation

Assembly
=====
These steps use software install on http://hpcc.ucr.edu but depend on opensource tools installable with conda or direct from the author. As long as the applications are in your path the steps should work. 

* [shovill](https://github.com/tseemann/shovill) for fast SPAdes assembly
* [AAFTF](https://github.com/stajichlab/AAFTF) for assembly cleanup and prep for funannotate
* [PILON](https://github.com/broadinstitute/pilon/wiki) for assembly polishing
* [RagOO](https://github.com/malonge/RaGOO) for scaffolding
```
cd assembly
pipeline/00_download.sh -download the DNA reads from SRA, get C.immitis RS genome from FungiDB
pipeline/01_shovill.sh -run Shovill assembly pipeline
pipeline/02_AAFTF.sh - run AAFTF cleanup of assembly, further pilon run
pipeline/03_ragoo.sh - scaffold against C.immitis RS assembly from FungiDB
```

Annotation
=====
These scripts provide the steps to annotate the genome and depend on 
* [funannotate](https://github.com/nextgenusfs/funannotate) which has many dependencies, in this annotation I used the gene predictors [Augustus](https://github.com/Gaius-Augustus/Augustus) (technically I used [v3.3](http://bioinf.uni-greifswald.de/augustus/binaries/old/)) [Genemark.hmm ES](http://exon.gatech.edu/GeneMark/gmes_instructions.html) [SNAP](https://github.com/KorfLab/SNAP) and [CodingQuarry](https://sourceforge.net/projects/codingquarry/).
* [PASA](https://pasapipeline.github.io/) and [Trinity](http://trinityrnaseq.github.io/) to assemnbly and annoate 
* [Interproscan](https://github.com/ebi-pf-team/interproscan/wiki/HowToRun)
* [AntiSMaSH](https://fungismash.secondarymetabolites.org/) - which you can run remotely without installing or run locally
```cd annotation
pipeline/00_download.sh - download the RNAseq from NCBI
pipeline/00_mask.sh - mask genome with existing repeat library for Cocci
pipeline/01_train.sh - run RNASeq alignment, Trinity to generate transcripts, and further call exons and train gene predictor Augustus
pipeline/02_predict.sh - run gene prediction steps
pipeline/03_annotfunc.sh - initial functional predictions using CAZY,Pfam,MEROPS,EggNog
pipeline/04_antismash_local.sh - run antismash locally (alt runs can be done remotely too)
pipeline/04b_iprscan.sh - run InterproScan
pipeline/03_annotfunc.sh - run again to incorporate AntiSMASH results and IPRScan - may need to edit config.txt to add back in expected antismash file
```

The genome assembly with annotation presented in this work is available under accession [RHJW00000000.2] (https://www.ncbi.nlm.nih.gov/nuccore/RHJW00000000.2/)
