# url: https://github.com/osrf/docker_images/blob/d9efe4367b9d376fd97a154bdaba896ca0382645/docker/Makefile

.ONESHELL:
all: help

help:		## Show this help. (press tab to complete)
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

##-------------

clean:		## clean all (volumes, images, rosserial, arduino, ins)
clean: clean-volumes clean-images

clean-volumes: clean-rosserial-volumes clean-arduino-volumes clean-ins-volumes

clean-images: clean-rosserial-images clean-arduino-images clean-ins-images

clean-rosserial-volumes:
	(cd rosserial/latest; delete_volume.sh 2> /dev/null || true)

clean-arduino-volumes:
	(cd arduino; delete_volume.sh 2> /dev/null || true)

clean-ins-volumes:
	(cd ins; delete_volume.sh 2> /dev/null || true)
	
clean-arduino-images:
	(cd arduino; rmi.sh 2> /dev/null || true)

clean-rosserial-images:
	(cd rosserial/latest; rmi.sh 2> /dev/null || true)

clean-ins-images:
	(cd ins; rmi.sh 2> /dev/null || true)

##-------------

.ressources: .apt.conf .gitconfig .proxy.list
	@echo $@

.apt.conf:
	@(											\
		if [ -f /etc/apt/apt.conf ]; then		\
			cp /etc/apt/apt.conf ressources/.;	\
		else									\
			touch ressources/apt.conf;			\
		fi;										\
	)

.gitconfig:
	(											\
		if [ -f ~/.gitconfig ]; then			\
			cp ~/.gitconfig ressources/.;		\
		else									\
			touch ressources/.gitconfig;		\
		fi;										\
	)

# utiliser dans scripts/run.sh
.proxy.list:
	@(											\
		if [ ! -f ressources/proxy.list ]; then	\
			touch ressources/apt.conf;			\
		fi;										\
	)

##-------------

li3ds: li3ds-all
li3ds-all: ros rosserial arduino ins

##-------------

ros:	## ros for LI3DS [DEV]
ros: .ressources ros-all
ros-all:
	(cd ros; 										\
		cp ${LI3DS_RESSOURCES_PATH}/apt.conf .;		\
		cp ${LI3DS_RESSOURCES_PATH}/.gitconfig .;	\
		build.sh		 			\
	)

##-------------

rosserial:	## rosserial
rosserial: rosserial-all
rosserial-all: ros rosserial-volumes rosserial-images
	
rosserial-volumes:
	(cd rosserial/latest; create_volume.sh)

rosserial-images: rosserial-volumes
	(cd rosserial/latest; build.sh; run.sh )

##-------------
##| ARDUINO   |
##-------------
arduino:	## build all (volumes, images, build, (run))
arduino: arduino-all
arduino-all: rosserial arduino-volumes arduino-images	\
	arduino-configure		\
	arduino-build			\
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
	@(	echo; echo "Type 'source /opt/ros/indigo/setup.bash' to set env. vars"; echo; 	\
		docker exec -it rosnode_li3ds_arduino bash										\
	)

##-------------
##| INS       |
##-------------
ins:		## build all (volumes, images, build, (run))
ins: ins-all
ins-all: ros ins-volumes ins-images ins-build

ins-volumes:
	(cd ins; create_volume.sh)

ins-images:
	(cd ins; build.sh)

ins-build:
	(cd ins; run.sh 'bash -c "/root/build.sh"')

ins-run:
	@(	echo; echo "Type 'source entry-point.sh' to set env. vars"; echo; 	\
		docker exec -it rosnode_li3ds_ins bash								\
	)

##-------------
##| LASER     |
##-------------
laser:		## build all (volumes, images, build, (run))
laser: laser-all
laser-all: ros laser-volumes laser-images laser-build

laser-volumes:
	(cd laser; create_volume.sh)

laser-images:
	(cd laser; build.sh)

laser-build:
	(cd laser; run.sh 'bash -c "/root/build.sh"')

laser-run:
	@(	echo; echo "Type 'source entry-point.sh' to set env. vars"; echo; 	\
		docker exec -it rosnode_li3ds_laser bash								\
	)

