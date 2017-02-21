#!/bin/bash
. ${LI3DS_ROOT_PATH}/scripts/create_overlay_ws.sh

##################################
#
##################################

# url: http://docs.ros.org/independent/api/rosdep/html/commands.html#rosdep-usage
rosdep install --from-paths ${ROS_OVERLAY_WS} --ignore-src --rosdistro indigo

mkdir -p $ROS_CATKIN_WS/src && pushd $ROS_CATKIN_WS

# url: http://stackoverflow.com/questions/59838/check-if-a-directory-exists-in-a-shell-script
if [ ! -d src ]; then
	catkin_init_workspace src;
	ln -s `eval echo $(dirs +1)` src/
else
	echo_c "${RED}'src/' already exist !${NC}";
fi

catkin_make
catkin_make install

popd