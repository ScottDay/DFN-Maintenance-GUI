#!/bin/bash

# Saner programming env: these switches turn some bugs into errors.
set -o pipefail -o noclobber -o nounset

# Source scripts.
source ./scripts/lib/util.sh
source ./scripts/lib/logger.sh
source ./scripts/lib/cli.sh



# Code.

## Source build target.
esection "Load"
einfo "Sourcing build target script: $target"

case "$target" in
    "docker")
        edebug "COMMAND: source ./scripts/target/docker.sh"
        source ./scripts/target/docker.sh
        ;;
    "bash")
        edebug "COMMAND: source ./scripts/target/bash.sh"
        source ./scripts/target/bash.sh
        ;;
    *)
        ecrit "Unknown build target: $1"
        exit 4
        ;;
esac

eok "Sourced build target script: $target"

## Setup.
if [ $skip_setup_stage -eq 0 ]; then
    einfo "Skipping Setup Stage"
else
    esection "Setup Stage"
    setup
fi

## Build.
if [ $skip_build_stage -eq 0 ]; then
    einfo "Skipping Build Stage"
else
    esection "Build Stage"
    build
fi

## Run.
if [ $skip_run_stage -eq 0 ]; then
    einfo "Skipping Run Stage"
else
    esection "Run Stage"
    run
fi