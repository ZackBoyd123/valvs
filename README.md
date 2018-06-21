# valvs
A modular and automated framework for easily building custom viral HTS analysis pipelines, with a range of cleaning options (read trimming/filtering, host mapping/removal, ribosomal depletion), viral reference alignment (with BWA, Bowtie2, Tanoti, GEM or Stampy), visualisation (weeSAM), consensus calling, and variant calling (with DiversiTools, LoFreq, VPhaser or VarScan). As well as integration with metagenomics (Kraken, DIAMOND) and downstream de novo assembly (spades).

valvs pipelines can be rapidly built by selecting which steps and in which order you want them run, valvs automatically identifies the FASTQ read files to analyse and reference sequence to align to, automatically builds reference/host indexes as well as handling SAM/BAM conversions and mpileup/consensus creation. valvs pipelines can be easily inserted into a valvs_loop to automatically run over large numbers of samples - each having its own sample statistics produced.

This is combined with an evaluation of the different reference aligners (BWA, Bowtie2, Tanoti, GEM or Stampy) and variant callers (LoFreq, VPhaser or VarScan) which was used to determine which programs valvs should use by default.

valvs also incorporates a number of additional scripts to convert the output of variant callers (VPhaser, DiversiTools, VarScan) into a standard VCF format, as well as scripts for comparing the mutations present in two samples (such as duplicates/replicates) and identifying common motifs around mutations.

Authors: Zack Boyd and Richard Orton   
#### _Example MiSeq Run_  

<details> 
 <summary>Accessory Python scripts for analysis</summary> <p>  
 
 #### valvs_duplicate_compare.py  
 ------  
 A script which takes two converted VCF files, finds unique and non-unique SNPs between them and their corresponding allele frequencies. This data is output in a format used by the Compare_duplicate.r script.  
 ``` 
 valvs_duplicate_compare.py --first input_1 --second input_2 --sample unique
 ``` 
 Both ``--first`` & ``--second`` require VCF files which have been converted by one of the "2VCF.py" scripts.
 The ``--sample`` tag is a unique string used to identify the sample. i.e sample1. This allows you to differentiate between samples in the Comapre_duplicate.r script.  
 
 ------   
 #### valvs_motifs.py  
 ------  
 A script which analyses mutations, specifically the effect that up and downstream bases have on the number of mutations occuring. 
 The user has the ability to choose how many bases are considered. The "\_raw" file shows the bases before and after each mutation in the file.The "\_calculation" file contains information on the total number of mutations occuring after user set bases, this value is also represented as a % of total number of mutations in the forward or reverse strand. Data is outputted in a format used by the Motif_Heatmap.r script.  
 ```
 valvs_motify.py --fasta file.fa --bases 2 --input in.txt --output out.txt --rfriendly yes 
 ```  
 ``--input:`` The converted diversitools output you wish to study.  
 ``--fasta:`` The fasta file used by diversitools to generate your input file.  
 ``--bases:`` How many up/down stream bases you wish to analyse. In this case dinucleotides are considered.  
 ``--output:`` What you wish to call your output file.  
 ``--rfriendly:`` Give me my data in a format ready for R analysis. You always want to set this if you are using Motif_Heatmap.r  
 
 ------  
 #### VCFDistanceMeasure.py  
 ------  
 Compares two mutation files containing SNPs. The two input files must have been created by using one of the "2VCF.py" scripts.
 The output file pairs non-unique SNPs at the top of the file, then unique SNPs below this. A sum of squares value is produced for each SNP in each file, with a total sum of squares value at the bottom of the file.  
 As well as this, the total number of shared & mishared 0-1% and > = 10% mutations are output at the bottom of the file.
 ```
 VCFDistanceMeasure.py -1 input1.txt -2 input2.txt -O output.txt
 ```  
 `-1`: First input converted VCF.  
 `-2`: Second input converted VCF.  
 `-O`: Output file name.  
 
 ------  
 #### X2VCF.py  
 ------ 
 All of the "2VCF.py" scripts take the corresponding variant callers output and converts it to a standard VCF format, allowing for east analysis.  
 _n.b: The VarScan2VCF.py script needs varscan to be run with the --output-vcf set to 1._  
 ```
 All of the 2VCF.py scripts are run as follows:  
 X2VCF.py input
 ```  
 The scripts only require one input, which is the file to convert.  
 
 ------  
 #### VCFilter.py  
 ------  
 Filters a VCF file produced by one of the "2VCF.py" scripts at user set thresholds. The output is identical to the input format only with SNPs filtered out.  
 ```
 VCFilter.py -C 1000 -F 0.1 -Q 0 -I input.txt -O output.txt --strandbias y/yes
 ```  
 `-C`: Coverage. Filter out all SNPs lower than this value.  
 `-F`: Frequency. Filter out all SNPs with an allele frequency lower than this value.  
 `-Q`: Quality. Filter out all SNPs with a quality lower than this value.  
 `--strandbias`: Strand bias: If y or yes, only show me SNPs which appears on both strands. If n or no only show me SNPs which occur on one strand.  
 `-I`: Input. Input converted VCF file.  
 `-O`: Output. What you want your output file to be called. 
 
 </p></summary></details>

