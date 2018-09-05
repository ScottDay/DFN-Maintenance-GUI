#!/bin/bash

# Set an option to exit immediately if any error appears.
set -o errexit

# Give GitHub release a body describing the submodules changes.
mv build/ GUI/
tar -czvf GUI.tar.gz GUI/

mv DFN-Maintenance-GUI-Installer/ Installer/
tar -czvf Installer.tar.gz Installer/

request_body='{
	"tag_name": "",
    "target_commitish": "master",
    "name": "",
    "body": "",
    "draft": false,
    "prerelease": false
}'

request_body=$(echo $request_body | jq ". + {"tag_name": \"$RELEASE_TAG\", "name": \"$RELEASE_TAG\", "body": \"$RELEASE_BODY\"}")

release_id=$(curl -s \
    -X GET \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: token ${GH_TOKEN}" \
    "https://api.github.com/repos/ScottDay/DFN-Maintenance-GUI/releases/latest" | jq -r '.id')

curl -s \
    -X PATCH \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: token ${GH_TOKEN}" \
    -d "$request_body" \
    "https://api.github.com/repos/ScottDay/DFN-Maintenance-GUI/releases/$release_id"

curl -s \
    -H "Content-Type: application/gzip" \
    -H "Authorization: token ${GH_TOKEN}" \
    --data-binary @GUI.tar.gz \
    "https://uploads.github.com/repos/ScottDay/DFN-Maintenance-GUI/releases/$release_id/assets?name=GUI.tar.gz&label=GUI.tar.gz"

curl -s \
    -H "Content-Type: application/gzip" \
    -H "Authorization: token ${GH_TOKEN}" \
    --data-binary @Installer.tar.gz \
    "https://uploads.github.com/repos/ScottDay/DFN-Maintenance-GUI/releases/$release_id/assets?name=Installer.tar.gz&label=Installer.tar.gz"