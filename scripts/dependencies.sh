#!/usr/bin/env bash
dist="$(cat /etc/*-release | cut -d "=" -f2 | head -1)"
if [ "${dist}" == "Ubuntu" ]; then
    pacman="apt-get install -y"
else
    pacman="apt-get install -y"
fi
${pacman} python3 ssh samba
