#!/bin/bash

echo "valvs_diamond_contigs"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :o: TEST; do
	case $TEST in
	o) OPT_O=$OPTARG
	;;
	esac
done

. valvs_config.txt

if [ -z $OPT_O ] 
then
	OPT_O=${FLD}
fi

echo "O = ${OPT_O}"
echo "$(date) $config_version valvs_diamond_contigs.sh O=$OPT_O" >> $LOG

mkdir -p Spades/diam_temp
mkdir -p diam_temp
diamond blastx -d $config_diamond -f 6 -o Spades/${OPT_O}_diam_nr.txt -p 10 -q Spades/contigs.fasta -t diam_temp
ktImportBLAST Spades/${OPT_O}_diam_nr.txt -o Spades/${OPT_O}_diam_nr.html > Spades/${OPT_O}_kt.txt

