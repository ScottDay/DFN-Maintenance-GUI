#!/bin/bash

# Set an option to exit immediately if any error appears
set -o errexit

source .env # Load up environment variables.

if [[ "$REQUEST_TYPE" == "release" ]]; then
    export RELEASE_VERSION=$(($RELEASE_VERSION+1)) # Increment release version.
    export DEV_VERSION=$((0)) # Reset dev version.
elif [[ "$REQUEST_TYPE" == "dev" ]]; then
    export DEV_VERSION=$(($DEV_VERSION+1)) # Increment dev version.
fi

export BUILD_DATE=$(date +%d-%m-%Y) # Current date.

export RELEASE_DOCKER_IMAGE_NAME=prod:$RELEASE_VERSION.$BUILD_DATE # Name to give to the docker image / tag.
export DEV_DOCKER_IMAGE_NAME=dev:$RELEASE_VERSION.$BUILD_DATE+$DEV_VERSION # Name to give to the docker image / tag.