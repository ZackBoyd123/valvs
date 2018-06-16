#!/bin/bash

#echo "valvs_check_reads"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

if [ -z $OPT_1 ]
then
    OPT_1=$FLD"_R1_valvs.fq"
fi
if [ -z $OPT_2 ]
then
    OPT_2=$FLD"_R2_valvs.fq"
fi

if [ -z $OPT_U ]
then
    if [ -e $OPT_1 ] && [ -e $OPT_2 ]
    then
        #R1 and R2 exist - so they use them
        :
    else
        OPT_U=$FLD"_valvs.fq"

        if [ -e $OPT_U ]
        then
            #R1 and R2 do not exist, Unpaired exists, so use it [aligners will automatically]
            :
        else
            echo "Could not find any read files (paired or unpaired) R1=$OPT_1 R2=$OPT_2 U=$OPT_U, exiting..."
            exit 1
        fi
    fi
fi

if [ -z $OPT_U ]
then
	:
	#echo "$(date) $config_version valvs_check_reads.sh 1=$OPT_1 2=$OPT_2" >> $LOG
else
	:
        #echo "$(date) $config_version valvs_check_reads.sh u=$OPT_U" >> $LOG
fi
