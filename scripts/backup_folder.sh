#!/usr/bin/env bash

backup_folder() {
    backup_date=$(echo $(date +%Y%m%d_%T) | tr -s ':' '_')
    origin_folder=$1
    origin_folder_name="$(echo ${origin_folder} | rev | cut -d "/" -f1 | rev)"
    destiny_folder="$2/${origin_folder_name}_${backup_date}/"

    mkdir -p "${destiny_folder}"
    rsync -au --info=progress2 ${origin_folder} ${destiny_folder}
}