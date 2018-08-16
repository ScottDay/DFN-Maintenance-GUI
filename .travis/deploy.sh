#!/bin/bash

# Set an option to exit immediately if any error appears
set -o errexit

docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD

# Stage the updated version and submodules.
git add .env DFN-Maintenance-GUI-Backend DFN-Maintenance-GUI-Frontend DFN-Maintenance-GUI-Config

if [[ "$REQUEST_TYPE" == "release" ]]; then
    docker push scottydevil/dfn-maintenance-gui:$RELEASE_DOCKER_IMAGE_NAME

    # Commit the updated .env file.
    git commit -m "[skip ci] $RELEASE_DOCKER_IMAGE_NAME"

    # Tag the commit.
    git tag $RELEASE_DOCKER_IMAGE_NAME
elif [[ "$REQUEST_TYPE" == "dev" ]]; then
    # Remove dev docker images.
    docker rmi $(docker images --filter=reference="*:dev:*" -q)
    
    # Remove old dev git tags from the last release.
    git push -d $(git tag -l "*+*")

    # Commit the updated .env file.
    git commit -m "[skip ci] $DEV_DOCKER_IMAGE_NAME"

    # Tag the commit.
    git tag $DEV_DOCKER_IMAGE_NAME
fi

docker push scottydevil/dfn-maintenance-gui:$DEV_DOCKER_IMAGE_NAME

# Push commit and tags.
git push origin HEAD:$TRAVIS_BRANCH
git push --tags