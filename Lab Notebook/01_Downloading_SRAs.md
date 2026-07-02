# Downloading SRA's From NCBI: Set Up
## Create a List of SRR's in HB
In order to download SRA's from NCBI, the appropriate SRR files must be located. Some papers will have a "Data Availability" section where they will provide this information. On NCBI, look up the library and download the Ascension List. Upload the Ascension list onto HB. 

Copy and paste the numbers into a text file
```
nano srrdata.txt    # my data set had 24 SRA files
SRR...37
SRR...38
SRR...39
|
|
SRR...60
```
Link to Data Set: [PRJNA1068064](https://www.ncbi.nlm.nih.gov/sra?term=PRJNA1068064&cmd=DetailsSearch)

Original Study (Preprint): [10.21203/rs.3.rs-7212941/v1](https://www.researchgate.net/publication/394166455_Heat_stress_responsive_genes_are_not_affected_by_ocean_warming_long-term_environmental_monitoring_and_acute_thermal_stress_experiments_identify_non-overlapping_sets_of_differentially_expressed_genes_i)

# Downloading SRA's From NCBI: Individually
Once the list is created, a script can be written to initiate the downloading process. You can download SRA files individually without a script using the following:
```
fastq-dump --skip technical --readids --read-filter pass --dumpbase --split-3 --clip SRR32484237/SRR32484237.sra
```
This method uses fastq-dump; however, I used fasterq-dump in my script, as it is faster and allows me to skip some flags, such as "```skip technical```" "```read filter```" and "```split-3```" etc. 

## Flags
Flags are options to give commands to perform tasks in a specific way. 
- ```--skip-technical``` only read biological reads (skip barcodes and primers)
- ```--readids``` appends .1 and .2 to the sequence ID's (default will give both reads the same ID)
- ```--read-filter pass``` filter out poor-quality reads or reads with uncalled bases (N)
- ```--dumpbase``` directs extracted bases to be in A, T, C, G, and N format (default would be colored)
- ```--split-3``` splits paired-end reads into two separate files (*_1.fastq and *_2.fastq) and unpaired or unmatched reads in a third file
- ```--clip``` removes tags that were used during amplification
- ```--outdir``` defines a folder to store FastQ files in

# Downloading SRA's From NCBI: Using an Array
An array allows mutiple tasks to run in parallel with each other and is the only feasible way to download many SRA's from NCBI
```
nano downloadfastq.sh

#!/bin/bash
|
|
|
#SBATCH --array=1-24                            # Since there are 24 files, the array goes from 1 to 24
#SBATCH --output=sra_download_out/_%A_%a.out
#SBATCH --error=sra_download_err/_%A_%a.err     
```
Note that originally when this script was written, I made out and error folders prior to sending the job. You can make these folders the way I did, or include the command in the script to have the folders, with out and error files, created on completion of the job. 
```
mkdir -p sra_download_out sra_download_err
```
I set the path to the directory where my SRR list was. This is also where I wanted the downloaded files to appear. 
```
cd /scratch/ikhajehn
```
A conda environment must be created to use ```prefetch``` and ```fasterq-dump``` commands. In the script, make sure you activate a conda environment as a first step, and load any necessary software. 
```
module load miniconda3
conda activate camino26
```
Next, I define a variable ```SRA```, which will store the files we wish to extract. This ensures that each ```.fastq``` file will be titled with its corresponding SRR number.  
```
SRA=$(sed -n "${SLURM_ARRAY_TASK_ID}p" poutssrdata.txt)
```
Then, I used prefetch to pull files from NCBI based on the SRA's stored
```
prefetch "{$SRA}"
```
Lastly, I downloaded the reads using ```fasterq-dump```
```
fasterq-dump "{$SRA}"
```
# Miscellaneous Notes 
## Memory
- Allotted Memory: 10GB
- Memory Utilizied: 606.95 MB 

## Time 
- Allotted Time: 03:00:00
- Job Completion Time: 00:19:11

## Note for the Future
This was my first ever successful job submitted with limited guidance. On future scripts, I direct a path to my ```pout``` folder as opposed to ```scratch```. If I were to rewrite this script, I would make that change. Having it output into my main directory would have removed the need to move files over between directories. Also, ```scratch``` is purged periodically, making it insuitable to store files long-term. 
