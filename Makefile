# url: https://github.com/osrf/docker_images/blob/d9efe4367b9d376fd97a154bdaba896ca0382645/docker/Makefile

.ONESHELL:
all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make arduino               - clean, configure, build and upload arduino project"
	@echo "   2. make arduino-clean         - clean arduino build project"
	@echo "   3. make arduino-configure     - configure arduino project"
	@echo "   4. make arduino-build         - build arduino project"
	@echo "   5. make arduino-upload        - upload arduino project"
	@echo ""

arduino: arduino-all

arduino-all: arduino-clean	\
	arduino-configure		\
	arduino-build			\
	arduino-upload

arduino-clean:
	(cd arduino; run.sh 'bash -c "/root/clean.sh"')

arduino-configure:
	(cd arduino; run.sh 'bash -c "/root/configure.sh"')

arduino-build:
	(cd arduino; run.sh 'bash -c "/root/build.sh"')

arduino-upload:
	(cd arduino; run.sh 'bash -c "/root/upload.sh"')