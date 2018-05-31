#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

# Load the current branch image from cache if available
if [[ -e $DOCKER_DIR/$IMAGE:$TRAVIS_BRANCH.lzo ]];
    then lzop -d $DOCKER_DIR/$IMAGE:$TRAVIS_BRANCH.lzo | docker load;
fi
