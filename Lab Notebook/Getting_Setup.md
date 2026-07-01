# Slurm on Hummingbird

```ssh ikhajehn@hb.ucsc.edu```
```cd ~/pout``` 

# Important Modules to Know
```
module load miniconda3   # to load SRA-Toolkit (which will include fasterq-dump, multiqc, and more)
  conda activate [environment name]   # create and/or activate a conda environment
module load fastqc
module load multiqc
module load git
module load star
```

# Installing Software Packages 

```
conda install -c bioconda:sra_tools   # download SRA-toolkit
brew install git    # download git
```

# Pushing Scripts onto GitHub via Terminal 

In order to upload files into GitHub using terminal, a local repository and remote repository must be made. On GitHub, click on your profile icon and navigate to "Repositories". Click the green "New" button (make sure Add README is toggled on). Afterwards, click on "<> Code" and copy the HTTPS link to the repository to your clipboard. That HTTPS link will be used in the following steps to create a local repository on HB
```
cd ~/pout
module load git
git clone https://github.com/ikhajehn/CAMINO-Scripts.git
```

# Uploading to GitHub
```
mv [file name] ~/pout/CAMINO-Scripts/    # Remember that the file must be in the local repository
cd ~/pout/CAMINO-Scripts/
git pull    # Make sure the local and remote repositories are up-to-date
git add [file name]
git commit -m "Title"
git push
```
Referesh GitHub 
