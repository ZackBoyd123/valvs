#!/bin/bash

echo "valvs_bowtie2"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :r:1:2:t:m:o:u:f: TEST; do
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
	u) OPT_U=$OPTARG
	;;
	f) OPT_U=$OPTARG
	;;
	esac
done

if [[ $1 = "-h" ]]
then
	printf "\t----${0##*/}----\n\t[-r]\tReference file\n\t[-1]\tFirst Input Fastq File\n\t[-2]\tSecond Input Fastq File\n\t[-t]\tThreads\n\t[-m]\tAlignment Mode\n\t[-o]\tOutputStub\n"
	exit 1

fi

. valvs_check_ref.sh
. valvs_config.txt
. valvs_check_reads.sh

if [ -z $OPT_T ] 
then
	OPT_T=$config_threads
fi
if [ -z $OPT_M ] 
then
	OPT_M="local"
fi
if [ -z $OPT_O ] 
then
	OPT_O=${FLD}
fi

#Check if bt2 indexes already exist.
check=$(dirname $OPT_R)
file=`awk -F "/" '{print $NF}' <<< $OPT_R`
tocheck=$check/$file".1.bt2"

if [ -e "$tocheck" ]
then
	:
else
	tocheck=$check/$file".1.bt2l"
	if [ -e "$tocheck" ]
	then
		:
	else
		echo "Indexing reference"
		bowtie2-build $OPT_R $OPT_R
		echo "Finished indexing"
	fi
fi

if [ -z $OPT_U ]
then
	echo "Ref = ${OPT_R} R1 = ${OPT_1} R2 = ${OPT_2} OutputStub = $OPT_O"
	echo "$(date) $config_version valvs_bowtie2.sh r=$OPT_R 1=$OPT_1 2=$OPT_2 o=$OPT_O t=$OPT_T m=$OPT_M" >> $LOG
	
	bowtie2 --"$OPT_M" -p $OPT_T -x $OPT_R -1 $OPT_1 -2 $OPT_2 -S ${OPT_O}.sam
else
	echo "Ref = ${OPT_R} RU = ${OPT_U} OutputStub = $OPT_O"
	echo "$(date) $config_version valvs_bowtie2.sh r=$OPT_R u=$OPT_U o=$OPT_O t=$OPT_T m=$OPT_M" >> $LOG

	bowtie2 --"$OPT_M" -p $OPT_T -x $OPT_R -U $OPT_U -S ${OPT_O}.sam
fi

#Fast option - remove mapped here
if [ -z $OPT_F ]
then
	valvs_sam2bam.sh -t $OPT_T -s ${OPT_O}.sam -o ${OPT_O}.bam
else
	#technically expected BAM but should work
	valvs_remove_mapped.sh -b ${OPT_O}.sam
fi

valvs_bamstats.sh -b ${OPT_O}.bam
