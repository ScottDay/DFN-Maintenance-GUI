#!/bin/bash

docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD

# Stage the updated version and submodules.
git add .env DFN-Maintenance-GUI-Frontend DFN-Maintenance-GUI-Backend DFN-Maintenance-GUI-Config

if [[ "$REQUEST_TYPE" == "release" ]]; then
    # Push docker tags.
    docker push scottydevil/dfn-maintenance-gui:latest

    # Commit the updated .env file.
    git commit -m "v$RELEASE_VERSION $BUILD_DATE latest"$'\n\n''[skip ci]' 

    # Tag the commit.
    git tag "v$RELEASE_VERSION"
else
    # TODO: Remove dev docker images from docker hub.
    
    # Remove old dev git tags from the last release.
    # git push origin --delete $(git tag -l "v*.*")

    # Commit the updated .env file.
    git commit -m "v$RELEASE_VERSION.$DEV_VERSION $BUILD_DATE dev"$'\n\n''[skip ci]' 

    # Tag the commit.
    git tag "v$RELEASE_VERSION.$DEV_VERSION"
fi

# Push docker tags.
docker push scottydevil/dfn-maintenance-gui:v$RELEASE_VERSION 
docker push scottydevil/dfn-maintenance-gui:v$RELEASE_VERSION.$DEV_VERSION 
docker push scottydevil/dfn-maintenance-gui:dev

# Push commit and tags.
git push origin HEAD:$TRAVIS_BRANCH
git push --tags