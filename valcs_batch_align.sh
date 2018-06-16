echo "valvs_batch_align"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

. valvs_config.txt

valvs_trim_galore.sh
valvs_tanoti.sh
valvs_vphaser.sh

echo "$(date) $config_version valvs_batch_align.sh" >> $LOG
