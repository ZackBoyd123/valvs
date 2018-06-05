#!/bin/bash

echo "valvs_consensus"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :b:r: TEST; do
	case $TEST in

	b) OPT_B=$OPTARG
	;;
	r) OPT_R=$OPTARG
	;;
	esac	
done

if [ $1 = "-h" ]
then
        printf "\t----${0##*/}----\n\t[-b]\tInput BAM File\n\t[-r]\tReference File\n"
        exit 1

fi

pwd=`pwd`
. valvs_checkref.sh

if [ -z $OPT_B ] 
then
	OPT_B=${FLD}.bam
fi

echo "Ref = ${OPT_R} BAM= ${OPT_B} Consensus = ${OPT_B%.bam}_samcon.fa"
echo "$(date) valvs_consensus.sh b=$OPT_B r=OPT_R" >> $LOG

samtools mpileup -uf $OPT_R $OPT_B | bcftools call -c | vcfutils.pl vcf2fq > ${OPT_B%.bam}"_samcon.fq"
valvs_samcon2fasta.py ${OPT_B%.bam}"_samcon.fq" ${OPT_B%.bam}"_samcon.fa"
rm -f $FLD"_samcon.fq"
