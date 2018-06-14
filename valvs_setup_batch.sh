#!/bin/bash

#IFS=$'\n'
greater=$(ls | grep .f*a* | grep -v .fastq)
if $greater -ge 2
then
	echo "There is more than one fasta file in the folder - remove the extra seqs"
	exit 1
else
	mkdir Refs
	for i in $(ls | grep .f*a* | grep -v .fastq)
	do
		mv $i Refs
		ln -s Refs/$i Refs/valvs_ref.fa
	done
fi

mkdir -p SeqDat
mv *.csv SeqDat 2>/dev/null 
mv *.xml SeqDat 2>/dev/null
mv *.txt SeqDat 2>/dev/null
mv Reports SeqDat 2>/dev/null
mv Stats SeqDat 2>/dev/null

mkdir -p Undetermined
mv Undetermined*.* Undetermined 2>/dev/null

for fastq in *_R1_*
do
	echo $fastq
        
	#sample="${fastq%_R1_001.fastq.gz}"
	#sample="${sample%_L001}"	

        sample="${fastq%_R1_*}"
        sample="${sample%_L001}"

	echo $sample
	
	mkdir -p ${sample}
	mv ${sample}*.* ${sample}

	cd $sample
	
	gunzip *.gz 2>/dev/null

	valvs_setup_reads.sh

	cd ..
done

