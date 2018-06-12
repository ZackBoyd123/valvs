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
	OPT_O=$FLD"_weesam"
fi

echo "BAM = ${OPT_B} OutputStub = $OPT_O"
echo "$(date) $config_version valvs_weesam.sh b=$OPT_B o=$OPT_O" >> $LOG

weeSAMv1.4 -b $OPT_B -o ${OPT_O}.txt -plot ${OPT_O}.pdf
