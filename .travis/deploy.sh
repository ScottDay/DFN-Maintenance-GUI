#!/bin/bash

# Set an option to exit immediately if any error appears
set -o errexit

docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD

git add .env

if [[ "$REQUEST_TYPE" == "release" ]]; then
    docker push $RELEASE_DOCKER_IMAGE_NAME

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

docker push $DEV_DOCKER_IMAGE_NAME

# Push commit and tags.
git push --follow-tags