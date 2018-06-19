#!/bin/bash

echo "valvs_bwa"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :r:1:2:t:o:u: TEST; do
	case $TEST in 
	
	r) OPT_R=$OPTARG
	;;
	1) OPT_1=$OPTARG
	;;
	2) OPT_2=$OPTARG
	;;
	t) OPT_T=$OPTARG
	;;	
	o) OPT_O=$OPTARG
	;;	
	u) OPT_U=$OPTARG
	;;
	esac
done

if [[ $1 = "-h" ]]
then
        printf "\t----${0##*/}----\n\t[-r]\tReference file\n\t[-1]\tFirst Input Fastq File\n\t[-2]\tSecond Input Fastq File\n\t[-t]\tThreads\n\t[-o]\tOutput File Name\n"
printf "\n----------------------------------------\n"
        printf "Maps reads to a reference using bwa both
paired and unpaired reads are supported."
        printf "\n----------------------------------------\n"
        exit 1

fi

. valvs_check_ref.sh
. valvs_config.txt
. valvs_check_reads.sh

if [ -z $OPT_T ]
then
	OPT_T=$config_threads
fi
if [ -z $OPT_O ]
then
	OPT_O=${FLD}
fi

check=$(dirname $OPT_R)
file=`awk -F "/" '{print $NF}' <<< $OPT_R`
tocheck=$check/$file".bwt"

if [ -e $tocheck ]
then
	:
else
	echo "Indexing reference"
	bwa index -p $OPT_R $OPT_R
	echo "Finished indexing"
fi

if [ -z $OPT_U ]
then
	echo "Ref = ${OPT_R} R1 = ${OPT_1} R2 = ${OPT_2} OutputStub = ${OPT_O}"
	echo "$(date) $config_version valvs_bwa.sh r=$OPT_R 1=$OPT_1 2=$OPT_2 o=$OPT_O t=$OPT_T" >> $LOG

	bwa mem -t $OPT_T $OPT_R $OPT_1 $OPT_2 > ${OPT_O}.sam
else
	echo "Ref = ${OPT_R} RU = ${OPT_U} OutputStub = ${OPT_O}"
	echo "$(date) $config_version valvs_bwa.sh r=$OPT_R U=$OPT_U o=$OPT_O t=$OPT_T" >> $LOG

	bwa mem -t $OPT_T $OPT_R $OPT_U > ${OPT_O}.sam
fi

valvs_sam2bam.sh -t $OPT_T -s ${OPT_O}.sam -o ${OPT_O}.bam
valvs_bamstats.sh -b ${OPT_O}.bam
