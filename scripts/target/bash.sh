#!/bin/bash

setup() {
    # Clone the develop branch.
    exec sed -i 's/master/develop/g' .gitmodules

    exec git submodule update --init --recursive --remote --merge DFN-Maintenance-GUI-Frontend
    eok "Cloned DFN-Maintenance-GUI-Frontend!"

    exec git submodule update --init --recursive --remote --merge DFN-Maintenance-GUI-Backend
    eok "Cloned DFN-Maintenance-GUI-Backend!"
}


build() {
    # Build the frontend.
    einfo "Building the frontend"

    cd DFN-Maintenance-GUI-Frontend
    exec npm --silent install
    eok "Finished npm install"

    exec npm --silent run build
    eok "Finished npm build"
    cd ..
    

    # Copy the projects build output to the build/ dir.
    einfo "Copying the projects build output to the build/ dir"
    
    exec mkdir -p build
    exec mkdir -p build/db
    exec cp -r DFN-Maintenance-GUI-Backend/gui.py build/
    exec cp -r DFN-Maintenance-GUI-Backend/requirements/prod.txt build/requirements.txt
    exec cp -r DFN-Maintenance-GUI-Backend/src build/src
    exec cp -r DFN-Maintenance-GUI-Backend/config build/config
    exec cp -r DFN-Maintenance-GUI-Frontend/dist build/dist
    exec cp -r DFN-Maintenance-GUI-Backend/db/dev.db build/db/
}


run() {
    # Run backend through Python.
    einfo "Running Flask backend"
    cd build
    exec gui.py --dev
}