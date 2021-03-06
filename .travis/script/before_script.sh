#!/bin/bash

# Set an option to exit immediately if any error appears.
set -o errexit

# Load up environment variables.
RELEASE_VERSION="$(cat env.json | jq -r '.version.release')"
DEV_VERSION="$(cat env.json | jq -r '.version.dev')"

if [ "$REQUEST_TYPE" = "release" ]; then
    export RELEASE_VERSION=$(($RELEASE_VERSION+1)) # Increment release version.
    export DEV_VERSION=$((0)) # Reset dev version.
else
    export RELEASE_VERSION=$(($RELEASE_VERSION))
    export DEV_VERSION=$(($DEV_VERSION+1)) # Increment dev version.
fi

export BUILD_DATE=$(date +%d-%m-%Y) # Current date.

# Setup release body message.
frontend=$(curl -s -H "Authorization: token ${GH_TOKEN}" "https://api.github.com/repos/ScottDay/DFN-Maintenance-GUI-Frontend/releases/latest" | jq -r '.body' | cut -c 3- | (printf "# Frontend " && cat))
backend=$(curl -s -H "Authorization: token ${GH_TOKEN}" "https://api.github.com/repos/ScottDay/DFN-Maintenance-GUI-Backend/releases/latest" | jq -r '.body' | cut -c 3- | (printf "# Backend " && cat))
installer=$(curl -s -H "Authorization: token ${GH_TOKEN}" "https://api.github.com/repos/ScottDay/DFN-Maintenance-GUI-Installer/releases/latest" | jq -r '.body' | cut -c 3- | (printf "# Installer " && cat))

export RELEASE_TAG="v$RELEASE_VERSION"
export RELEASE_BODY="$frontend\n$backend\n$installer"

echo "RELEASE_VERSION: ${RELEASE_VERSION}"
echo "DEV_VERSION: ${DEV_VERSION}"
echo "BUILD_DATE: ${BUILD_DATE}"