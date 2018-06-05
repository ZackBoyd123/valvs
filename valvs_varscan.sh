#!/bin/bash

echo "valvs_varscan"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :q:f:m:d: TEST; do
	case $TEST in

	q) OPT_Q=$OPTARG
	;;
	m) OPT_M=$OPTARG
	;;
	f) OPT_F=$OPTARG
	;;
    	d) OPT_D=$OPTARG
    	;;
	esac
done

if [ $1 = "-h" ]
then
        printf "\t----${0##*/}----\n\t[-m]\tInput Mpileup File\n\t[-q]\tMinimum Average Quality\n\t[-f]\tMinimum Variant Frequency\n\t[-d]\tPut Output Files in New Directory? y/n\n"
        exit 1

fi



if [ -z $OPT_Q ] 
then
	OPT_Q=0
fi
if [ -z $OPT_F ] 
then
	OPT_F=0.000001
fi
if [ -z $OPT_M ]
then
	OPT_M=${FLD}_mpileup.txt
	VAR=${OPT_M%_mpileup.txt}_varscan.txt
else
	VAR=${OPT_M}s_varscan.txt
fi

echo "mpileup = ${OPT_M} Qual = $OPT_Q Freq = $OPT_F"
echo "$(date) valvs_varscan.sh m=$OPT_M q=$OPT_Q f=$OPT_F" >> $LOG

#RJO - valvs_path
java -jar /software/bin/VarScan.v2.3.7.jar mpileup2snp $OPT_M --min-avg-qual $OPT_Q -min-var-freq $OPT_F --output-vcf 1 > ${VAR}

if [ -n $OPT_D ]
then
    mkdir -p VarScanOutput
    mv ${VAR} VarScanOutput/
fi
