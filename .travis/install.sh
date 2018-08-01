#!/bin/bash

# Set an option to exit immediately if any error appears
set -o errexit

# Main function that describes the behavior of the script. 
# By making it a function we can place our methods below 
# and have the main execution described in a concise way 
# via function invocations.
main() {
    clone_submodules
    update_docker_configuration

    echo "SUCCESS:
    Done! Finished setting up the Travis machine.
    "
}

# Prepare the dependencies that the machine need.
# Add GitHub Application Token into each submodule HTTPS 
# URL and then clone. Allows local cloning outside of Travis.
# We also upgrade `docker-ce` so that we can get the
# latest docker version which allows us to perform
# image squashing as well as multi-stage builds.
clone_submodules() {
    echo "INFO:
    Setting up git submodules.
    "

    sed -i 's/github/'"$TRAVIS_CI_TOKEN"'@github/g' .gitmodules

    if [[ "$REQUEST_TYPE" == "dev" ]]; then
        sed -i 's/master/develop/g' .gitmodules
    fi

    git submodule update --init --recursive --remote --merge
}

# Tweak the daemon configuration so that we
# can make use of experimental features (like image
# squashing) as well as have a bigger amount of
# concurrent downloads and uploads.
update_docker_configuration() {
    echo "INFO:
    Updating docker configuration
    "

    echo '{
    "experimental": true,
    "storage-driver": "overlay2",
    "max-concurrent-downloads": 50,
    "max-concurrent-uploads": 50
    }' | sudo tee /etc/docker/daemon.json
    sudo service docker restart
}

main