#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

# Load the current commit image from cache
lzop -d $DOCKER_DIR/$IMAGE:$TRAVIS_COMMIT.lzo | docker load
