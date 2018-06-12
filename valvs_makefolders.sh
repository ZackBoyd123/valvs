#!/bin/bash


#IFS=$'\n'
greater=$(ls | grep .f*a* | grep -v .fastq)
if $greater -ge 2
then
	echo "There's more than one fasta you're trying to copy"
	echo "Remove one and add it back into References folder later"
	exit 1
else
	mkdir References
	for i in $(ls | grep .f*a* | grep -v .fastq)
	do
		mv $i References
	done

	cd References 
	ln -s * ./ref.fa
	cd ../
fi


mkdir -p seqrun
mv *.csv seqrun 2>/dev/null 
mv *.xml seqrun 2>/dev/null
mv *.txt seqrun 2>/dev/null
mv Reports seqrun 2>/dev/null
mv Stats seqrun 2>/dev/null

mkdir -p Undetermined
mv Undetermined*.gz Undetermined 2>/dev/null

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
	
	gunzip *.gz

	valvs_setup_reads.sh

	cd ..
done

