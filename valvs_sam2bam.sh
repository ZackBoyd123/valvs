#!/bin/bash

echo "valvs_sam2bam"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :t:s:o: TEST; do
	case $TEST in 

	t) OPT_T=$OPTARG
	;;
	s) OPT_S=$OPTARG
	;;	
	o) OPT_O=$OPTARG
	;;
	esac
done

if [ $1 = "-h" ]
then
        printf "\t----${0##*/}----\n\t[-s]\tInput SAM File\n\t[-t]\tNumber of Threads to Use\n\t[-o]\tOutput BAM File Name\n"
        exit 1

fi

. valvs_config.txt

if [ -z $OPT_T ] 
then
	OPT_T=$config_threads
fi
if [ -z $OPT_S ]
then
	OPT_S=${FLD}.sam
fi
if [ -z $OPT_O ] 
then
	if [ -z $OPT_S ]
	then
		OPT_O=${FLD}.bam
	else
		OPT_O=${OPT_S%.sam}.bam
	fi
fi

echo "SAM = ${OPT_S} BAM = ${OPT_O}"
echo "$(date) $config_version valvs_sam2bam.sh s=$OPT_S o=$OPT_O" >> $LOG

samtools view -@ $OPT_T -bS $OPT_S | samtools sort -@ $OPT_T -o $OPT_O
rm -f $OPT_S

samtools index $OPT_O
