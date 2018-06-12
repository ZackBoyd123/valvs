#!/bin/bash

echo "valvs_trim_galore"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :q:l:U:1:2:k:o: TEST; do
	case $TEST in
	
	q) OPT_Q=$OPTARG
	;;
	l) OPT_L=$OPTARG
	;;
	1) OPT_1=$OPTARG
	;;
	2) OPT_2=$OPTARG
	;;
	k) OPT_K=$OPTARG
        ;;
	o) OPT_O=$OPTARG
        ;;
	esac
done

if [ $1 = "-h" ]
then
        printf "\t----${0##*/}----\n\t[-q]\tQuality Score\n\t[-l]\Length\n[-1]\tName Of First Fastq File\n\t[-2]\tName Of Second Fastq File\n\t[-l]\n"
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
if [ -z $OPT_Q ] 
then
	OPT_Q=$config_trim_quality
fi
if [ -z $OPT_L ]
then
	OPT_L=$config_trim_length
fi
if [ -z $OPT_0 ]
then
        OPT_O=${FLD}
fi

echo "R1 = ${OPT_1} R2 = ${OPT_2} q = ${OPT_Q} l = ${OPT_L}"
echo "$(date) $config_version_number valvs_trim_galore.sh 1=$OPT_1 2=$OPT_2 q=$OPT_Q l=$OPT_L" >> $LOG

trim_galore -q $OPT_Q --dont_gzip --length $OPT_L --paired "$OPT_1" "$OPT_2"

if [ -z $OPT_K ]
then
	mkdir -p reads
	cp ${OPT_1%.f*}_val_1.fq reads/trim_R1.fastq
	cp ${OPT_2%.f*}_val_2.fq reads/trim_R2.fastq
fi

mv ${OPT_1%.f*}_val_1.fq ${OPT_O}"_R1_valvs.fq"
mv ${OPT_2%.f*}_val_2.fq ${OPT_O}"_R2_valvs.fq"

valvs_readstats.sh -1 ${OPT_O}"_R1_valvs.fq" -2 ${OPT_O}"_R1_valvs.fq"
