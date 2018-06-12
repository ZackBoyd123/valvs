#!/bin/bash

echo "valvs_lofreq"

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

. valvs_checkref.sh
. valvs_config.txt

if [ -z $OPT_B ] 
then
	OPT_B=${FLD}".bam"
fi

echo "Ref = ${OPT_R} BAM = ${OPT_B}"
echo "$(date) $config_version valvs_lofreq.sh b=$OPT_B r=$OPT_R" >> $LOG

lofreq call -f $OPT_R -o ${OPT_B%.bam}".vcf" --verbose "$OPT_B"

