#!/bin/bash

echo "valvs_contamination"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :1:2:k:o: TEST; do
	case $TEST in

	1) OPT_1=$OPTARG
	;;
	2) OPT_2=$OPTARG
	;;
	k) OPT_K=$OPTARG
	;;
	o) OPT_O=$OPTARG
	;;
	esac
done

if [ $1 = "-h" ]
then
        printf "\t----${0##*/}----\n\t[-1]\tFirst Input Fastq File\n\t[-2]\tSecond Input Fastq File\n\t[-k]\tKeep old BAM? y/n\n\t[-o]\tOutput File Name\n"
        exit 1

fi

. valvs_config.txt

if [ -z $OPT_1 ]
then
	OPT_1=$FLD"_R1_valvs.fq"
fi
if [ -z $OPT_2 ]
then
	OPT_2=$FLD"_R2_valvs.fq"
fi
if [ -z $OPT_O ]
then
	OPT_O=${FLD}_contam
	R1=${FLD}_R1_valvs.fq
	R2=${FLD}_R2_valvs.fq
else
	R1=${OPT_O%.bam}_R1_valvs.fq
        R2=${OPT_O%.bam}_R2_valvs.fq
fi

echo "R1 = ${OPT_1} R2 = ${OPT_2} OutputStub = ${OPT_O}"
echo "$(date) $config_version_number valvs_contamination.sh 1=${OPT_1} 2=${OPT_2} o=${OPT_O}" >> $LOG

#RJO - valvs_path
valvs_bowtie2.sh -r $config_contam_db -1 $OPT_1 -2 $OPT_2 -o "$OPT_O.sam"
samtools idxstats ${OPT_O}.bam >> $LOG
valvs_extract_unmapped.sh -b ${OPT_O}.bam -1 $R1 -2 $R2

if [ -z $OPT_K ]
    then
    rm -f ${OPT_O}.bam
fi
