#!/bin/bash
set -ex

function announce() {
  echo "================================================================================"
  echo $@
  echo "================================================================================"
}

# setup ros environment
source "$HOME/.bashrc.local"

# Compile the ROS workspace ----------------------------------------------------
announce "Compiling Workspace packages..."
# compile_ws

/bin/bash
