Assembly and annotation pipeline for Coccidioides immitis 211

Run assembly first and then annotation

Assembly
=====
These steps use software install on http://hpcc.ucr.edu but are all opensource and installable as long as are in path the steps should work.
```
cd assembly
pipeline/00_download.sh
pipeline/01_shovill.sh
pipeline/02_AAFTF.sh
pipeline/03_ragoo.sh
```
