#!/bin/bash

source ./setenv.sh

docker volume create 					\
	--driver 	$DOCKER_VOLUME_DRIVER 	\
	--name 		$DOCKER_VOLUME_NAME 

docker volume inspect $DOCKER_VOLUME_NAME 
