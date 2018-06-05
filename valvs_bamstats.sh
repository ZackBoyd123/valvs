#!/bin/bash

echo "valvs_bamstats"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :b: TEST; do
	case $TEST in

	b) OPT_B=$OPTARG
	;;	
	esac
done

if [ $1 = "-h" ]
then
        printf "\t----${0##*/}----\n\t[-b]\tInput BAM File\n"
        exit 1

fi



if [ -z $OPT_B ] 
then
	OPT_B=${FLD}.bam
fi

echo "BAM file = ${OPT_B}"
echo "$(date) valvs_bamstats.sh b=$OPT_B" >> $LOG

#sam flags 4 (unmapped) + 256 (secondary alignments) = 260
MP=$(samtools view -F 260 -c $OPT_B)
UMP=$(samtools view -f 4 -c $OPT_B)

echo "$MP mapped reads"
echo "$UMP unmapped reads"
printf "$MP\tmapped reads\n" >> $LOG
printf "$UMP\tunmapped reads\n" >> $LOG
