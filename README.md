# valvs
A modular and automated framework for easily building custom viral HTS analysis pipelines, with a range of cleaning options (read trimming/filtering, host mapping/removal, ribosomal depletion), viral reference alignment (with BWA, Bowtie2, Tanoti, GEM or Stampy), visualisation (weeSAM), consensus calling, and variant calling (with DiversiTools, LoFreq, VPhaser or VarScan). As well as integration with metagenomics (Kraken, DIAMOND) and downstream de novo assembly (spades).

valvs pipelines can be rapidly built by selecting which steps and in which order you want them run, valvs automatically identifies the FASTQ read files to analyse and reference sequence to align to, automatically builds reference/host indexes as well as handling SAM/BAM conversions and mpileup/consensus creation. valvs pipelines can be easily inserted into a valvs_loop to automatically run over large numbers of samples - each having its own sample statistics produced.

This is combined with an evaluation of the different reference aligners (BWA, Bowtie2, Tanoti, GEM or Stampy) and variant callers (LoFreq, VPhaser or VarScan) which was used to determine which programs valvs should use by default.

valvs also incorporates a number of additional scripts to convert the output of variant callers (VPhaser, DiversiTools, VarScan) into a standard VCF format, as well as scripts for comparing the mutations present in two samples (such as duplicates/replicates) and identifying common motifs around mutations.

Authors: Zack Boyd and Richard Orton
## **Assemblers**
#### valvs_bowtie2.sh
Run as:	`valvs_bowtie2.sh`  
Can be given: `{(-1 Read1.fq -2 Read2.fq} OR {-u unpaired.fq)} -r ref.fa -t threads -m mode -o output`  
###### _Example Paired End_
``` bash
user@server: valvs_bowtie2.sh -1 paired1.fq -2 paired2.fq -r ref.fasta -t 15 -m local -o myoutput
```
#### valvs_bwa.sh
Run as:	`valvs_bwa.sh`  
Can be given: `({-1 Read1.fq -2 Read2.fq} OR {-u unpaired.fq}) -r ref.fa -t threads -o output`  
###### _Example Paired End_
``` bash
user@server: valvs_bwa.sh -u unpaired.fastq -r ref.fasta -t 6 -o bwa_out
```
#### valvs_tanoti.sh
Run as:	`valvs_tanoti.sh`  
###### _Example Paired End_
Can be given: `({-1 Read1.fq -2 Read2.fq} OR {-u unpaired.fq}) -r ref.fa -o output`  
``` bash
user@server: valvs_tanoti.sh -1 paired1.fq -2 paired2.fq -r ref.fa -o tanoti_out
```
