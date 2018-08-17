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

    git config --global user.email "17160182@student.curtin.edu.au"
    git config --global user.name "ScottDay"
    git config --global push.default matching

    # Get the credentials from a file
    git config credential.helper "store --file=.git/credentials"

    # This associates the API Key with the account
    echo "https://${TRAVIS_CI_TOKEN}:@github.com" > .git/credentials


    sed -i 's/github/'"$TRAVIS_CI_TOKEN"'@github/g' .gitmodules

    if [[ "$REQUEST_TYPE" == "release" ]]; then
        sed -i 's/develop/master/g' .gitmodules
    else   
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