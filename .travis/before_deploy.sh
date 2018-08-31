#!/bin/bash

# Set an option to exit immediately if any error appears.
set -o errexit

# Setup release body message.
curl -s https://api.github.com/repos/ScottDay/DFN-Maintenance-GUI-Frontend/releases/latest | jq -r '.body' | cut -c 3- | (printf "# Frontend " && cat) > frontend.md
curl -s https://api.github.com/repos/ScottDay/DFN-Maintenance-GUI-Backend/releases/latest | jq -r '.body' | cut -c 3- | (printf "# Backend " && cat) > backend.md

export RELEASE_TAG="v$RELEASE_VERSION"
export RELEASE_BODY="$(cat frontend.md backend.md)"