#!/bin/bash

#$1=valvs script to run in each folder

echo "valvs_loop"

FLD=${PWD##*/}
LOG="${FLD}_valvs_loop.txt"
touch $LOG

while getopts :v: TEST; do
        case $TEST in 
        
        v) OPT_V=$OPTARG
        ;;
	esac
done

if [ -z $OPT_V ]
then
        OPT_V=valvs.sh
fi

for i in $(ls -d */ | grep -v Undetermined | grep -v SeqDat)
do 
	echo $i

	cd $i
	
	$OPT_V

	cd ../
done
