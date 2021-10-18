#!/usr/bin/env bash
dist="$(cat /etc/*-release | cut -d "=" -f2 | head -1)"
if [ "${dist}" == "Ubuntu" ]; then
    pacman="apt-get install -y"
else
    echo "Install dependencies manually: python3, ssh, samba"
fi
${pacman} python3 ssh samba