#!/bin/bash

echo "valvs_kraken"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :1:2:t:o: TEST; do
	case $TEST in

	1) OPT_1=$OPTARG
	;;
	2) OPT_2=$OPTARG
	;;
	t) OPT_T=$OPTARG
	;;
	o) OPT_O=$OPTARG
	;;
	esac
done

if [ $1 = "-h" ]
then
        printf "\t----${0##*/}----\n\t[-1]\tName Of First Fastq File\n\t[-2]\tName Of Second Fastq File\n\t[-t]\tNumber of Threads\n\t[-o]\tOutput File Name\n"
        exit 1

fi




if [ -z $OPT_1 ] 
then
	OPT_1=${FLD}_R1_valvs.fq
fi
if [ -z $OPT_2 ]
then
	OPT_2=${FLD}_R2_valvs.fq
fi
if [ -z $OPT_T ] 
then
	OPT_T=10
fi
if [ -z $OPT_O ]
then
    OPT_O=${FLD}
fi

echo "R1 = ${OPT_1} R2 = ${OPT_2} Output = ${OPT_O}"
echo "$(date) valvs_kraken.sh 1=$OPT_1 2=$OPT_2 t=$OPT_T o=$OPT_O" >> $LOG

#RJO - valvs_path
kraken --db /home2/db/kraken/Alpha_Kraken_GB_DB --paired $OPT_1 $OPT_2 --threads $OPT_T > ${OPT_O}_kraken.txt
kraken-report -db /home2/db/kraken/MiniDB ${OPT_O}_kraken.txt > ${OPT_O}_kraken_report.txt
ktImportTaxonomy -q 2 -t 3 -s 4 ${OPT_O}_kraken.txt -o ${OPT_O}_kraken.html
