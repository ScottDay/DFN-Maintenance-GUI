#!/bin/bash

# Set an option to exit immediately if any error appears
set -o errexit

if [[ "$REQUEST_TYPE" == "release" ]]; then
    cp .docker/prod/Dockerfile .
    docker build -t scottydevil/dfn-maintenance-gui:$RELEASE_DOCKER_IMAGE_NAME .
else
    cp .docker/dev/Dockerfile .
    docker build -t scottydevil/dfn-maintenance-gui:$DEV_DOCKER_IMAGE_NAME .
fi