<details>  
<summary>Click to view assembler examples</summary> <p>  

 ## **Assemblers**  
#### valvs_bowtie2.sh
------
**Run as:**	`valvs_bowtie2.sh`  
Can be given: `{(-1 Read1.fq -2 Read2.fq} OR {-u unpaired.fq)} -r ref.fa -t threads -m mode -o output`  
###### _Example Paired End_
``` bash
user@server: valvs_bowtie2.sh -1 paired1.fq -2 paired2.fq -r ref.fasta -t 15 -m local -o myoutput
```
------
#### valvs_bwa.sh
------
**Run as:**	`valvs_bwa.sh`  
Can be given: `({-1 Read1.fq -2 Read2.fq} OR {-u unpaired.fq}) -r ref.fa -t threads -o output`  
###### _Example Unpaired_
``` bash
user@server: valvs_bwa.sh -u unpaired.fastq -r ref.fasta -t 6 -o bwa_out
```
------
#### valvs_tanoti.sh
------
**Run as:**	`valvs_tanoti.sh`  
Can be given: `({-1 Read1.fq -2 Read2.fq} OR {-u unpaired.fq}) -r ref.fa -o output`  
###### _Example Paired End_
``` bash
user@server: valvs_tanoti.sh -1 paired1.fq -2 paired2.fq -r ref.fa -o tanoti_out 
```   
------
#### valvs_stampy.sh  
------
**Run as:** `valvs_stampy.sh` 
###### _Example with command line inputs._
``` bash
user@server: valvs_stampy.sh -1 paired1.fq -2 paired.fq -r ref.fa -o output
```  
------
#### valvs_gem.sh  
------
**Run as:** `valvs_gem.sh`  
###### _Example with command line inputs._
``` bash
user@server: valvs_gem -1 paired.fq -2 paired.fq -r ref.fa -o output
```
  
</p></details>  
<details>
  <summary>Click to view variant caller examples</summary> <p>  
  
  ## Variant Callers  
  #### valvs_vphaser.sh  
  ------ 
  
  **Run as:** `valvs_vphaser.sh`  
  Can be given: `-b bamfile` 
  ###### _Example_  
  ``` bash
  user@server: valvs_vphaser.sh -b file.bam
  ``` 
  ------
  #### valvs_lofreq.sh 
  ------
  **Run as:** `valvs_lofreq.sh`  
  Can be given: `-b bamfile -r ref.fa`  
  ###### _Example_  
  ```bash 
  user@server: valvs_lofreq.sh -b file.bam -r ref.fa
  ```  
  _n.b: output file is always your input bam -(.bam) +(.vcf)._ 
  
  ------  
  #### valvs_varscan.sh  
  ------ 
  **Run as:** `valvs_varscan.sh`  
  Can be given: `-m mpileupFile -q minAvgQual -f minVarFreq`  
  ###### _Example_  
  ``` bash
  user@server: valvs_varscan.sh -m input.mpileup.txt -q 1 -f 0.1
  ```  
  _n.b: output file is always your input mpileup -(mpileup.txt) +(.vcf)._
  
  
  </p></details>
