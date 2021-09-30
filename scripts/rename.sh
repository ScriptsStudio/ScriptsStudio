#!/usr/bin/env bash

ren() {
    if [ $(($# % 2)) == 0 ]; then
        for i in "$@"; do
            mv "$1" "$2" 2>/dev/null
            shift
        done
    else 
      echo "Need to specify a new filename or path for the file."
    fi
}