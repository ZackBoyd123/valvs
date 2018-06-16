#!/bin/bash

echo "valvs_readstats"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :1:2:u: TEST; do
	case $TEST in

	1) OPT_1=$OPTARG
	;;
	2) OPT_2=$OPTARG
	;;
	u) OPT_U=$OPTARG
	;;
	esac
done

if [[ $1 = "-h" ]]
then
        printf "\t----${0##*/}----\n\t[-1]\tName Of First Fastq File\n\t[-2]\tName Of Second Fastq File\n"
        exit 1

fi

. valvs_config.txt
. valvs_check_reads.sh

if [ -z $OPT_U ]
then
	echo "R1 = ${OPT_1} R2 = ${OPT_2}"
	echo "$(date) $config_version valvs_readstats.sh 1=$OPT_1 2=$OPT_2" >> $LOG

	R1=$(expr `(wc -l ${OPT_1} | cut -f1 -d " ")` / 4)
	R2=$(expr `(wc -l ${OPT_2} | cut -f1 -d " ")` / 4)

	echo "$R1 reads in R1 ${OPT_1}"
	echo "$R2 reads in R2 ${OPT_2}"
	printf "$R1\treads in R1 ${OPT_1}\n" >> $LOG
	printf "$R2\treads in R2 ${OPT_2}\n" >> $LOG
else
	echo "RU = ${OPT_U}"
	echo "$(date) $config_version valvs_readstats.sh u=$OPT_U" >> $LOG

	RU=$(expr `(wc -l ${OPT_U} | cut -f1 -d " ")` / 4)

	echo "$RU reads in R1 ${OPT_U}"
	printf "$RU\treads in RU ${OPT_U}\n" >> $LOG
fi
