#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

# Create docker directory
mkdir -p $DOCKER_DIR
# Run the build with cache if it exists
docker build --rm=false --cache-from $IMAGE:$TRAVIS_BRANCH -t $IMAGE:$TRAVIS_COMMIT .
# Save the base branch image if it doesn't exist yet
if [[ ! -e $DOCKER_DIR/$IMAGE:$TRAVIS_BRANCH.lzo ]];
    then docker tag $IMAGE:$TRAVIS_COMMIT $IMAGE:$TRAVIS_BRANCH;
    docker save $IMAGE:$TRAVIS_BRANCH | lzop -1 > $DOCKER_DIR/$IMAGE:$TRAVIS_BRANCH.lzo;
fi
# Save the current commit image for following stages
docker save $IMAGE:$TRAVIS_COMMIT | lzop -1 > $DOCKER_DIR/$IMAGE:$TRAVIS_COMMIT.lzo
