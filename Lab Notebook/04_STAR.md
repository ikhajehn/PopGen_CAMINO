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
## Types of Output Files 
STAR Aligner results in many output files, but what do they all mean? The following definitions are taken directly from the manual for reference purposes

- Log.out: main log file with a lot of detailed information about the run. This file is most useful for troubleshooting and debugging.
- Log.progress.out: reports job progress statistics, such as the number of processed reads, % of mapped reads etc. It is updated in 1 minute intervals.
- Log.final.out: summary mapping statistics after mapping job is complete, very useful for quality control. The statistics are calculated for each read (single- or paired-end) and then summed or averaged over all reads. Note that STAR counts a paired-end read as one read, (unlike the samtools flagstat/idxstats, which count each mate separately). Most of the information is collected about the UNIQUE mappers (unlike samtools flagstat/idxstats which does not separate unique or multi-mappers). Each splicing is counted in the numbers of splices, which would correspond to summing the counts in SJ.out.tab. The mismatch/indel error rates are calculated on a per base basis, i.e. as total number of mismatches/indels in all unique mappers divided by the total number of mapped bases.

## Log Progress Out Report 
- Speed M/hr:	Processing speed (reads per million per hour) 
- Read number:	Total reads processed so far 
- Read length: your read length
- Mapped unique: reads that mapped to one location (>80% is good)
- Mapped length: average length of mapped reads
- Mapped MMrate: mapped mismatch rate (<3%)
- Mapped multi: reads mapping to multiple locations
- Unmapped multi: discarded reads mapping to multiple locations (too ambiguous)
- Unmapped short: reads too short to map
- Unmapped other: other unmapped reads

## Tab Out Folder
SJ.out.tab contains high confidence collapsed splice junctions in tab-delimited format. Note that STAR defines the junction start/end as intronic bases, while many other software define them as exonic bases. The columns have the following meaning:
- column 1: chromosome 
- column 2: first base of the intron (1-based)
- column 3: last base of the intron (1-based)
- column 4: strand (0: undefined, 1: +, 2: -)
- column 5: intron motif: 0: non-canonical; 1: GT/AG, 2: CT/AC, 3: GC/AG, 4: CT/GC, 5: AT/AC, 6: GT/AT
- column 6: 0: unannotated, 1: annotated in the splice junctions database. Note that in 2-pass mode, junctions detected in the 1st pass are reported as annotated, in addition to annotated junctions from GTF.
- column 7: number of uniquely mapping reads crossing the junction
- column 8: number of multi-mapping reads crossing the junction
- column 9: maximum spliced alignment overhang
