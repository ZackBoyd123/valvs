#!/bin/bash

echo "valvs_remove_mapped"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :b:t:o: TEST; do
	case $TEST in

	b) OPT_B=$OPTARG
	;;
	t) OPT_T=$OPTARG
	;;
        o) OPT_O=$OPTARG
        ;;
	esac
done

if [[ $1 = "-h" ]]
then
        printf "\t----${0##*/}----\n\t[-b]\tInput BAM File\n\t[-t]\tNumber of Threads to Use\n"
	printf "\n----------------------------------------\n"
        printf "Remove all mapped reads in a BAM file. Unlike
extract mapped, this script doesn't produce a new file(s) with
the mapped reads"
        printf "\n----------------------------------------\n"
        exit 1

fi

. valvs_config.txt

if [ -z $OPT_T ]
    then
    OPT_T=$config_threads
fi
if [ -z $OPT_B ]
    then
    OPT_B=${FLD}.bam
fi
if [ -z $OPT_O ]
    then
    OPT_O=${FLD}.bam
fi

TEMP=${OPT_B%.bam}.v2.bam

echo "BAM = ${OPT_B} OUTPUT=${OPT_O}"
echo "$(date) $config_version valvs_remove_mapped.sh b=$OPT_B o=$OPT_O" >> $LOG

samtools view -@ $OPT_T -bh -f 4 $OPT_B | samtools sort -@ $OPT_T -o $TEMP
mv $TEMP $OPT_O
samtools index ${OPT_O}
