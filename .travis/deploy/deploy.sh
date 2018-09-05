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
echo "$(jq \
    --tab \
    --arg release $RELEASE_VERSION \
    --arg dev $DEV_VERSION \
    --arg build $BUILD_DATE \
    '.version.release = $release 
        | .version.dev = $dev 
        | .buildDate = $build' \
    env.json
)" > env.json

# Stage the updated version and submodules.
git add env.json DFN-Maintenance-GUI-Frontend DFN-Maintenance-GUI-Backend DFN-Maintenance-GUI-Installer DFN-Maintenance-GUI-Config

if [ "$REQUEST_TYPE" = "release" ]; then
    # Remove dev docker images from docker hub.
    ./.travis/deploy/curl_docker_tags.sh scottydevil/dfn-maintenance-gui v$RELEASE_VERSION. > tags.txt

    for tag in `cat tags.txt`; do
        delete_from_docker_by_tag $tag
    done

    # Push docker tags.
    docker push scottydevil/dfn-maintenance-gui:latest

    # Commit the updated env.json file.
    git commit -m "v$RELEASE_VERSION" -m '[skip ci]' 

    # Remove old dev git tags from the last release.
    git tag --delete $(git tag -l "v*.*")
    git push origin --delete $(git tag -l "v*.*")
    
    # Tag the commit.
    git tag "v$RELEASE_VERSION"
else
    # Commit the updated .env file.
    git commit -m "v$RELEASE_VERSION.$DEV_VERSION" -m '[skip ci]' 

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