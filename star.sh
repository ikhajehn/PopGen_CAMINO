#!/bin/bash

#SBATCH --partition=128x24
#SBATCH --time=02:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ikhajehn@ucsc.edu
#SBATCH --job-name=star_array
#SBATCH --cpus-per-task=20
#SBATCH --mem=80G
#SBATCH --array=1-24
#SBATCH --output=star_out/_%A_%a.out
#SBATCH --error=star_err/_%A_%a.err
#SBATCH --no-requeue

# 0. Make output and error directories
mkdir -p star_out star_err

# 1. Load STAR
module load star

# 2. Configuration
cd /home/ikhajehn/pout
FASTQ_DIR="trim_results"
OUTPUT_DIR="star_results"
GENOME_INDEX="/home/ikhajehn/pout/genome_index"


# 3. Read the SRA ID for this array index
LINE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/ikhajehn/pout/poutssrdata.txt)

SRA=$(echo ${LINE} | awk '{print $1; }')

echo "Running STAR for sample: $SRA"

# 4. Set paths for paired-end reads
R1="${FASTQ_DIR}/${SRA}_1_val_1.fq"
R2="${FASTQ_DIR}/${SRA}_2_val_2.fq"

# 5. Skip if already done
if [ -f ${SRA}_Log.final.out ]; then
    echo "Already finished STAR for $SRA"
    exit 0
fi

# 6. Run STAR
STAR --genomeDir /home/ikhajehn/pout/genome_index \
     --runThreadN 20 \
     --outSAMtype BAM SortedByCoordinate \
     --outFileNamePrefix ${SRA}_ \
     --readFilesIn $R1 $R2
