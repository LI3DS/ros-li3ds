#!/bin/bash

if [ -f $ROS_CATKIN_WS/devel/setup.bash ]; then
	echo "source devel ..."
	source $ROS_CATKIN_WS/devel/setup.bash
fi
