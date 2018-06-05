#!/bin/bash

echo "valvs_setup_ref"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

while getopts :r: TEST; do
	case $TEST in
	
	r) OPT_R=$OPTARG
	;;
	esac
done

if [ -z $OPT_R ]
then
	for fa in *.f*
	do
		ext="${fa##*.}"
		if [[ $fa == *.fa ]] || [[ $fa == *.fna ]] || [[ $fa == *.fasta ]]
		then	
			if [[ $fa == valvs_ref.fa ]]
			then
				:		
			elif [ -z $ref ]
			then
				echo "ref = $fa"
				ref=$fa
			else
				echo "Multiple ref fasta files exist $fa, using the 1st one $ref"	
			fi
		fi
	done
else
	$ref=${OPT_R}
fi

echo "$(date) valvs_set_ref.sh ref=$ref" >> $LOG

if [[ -n $ref ]]
then
	cp $ref valvs_ref.fa
	echo "valvs_ref has been created: valvs_ref.fa"
else
	echo "Could not find a ref fasta file"
fi

