#!/bin/bash
#$ -pe smp 6
#$ -l h_vmem=4G
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
file="/data/scratch/bt22880/2023-21-03-colorectal-rrbs/2023-06-04-TE_refrence/data/hg38.fa.out"
# Set the header names for the selected columns
#headers="Chromosome\tStart\tEnd\tRE_name"

# Use awk to select the specified columns and output to a new file, skipping the first two lines
awk 'NR>3{print $5 "\t" $6 "\t" $7 "\t" $10"_"$11}' $file > hg38_column.tsv

# Remove "chr" from the Chromosome column and output to a new file
awk -F'\t' '{sub(/^chr/, "", $1); print}' hg38_column.tsv > hg38.out.bed

#make it tab delimited 
tr ' ' '\t' < hg38.out.bed > hg38.out.tab.bed


