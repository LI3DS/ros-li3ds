#!/bin/bash

source /root/entry-point.sh

pushd ${LI3DS_ROOT_PATH}
./scripts/create_overlay_ws.sh
./scripts/get_and_build_with_catkin.sh
popd