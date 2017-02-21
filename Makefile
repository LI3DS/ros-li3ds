# url: https://github.com/osrf/docker_images/blob/d9efe4367b9d376fd97a154bdaba896ca0382645/docker/Makefile

.ONESHELL:
all: help

help:           		## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

clean:				## clean all
clean: clean-volumes clean-images

clean-volumes:			## clean all docker volumes
clean-volumes: clean-rosserial-volumes clean-arduino-volumes

clean-images:			## clean all docker images
clean-images: clean-rosserial-images clean-arduino-images

clean-rosserial-volumes:	## clean rosserial volumes ('')
clean-rosserial-volumes:
	(cd rosserial/latest; delete_volume.sh 2> /dev/null || true)

clean-arduino-volumes:
	(cd arduino; delete_volume.sh 2> /dev/null | true)

clean-arduino-images:
	(cd arduino; rmi.sh 2> /dev/null || true)

clean-rosserial-images:
	(cd rosserial/latest; rmi.sh 2> /dev/null || true)

rosserial: rosserial-all
rosserial-all: rosserial-volumes rosserial-images
	
rosserial-volumes:
	(cd rosserial/latest; create_volume.sh)

rosserial-images: rosserial-volumes
	(cd rosserial/latest; \
		if [ ! -f apt.conf ]; then
			touch apt.conf
		fi;	\
		build.sh;	\
		run.sh)

arduino: arduino-all
arduino-all: arduino-volumes arduino-images	\
	arduino-clean			\
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

ins-images:
	(cd ins
	