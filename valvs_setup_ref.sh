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

. valvs_config.txt

if [ -z $OPT_R ]
then
	for fa in *.f*
	do
		ext="${fa##*.}"
		if [[ $fa == *.fa ]] || [[ $fa == *.fna ]] || [[ $fa == *.fasta ]]
		then	
			if [[ $fa == valvs_ref.fa ]]
			then
				rm -f valvs_ref.fa*
			elif [ -z $ref ]
			then
				echo "ref = $fa"
				ref=$fa
			else
				echo "Multiple ref fasta files exist $fa, using the 1st one $ref"
				echo "Multiple ref fasta files exist $fa, using the 1st one $ref" >> $LOG
			fi
		fi
	done
else
	ref=${OPT_R}
fi

echo "$(date) $config_version valvs_set_ref.sh ref=$ref" >> $LOG

if [[ -n $ref ]]
then
	ln -s $ref valvs_ref.fa
	echo "valvs_ref link has been created: valvs_ref.fa -> $ref"
	echo "valvs_ref link created valvs_ref.fa -> $ref" >> $LOG
else
	echo "Could not find a ref fasta file"
	echo "Could not find a ref fasta file" >> $LOG
fi
