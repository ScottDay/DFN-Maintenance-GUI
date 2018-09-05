#!/bin/bash

# Give GitHub release a body describing the submodules changes.
if [ "$REQUEST_TYPE" == "release" ]; then
    BODY='{
        "tag_name": "$RELEASE_TAG",
        "target_commitish": "master",
        "name": "$RELEASE_TAG",
        "body": "$RELEASE_BODY",
        "draft": false,
        "prerelease": false
    }'

    curl -s -X PATCH \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -H "Authorization: token ${GH_TOKEN}" \
        -d "$BODY" \
        "https://api.github.com/repos/ScottDay/DFN-Maintenance-GUI/releases/tag/$RELEASE_TAG"
fi