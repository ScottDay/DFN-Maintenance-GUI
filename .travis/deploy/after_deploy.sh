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

    upload_url=$(curl -s -X PATCH \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -H "Authorization: token ${GH_TOKEN}" \
        -d "$BODY" \
        "https://api.github.com/repos/ScottDay/DFN-Maintenance-GUI/releases/tag/$RELEASE_TAG" | jq -r '.upload_url')
    
    mv build/ GUI/
    tar -czfv GUI.tar.gz GUI/*

    curl -s \
        -H "Content-Type: application/gzip" \
        -H "Authorization: token ${GH_TOKEN}"  \
        --data-binary @GUI.tar.gz  \
        "$upload_url?name=GUI.tar.gz&label=GUI.tar.gz"
    
    tar -czfv Installer.tar.gz DFN-Maintenance-GUI-Installer/*

    curl -s \
        -H "Content-Type: application/gzip" \
        -H "Authorization: token ${GH_TOKEN}"  \
        --data-binary @Installer.tar.gz  \
        "$upload_url?name=Installer.tar.gz&label=Installer.tar.gz"
fi