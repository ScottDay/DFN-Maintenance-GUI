#!/bin/bash

# Set an option to exit immediately if any error appears.
set -o errexit

# Setup release body message.
frontend=$(curl -s https://api.github.com/repos/ScottDay/DFN-Maintenance-GUI-Frontend/releases/latest | jq -r '.body' | cut -c 3- | (printf "# Frontend " && cat))
backend=$(curl -s https://api.github.com/repos/ScottDay/DFN-Maintenance-GUI-Backend/releases/latest | jq -r '.body' | cut -c 3- | (printf "# Backend " && cat))
installer=$(curl -s https://api.github.com/repos/ScottDay/DFN-Maintenance-GUI-Installer/releases/latest | jq -r '.body' | cut -c 3- | (printf "# Installer " && cat))

export RELEASE_TAG="v$RELEASE_VERSION"
export RELEASE_BODY="$frontend\n$backend\n$installer"