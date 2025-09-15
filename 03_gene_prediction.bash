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
tmux new -s braker3 # create a new session to run braker in
tmux attach -t braker3 # attach to the new session
srun --partition defq --cpus-per-task 17 --mem 360g --time 168:00:00 --pty bashi # request compute resources

# set variables
wkdir=/gpfs01/home/mbzlld/data/hagfish/RNAseq
reference=/gpfs01/home/mbzlld/data/hagfish/flye_1/assembly_ragtag/ragtag.scaffold.fasta

# move to working dir
cd $wkdir

# load singularity
module load singularity/3.8.5

# build and the braker3 container
# think I only need to do this once so hashing out
#singularity build braker3.sif docker://teambraker/braker3:latest




###############
# run braker3 #
###############

# this ran for 7 days and then timed out
# trying first with increased threads
# increasing threads didn't work as braker complained that with such a fragmented
# genome it wanted to run on just 1 thread.
# Next plan:
# going to try running again but separating the brain and notochord input files
# if that fails I could try splitting the genome into chromosomes


# run braker3 in the singularity container
singularity exec braker3.sif braker.pl \
	--genome $reference \
        --bam=$wkdir/all_hagfish_brain.bam \
        --softmasking \
        --gff3 \
        --AUGUSTUS_ab_initio \
        --species=Eptatretus_stoutii \
	--useexisting



#	--threads 16 \
#        --bam=$wkdir/all_hagfish_brain.bam,$wkdir/all_hagfish_notochord.bam \


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

