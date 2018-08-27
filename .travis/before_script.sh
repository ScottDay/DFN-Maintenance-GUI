#!/bin/bash

# Set an option to exit immediately if any error appears.
set -o errexit

source .env # Load up environment variables.

if [ "$REQUEST_TYPE" = "release" ]; then
    export RELEASE_VERSION=$(($RELEASE_VERSION+1)) # Increment release version.
    export DEV_VERSION=$((0)) # Reset dev version.
else
    export RELEASE_VERSION=$(($RELEASE_VERSION))
    export DEV_VERSION=$(($DEV_VERSION+1)) # Increment dev version.
fi

export BUILD_DATE=$(date +%d-%m-%Y) # Current date.

echo "RELEASE_VERSION: ${RELEASE_VERSION}"
echo "DEV_VERSION: ${DEV_VERSION}"
echo "BUILD_DATE: ${BUILD_DATE}"

# Setup release body message.
curl -s https://api.github.com/repos/ScottDay/DFN-Maintenance-GUI-Frontend/releases/latest | jq -r '.body' | cut -c 3- | (printf "# Frontend " && cat) > frontend.txt
curl -s https://api.github.com/repos/ScottDay/DFN-Maintenance-GUI-Backend/releases/latest | jq -r '.body' | (printf "# Backend\n\n" && cat) > backend.txt

export RELEASE_BODY="$(cat frontend.txt backend.txt)"