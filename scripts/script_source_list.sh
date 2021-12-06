#!/usr/bin/env bash
# source the path of this script in user's bashrc or profile to be able to use bash functions
if [ ! -f "$HOME/.config/user-dirs.dirs" ]; then
  xdg-user-dirs-update
else
  if [ -f "$HOME/.config/user-dirs.dirs" ]; then
    source "$HOME/.config/user-dirs.dirs"
  fi
fi
item_list=("${XDG_DESKTOP_DIR}/git/ScriptsStudio/scripts/manage_apt_repo.sh"
"${XDG_DESKTOP_DIR}/git/ScriptsStudio/scripts/customize_desktop.sh"
"${XDG_DESKTOP_DIR}/git/ScriptsStudio/scripts/rename.sh"
"${XDG_DESKTOP_DIR}/git/ScriptsStudio/scripts/compile_rust.sh"
"${XDG_DESKTOP_DIR}/git/ScriptsStudio/scripts/wtf.sh"
)


for item in "${item_list[@]}"; do
  source "${item}"
done