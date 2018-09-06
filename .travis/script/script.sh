#!/bin/bash

# Set an option to exit immediately if any error appears.
set -o errexit

# Build the source.
cd DFN-Maintenance-GUI-Frontend; npm install; npm run build; rm -rf node_modules; cd ..

# Copy the source over.
mkdir build
mkdir build/db
cp -r DFN-Maintenance-GUI-Backend/main.py build/
cp -r DFN-Maintenance-GUI-Backend/requirements/prod.txt build/requirements.txt
cp -r DFN-Maintenance-GUI-Backend/src build/src
cp -r DFN-Maintenance-GUI-Frontend/dist build/dist
cp -r DFN-Maintenance-GUI-Backend/config build/config
cp -r DFN-Maintenance-GUI-Config/config/. build/config/

# Copy database.
if [ "$REQUEST_TYPE" = "release" ]; then
    cp -r DFN-Maintenance-GUI-Config/db/auth.db build/db/
fi

cp -r DFN-Maintenance-GUI-Backend/db/dev.db build/db/

# Docker build.
#if [ "$REQUEST_TYPE" = "release" ]; then
#    docker build --squash --compress -t scottydevil/dfn-maintenance-gui:v$RELEASE_VERSION -t scottydevil/dfn-maintenance-gui:latest .
#fi

#docker build --squash --compress -f .docker/Dockerfile -t scottydevil/dfn-maintenance-gui:v$RELEASE_VERSION -t scottydevil/dfn-maintenance-gui:v$RELEASE_VERSION.$DEV_VERSION -t scottydevil/dfn-maintenance-gui:dev .