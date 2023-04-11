#!/bin/bash
#$ -pe smp 6
#$ -l h_vmem=4G
#!/bin/bash
#$ -pe smp 6
#$ -l h_vmem=4G
#$ -l h_rt=24:0:0
#$ -cwd
#$ -j y
#$ -N Bedtools_TE_refrence 
#$ -o /data/home/bt22880/scratch/2023-21-03-colorectal-rrbs/2023-06-04-TE_refrence/output  
#$ -m bea

#load in module 
module load bedtools/2.28.0

bedtools getfasta -name -fi <Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa> -bed <hg38.out.bed>

