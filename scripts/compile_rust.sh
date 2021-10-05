#!/usr/bin/env bash
compile_rust() {
    name="$(echo $1 | cut -d "." -f1)"
    rustc "$1"
    ./"${name}"
}