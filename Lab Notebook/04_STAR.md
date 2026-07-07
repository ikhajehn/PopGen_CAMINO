# Mapping RNAseq Reads to a Reference Genome via STAR Aligner
## Creating a Genome Index
Making a genome index compresses and organizes all the FASTA files into a searchable dictionary for STAR to quickly refer to. ```STAR--``` automatically defaults to a 14 SA pre-indexing string, but it was too large for my genome size = 663017713; therefore, I had to lower it to 13 using ```--genomeSAindexNbases 13```

My command for creating a genome index on HB
```
module load star && STAR --runMode genomeGenerate --genomeDir /path/to/genome_index --genomeFastaFiles /path/to/GGA_*_genomic.fna --sjdbGTFfile /path/to/genomic.gtf --sjdbOverhang 149 --runThreadN 8 --genomeSAindexNbases 13
```
- ```--runMode genomeGenerate``` tells STAR to initiate creation of genome index
- ```--genomeDir /path/to/genomeDir``` specifies the directory to store genome index in
- ```--genomeFastaFiles /path/to/genome/fasta1 /path/to/genome/fasta2 ...``` specifies the FASTA file(s) with genome reference sequences
- ```--sjdbGTFfile /path/to/annotations.gtf``` specifies the path to the annotated transcipts (.gtf file)
- ```--sjdbOverhang``` specifies the length of the genomic sequence around the annotated junction to be used in constructing the splice junctions database: Read length - 1 (in my case, it would be 150 - 1 = 149)
- ```--runThreadN #``` defines the number of threads to be used for genome generation (must be equal to number of cores available)

[STAR Manual](https://github.com/alexdobin/STAR/blob/master/doc/STARmanual.pdf)

In Progress


# Interpretation of STAR Outputs
STAR Aligner results in many output files, but what do they all mean? The following definitions are taken directly from the manual for reference purposes

- Log.out: main log file with a lot of detailed information about the run. This file is most useful for troubleshooting and debugging.
- Log.progress.out: reports job progress statistics, such as the number of processed reads, % of mapped reads etc. It is updated in 1 minute intervals.
- Log.final.out: summary mapping statistics after mapping job is complete, very useful for quality control. The statistics are calculated for each read (single- or paired-end) and then summed or averaged over all reads. Note that STAR counts a paired-end read as one read, (unlike the samtools flagstat/idxstats, which count each mate separately). Most of the information is collected about the UNIQUE mappers (unlike samtools flagstat/idxstats which does not separate unique or multi-mappers). Each splicing is counted in the numbers of splices, which would correspond to summing the counts in SJ.out.tab. The mismatch/indel error rates are calculated on a per base basis, i.e. as total number of mismatches/indels in all unique mappers divided by the total number of mapped bases.
