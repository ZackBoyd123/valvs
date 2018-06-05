#!/bin/bash
valvs_makefolders.sh
for i in $(ls -d */ | grep -v Undetermined | grep -v seqrun)
	do echo $i
	cd $i
	
	valvs_trim_galore.sh
	valvs_kraken.sh
	valvs_contamination.sh
	valvs_host.sh -r /home2/db/bowtie2/hg38
	valvs_bwa.sh
	valvs_readstats.sh
	valvs_mpileup.sh
	valvs_lofreq.sh
	valvs_vphaser.sh
#	put
#	scripts
#	in
#	here
#
#

	cd ../
done
