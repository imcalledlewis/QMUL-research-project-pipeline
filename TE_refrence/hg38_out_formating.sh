#!/bin/bash
#$ -pe smp 6
#$ -l h_vmem=4G
#$ -l h_rt=24:0:0
#$ -cwd
#$ -j y
#$ -N hg38 trim 
#$ -o /data/home/bt22880/scratch/2023-21-03-colorectal-rrbs/2023-06-04-TE_refrence/tmp
#$ -m bea

# Set the file path and column indices to select
#file="/data/scratch/bt22880/2023-21-03-colorectal-rrbs/2023-06-04-TE_refrence/data/hg38.fa.out"
# Set the header names for the selected columns
headers="Chromosome,Start,End,Name"

#tr -s ' ' ',' < $file > hg38.fa.c.out


# Use awk to select the specified columns and output to a new file, skipping the first line
awk -F',' 'NR>1{print $6,$7,$8,$12}' hg38.fa.c.out > hg38_column.tsv

# Remove "chr" from the Chromosome column and output to a new file
awk -F'\t' '{sub(/^chr/, "", $1); print}' hg38_column.tsv > hg38_column_clean.tsv

# Replace the headers and remove the second row
sed -i '1s/^/Chromosome,Start,End,RE_name\n/' hg38_column_clean.tsv
sed -i '2d' hg38_column_clean.tsv
