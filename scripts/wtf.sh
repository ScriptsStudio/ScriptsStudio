#!/usr/bin/env bash

wtf() {
    if [ "$(which $1)" ]; then
        echo "$(whereis $1 | cut -d ' ' -f2-)"
    else
        exit 1 &>/dev/null
    fi
}