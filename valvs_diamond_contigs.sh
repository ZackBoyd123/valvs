#!/bin/bash

echo "valvs_diamond_contigs"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :o:d: TEST; do
	case $TEST in
	o) OPT_O=$OPTARG
	;;
	d) OPT_D=$OPTARG
	;;
	esac
done

. valvs_config.txt

if [ -z $OPT_O ] 
then
	OPT_O=${FLD}
fi
if [ -z $OPT_D ] 
then
	OPT_D=$config_diamond
fi

echo "o = ${OPT_O} d=${OPT_D}"
echo "$(date) $config_version valvs_diamond_contigs.sh o=$OPT_O d=$OPT_D" >> $LOG

mkdir -p Spades/diam_temp
mkdir -p diam_temp
diamond blastx -d $OPT_D -f 6 -o Spades/${OPT_O}_diam_nr.txt -p 10 -q Spades/contigs.fasta -t diam_temp
ktImportBLAST Spades/${OPT_O}_diam_nr.txt -o Spades/${OPT_O}_diam_nr.html > Spades/${OPT_O}_kt.txt
