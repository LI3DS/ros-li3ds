#!/bin/bash
. ${LI3DS_ROOT_PATH}/scripts/create_overlay_ws.sh

##################################
#
##################################

# url: http://docs.ros.org/independent/api/rosdep/html/commands.html#rosdep-usage
rosdep install --from-paths ${ROS_OVERLAY_WS} --ignore-src --rosdistro indigo

pushd $ROS_CATKIN_WS

# url: http://stackoverflow.com/questions/59838/check-if-a-directory-exists-in-a-shell-script
if [ ! -d src ]; then
	mkdir -p $ROS_CATKIN_WS/src
	catkin_init_workspace src;
else
	echo_c "${YELLOW}'src/' already exist !${NC}";
fi

ln -s `eval echo $(dirs +1)` src/

catkin_make
catkin_make install

popd