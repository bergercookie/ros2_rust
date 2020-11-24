# configuration ----------------------------------------------------------------
define announce
	@echo "===================================================================="
	@echo $(1)
	@echo "===================================================================="
	@echo
endef

default: run

SHELL:=/bin/bash
THIS_FILE:=$(lastword $(MAKEFILE_LIST))
THIS_DIR:=$(dir $(abspath ${THIS_FILE}))
DOCKERFILE_DIR=${THIS_DIR}
ROS2_RUST_DIR=${THIS_DIR}/..
ROS_WS_DIR=${ROS2_RUST_DIR}/../../..
DOCKER_NAME:=ros2_rust
DOCKER_USER:=$(shell whoami)

# targets ----------------------------------------------------------------------
.PHONY: build
build:
	$(call announce,"Building container...")
	docker build ${DOCKERFILE_DIR} \
			--build-arg ROS_VERSION=foxy \
			--build-arg USERNAME=${DOCKER_USER} \
			--build-arg UID=$(shell id -u) \
			--build-arg GID=$(shell id -g) \
			-t ${DOCKER_NAME}

.PHONY: run
run: build
	$(call announce,"Starting the container...")
	docker run \
		--volume "${ROS_WS_DIR}":"/home/${DOCKER_USER}/ros_ws/" \
		--volume "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
		--volume ${HOME}/.bash_history:/home/${DOCKER_USER}/.bash_history \
		--network host  \
		--ipc=host \
		--privileged \
		--env DISPLAY=${DISPLAY} \
		--env=QT_X11_NO_MITSHM=1 \
		--rm -it --name ${DOCKER_NAME} ${DOCKER_NAME}

.PHONY: connect
connect:
	@# assuming that only one container of the said image is running
	$(eval container=$(shell docker ps -q --filter "name=${DOCKER_NAME}"))
	$(call announce,"Connecting to running container -> ${container}")
	docker exec -it ${container} ${SHELL}

.PHONY: purge
purge:
	-docker rmi -f ${DOCKER_NAME}
