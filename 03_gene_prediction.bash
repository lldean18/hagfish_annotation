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

####################################
# set up resources and environment #
####################################

source $HOME/.bash_profile
conda activate tmux
tmux new -s braker3
srun --partition defq --cpus-per-task 1 --mem 50g --time 160:00:00 --pty bash

# set variables
wkdir=/gpfs01/home/mbzlld/data/hagfish/RNAseq
reference=/gpfs01/home/mbzlld/data/hagfish/flye_1/assembly_ragtag/ragtag.scaffold.fasta

# move to working dir
cd $wkdir

# load singularity
module load singularity/3.8.5

# build and the braker3 container
singularity build braker3.sif docker://teambraker/braker3:latest




###############
# run braker3 #
###############

# run braker3 in the singularity container
singularity exec braker3.sif braker.pl \
	--genome $reference \
        --bam=$wkdir/all_hagfish_brain.bam,$wkdir/all_hagfish_notochord.bam \
        --softmasking \
        --gff3 \
        --AUGUSTUS_ab_initio \
        --species=Eptatretus_stoutii







# unload singularity
module unload singularity/3.8.5








###############################
## This didn't give a proper output because genewise won't install correctly so tried again
## above with the braker3 singularity container
## delete the below if that works
###############################
###############################
## load software
#source $HOME/.bash_profile
##conda create --name braker3 bioconda::braker3 -y 
#conda activate braker3
## had to install genemark manually from here: http://topaz.gatech.edu/GeneMark/license_download.cgi
## move it to Ada software bin, unzip it and add the unzipped dir to my path in .bashrc
#
#
## predict genes
#braker.pl --genome $reference \
#          --bam=$wkdir/all_hagfish_brain.bam,$wkdir/all_hagfish_notochord.bam \
#          --softmasking \
#	  --gff3 \
#          --AUGUSTUS_ab_initio \
#          --species=Eptatretus_stoutii
#
#
## unload software
#conda deactivate

