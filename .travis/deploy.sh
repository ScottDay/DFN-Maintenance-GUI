#!/bin/bash

delete_from_docker_by_tag() {
    registry='scottydevil'
    name='dfn-maintenance-gui'
    auth="-u $DOCKER_HUB_USERNAME:$DOCKER_HUB_PASSWORD"
    tag="$1"
    curl $auth -X DELETE -sI -k "https://${registry}/v2/${name}/manifests/$(
        curl $auth -sI -k \
            -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
            "https://${registry}/v2/${name}/manifests/${tag}" \
            | tr -d '\r' | sed -En 's/^Docker-Content-Digest: (.*)/\1/pi'
    )"
}

# Login to DockerHub.
docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD

# Persist environment variables.
sed -i -e "s/RELEASE_VERSION=.*/RELEASE_VERSION=${RELEASE_VERSION}/" .env
sed -i -e "s/DEV_VERSION=.*/DEV_VERSION=${DEV_VERSION}/" .env
sed -i -e "s/BUILD_DATE=.*/BUILD_DATE=${BUILD_DATE}/" .env

# Stage the updated version and submodules.
git add .env DFN-Maintenance-GUI-Frontend DFN-Maintenance-GUI-Backend DFN-Maintenance-GUI-Config

if [ "$REQUEST_TYPE" = "release" ]; then
    # Remove dev docker images from docker hub.
    ./curl_docker_tags.sh scottydevil/dfn-maintenance-gui v$RELEASE_VERSION. > tags.txt

    for tag in `cat tags.txt`; do
        delete_from_docker_by_tag $tag
    done

    # Remove old dev git tags from the last release.
    git push origin --delete $(git tag -l "v*.*")

    # Push docker tags.
    docker push scottydevil/dfn-maintenance-gui:latest

    # Commit the updated .env file.
    git commit -m "v$RELEASE_VERSION $BUILD_DATE latest" -m '[skip ci]' 

    # Tag the commit.
    git tag "v$RELEASE_VERSION"
else
    # Commit the updated .env file.
    git commit -m "v$RELEASE_VERSION.$DEV_VERSION $BUILD_DATE dev" -m '[skip ci]' 

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