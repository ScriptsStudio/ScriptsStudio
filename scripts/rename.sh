#!/usr/bin/env bash

re() {
    if [ $(($# % 2)) == 0 ]; then
        for i in "$@"; do
            if [ "${i: -1}" == "*" ]; then
                echo multiple!!!
                for j in $(ls -1 *$i*); do
                    echo "$j"
                    echo perform substitution
                    #for i in *.JPG;  do echo ${i%%.JPG}.jpg;  done
                done
                shift
            else
                mv "$1" "$2" 2>/dev/null
                shift
            fi
        done
    else 
      echo "Need to specify a new filename or path for the file."
    fi
}