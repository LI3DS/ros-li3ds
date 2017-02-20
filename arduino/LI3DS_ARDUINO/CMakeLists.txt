#cmake_minimum_required(VERSION 3.2)
cmake_minimum_required(VERSION 2.8)


set(ARDUINO_DEFAULT_BOARD diecimila) # Default Board ID, when not specified
set(ARDUINO_DEFAULT_PORT /dev/ttyACM0) # Default Port, when not specified


#SET(PATH_TO_ROS_LIB /root/ros_lib)
SET(PATH_TO_ROS_LIB /catkin_ws/ros_lib)

link_directories(${PATH_TO_ROS_LIB})
INCLUDE_DIRECTORIES(${PATH_TO_ROS_LIB})

#====================================================================#
# 
#====================================================================#

set(BLINK_SKETCH "src/li3ds_arduino.ino")

generate_arduino_firmware(LI3DS_ARDUINO
    SKETCH "${BLINK_SKETCH}"
    PORT  /dev/ttyACM0
    SERIAL picocom @SERIAL_PORT@
    BOARD uno)


#################################################
# url: http://wiki.ros.org/IDEs#QtCreator
#################################################
# Add all files in subdirectories of the project in
# a dummy_target so qtcreator have access to all files
FILE(GLOB children ${CMAKE_SOURCE_DIR}/src)
FOREACH(child ${children})
  IF(IS_DIRECTORY ${child})
    file(GLOB_RECURSE dir_files "${child}/*")
    LIST(APPEND extra_files ${dir_files})
  ENDIF()
ENDFOREACH()
add_custom_target(dummy_${PROJECT_NAME} SOURCES ${extra_files})
#################################################
