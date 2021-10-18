#!/usr/bin/env bash
# source the path of this script in user's bashrc or profile to be able to use bash functions
item_list=("/home/axel/Escritorio/git/ScriptsStudio/scripts/manage_apt_repo.sh" 
"/home/axel/Escritorio/git/ScriptsStudio/scripts/customize_desktop.sh" 
"/home/axel/Escritorio/git/ScriptsStudio/scripts/rename.sh" 
"/home/axel/Escritorio/git/ScriptsStudio/scripts/compile_rust.sh"
"/home/axel/Escritorio/git/ScriptsStudio/scripts/wtf.sh")


for item in ${item_list[@]}; do
    if [ -f "${item}" ]; then
        source "${item}"
    fi
done