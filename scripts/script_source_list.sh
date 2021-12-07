#!/usr/bin/env bash
# source the path of this script in user's bashrc or profile to be able to use bash functions


if [ "${EUID}" != 0 ]; then
  declare HOME_FOLDER="${HOME}"
  declare BASHRC_PATH="${HOME_FOLDER}/.bashrc"
  declare BASHRC_ALL_USERS_PATH="/etc/bash.bashrc"
  declare PROFILE_PATH="${HOME_FOLDER}/.profile"
  declare SCRIPTS_FOLDER="${XDG_DESKTOP_DIR}/git/ScriptsStudio"

  declare USER_DIRS_PATH="${HOME_FOLDER}/.config/user-dirs.dirs"

  if [ ! -f "${USER_DIRS_PATH}" ]; then
    xdg-user-dirs-update
  else
    if [ -f "${USER_DIRS_PATH}" ]; then
      source "${USER_DIRS_PATH}"
    fi
  fi
fi


item_list=("${SCRIPTS_FOLDER}/scripts/manage_apt_repo.sh"
"${SCRIPTS_FOLDER}/scripts/customize_desktop.sh"
"${SCRIPTS_FOLDER}/scripts/rename.sh"
"${SCRIPTS_FOLDER}/scripts/compile_rust.sh"
"${SCRIPTS_FOLDER}/scripts/wtf.sh"
)


for item in "${item_list[@]}"; do
  source "${item}"
done


if [ "${EUID}" != 0 ]; then

  declare SCRIPTS_SCRIPT_PATH="${SCRIPTS_FOLDER}/scripts/script_source_list.sh"
  chmod +x "${SCRIPTS_SCRIPT_PATH}"

  # This script maintains a source line script in ~/.bashrc
  declare script_source_list="source ${SCRIPTS_SCRIPT_PATH}"
  if ! grep -Fqo "${script_source_list}" "${BASHRC_PATH}"; then
    echo -e "${script_source_list}" >> "${BASHRC_PATH}"
  fi

  unset script_source_list

  unset HOME_PATH
  unset BASHRC_PATH
  unset BASHRC_ALL_USERS_PATH
  unset PROFILE_PATH
  unset USER_DIRS_PATH
  unset SCRIPTS_FOLDER
  unset SCRIPTS_SCRIPT_PATH
fi