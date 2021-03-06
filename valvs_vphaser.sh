#!/bin/bash

echo "valvs_vphaser"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :b: TEST; do
	case $TEST in

	b) OPT_B=$OPTARG
	;;
	esac
done

if [[ $1 = "-h" ]]
then
        printf "\t----${0##*/}----\n\t[-b]\tInput BAM File\n"
	printf "\n----------------------------------------\n"
        printf "Run the VPhaser variant caller."
        printf "\n----------------------------------------\n"

        exit 1

fi

. valvs_config.txt

if [ -z $OPT_B ] 
then
	OPT_B=${FLD}".bam"
fi

echo "BAM file = ${OPT_B}"
echo "$(date) $config_version valvs_vphaser.sh b=$OPT_B" >> $LOG

variant_caller -i $OPT_B -o ./

mkdir -p Vphaser
mv *.region Vphaser
mv *.covplot.R Vphaser
mv *.eb Vphaser
