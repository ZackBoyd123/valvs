#!/bin/bash

echo "valvs_bam2sam"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :t:b:o: TEST; do
  case $TEST in 

	t) OPT_T=$OPTARG
	;;
	b) OPT_B=$OPTARG
	;;	
	o) OPT_O=$OPTARG
	;;
	esac
done

if [[ $1 = "-h" ]]
then
        printf "\t----${0##*/}----\n\t[-b]\tInput BAM File\n\t[-t]\tNumber of Threads to Use\n\t[-o]\tOutput SAM File Name\n"
        exit 1
fi

. valvs_config.txt

if [ -z $OPT_T ] 
then
	OPT_T=$config_threads
fi
if [ -z $OPT_B ]
then
	OPT_B=${FLD}.bam
fi
if [ -z $OPT_O ] 
then
	if [ -z $OPT_B ]
	then
		OPT_O=${FLD}.sam
	else
		OPT_O=${OPT_B%.bam}.sam
	fi
fi

echo "BAM = ${OPT_B} SAM = ${OPT_O}"
echo "$(date) $config_version valvs_bam2sam.sh b=$OPT_B o=$OPT_O" >> $LOG

samtools view -h $OPT_B > $OPT_O
