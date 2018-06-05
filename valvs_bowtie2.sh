

#!/bin/bash

echo "valvs_bowtie2"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :r:1:2:t:m:o: TEST; do
	case $TEST in 
	r) OPT_R=$OPTARG
	;;
	1) OPT_1=$OPTARG
	;;
	2) OPT_2=$OPTARG
	;;
	t) OPT_T=$OPTARG
	;;	
	m) OPT_M=$OPTARG
	;;
	o) OPT_O=$OPTARG
	;;
	esac
done

if [ $1 = "-h" ]
then
	printf "\t----${0##*/}----\n\t[-r]\tReference file\n\t[-1]\tFirst Input Fastq File\n\t[-2]\tSecond Input Fastq File\n\t[-t]\tThreads\n\t[-m]\tAlignment Mode\n\t[-o]\tOutput File Name\n"
	exit 1

fi


pwd=`pwd`
. valvs_checkref.sh

if [ -z $OPT_1 ]
then
	OPT_1=$FLD"_R1_valvs.fq"
fi
if [ -z $OPT_2 ] 
then
	OPT_2=$FLD"_R2_valvs.fq"
fi
if [ -z $OPT_T ] 
then
	OPT_T=10
fi
if [ -z $OPT_M ] 
then
	OPT_M="local"
fi
if [ -z $OPT_O ] 
then
	OPT_O=${FLD}
fi

echo "Ref = ${OPT_R} R1 = ${OPT_1} R2 = ${OPT_2} OutputStub = $OPT_O"
echo "$(date) valvs_bowtie2.sh R=$OPT_R 1=$OPT_1 2=$OPT_2 o=$OPT_O t=$OPT_T m=$OPT_M" >> $LOG

#Check if bt2 indexes already exist.
check=$(dirname $OPT_R)
file=`awk -F "/" '{print $NF}' <<< $OPT_R`
tocheck=$check/$file".1.bt2"

echo "Looing for $tocheck to check indexes..."
if [ -e "$tocheck" ]
then
	echo "indexes found"
	:
else
	echo "Couldn't find bowtie indexes in the correct location, indexing...."
	bowtie2-build $OPT_R $OPT_R
fi

bowtie2 --"$OPT_M" -p $OPT_T -x $OPT_R -1 $OPT_1 -2 $OPT_2 -S ${OPT_O}.sam
valvs_sam2bam.sh -t $OPT_T -s ${OPT_O}.sam -o ${OPT_O}.bam
valvs_bamstats.sh -b ${OPT_O}.bam
