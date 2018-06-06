#!/bin/bash

echo "valvs_gem"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :r:1:2:t:o: TEST; do
	case $TEST in 
	
	r) OPT_R=$OPTARG
	;;
	1) OPT_1=$OPTARG
	;;
	2) OPT_2=$OPTARG
	;;
	o) OPT_O=$OPTARG
	;;	
	esac
done

if [ $1 = "-h" ]
then
        printf "\t----${0##*/}----\n\t[-r]\tReference file\n\t[-1]\tFirst Input Fastq File\n\t[-2]\tSecond Input Fastq File\n\t[-t]\tThreads\n\t[-o]\tOutput File Name\n"
        exit 1

fi



pwd=`pwd`
. valvs_checkref.sh
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
	OPT_O=${FLD}
fi

echo "Ref = ${OPT_R} R1 = ${OPT_1} R2 = ${OPT_2} OutputStub = ${OPT_O}"
echo "$(date) $config_version_number valvs_gem.sh R=$OPT_R 1=$OPT_1 2=$OPT_2 o=$OPT_O t=$OPT_T" >> $LOG

check=$(dirname $OPT_R)
file=`awk -F "/" '{print $NF}' <<< $OPT_R`
file=${file%.fa*}
tocheck=$check/$file".gem"

if [ -e $tocheck ]
then
	echo "index exists"
else
	echo "indexing"
	gem-indexer -i $OPT_R -o ${OPT_R%.fa*}
fi

gem-mapper -I ${OPT_R%.fa*}.gem -1 $OPT_1 -2 $OPT_2 -o $OPT_O".sam"
valvs_sam2bam.sh -s ${OPT_O}.sam -o ${OPT_O}.bam
valvs_bamstats.sh -b ${OPT_O}.bam
