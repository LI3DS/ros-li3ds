#!/bin/bash

docker run \
	--rm -it 								\
	-v li3ds_catkin_ws:/catkin_ws 			\
	-v li3ds_overlay_ws:/root/overlay_ws 	\
	-v $(realpath scripts):/root/scripts 	\
	li3ds/ins:latest 						\
	bash