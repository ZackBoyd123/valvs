#!/bin/bash

echo "valvs_mpileup"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :r:b: TEST; do
	case $TEST in
	
	r) OPT_R=$OPTARG
	;;
	b) OPT_B=$OPTARG
	;;
	esac
done

if [[ $1 = "-h" ]]
then
        printf "\t----${0##*/}----\n\t[-b]\tInput BAM File\n\t[-r]\tRefence File\n"
	printf "\n----------------------------------------\n"
        printf "Generate an mpileup file given a BAM and 
reference file."
        printf "\n----------------------------------------\n"
        exit 1

fi

. valvs_check_ref.sh
. valvs_config.txt

if [ -z $OPT_B ]
then
	OPT_B=${FLD}".bam"
fi

echo "Ref = ${OPT_R} BAM = ${OPT_B}"
echo "$(date) $config_version valvs_mpileup.sh r=$OPT_R b=$OPT_B" >> $LOG

samtools mpileup -B -d 100000000 -A -q 0 -Q 0 -C 0 -f $OPT_R $OPT_B > ${OPT_B%.bam}"_mpileup.txt"

