#!/bin/bash

echo "valvs_prinseq"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts ::1:2:o:c:k: TEST; do
        case $TEST in
        
	1) OPT_1=$OPTARG
        ;;
        2) OPT_2=$OPTARG
        ;;
	o) OPT_O=$OPTARG
        ;;
	c) OPT_C=$OPTARG
        ;;
	k) OPT_K=$OPTARG
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
if [ -z $OPT_0 ]
then
        OPT_O=${FLD}
fi
if [ -z $OPT_C ]
then
        OPT_C=""
else
	OPT_C="-derep ${OPT_C}"
fi

echo "R1 = ${OPT_1} R2 = ${OPT_2} Dereplication = $OPT_C Output = $OPT_O"
echo "$(date) $config_version valvs_prinseq.sh 1=$OPT_1 2=$OPT_2 c=$OPT_C" o=$OPT_O >> $LOG

prinseq-lite.pl -lc_method dust -lc_threshold 7 $OPT_C -fastq ${OPT_1} -fastq2 ${OPT_2} -out_good prinseq_good -out_bad prinseq_bad > ${OPT_O}_prinseq.txt 2>&1

if [ -z $OPT_K ]
then
	:
else
	mkdir -p Reads
	cp prinseq_good_1.fastq Reads/prinseq_1.fastq
	cp prinseq_good_2.fastq Reads/prinseq_2.fastq
fi

mv prinseq_good_1.fastq ${FLD}"_R1_valvs.fq"
mv prinseq_good_2.fastq ${FLD}"_R2_valvs.fq"

valvs_readstats.sh

rm -f prinseq_good_1_singletons.fastq
rm -f prinseq_good_2_singletons.fastq
rm -f prinseq_bad_1.fastq
rm -f prinseq_bad_2.fastq
