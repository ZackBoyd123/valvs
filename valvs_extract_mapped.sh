#!/bin/bash

echo "valvs_extract_mapped"

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
echo "$(date) $config_version valvs_extract_mapped.sh b=$OPT_B" 1=${OPT_1} 2=${OPT_2} >> $LOG

#samtools view -F4 -bh ${OPT_B} > valvs_mapped.bam
#java -jar $config_picard SamToFastq I=valvs_mapped.bam FASTQ=${OPT_1} SECOND_END_FASTQ=${OPT_2} VALIDATION_STRINGENCY=SILENT
#rm -f valvs_mapped.bam

OPT_F=${OPT_B%.bam}"_valvs"
bam2fastq --no-unaligned --aligned -o ${OPT_F}"#.fq" ${OPT_B}
mv ${OPT_F}_1.fastq ${OPT_B%.bam}"_R2_valvs.fq"
mv ${OPT_F}_2.fastq ${OPT_B%.bam}"_R2_valvs.fq"

valvs_readstats.sh
