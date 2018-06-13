#!/bin/bash

echo "valvs_prinseq"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts ::1:2: TEST; do
        case $TEST in
        
	1) OPT_1=$OPTARG
        ;;
        2) OPT_2=$OPTARG
        ;;
        esac
done

if [[ $1 = "-h" ]]
then
        printf "\t----${0##*/}----\n\t[-1]\tName Of First Fastq File\n\t[-2]\tName Of Second Fastq File\n"
        exit 1

fi

. valvs_config.txt

if [ -z $OPT_1 ]
then
        OPT_1=${FLD}"_R1_valvs.fq"
fi
if [ -z $OPT_2 ]
then
        OPT_2=${FLD}"_R2_valvs.fq"
fi

echo "R1 = ${OPT_1} R2 = ${OPT_2}"
echo "$(date) $config_version valvs_prinseq.sh 1=$OPT_1 2=$OPT_2" >> $LOG

prinseq-lite.pl -lc_method dust -lc_threshold 7 -derep 12345 -fastq ${OPT_1} -fastq2 ${OPT_2} -out_good prinseq_good -out_bad prinseq_bad

mv prinseq_good_1.fastq ${FLD}"_R1_valvs.fq"
mv prinseq_good_2.fastq ${FLD}"_R2_valvs.fq"

valvs_readstats.sh

rm -f prinseq_good_1_singletons.fastq
rm -f prinseq_good_2_singletons.fastq
rm -f prinseq_bad_1.fastq
rm -f prinseq_bad_2.fastq
