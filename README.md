# valvs
A modular and automated framework for easily building custom viral HTS analysis pipelines, with a range of cleaning options (read trimming/filtering, host mapping/removal, ribosomal depletion), viral reference alignment (with BWA, Bowtie2, Tanoti, GEM or Stampy), visualisation (weeSAM), consenus calling, and variant calling (with DiversiTools, LoFreq, VPhaser or VarScan). As well as integration with metagenomics (kraken) and downstream de novo assembly (spades).

valvs pipelines can be rapidly built by selecting which steps and in which order you want them run, valvs automatically identifies the FASTQ read files to analyses and reference seuqence to align to, automatically builds reference/host indexes as well as handling SAM/BAM conversions and mpileup/consensus creation. Valvs pipelines can be easily inserted into a valvs_loop to automatically run over large numbers of samples - each having its own sample statistics produced.

This is combined with an evalutation of the different reference aligners (BWA, Bowtie2, Tanoti, GEM or Stampy) and variant callers (LoFreq, VPhaser or VarScan) which was used to determine the default valvs programs.

valvs also incorprates a number of additional scripts to convert the output of variant callers (VPhaser, DiversiTools, VarScan) into a standard VCF format, as well as scripts for comparing the mutations present in two samples (such as duplicates/replicates), and identiying common motifs around mutations.

Authors: Zack Boyd and Richard Orton
