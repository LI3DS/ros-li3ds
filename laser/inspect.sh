#!/bin/bash

docker run \
	--net=host \
	--rm -it 								\
	-v li3ds_catkin_ws:/catkin_ws 			\
	-v li3ds_laser_overlay_ws:/root/overlay_ws 	\
	-v $(realpath scripts):/root/scripts 	\
	-p 127.0.0.1:2368:2368/udp					\
	-p 127.0.0.1:8308:8308/udp					\
	li3ds/laser:latest 						\
	bash