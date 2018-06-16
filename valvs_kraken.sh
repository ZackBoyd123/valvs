#!/bin/bash

echo "valvs_kraken"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :1:2:t:o:d:u: TEST; do
	case $TEST in

	1) OPT_1=$OPTARG
	;;
	2) OPT_2=$OPTARG
	;;
	t) OPT_T=$OPTARG
	;;
	o) OPT_O=$OPTARG
	;;
	d) OPT_D=$OPTARG
	;;
	u) OPT_U=$OPTARG
	;;
	esac
done

if [[ $1 = "-h" ]]
then
        printf "\t----${0##*/}----\n\t[-1]\tName Of First Fastq File\n\t[-2]\tName Of Second Fastq File\n\t[-t]\tNumber of Threads\n\t[-o]\tOutput File Name\n"
        exit 1

fi

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
if [ -z $OPT_D ]
then
	OPT_D=$config_kraken
fi

if [ -z $OPT_U ]
then
	echo "R1 = ${OPT_1} R2 = ${OPT_2} Output = ${OPT_O} db = $OPT_D"
	echo "$(date) $config_version valvs_kraken.sh 1=$OPT_1 2=$OPT_2 t=$OPT_T o=$OPT_O db=$OPT_D" >> $LOG

	kraken --db $OPT_D --paired $OPT_1 $OPT_2 --threads $OPT_T > ${OPT_O}_kraken.txt
else
	echo "RU = ${OPT_U} Output = ${OPT_O} db = $OPT_D"
	echo "$(date) $config_version valvs_kraken.sh U=$OPT_U t=$OPT_T o=$OPT_O db=$OPT_D" >> $LOG

	kraken --db $OPT_D --threads $OPT_T $OPT_U > ${OPT_O}_kraken.txt
fi

kraken-report -db $OPT_D ${OPT_O}_kraken.txt > ${OPT_O}_kraken_report.txt
ktImportTaxonomy -q 2 -t 3 -s 4 ${OPT_O}_kraken.txt -o ${OPT_O}_kraken.html
