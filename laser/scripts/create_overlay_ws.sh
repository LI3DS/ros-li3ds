#!/bin/bash

source bash_tools.sh

echo_c "${RED}Creator overlay_ws/src directory${NC}"
mkdir -p overlay_ws/src
cd overlay_ws/src

echo_c "Init WorkSpace"
wstool init

echo_c "Add repos to WorkSpace"

TUPLE_PACKAGES="(
			(ros_velodyne, 					git@github.com:yoyonel/ros_velodyne.git)
			(ros_velodyne_configuration,	git@github.com:yoyonel/ros_velodyne_configuration.git),
			(ros_rqt_li3ds,					git@bitbucket.org:ignli3ds/ros_rqt_li3ds.git)
			)"

USE_TUPLES_LIST "$TUPLE_PACKAGES" \
				'echo_c "- Add library $1 to the WorkSpace"' \
				'wstool set -y $1 --git $2'

echo_c "Download sources from repos"
wstool update

cd -
