#!/bin/bash

# Set an option to exit immediately if any error appears
set -o errexit

if [[ "$REQUEST_TYPE" == "release" ]]; then
    docker build --file .docker/prod/Dockerfile -t /DFN-Maintenance-GUI:$RELEASE_DOCKER_IMAGE_NAME .
fi

docker build --file .docker/dev/Dockerfile -t /DFN-Maintenance-GUI:$DEV_DOCKER_IMAGE_NAME .
