#!/bin/bash

cd $ROS_CATKIN_WS/src

#################################################
# remove the symbolic link
#################################################
sed -i '' CMakeLists.txt

#################################################
# patch into CMakeLists.txt 
# to have all files availables in QtCreator IDE
#################################################
echo '

#################################################
# url: http://wiki.ros.org/IDEs#QtCreator
#################################################
# Add all files in subdirectories of the project in
# a dummy_target so qtcreator have access to all files
FILE(GLOB children ${CMAKE_SOURCE_DIR}/*)
FOREACH(child ${children})
  IF(IS_DIRECTORY ${child})
    file(GLOB_RECURSE dir_files "${child}/*")
    LIST(APPEND extra_files ${dir_files})
  ENDIF()
ENDFOREACH()
add_custom_target(dummy_${PROJECT_NAME} SOURCES ${extra_files})
#################################################
' >> CMakeLists.txt

#################################################
# Launch QtCreator IDE
#################################################
# qtcreator .

cd -
