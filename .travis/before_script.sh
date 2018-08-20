#!/bin/bash

# Set an option to exit immediately if any error appears.
set -o errexit

source .env # Load up environment variables.

if [ "$REQUEST_TYPE" = "release" ]; then
    export RELEASE_VERSION=$(($RELEASE_VERSION+1)) # Increment release version.
    export DEV_VERSION=$((0)) # Reset dev version.
else
    export RELEASE_VERSION=$(($RELEASE_VERSION))
    export DEV_VERSION=$(($DEV_VERSION+1)) # Increment dev version.
fi

export BUILD_DATE=$(date +%d-%m-%Y) # Current date.