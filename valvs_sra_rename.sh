#!/bin/bash

echo "valvs_sra_rename"

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
	OPT_1=$FLD"_R1_valvs.fq"
fi
if [ -z $OPT_2 ] 
then
	OPT_2=$FLD"_R2_valvs.fq"
fi

echo "R1 file = ${OPT_1} R2 file = ${OPT_2}"
echo "$(date) $config_version valvs_sra_rename.sh R1=$OPT_1 R2=$OPT_2" >> $LOG

sed -i 's/\.1 / /g' ${OPT_1}
sed -i 's/\.2 / /g' ${OPT_2}
