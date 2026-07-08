#!/bin/bash

#SBATCH --mail-user=ikhajehn@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=trimgalore
#SBATCH --time=05:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --array=1-24
#SBATCH --output=trimming_out/_%A_%a.out
#SBATCH --error=trimming_err/_%A_%a.err
#SBATCH --no-requeue

# Set path to where the files are stored
cd /home/ikhajehn/pout/fastq_24

# Load conda environment and trim-galore 
module load miniconda3
conda activate camino26
module load trimgalore 
module load fastqc/0.12.1

# Configuration
sra_path=/home/ikhajehn/pout/poutssrdata.txt

R1=$(sed -n "${SLURM_ARRAY_TASK_ID}p" r1_list.txt)
R2=$(sed -n "${SLURM_ARRAY_TASK_ID}p" r2_list.txt)

# Make output directory

mkdir -p ../fastqc_results2
mkdir -p ../trim_results

# Trim Sequences

trim_galore --cores 2 --paired -q 20 --stringency 5 --length 50 --o ../trim_results \
	    --fastqc --fastqc_args "--nogroup --outdir ../fastqc_results2" "$R1" "$R2" 


# Unload trimgalore and deactivate conda environment 

module unload trimgalore
conda deactivate 


