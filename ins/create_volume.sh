#!/bin/bash

DOCKER_VOLUME_NAME=li3ds_overlay_ws

docker volume create -d local $DOCKER_VOLUME_NAME

docker volume inspect $DOCKER_VOLUME_NAME