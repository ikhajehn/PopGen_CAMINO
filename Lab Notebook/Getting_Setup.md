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

```
# Make a Local Repository
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
