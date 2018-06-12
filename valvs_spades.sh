#!/bin/bash

echo "valvs_spades"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :1:2:t:e: TEST; do
	case $TEST in

	1) OPT_1=$OPTARG
	;;
	2) OPT_2=$OPTARG
	;;
	e) OPT_E=$OPTARG
	;;
	t) OPT_T=$OPTARG
	;;
	esac
done

if [ $1 = "-h" ]
then
        printf "\t----${0##*/}----\n\t[-1]\tName Of First Fastq File\n\t[-2]\tName Of Second Fastq File\n\t[-e]\tOnly assembly? y\n"
        exit 1

fi

. valvs_config.txt

if [ -z $OPT_1 ]
then
	OPT_1=${FLD}_R1_valvs.fq
fi
if [ -z $OPT_2 ]
then
	OPT_2=${FLD}_R2_valvs.fq
fi
if [ -z $OPT_E ]
then
	OPT_E='--only-assembler'
else
	OPT_E=''
fi
if [ -z $OPT_T ]
then
        OPT_T=$config_threads
fi

echo "R1 = ${OPT_1} R2 = ${OPT_2} e = ${OPT_E}"
echo "$(date) $config_version valvs_spades.sh 1=$OPT_1 2=$OPT_2 t=$OPT_T e=$OPT_E" >> $LOG

spades.py $OPT_E -t $OPT_T -1 $OPT_1 -2 $OPT_2 -o ./spades
