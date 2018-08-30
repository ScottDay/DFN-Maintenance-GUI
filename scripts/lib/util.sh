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
    case "$@" in
        0)
            eok "No errors encountered!"
            ;;
        *)
            ecrit "Fatal error during execution!"
            
            if [ $clean -eq 0 ]; then
                einfo "Resetting local changes..."
                exec git reset --hard HEAD
            fi            
            ;;
    esac

    einfo "Exiting..."

    exit $@
}