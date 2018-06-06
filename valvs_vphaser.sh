#!/bin/bash

echo "valvs_vphaser"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :b:d: TEST; do
	case $TEST in

	b) OPT_B=$OPTARG
	;;
    	d) OPT_D=$OPTARG
    	;;
	esac
done

if [ $1 = "-h" ]
then
        printf "\t----${0##*/}----\n\t[-b]\tInput BAM File\n\t[-d]\tPut Output Files in New Directory? y/n\n"
        exit 1

fi


. valvs_config.txt
if [ -z $OPT_B ] 
then
	OPT_B=${FLD}".bam"
fi

echo "BAM file = ${OPT_B}"
echo "$(date) $config_version_number valvs_vphaser.sh b=$OPT_B" >> $LOG

variant_caller -i $OPT_B -o ./

if [ -n $OPT_D ]
then
    mkdir -p VPhaserOutput
    #RJO - need to move vphaser files into here - maybe keep the key variant file in the folder though?
    for i in $(ls | grep ".region")
    do
        mv $i VPhaserOutput
    done
fi
