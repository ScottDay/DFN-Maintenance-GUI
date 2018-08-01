#!/bin/bash

# Set an option to exit immediately if any error appears
set -o errexit

# Persist environment variables.
sed -i -e "s/RELEASE_VERSION=.*/RELEASE_VERSION=${RELEASE_VERSION}/" .env
sed -i -e "s/DEV_VERSION=.*/DEV_VERSION=${DEV_VERSION}/" .env
sed -i -e "s/BUILD_DATE=.*/BUILD_DATE=${BUILD_DATE}/" .env