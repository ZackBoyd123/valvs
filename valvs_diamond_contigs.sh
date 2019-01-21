#!/bin/bash

echo "valvs_diamond_contigs"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :o:d:i:t: TEST; do
	case $TEST in
	o) OPT_O=$OPTARG
	;;
	d) OPT_D=$OPTARG
	;;
	i) OPT_I=$OPTARG
	;;
	t) OPT_T=$OPTARG
	;;
	esac
done

. valvs_config.txt

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
	OPT_D=$config_diamond
fi
if [ -z $OPT_I ]
then
	OPT_I=Spades/contigs.fasta
fi

echo "valvs_diamond_contigs input = ${OPT_I} output = ${OPT_O} database=${OPT_D}"
echo "$(date) $config_version valvs_diamond_contigs.sh i=${OPT_I} o=$OPT_O d=$OPT_D" >> $LOG

mkdir -p diam_temp
diamond blastx -d $OPT_D -f 6 -o ${OPT_O}_diam.txt -p ${OPT_T} -q ${OPT_I} -t diam_temp
ktImportBLAST ${OPT_O}_diam.txt -o ${OPT_O}_diam.html > ${OPT_O}_kt.txt
