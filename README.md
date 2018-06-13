# valvs
A modular and automated framework for easily building custom viral HTS analysis pipelines, with a range of cleaning options (read trimming/filtering, host mapping/removal, ribosomal depletion), viral reference alignment (with BWA, Bowtie2, Tanoti, GEM or Stampy), visualisation (weeSAM), consenus calling, and variant calling (with DiversiTools, LoFreq, VPhaser or VarScan). As well as integration with metagenomics (kraken) and downstream de novo assembly (spades).

valvs pipelines can be rapidly built by selecting which steps and in which order you want them run, valvs automatically identifies the FASTQ read files to analyses and reference seuqence to align to, and automatically builds reference/host indexes and SAM/BAM conversions. Valvs pipelines can be easily inserted into a valvs_loop to automatically run over large numbers of samples - each having its own sample statistics produced.

This is combined with an evalutation of the different reference aligners (BWA, Bowtie2, Tanoti, GEM or Stampy) and variant callers (LoFreq, VPhaser or VarScan) which was used to determine the default valvs programs.

Authors: Zack Boyd and Richard Orton
