#!/bin/bash

# urls:
# - https://www.mankier.com/1/wstool

# SETTINGS
TUPLE_PACKAGES="(
	(sbg_ros_driver,	https://github.com/yoyonel/sbg_ros_driver.git)
)"

ws_init_workspace() {
	echo_c "${CYAN}Init WorkSpace${NC}"
	if [ ! -f .rosinstall ]; then
		wstool init ;
	else
		echo_c "${YELLOW}.rosinstall already exist !${NC}"
	fi
}

ws_add_repo() {
	echo_c "${CYAN}Add repos to WorkSpace${NC}"
	
	USE_TUPLES_LIST "$TUPLE_PACKAGES" \
					'echo_c "${CYAN}- Add library ${BLUE}$1${CYAN} to the WorkSpace"${NC}' \
					'wstool set $1 --confirm --update --git $2'
	echo "PATH: $PWD"
	# wstool set sbg_ros_driver --git https://github.com/yoyonel/sbg_ros_driver.git
}

ws_update() {
	echo_c "${CYAN}Download sources from repos${NC}"
	#
	wstool update
}

source scripts/bash_tools.sh

echo_c "${GREEN}Create overlay_ws/src directory${NC}"
mkdir -p overlay_ws/src
cd overlay_ws/src

ws_init_workspace

ws_add_repo

ws_update

cd -