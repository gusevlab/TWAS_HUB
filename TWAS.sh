#!/bin/sh

# Run TWAS analyses
# $1 = file pointer to GWAS summary data in LDSC format
# $2 = integer GWAS sample size
# Run assumes all FUSION code, LDREF, and weights are in a FUSION directory
# --- for parallel jobs, your job scheduler variable goes here
CHR=${SLURM_ARRAY_TASK_ID}
# ---

GWAS=$1
N=$2
g=`basename $g_input | sed 's/\.sumstats//'`

POS="all.models.par"
OUT="$g/$g.$CHR"

Rscript ./FUSION/FUSION.assoc_test.R \
--sumstats $GWAS \
--out $OUT.dat \
--weights $POS \
--weights_dir ./FUSION/WEIGHTS/ \
--ref_ld_chr ./FUSION/LDREF/1000G.EUR. \
--chr $CHR --coloc_P 0.00005 --GWASN $N --PANELN panels.par
cat $OUT.dat | awk -vt=120092 'NR == 1 || $20 < 0.05/t' > $OUT.top

Rscript ./FUSION/FUSION.post_process.R \
--sumstats $GWAS \
--input $OUT.top \
--out $OUT.post \
--minp_input 1 \
--ref_ld_chr ./FUSION/LDREF/1000G.EUR. \
--chr $CHR --plot --locus_win 200e3 --report
