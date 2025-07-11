#!/bin/bash
# Laura Dean
# 11/7/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=gene_prediction
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50g
#SBATCH --time=148:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# set variables
wkdir=/gpfs01/home/mbzlld/data/hagfish/RNAseq
reference=/gpfs01/home/mbzlld/data/hagfish/flye_1/assembly_ragtag/ragtag.scaffold.fasta


cd $wkdir


# load software
source $HOME/.bash_profile
#conda create --name braker3 bioconda::braker3 -y 
conda activate braker3
# had to install genemark manually from here: http://topaz.gatech.edu/GeneMark/license_download.cgi
# move it to Ada software bin, unzip it and add the unzipped dir to my path in .bashrc


# predict genes
braker.pl --genome $reference \
          --bam=$wkdir/all_hagfish_brain.bam,$wkdir/all_hagfish_notochord.bam \
          --softmasking \
	  --gff3 \
          --AUGUSTUS_ab_initio \
          --species=Eptatretus_stoutii



# unload software
conda deactivate

