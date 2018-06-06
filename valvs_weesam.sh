#!/bin/bash
echo "valvs_weesam"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :b:o TEST; do
	case $TEST in
	b) OPT_B=$OPTARG
	;;
	o) OPT_O=$OPTARG
	;;	
	esac
done

if [ $1 = "-h" ]
then
	printf "\t----${0##*/}----\n\t[-b]\tInput BAM file\n\t[-o]\tOutput file name.\n"
	exit 1
fi

. valvs_config.txt

if [ -z $OPT_B ]
then
	OPT_B=$FLD".bam"
fi

if [ -z $OPT_O ] 
then
	OPT_O=$FLD"_weesam.txt"
fi

echo "$(date) $config_version_number valvs_weesam.sh B=$OPT_B O=$OPT_O" >> $LOG
echo $config_weesam_install
$config_weesam_install -b $OPT_B -o $OPT_O
