Assembly and annotation pipeline for Coccidioides immitis 211

Run assembly first and then annotation

Assembly
=====
These steps use software install on http://hpcc.ucr.edu but are all opensource and installable as long as are in path the steps should work.
```
cd assembly
pipeline/00_download.sh -download the DNA reads from SRA, get C.immitis RS genome from FungiDB
pipeline/01_shovill.sh -run Shovill assembly pipeline
pipeline/02_AAFTF.sh - run AAFTF cleanup of assembly, further pilon run
pipeline/03_ragoo.sh - scaffold against C.immitis RS assembly from FungiDB
```

Annotation
=====
These steps to annotate the genome
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
