#!/bin/bash

#SBATCH --mail-user=ikhajehn@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=run_fastqc
#SBATCH --time=03:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=15G
#SBATCH --array=1-48
#SBATCH --output=fastqc_out/_%A_%a.out
#SBATCH --error=fastqc_err/_%A_%a.err
#SBATCH --no-requeue

# Load fastqc
module load fastqc/0.12.1

# Set the path 
cd /home/ikhajehn/pout/fastq_24

# Use FASTQ files uploaded to HB for FASTQC
FASTQ=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ../fastq_list.txt)

# Make output directory
mkdir -p ../fastqc_results

# run fastqc and put results into the output directory
fastqc "$FASTQ" --outdir ../fastqc_results 
