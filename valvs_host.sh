#!/bin/bash

echo "valvs_host"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :1:2:r:k:o:t:m: TEST; do
	case $TEST in

	1) OPT_1=$OPTARG
	;;
	2) OPT_2=$OPTARG
	;;
	r) OPT_R=$OPTARG
	;;
	k) OPT_K=$OPTARG
	;;
	o) OPT_O=$OPTARG
	;;
	t) OPT_T=$OPTARG
	;;	
	m) OPT_M=$OPTARG
	;;
	esac
done

if [[ $1 = "-h" ]]
then
        printf "\t----${0##*/}----\n\t[-1]\tName Of First Fastq File\n\t[-2]\tName Of Second Fastq File\n\t[-r]\tReference File\n\t[-o]\tOutput File Name\n\t[-k]\t Keep Old Files? y\n"
	printf "\n----------------------------------------\n"
        printf "Maps reads to a host index using bowtie2 both paired and unpaired reads are supported aswell as different bowtie alignment modes."
        printf "\n----------------------------------------\n"
        exit 1

fi

#RJO - host ref is different to viral so can't use checkref
if [ -z $OPT_R ]
then
	if [ -e $PWD"/valvs_host.txt" ]
        	then
        	OPT_R=$(cat $PWD"/valvs_host.txt")
        elif [ -e $PWD"/valvs_host.fa" ]
        then
                OPT_R=$PWD"/valvs_host.fa"
        else
                OPT_R=$(dirname $PWD)"/Refs/valvs_host.fa"
        fi
fi

firstchar="${OPT_R:0:1}"
if [ "$firstchar" == "." ] || [ "$firstchar" == "/" ] || [ "$firstchar" == "~" ]
then
	:
else
	echo "Please specify your reference as a full or relative path - exiting..."
	1
fi

. valvs_config.txt

if [ -z $OPT_1 ]
    then
    OPT_1=$FLD"_R1_valvs.fq"
fi
if [ -z $OPT_2 ]
then
    OPT_2=$FLD"_R2_valvs.fq"
fi
if [ -z $OPT_O ]
then
        OPT_O=${FLD}_host
        R1=${FLD}_R1_valvs.fq
        R2=${FLD}_R2_valvs.fq
else
        R1=${OPT_O}_R1_valvs.fq
        R2=${OPT_O}_R2_valvs.fq
fi
if [ -z $OPT_T ] 
then
	OPT_T=$config_threads
fi
if [ -z $OPT_M ] 
then
	OPT_M=""
else
	OPT_M="end-to-end"
fi

echo "Ref = $OPT_R R1 = $OPT_1 R2 = $OPT_2 OutputStub = $OPT_O Threads = $OPT_T Alignment Mode = $OPT_M"
echo "$(date) $config_version valvs_host.sh r=$OPT_R o=$OPT_O 1=$OPT_1 2=$OPT_2 t=$OPT_T m=$OPT_M" >> $LOG

valvs_bowtie2.sh -r $OPT_R -o ${OPT_O} -1 $OPT_1 -2 $OPT_2 -t $OPT_T -m $OPT_M
valvs_extract_unmapped.sh -b ${OPT_O}.bam -1 $R1 -2 $R2

if [ -z $OPT_K ]
then
	rm -f ${OPT_O}.bam
	rm -f ${OPT_O}.bam.bai
else
	mkdir -p Reads
	cp $R1 Reads/host_R1.fastq
	cp $R2 Reads/host_R2.fastq
fi
