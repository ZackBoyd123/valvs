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

if [ $1 = "-h" ]
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
echo "$(date) $config_version_number valvs_extract_unmapped.sh b=$OPT_B" 1=${OPT_1} 2=${OPT_2} >> $LOG

#RJO - valvs_path
#ZB added picard install path to jar file
java -jar $config_picard_install SamToFastq I=$OPT_B FASTQ=$OPT_1 SECOND_END_FASTQ=$OPT_2
#/home1/orto01r/programs/picard.jar SamToFastq I=$OPT_B FASTQ=${OPT_1} SECOND_END_FASTQ=${OPT_2}

valvs_readstats.sh

