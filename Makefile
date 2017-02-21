# url: https://github.com/osrf/docker_images/blob/d9efe4367b9d376fd97a154bdaba896ca0382645/docker/Makefile

.ONESHELL:
all: help

help:		## Show this help. (press tab to complete)
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

##-------------

clean:		## clean all (volumes, images, rosserial, arduino, ins)
clean: clean-volumes clean-images

clean-volumes: clean-rosserial-volumes clean-arduino-volumes

clean-images: clean-rosserial-images clean-arduino-images

clean-rosserial-volumes:
	(cd rosserial/latest; delete_volume.sh 2> /dev/null || true)

clean-arduino-volumes:
	(cd arduino; delete_volume.sh 2> /dev/null | true)

clean-arduino-images:
	(cd arduino; rmi.sh 2> /dev/null || true)

clean-rosserial-images:
	(cd rosserial/latest; rmi.sh 2> /dev/null || true)

##-------------

rosserial:	## rosserial
rosserial: rosserial-all
rosserial-all: rosserial-volumes rosserial-images
	
rosserial-volumes:
	(cd rosserial/latest; create_volume.sh)

rosserial-images: rosserial-volumes
	(cd rosserial/latest; 			\
		if [ -f apt.conf ]; then 	\
			touch apt.conf; 		\
		fi; 						\
		build.sh; run.sh 			\
	)

##-------------
##| ARDUINO   |
##-------------
arduino:	## build all (volumes, images, build, (run))
arduino: arduino-all
arduino-all: arduino-volumes arduino-images	\
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
ins-all: ins-volumes ins-images ins-build

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