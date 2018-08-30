#!/bin/bash

show_help() {
cat << EOF
NAME
    ${0##*/} - locally build and execute the DFN-Maintenance-GUI project.

SYNOPSIS
    ${0##*/} -o|--options [TARGET]

DESCRIPTION
    ${0##*/} is used to build each individual child project, compile the output into a build/ dir, and run the resulting code.

    The TARGET parameter specifies the type of build that is to be done. A build TARGET must be provided.

OPTIONS
    -h|--help     display this help and exit.
    -s|--skip     skip a build stage (setup|build|run).
    -c|--clean    clean all local changes.
    -q|--quiet    quiet logging.
    -v|--verbose  verbose logging.
    -d|--debug    debug logging.

PARAMETERS
    docker  build and run a local docker container.
    bash    build and run the project from bash.

EXAMPLES
    1: ./${0##*/} docker
    2: ./${0##*/} -v bash
    3: ./${0##*/} bash --skip setup
EOF
}


! getopt --test > /dev/null

if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    ecrit "I’m sorry, `getopt --test` failed in this environment."
    exit 1
fi

# If you want an option to have an argument place ':' after it. 
# E.g: 'o:' lets us do '-o /fizz/someOtherFile'
OPTIONS=hs:cqvd
LONGOPTS=help,skip:,clean,quiet,verbose,debug

# -use ! and PIPESTATUS to get exit code with errexit set
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")

if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # E.g. return value is 1
    ecrit "getopt has complained about wrong arguments to stdout."
    exit 2
fi

# Read getopt’s output this way to handle the quoting right.
eval set -- "$PARSED"

# Sensible defaults.
clean=1
skip_setup_stage=1
skip_build_stage=1
skip_run_stage=1

# Enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -s|--skip)
            case "$2" in
                "setup")
                    skip_setup_stage=0
                    ;;
                "build")
                    skip_build_stage=0
                    ;;
                "run")
                    skip_run_stage=0
                    ;;
                *)
                    eerror "No matching build stage, ignoring!"
            esac

            shift 2
            ;;
        -c|--clean)
            clean=0
            shift
            ;;
        -q|--quiet)
            verbosity=$silent_lvl
            shift
            ;;
        -v|--verbose)
            verbosity=$inf_lvl
            shift
            ;;
        -d|--debug)
            verbosity=$dbg_lvl
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            eerror "Programming error while parsing CLI arguments!"
            exit 3
            ;;
    esac
done

# Handle non-option arguments.
if [[ $# -ne 1 ]]; then
    ecrit "$0: A single build parameter must be provided, see 'TARGET' in help docs."
    exit 4
fi

target=$1
edebug "Build target: $target"