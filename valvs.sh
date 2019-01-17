echo "valvs"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG


while getopts :1:2:r:q:l: TEST; do
	case $TEST in
	
	1) OPT_1=$OPTARG
	;;
	2) OPT_2=$OPTARG
	;;
	r) OPT_R=$OPTARG
	;;
  q) OPT_Q=$OPTARG
	;;
  l) OPT_L=$OPTARG
	;;
	esac
done

. valvs_config.txt
. valvs_check_reads.sh
. valvs_check_ref.sh

if [ -z $OPT_Q ]
then
    OPT_Q=$config_qual
fi
if [ -z $OPT_L ]
then
    OPT_L=$config_len
fi

echo "$(date) $config_version valvs.sh" >> $LOG

valvs_setup_reads.sh -1 ${OPT_1} -2 ${OPT_2}
valvs_setup_ref.sh -r ${OPT_R}
valvs_trim_galore.sh -q ${OPT_Q} -l ${OPT_l}
valvs_tanoti.sh
valvs_vphaser.sh
