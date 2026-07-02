# Running a Quality Control via FastQC
## Introduction to FastQC
FastQC is an important software that evaluates the quality of raw sequencing reads. It is important to check the quality of a library before running analysis to check for poor quality reads, overrepresented sequences, and adapter contimination, etc.

A basic command for running FastQC 
```
fastqc SRR32484237_1.fastq.gz SRR32484237_2.fastq --outdir=fastqc_results
```
## Running FastQC on Multiple Files in Parallel
In practical settings, running FastQC's on multiple SRA files inidivually is inefficient. Because of this, an array must be written to run multiple FastQC's at the same time. 

1. Important parts of the script to note:
```
#SBATCH --job-name=run_fastqc 
#SBATCH --time=03:00:00
|
|
#SBATCH --mem=15G
#SBATCH --array=1-48
#SBATCH --output=fastqc_out/_%A_%a.out
#SBATCH --error=fastqc_err/_%A_%a.err
|
```
The array runs from 1-48 because I have 24 paired-end reads, resulting in 48 fastq files. 

2. Load FastQC
```
module load fastqc/0.12.1
```
3. I set the path to where the fastq files are located on HB
```
cd /home/ikhajehn/pout/fastq_24
```
4. Set a variable ```FASTQ``` to each fastq file upload to HB
```
FASTQ=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ../fastq_list.txt)
```
Why did I put the ```../``` before the ```fastq_list.txt```? 

That is because the list of fastq file names are located in a parent directory, and not in the current configured directory. This will tell HPC to look at the parent directory ```~/pout``` for the file ```fastq_list.txt```

5. Make an output directory for the FastQC results in the parent directory 
```
mkdir -p ../fastqc_results
```
6. Run FastQC and put the results into the output directory
```
fastqc "$FASTQ" --outdir ../fastqc_results
```
Breaking up the syntax:
- ```fastqc```: run a fastqc on ...
- ```"$FASTQ"```: variable from earlier which I set to be the names of each fastq file uploaded
- ```--outdir ../fastqc_results```: after running FastQC on all the files on HB, put the results in the output directory

Resource for FastQC Interpretation: [FastQC Manual](https://mugenomicscore.missouri.edu/PDF/FastQC_Manual.pdf)

Script for Running FastQC: [runfastqc.sh](https://github.com/ikhajehn/PopGen_CAMINO/blob/main/Scripts/runfastqc.sh)

# MultiQC Report
MultiQC is a great tool for visualizing all the FastQC reports at once. 

Running MultiQC
```
cd fastqc_results

module load miniconda3     # multiqc is a software available on miniconda
conda activate camino26
module load multiqc        # load multiqc software
multiqc .                  # run multiqc
```

# Viewing FastQC and MultiQC Reports 
There are many ways to view reports that involve either moving files on a external folder on a personal device through Terminal, or using an application such as CyberDuck or FileZilla. I used CyberDuck to move all my reports onto my desktop to view them. 
## Download CyberDuck onto Computer or Laptop 
CyberDuck is an application that allows users to click and drag ```.html``` files from HPC to an external folder with ease. 

[Download CyberDuck](https://cyberduck.io/download/)

## Configuring CyberDuck 
Before using CyberDuck, we need to configure it to get access to all our files on HB
1. Open CyberDuck and click **Open Connection**
2. Make sure SFTP (SSH File Transfer Protocol) is selected (default is FTP, File Transfer Protocol)
3. Server: hb.ucsc.edu
4. Username: Gold ID
5. Password: Password for Gold ID
6. Under **More Options**, nickname the connection
7. Under Download Folder, select the folder you wish the files to be transferred to

## Moving Files with CyberDuck

1. Click **Connect**,
2. Check if CyberDuck is configured properly, and it has access to your files on HB.
3. Click into the connection
4. Select the folder where the FastQC and MultiQC files are located
5. Click and drag the ```.html``` files from CyberDuck directly into Finder or File Explorer. 

# Miscellaneous Notes 
## Memory 
- Memory Allotted: 15 GB
- Memory Utilized: 418.57 MB
## Time 
- Time Allotted: 00:03:00
- Job Completion Time: 00:04:44
## Notes for the Future
- Remember that you must configure the path to where the fastq files are located
- Put all folders under one directory, so you will not need ```../``` (but know that it is an option if need be). 
