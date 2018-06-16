#!/bin/bash

echo "valvs_diversitools"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :r:b:o: TEST; do
	case $TEST in
	
	r) OPT_R=$OPTARG
	;;
	b) OPT_B=$OPTARG
	;;
	o) OPT_O=$OPTARG
	;;
	esac
done

if [[ $1 = "-h" ]]
then
        printf "\t----${0##*/}----\n\t[-b]\tInput BAM File\n\t[-r]\tReference File\n\t[-o]\tOutput File Name\n"
        exit 1

fi

. valvs_check_ref.sh
. valvs_config.txt

if [ -z $OPT_B ]
then
	OPT_B=$FLD".bam"
fi
if [ -z $OPT_O ]
then
	OPT_O=${OPT_B%.bam}
fi

echo "Ref = ${OPT_R} BAM = ${OPT_B} Stub = ${OPT_O}"
echo "$(date) $config_version valvs_diversitools.sh r=$OPT_R b=OPT_B" o=${OPT_O} >> $LOG

$config_diversiutils -bam $OPT_B -ref $OPT_R -stub $OPT_O

