FROM ros:foxy

ARG ROS_VERSION=foxy
ENV ROS_VERSION=$ROS_VERSION

RUN apt-get update && \
    apt-get upgrade -y && \
    # CI dependencies
    apt-get install --no-install-recommends --assume-yes \
    ccache \
    clang \
    lcov \
    libclang-dev \
    llvm-dev \
    # dev packages
    vim neovim git tmux curl man ssh iproute2 gdb cmake-gui cmake-curses-gui \
    psmisc htop wget sxiv rsync \
    python3-pip python3-setuptools \
    # indicated by rosdep-install
    ros-$ROS_VERSION-test-interface-files \
    ros-$ROS_VERSION-example-interfaces \
    && rm -rf /var/lib/apt/lists/*

# install rust dependencies ----------------------------------------------------
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.47.0
RUN set -ex && \
    wget -O rustup-init "https://sh.rustup.rs" && \
    chmod +x rustup-init && \
    ./rustup-init -y \
      --no-modify-path \
      --default-toolchain $RUST_VERSION && \
    rm rustup-init && \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME && \
    rustup --version && \
    cargo --version && \
    rustc --version;

# don't run as root ------------------------------------------------------------
ARG USERNAME
ARG UID
ARG GID
ARG HOME=/home/$USERNAME
ARG ROS_DIR=$HOME/ros_ws
ARG ROS2_RUST_DIR=$HOME/ros_ws/src/ros2_rust/ros2_rust
ENV HOME=$HOME
ENV ROS_DIR=$ROS_DIR
ENV ENTRYPOINT_PATH=$HOME/.entrypoint.sh

RUN groupadd -g $GID -o $USERNAME
RUN useradd \
    --create-home \
    --uid $UID \
    --gid $GID \
    --groups sudo \
    --password $(openssl passwd -1 $USERNAME) $USERNAME \
    --home-dir $HOME
RUN usermod -aG sudo $USERNAME
RUN echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME
RUN cat /etc/sudoers.d/$USERNAME

# vvvv Regular user vvvv -------------------------------------------------------

USER $USERNAME

# compile when connecting to the docker - on docker-run

# setup ROS workspace ----------------------------------------------------------
# add these as symbolic links so that we're able to edit them during the docker
# runtime
# TODO bashrc
RUN ln -s "$ROS2_RUST_DIR/dev/bashrc.local" $HOME/.bashrc.local
RUN ln -s "$ROS2_RUST_DIR/dev/entrypoint.sh" $HOME/.entrypoint.sh
RUN echo "source \$HOME/.bashrc.local" >> ~/.bashrc

RUN rosdep update

ENTRYPOINT $ENTRYPOINT_PATH
CMD ["bash"]
WORKDIR $ROS_DIR
