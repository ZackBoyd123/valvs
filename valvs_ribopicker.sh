#!/bin/bash

echo "valvs_ribopicker"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts ::1:2:t:k: TEST; do
        case $TEST in
        
	1) OPT_1=$OPTARG
        ;;
        2) OPT_2=$OPTARG
        ;;
        t) OPT_T=$OPTARG
        ;;
	k) OPT_T=$OPTARG
        ;;
        esac
done

if [[ $1 = "-h" ]]
then
        printf "\t----${0##*/}----\n\t[-1]\tName Of First Fastq File\n\t[-2]\tName Of Second Fastq File\n\t[-t]\tNumber of Threads to Use\n"
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
if [ -z $OPT_T ]
then
        OPT_T=$config_threads
fi

echo "R1 = ${OPT_1} R2 = ${OPT_2} T = ${OPT_T}"
echo "$(date) $config_number valvs_ribopicker.sh 1=$OPT_1 2=$OPT_2 t=$OPT_T" >> $LOG

#Interleave the two fastq files into 1 file - as ribo picker does not do paired end
java -jar $config_ortools -i ${OPT_1} ${OPT_2} valvs_unmap

ribopicker.pl -t ${OPT_T} -id valvs_ribo -f valvs_unmap.fastq -dbs ssr123,slr123

#De-interleave - removes unmatched pairs
java -jar $config_ortools -d valvs_ribo_nonrrna.fq

mv valvs_ribo_nonrrna_1.fastq $FLD"_R1_valvs.fq"
mv valvs_ribo_nonrrna_2.fastq $FLD"_R2_valvs.fq"

if [ -z $OPT_K ]
then
	:
else
	mkdir -p Reads
	cp $FLD"_R1_valvs.fq" Reads/ribo_R1.fastq
	cp $FLD"_R2_valvs.fq" Reads/ribo_R2.fastq
fi

valvs_readstats.sh

rm -f valvs_unmap.fastq
rm -f valvs_ribo_nonrrna.fq
rm -f valvs_ribo_rrna.fq
