#!/bin/bash

# Clone the develop branch.
sed -i 's/master/develop/g' .gitmodules

git submodule update --init --recursive --remote --merge DFN-Maintenance-GUI-Frontend
git submodule update --init --recursive --remote --merge DFN-Maintenance-GUI-Backend

# Build the source.
cd DFN-Maintenance-GUI-Frontend; npm install; npm run build; cd ..

# Copy the source over.
mkdir build
mkdir build/db
cp -r DFN-Maintenance-GUI-Backend/main.py build/
cp -r DFN-Maintenance-GUI-Backend/requirements/prod.txt build/requirements.txt
cp -r DFN-Maintenance-GUI-Backend/src build/src
cp -r DFN-Maintenance-GUI-Backend/config build/config
cp -r DFN-Maintenance-GUI-Frontend/dist build/dist

# Create and Copy the database.
cp -r DFN-Maintenance-GUI-Backend/db/dev.db build/db/

# Docker build.
docker build -f .docker/Dockerfile -t scottydevil/dfn-maintenance-gui:local-dev .

# Run docker container.
docker run -p 5000:5000 scottydevil/dfn-maintenance-gui:local-dev