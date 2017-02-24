# DEV

FROM li3ds/qtcreator

USER root

ENV HOME /root
ENV LI3DS_ROOT_PATH /root
ENV ROS_OVERLAY_WS="/root/overlay_ws"
ENV ROS_CATKIN_WS="/root/catkin_ws"

# Build our catkin workspace from the /catkin_ws directory
WORKDIR /root

RUN mkdir -p /catkin_ws

#
COPY scripts /root/scripts
RUN chmod +x /root/scripts/*.sh

#### Gere les dépendances ROS/APT du projet ####
RUN /bin/bash -c "source scripts/create_overlay_ws.sh"
# SHELL ["scripts/create_overlay_ws.sh"]

WORKDIR overlay_ws

RUN /bin/bash -c "source /opt/ros/indigo/setup.bash"

# urls: 
# - http://docs.ros.org/independent/api/rosdep/html/commands.html#rosdep-usage
# - http://docs.ros.org/independent/api/rosdep/html/commands.html#options
RUN rosdep install --default-yes --from-paths ${ROS_OVERLAY_WS} --ignore-src --rosdistro indigo
####

WORKDIR /root/

# ENTRYPOINT ["/root/entry-point.sh"]
# CMD ["bash"]