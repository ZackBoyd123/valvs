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
		cd Refs
		ln -s $i valvs_ref.fa
		cd ..
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

ls *_R1_*.f*q *_R1.f*q *_1.f*q > filelist.txt 2>/dev/null 
for fastq in `cat filelist.txt`
do
	echo $fastq

	sample="${fastq%_1.f*q}"
	sample="${fastq%_R1.f*q}"
        sample="${fastq%_R1_*.f*q}"
        sample="${sample%_L001}"

	echo $sample
	
	mkdir -p ${sample}
	mv ${sample}*.f*q ${sample}

	cd $sample
	
	gunzip *.gz 2>/dev/null

	valvs_setup_reads.sh

	cd ..
done

rm -f filelist.txt
