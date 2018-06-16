echo "valvs"

FLD=${PWD##*/}
LOG="${FLD}_valvs_log.txt"
touch $LOG

. valvs_config.txt

echo "$(date) $config_version valvs.sh" >> $LOG

valvs_setup_reads.sh
valvs_setup_ref.sh
valvs_trim_galore.sh
valvs_tanoti.sh
valvs_vphaser.sh
