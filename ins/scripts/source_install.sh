#!/bin/bash

if [ -f $ROS_CATKIN_WS/install/setup.bash ]; then
	#echo "source install ..."
	source $ROS_CATKIN_WS/install/setup.bash
    #source $ROS_CATKIN_WS/install/setup.zsh
fi
