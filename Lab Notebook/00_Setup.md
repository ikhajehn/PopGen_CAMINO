# Slurm on Hummingbird

Logging onto HB using terminal
```
ssh ikhajehn@hb.ucsc.edu
cd pout
``` 

# Important Modules to Know
```
module load miniconda3                  # to load SRA-Toolkit (which will include fasterq-dump, multiqc, and more)
module load fastqc
module load multiqc
module load git
module load star

conda activate [conda environment name] # command to create and activate an environment of a given name
conda deactivate                        # turns off the conda environment 
```

# Installing Software Packages 

Note that these softwares may already be present on HPC, but it is useful to know how to install softwares using Anaconda and/or Homebrew 
```
conda install -c bioconda:sra_tools   # download SRA-toolkit
conda install bioconda::multiqc       # download multiqc
brew install git                      # download git
```

# Pushing Scripts onto GitHub via Terminal 

## Creating Repositories 

In order to upload files into GitHub using terminal, a local repository and remote repository must be made. 

1. On GitHub, click on your profile icon and navigate to **Repositories**.
2. Click the green **New** button (make sure Add README is toggled on).
3. Click on **<> Code** and copy the HTTPS link to the repository to your clipboard (will be used in the following steps to create a local repository on HB)
4. On Terminal, use the following commands to create a local repository in HB
```
cd pout
module load git
git clone https://github.com/ikhajehn/CAMINO-Scripts.git
```

## Uploading to GitHub
Use the following commands to upload a file into GitHub 
```
mv /path/to/file /path/to/repository    # Remember that the file must be in the local repository
cd /path/to/repository
git pull                                # Make sure the local and remote repositories are up-to-date
git add [file name]
git commit -m "Title"
git push
```
Referesh GitHub 
