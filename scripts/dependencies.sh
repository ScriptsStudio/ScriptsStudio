#!/usr/bin/env bash
dist="$(cat /etc/*-release | cut -d "=" -f2 | head -1)"
DIR="$(echo "${BASH_SOURCE}" | rev | cut -d '/' -f3- | rev)"

if [ "${dist}" == "Ubuntu" ]; then
    pacman="apt-get install -y"
    if [ ! -d "${HOME}/ScriptsStudio" ]; then
      mkdir "${HOME}/ScriptsStudio"
    fi
    if [ ! -f "${HOME}/ScriptsStudio/install.py" ]; then
      cp "../install.py" "${HOME}/ScriptsStudio/install.py"
    fi
else
    #pacman="apt-get install -y"
    :
fi
#${pacman} python3 ssh samba
