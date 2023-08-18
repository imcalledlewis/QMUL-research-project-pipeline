#!/bin/bash
#$ -pe smp 4
#$ -l h_vmem=20G
#$ -l h_rt=1:0:0
#$ -cwd
#$ -j y
#$ -N features
#$ -o /data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/Features
#$ -m beas

module load R/4.2.2
#run R script using Rscript with --no-save option
Rscript --no-save Features.r