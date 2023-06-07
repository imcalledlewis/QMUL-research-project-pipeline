#!/bin/bash
#$ -pe smp 4
#$ -l h_vmem=15G
#$ -l h_rt=4:0:0
#$ -cwd
#$ -j y
#$ -N Annotatr_DMR
#$ -o /data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/Comb-p/DMR_test_26-05-2023/annotate
#$ -m beas


#load my R
module load R/4.2.2

#run R script using Rscript with --no-save option
Rscript --no-save /data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/Comb-p/DMR_test_26-05-2023/annotate/annotate_DMR.r