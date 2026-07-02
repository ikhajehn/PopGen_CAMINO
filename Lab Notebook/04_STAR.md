# Mapping RNAseq to Reference Genome via STAR Aligner
## Creating a Genome Index
Making a genome index compresses and organizes all the FASTA files into a searchable dictionary for STAR to quickly refer to. ```STAR--``` automatically defaults to a 14 SA pre-indexing string, but it was too large for my genome size = 663017713; therefore, I had to lower it to 13 using ```--genomeSAindexNbases 13```
My command for creating a genome index on HB
```
module load star && STAR --runMode genomeGenerate --genomeDir /home/ikhajehn/pout/genome_index --genomeFastaFiles /home/ikhajehn/pout/reference_genome/ncbi_dataset/data/GCA_040110945.1/GCA_040110945.1_Zoavi_1_2_genomic.fna --sjdbGTFfile /home/ikhajehn/pout/reference_genome/ncbi_dataset/data/GCA_040110945.1/genomic.gtf --sjdbOverhang 149 --runThreadN 8 --genomeSAindexNbases 13
```
- ```--runMode genomeGenerate``` tells STAR to initiate creation of genome index
- ```--genomeDir /path/to/genomeDir``` specifies the directory to store genome index in
- ```--genomeFastaFiles /path/to/genome/fasta1 /path/to/genome/fasta2 ...``` specifies the FASTA file(s) with genome reference sequences
- ```--sjdbGTFfile /path/to/annotations.gtf``` specifies the path to the annotated transcipts (.gtf file)
- ```--sjdbOverhang``` specifies the length of the genomic sequence around the annotated junction to be used in constructing the splice junctions database: Read length - 1 (in my case, it would be 150 - 1 = 149)
- ```--runThreadN #``` defines the number of threads to be used for genome generation (must be equal to number of cores available (I used 8)

In Progress
