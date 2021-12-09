#!/usr/bin/env bash
# source the path of this script in user's bashrc or profile to be able to use bash functions


DIR="$(echo "${BASH_SOURCE}" | rev | cut -d '/' -f2- | rev)"
item_list=("${DIR}/manage_apt_repo.sh"
"${DIR}/customize_desktop.sh"
"${DIR}/rename.sh"
"${DIR}/compile_rust.sh"
"${DIR}/wtf.sh"
)


for item in "${item_list[@]}"; do
  source "${item}"
done
