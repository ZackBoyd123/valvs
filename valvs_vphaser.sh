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



if [ -z $OPT_B ] 
then
	OPT_B=${FLD}".bam"
fi

echo "BAM file = ${OPT_B}"
echo "$(date) valvs_vphaser.sh b=$OPT_B" >> $LOG

variant_caller -i $OPT_B -o ./

if [ -n $OPT_D ]
then
    mkdir -p VPhaserOutput
    #RJO - need to move vphaser files into here - maybe keep the key variant file in the folder though?
    prefix=$(samtools view $OPT_B | head -1 | awk '{print $3}')
    for i in $(ls | grep $prefix | grep -v $prefix".1.var.raw.txt")
    do
        mv $i VPhaserOutput
    done
fi
