#!/bin/bash

echo "valvs_setup_reads"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :1:2:u: TEST; do
	case $TEST in
	
	1) OPT_1=$OPTARG
	;;
	2) OPT_2=$OPTARG
	;;
	u) OPT_U=$OPTARG
	;;
	esac
done

. valvs_config.txt

if [[ -z $OPT_1 && -z $OPT_U ]]
then
	ls *_R1_*.f*q *_R1.f*q *_1.f*q *_1_*.f*q > filelist.txt 2>/dev/null 
	for fastq in `cat filelist.txt`
	do
		if [[ $fastq == *_R1_valvs.fq ]]
		then
			echo "valvs R1 fastq file already exists: $fastq [so using it]"
			echo "valvs R1 fastq file already exists: $fastq [so using it]" >> $LOG
		else
			if [ -z $R1 ]
			then
				echo "R1 = $fastq"
				R1=$fastq
			else
				echo "Multiple R1 fastq files exist $fastq, using the 1st one $R1"
				echo "Multiple R1 fastq files exist $fastq, using the 1st one $R1" >> $LOG
			fi
		fi
	done
	rm -f filelist.txt
else
	R1=${OPT_1}
fi

if [[ -z $OPT_2 && -z $OPT_U ]]
then
	ls *_R2_*.f*q *_R2.f*q *_2.f*q *_2_*.f*q> filelist.txt 2>/dev/null
        for fastq in `cat filelist.txt`
	do
        	if [[ $fastq == *_R2_valvs.fq ]]
        	then
                	echo "valvs R2 fastq file already exists: $fastq [so using it]"
			echo "valvs R2 fastq file already exists: $fastq [so using it]" >> $LOG
        	else
                	if [ -z $R2 ]
                	then
				echo "R2 = $fastq"
                        	R2=$fastq
                	else
                        	echo "Multiple R2 fastq files exist $fastq, using the 1st one $R2"
				echo "Multiple R2 fastq files exist $fastq, using the 1st one $R2" >> $LOG 
                	fi
        	fi
	done
	rm -f filelist.txt
else
	R2=${OPT_2}
fi

if [[ -n $R1 && -n $R2 ]]
then
	cp $R1 ${FLD}_R1_valvs.fq
	cp $R2 ${FLD}_R2_valvs.fq
	echo "$(date) $config_version valvs_setup_reads.sh R1=$R1 R2=$R2" >> $LOG
	valvs_readstats.sh -1 $R1 -2 $R2
	echo "valvs paired end reads have been created: $R1 -> ${FLD}_R1_valvs.fq $R2 -> ${FLD}_R2_valvs.fq"
	echo "valvs paired end reads have been created: $R1 -> ${FLD}_R1_valvs.fq $R2 -> ${FLD}_R2_valvs.fq" >> $LOG
else
	if [ -z $OPT_U ]
	then
		ls *.f*q > filelist.txt 2>/dev/null
        	for fastq in `cat filelist.txt`
       		do
			if [ -z $RU ]
                	then
				echo "RU = $fastq"
                        	RU=$fastq
			else
				echo "Multiple RU fastq files exist $fastq, using the 1st one $RU" 
			fi
        	done
        	rm -f filelist.txt
	else
		RU=${OPT_U}
	fi

        cp $RU ${FLD}_valvs.fq
	echo "$(date) $config_version valvs_setup_reads.sh RU=$RU" >> $LOG
	valvs_readstats.sh -u $RU
	echo "valvs single end reads have been created: $RU -> ${FLD}_valvs.fq"
	echo "valvs single end reads have been created: $RU -> ${FLD}_valvs.fq" >> $LOG
fi
