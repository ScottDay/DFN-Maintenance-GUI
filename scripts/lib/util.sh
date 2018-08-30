#!/bin/bash

trap 'trapper $?' EXIT


exec() {
    edebug "COMMAND: $@"
    
    if ! output=$($@ 2>&1 >/dev/null); then
        eerror "$output"
        exit 1
    fi
}


trapper() {
    echo
    
    case "$@" in
        0)
            echo "Success!"
            ;;
        *)
            echo "Fatal error during execution! Resetting changes and exiting..."
            git reset --hard head
            ;;
    esac

    exit $@
}