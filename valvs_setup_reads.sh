#!/bin/bash

echo "valvs_setup_reads"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :1:2: TEST; do
	case $TEST in
	
	1) OPT_1=$OPTARG
	;;
	2) OPT_2=$OPTARG
	;;
	esac
done

. valvs_config.txt

if [ -z $OPT_1 ]
then
	for fastq in *_*1_*.f*q
	do
		if [[ $fastq == *_R1_valvs.fq ]]
		then
			:
		else
			if [ -z $R1 ]
			then
				echo "R1 = $fastq"
				R1=$fastq
			else
				echo "Multiple R1 fastq files exist $fastq, using the 1st one $R1"	
			fi
		fi
	done
else
	$R1=${OPT_1}
fi

if [ -z $OPT_2 ]
then
	for fastq in *_*2*.f*q
	do
        	if [[ $fastq == *_R2_valvs.fq ]]
        	then
                	:
        	else
                	if [ -z $R2 ]
                	then
				echo "R2 = $fastq"
                        	R2=$fastq
                	else
                        	echo "Multiple R2 fastq files exist $fastq,using the 1st one $R2" 
                	fi
        	fi
	done
else
	$R2=${OPT_2}
fi

echo "$(date) $config_version valvs_set_reads.sh R1=$R1 R2=$R2" >> $LOG

if [[ -n $R1 && -n $R2 ]]
then
	valvs_readstats.sh -1 $R1 -2 $R2
	cp $R1 ${FLD}_R1_valvs.fq
	cp $R2 ${FLD}_R2_valvs.fq
	echo "valvs reads have been create: ${FLD}_R1_valvs.fq ${FLD}_R2_valvs.fq"
else
	echo "Could not find a R1 & R2 file"
	echo "R1 = $R1"
	echo "R2 = $R2"
fi
