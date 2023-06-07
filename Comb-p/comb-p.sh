#!/bin/bash
#$ -pe smp 8
#$ -l h_vmem=55G
#$ -l highmem
#$ -l h_rt=10:0:0
#$ -cwd
#$ -j y
#$ -N comb_p
#$ -o /data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/Comb-p/DMR_test_26-05-2023
#$ -m beas

module load R/4.2.2
Rscript --no-save /data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/Comb-p/DMR_test_26-05-2023/meth_to_bed.r

#load my anaconda3 env ###Python 2.7.18###
module load anaconda3/2020.02
conda activate comb_p

#use bedtools to sort bed file 
bedtools sort -i methDiff.bed > sort_methDiff.bed
conda deactivate

module load R/4.2.2
Rscript --no-save /data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/Comb-p/DMR_test_26-05-2023/header.r

conda activate comb_p
#run comb_p script
comb-p pipeline -c 4 --seed 0.05 --dist 200 -p results/DMR_def --region-filter-p 0.1 --annotate hg38 sort_methDiff.bed

