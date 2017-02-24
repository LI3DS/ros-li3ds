# url: https://github.com/osrf/docker_images/blob/d9efe4367b9d376fd97a154bdaba896ca0382645/docker/Makefile

.ONESHELL:
all: help

help:       ## Show this help. (press tab to complete)
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

##-------------

clean:      ## clean all (volumes, images, rosserial, arduino, ins)
clean: clean-volumes clean-images

clean-images:               \
	clean-rosserial-images  \
	clean-arduino-images    \
	clean-ins-images

clean-volumes:              \
	clean-rosserial-volumes \
	clean-arduino-volumes   \
	clean-ins-volumes

clean-rosserial-images:
	(cd rosserial/latest; rmi.sh 2> /dev/null || true)
clean-rosserial-volumes:
	(cd rosserial/latest; delete_volume.sh 2> /dev/null || true)

clean-arduino-images:
	(cd arduino; rmi.sh 2> /dev/null || true)
clean-arduino-volumes:
	(cd arduino; delete_volume.sh 2> /dev/null || true)

clean-ins-images:
	(cd ins; rmi.sh 2> /dev/null || true)
clean-ins-volumes:
	(cd ins; delete_volume.sh 2> /dev/null || true)

clean-laser-volumes:
	(cd laser; rmi.sh 2> /dev/null || true)
clean-laser-images:
	(cd laser; delete_volume.sh 2> /dev/null || true)

##-------------

.ressources: .dir_ressources .apt.conf .gitconfig .proxy.list
	@echo $@

.dir_ressources:
	@(mkdir -p ressources)
.apt.conf:
	@(                                          \
		if [ -f /etc/apt/apt.conf ]; then       \
			cp /etc/apt/apt.conf ressources/.;  \
		else                                    \
			touch ressources/apt.conf;          \
		fi;                                     \
	)

.gitconfig:
	(                                           \
		if [ -f ~/.gitconfig ]; then            \
			cp ~/.gitconfig ressources/.;       \
		else                                    \
			touch ressources/.gitconfig;        \
		fi;                                     \
	)

# utiliser dans scripts/run.sh
.proxy.list:
	@(                                          \
		if [ ! -f ressources/proxy.list ]; then \
			touch ressources/apt.conf;          \
		fi;                                     \
	)

##-------------

li3ds: li3ds-all
# dev
# qtcreator
li3ds-all: ros 	\
	rosserial 	\
	arduino 	\
	ins 		\
	laser

##-------------

ros:    ## ros for LI3DS [DEV]
ros: .ressources ros-all
ros-all:
	(cd ros;                                        \
		cp ${LI3DS_RESSOURCES_PATH}/apt.conf .;     \
		cp ${LI3DS_RESSOURCES_PATH}/.gitconfig .;   \
		build.sh                    \
	)

##-------------

dev: dev-all
dev-all: ros dev-volumes dev-images

dev-volumes:
	(	\
		docker volume create --driver local --name li3ds_dev_overlay_ws;	\
		docker volume create --driver local --name li3ds_dev_catkin_ws		\
	)

dev-images:
	(cd dev; build.sh)

dev-run:
	(  echo; echo ""; echo;		\
		cd dev;			\
		xhost +;				\
		run.sh "bash"	\
	)

##-------------

qtcreator: qtcreator-all
qtcreator-all: dev qtcreator-images

qtcreator-images:
	(cd qtcreator; build.sh)

qtcreator-run:
	(  echo; echo ""; echo;		\
		cd qtcreator;			\
		xhost +;				\
		run.sh "zsh"			\
	)

##-------------

rosserial:  ## rosserial
rosserial: rosserial-all
rosserial-all: ros rosserial-volumes rosserial-images

# rosserial-all: dev rosserial-images
	
rosserial-volumes:
	(cd rosserial; create_volume.sh)

rosserial-images: rosserial-volumes
	(cd rosserial; build.sh; run.sh )
	# (cd rosserial/latest; build.sh; run.sh )

# rosserial-images:
# 	(cd rosserial; build.sh; run.sh )

##-------------
##| ARDUINO   |
##-------------
arduino:    ## build all (volumes, images, build, (run))
arduino: arduino-all
# arduino-all: rosserial arduino-volumes arduino-images
arduino-all: rosserial 		\
	arduino-images   		\
	arduino-configure       \
	arduino-build           \
	arduino-upload

arduino-images: rosserial-images
	(cd arduino; build.sh)

arduino-volumes: rosserial-volumes

arduino-clean:
	(cd arduino; run.sh 'bash -c "/root/clean.sh"')

arduino-configure:
	(cd arduino; run.sh 'bash -c "/root/configure.sh"')

arduino-build:
	(cd arduino; run.sh 'bash -c "/root/build.sh"')

arduino-upload:
	(cd arduino; run.sh 'bash -c "/root/upload.sh"')

arduino-run:
	@(  echo; echo "Type 'source /opt/ros/indigo/setup.bash' to set env. vars"; echo;   \
		docker exec -it rosnode_li3ds_arduino bash                                      \
	)

##-------------
##| INS       |
##-------------
ins:        ## build all (volumes, images, build, (run))
ins: ins-all
ins-all: ros ins-volumes ins-images ins-build
# ins-all: ros ins-images ins-build

ins-volumes:
	(cd ins; create_volume.sh)

ins-images:
	(cd ins; build.sh)

ins-build:
	(cd ins; run.sh 'bash -c "/root/build.sh"')

ins-run:
	@(  echo; echo "Type 'source entry-point.sh' to set env. vars"; echo;   \
		docker exec -it rosnode_li3ds_ins bash                              \
	)

##-------------
##| LASER     |
##-------------
laser:      ## build all (volumes, images, build, (run))
laser: laser-all
laser-all: ros laser-volumes laser-images laser-build
# laser-all: ros laser-images laser-build

laser-volumes:
	(cd laser; create_volume.sh)

laser-images:
	(cd laser; build.sh)

laser-build:
	(cd laser; run.sh 'bash -c "/root/build.sh"')

laser-run:
	@(  echo; echo "Type 'source entry-point.sh' to set env. vars"; echo;   \
		docker exec -it rosnode_li3ds_laser bash                                \
	)