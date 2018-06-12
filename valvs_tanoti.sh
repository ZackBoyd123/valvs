#!/bin/bash

echo "valvs_tanoti"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :r:1:2:o:t: TEST; do
	case $TEST in 

	r) OPT_R=$OPTARG
	;;
	1) OPT_1=$OPTARG
	;;
	2) OPT_2=$OPTARG
	;;
    	o) OPT_O=$OPTARG
    	;;
	t) OPT_T=$OPTARG
        ;;
	esac
done

if [ $1 = "-h" ]
then
        printf "\t----${0##*/}----\n\t[-r]\tReference file\n\t[-1]\tFirst Input Fastq File\n\t[-2]\tSecond Input Fastq File\n\t[-o]\tOutput File Name\n"
        exit 1

fi

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
	OPT_O=$FLD
fi
if [ -z $OPT_T ] 
then
        OPT_T=$config_threads
fi

echo "R1 = ${OPT_1} R2 = ${OPT_2} OutputStub = ${OPT_O}"
echo "$(date) $config_version valvs_tanoti.sh R=$OPT_R 1=$OPT_1 2=$OPT_2 o=$OPT_O" >> $LOG

tanoti -r $OPT_R -i "$OPT_1" "$OPT_2" -o ${OPT_O}.sam -p 1 -P ${OPT_T}

valvs_sam2bam.sh -t ${OPT_T} -s ${OPT_O}.sam -o ${OPT_O}.bam
valvs_bamstats.sh -b ${OPT_O}.bam
