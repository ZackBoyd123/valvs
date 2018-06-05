#!/bin/bash
if [ -z $OPT_R ]
then
	if [ -e $PWD"/valvs_ref.fa" ]
	then 
		OPT_R=$PWD"/valvs_ref.fa"
	else
		OPT_R=$(dirname $PWD)"/References/valvs_ref.fa"
	fi
fi

firstchar="${OPT_R:0:1}"
if [ "$firstchar" == "/" ] || [ "$firstchar" == "~" ]
then
	:
else
	echo "Please specify your reference as a full or relative path"
	#RJO - should we exit here
	exit 1
fi
