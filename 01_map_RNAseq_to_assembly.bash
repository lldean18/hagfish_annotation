#!/bin/bash
# Laura Dean
# 9/7/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=mapRNA2asm
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=50g
#SBATCH --time=150:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# set variables
wkdir=/gpfs01/home/mbzlld/data/hagfish
assembly=$wkdir/flye_1/assembly_ragtag/ragtag.scaffold.fasta

RNAseq=( /gpfs01/home/mbzlld/data/hagfish/RNAseq/all_hagfish_notochord.fastq.gz /gpfs01/home/mbzlld/data/hagfish/RNAseq/all_hagfish_brain.fastq.gz )


# activate software
source $HOME/.bash_profile
conda activate minimap2



# map the RNAseq reads to the assembly
for file in ${RNAseq[@]}; do
minimap2 -ax splice -uf -k14 $assembly $file | samtools view -@15 -bS - | samtools sort -@15 -o ${file%.*.*}.bam
samtools index -@ 15 ${file%.*.*}.bam
done



# deactivate software
conda deactivate

