#!/bin/bash
#$ -pe smp 4
#$ -l h_vmem=100G
#$ -l h_rt=24:0:0
#$ -l highmem
#$ -cwd
#$ -j y
#$ -N Methylkit_R
#$ -o /data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/
#$ -m beas

module load anaconda3/2020.02
#load my enviroment
conda activate myRmeth

#run R script using Rscript with --no-save option
Rscript --no-save methRead_unite.r