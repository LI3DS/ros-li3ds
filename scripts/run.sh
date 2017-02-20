#!/bin/bash

source ./setenv.sh

echo "DOCKER_RUN_OPTIONS: $DOCKER_RUN_OPTIONS"
echo "DOCKER_BUILD_TAG: $DOCKER_BUILD_TAG"

# url: http://stackoverflow.com/questions/638975/how-do-i-tell-if-a-regular-file-does-not-exist-in-bash
if [ -f ./proxy.list ]; then
	# url: https://docs.docker.com/engine/reference/commandline/run/
	DOCKER_RUN_ENV_FILES="--env-file ./proxy.list"
else
	DOCKER_RUN_ENV_FILES=""
fi

# url: https://docs.docker.com/engine/tutorials/dockervolumes/
docker run                          		\
    $DOCKER_RUN_OPTIONS						\
    $DOCKER_RUN_ENV_FILES					\
    $DOCKER_BUILD_TAG						\
    $@
