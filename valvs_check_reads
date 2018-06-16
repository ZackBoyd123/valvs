v#!/bin/bash

echo "valvs_check_reads"

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

#If unpaired option not supplied, check that the R1 and R2 files exist [defualt or supplied]
#If they dont exist then see if the single end unpaired file exists
#If paired and unpaired don't exist then quit
#If paired don't exist but unpaired does - then bt2/bwa etc will use the unpaired reads as the OPT_U option will be set
#If paired do exist - then bt2/bwa etc will use them as OPT_U option will not be set
#All relies on there not being both paired and unpaired VALVS reads files in the same directory - if they do - paired is default
#User can override it all with explicit -1/-2 or -u arguments

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
            echo "Could not find any read files (paired ir unpaired) R1=$OPT_1 R2=$OPT_2 U=$OPT_U, exiting..."
            exit 1
        fi
    fi
fi

echo "valvs_check_reads.sh (date)

echo "R1 = ${OPT_1} R2 = ${OPT_2} RU = ${OPT_U}"
echo "$(date) $config_version valvs_check_reads.sh 1=$OPT_1 2=$OPT_2 u=$OPT_U" >> $LOG
