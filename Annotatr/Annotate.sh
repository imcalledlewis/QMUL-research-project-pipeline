#!/bin/bash
#$ -pe smp 4
#$ -l h_vmem=15G
#$ -l h_rt=24:0:0
#$ -l highmem
#$ -cwd
#$ -j y
#$ -N Methylkit_R
#$ -o /data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/
#$ -m beas


#load my R
module load R/4.2.2

#run R script using Rscript with --no-save option
Rscript --no-save /data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/Annotation/Annotatr_TE.r
