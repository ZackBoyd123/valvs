#!/bin/bash

echo "valvs_extract_unmapped"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :b:1:2: TEST; do
	case $TEST in

	b) OPT_B=$OPTARG
	;;
	1) OPT_1=$OPTARG
	;;
	2) OPT_2=$OPTARG
	;;
	esac	
done

if [[ $1 = "-h" ]]
then
        printf "\t----${0##*/}----\n\t[-b]\tInput BAM File\n\t[-1]\tName Of First New Fastq File\n\t[-2]\tName Of Second New Fastq File\n"
	printf "\n----------------------------------------\n"
        printf "Extract unmapped reads from an input BAM file
Two new fastq files will be produced."
        printf "\n----------------------------------------\n"
        exit 1

fi

. valvs_config.txt

if [ -z $OPT_B ]
then
	OPT_B=${FLD}.bam
fi
if [ -z $OPT_1 ]
	then
	OPT_1=${OPT_B%.bam}"_R1_valvs.fq"
fi
if [ -z $OPT_2 ]
then
	OPT_2=${OPT_B%.bam}"_R2_valvs.fq"
fi

echo "BAM = ${OPT_B} R1out = ${OPT_1} R2out = ${OPT_2}"
echo "$(date) $config_version valvs_extract_unmapped.sh b=$OPT_B" 1=${OPT_1} 2=${OPT_2} >> $LOG

#samtools view -f4 -bh ${OPT_B} > valvs_unmapped.bam
#java -jar $config_picard SamToFastq I=valvs_unmapped.bam FASTQ=${OPT_1} SECOND_END_FASTQ=${OPT_2} VALIDATION_STRINGENCY=SILENT
#rm -f valvs_unmapped.bam

#think bam2fastq can give an issue - if unmapped removed beforehand in BAM - and one of the pairs is remvoed - looks like bam2fastq will maybe still extract the single unpaired??? check??
OPT_F=${OPT_B%.bam}"_valvs"
bam2fastq --force --no-aligned --unaligned -o ${OPT_F}"#.fq" ${OPT_B}
mv ${OPT_F}_1.fq $OPT_1
mv ${OPT_F}_2.fq $OPT_2

valvs_readstats.sh -1 $OPT_1 -2 $OPT_2
