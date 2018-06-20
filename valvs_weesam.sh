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

if [[ $1 = "-h" ]]
then
	printf "valvs_weesam.sh runs weeSAM on a BAM file to generate a coverage statistics file (txt) and coverage plot (pdf)\n"
	printf "By default valvs_weesam.sh will look for folderName.bam and generate folderName_weesam.txt and folderName_weesam.pdf\n"
	printf "However, these can be overrideen using the -b flag to specify an input BAM file and -o flag to specity and OutputStub filename (OutputStub_weesam.txt and OutputStub_pdf.txt will be created)\n"
	printf "\n----------------------------------------\n"
	printf "Usage:"
	printf "\t----${0##*/}----\n\t[-b]\tInput BAM file\n\t[-o]\tOutput file name.\n"
	printf "\n----------------------------------------\n"

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
