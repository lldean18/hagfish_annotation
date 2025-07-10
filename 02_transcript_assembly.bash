#!/bin/bash
# Laura Dean
# 10/7/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=transcript_assembly
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=30g
#SBATCH --time=100:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# set variables
wkdir=/gpfs01/home/mbzlld/data/hagfish/RNAseq
assembly=/gpfs01/home/mbzlld/data/hagfish/flye_1/assembly_ragtag/ragtag.scaffold.fasta
bams=( /gpfs01/home/mbzlld/data/hagfish/RNAseq/all_hagfish_brain.bam /gpfs01/home/mbzlld/data/hagfish/RNAseq/all_hagfish_notochord.bam )

# load software
source $HOME/.bash_profile
#conda create --name stringtie bioconda::stringtie -y
conda activate stringtie

for bam in ${bams[@]}; do
# assemble transcript
stringtie \
	$bam \
	-p 16 \
	--ref $assembly \
	-o ${bam%.*} \
	-L
done



# deactivate software
conda deactivate

