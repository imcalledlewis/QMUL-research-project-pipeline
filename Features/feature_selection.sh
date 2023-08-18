#!/bin/bash
#$ -pe smp 15
#$ -l h_vmem=10G
#$ -l h_rt=72:0:0
#$ -l highmem
#$ -cwd
#$ -j y
#$ -N features
#$ -o /data/home/bt22880/WGBS_TE_pipeline/TensorFlow/Feature_selection
#$ -m beas

module load anaconda3/2020.02

conda activate tensorf_env

python features.py
