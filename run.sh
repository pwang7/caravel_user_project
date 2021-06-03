#! /bin/sh
set -o errexit
set -o nounset
set -o xtrace

make install

export PROJ_HOME=`pwd`
export OPENLANE_ROOT=`realpath $PROJ_HOME/../openlane`
export OPENLANE_TAG="v0.17"

#make simenv
export PDK_ROOT=$OPENLANE_ROOT/pdks
export CARAVEL_ROOT=$PROJ_HOME/caravel
# specify simulation mode: RTL/GL
export SIM=RTL
# Run IO ports testbench
#make verify-io_ports

export PRECHECK_ROOT=$PROJ_HOME/precheck
export TARGET_PATH=$PROJ_HOME
# Install precheck
#make precheck
#make run-precheck
#$PRECHECK_ROOT/docker-mount.sh
#docker run -v $PRECHECK_ROOT:/usr/local/bin -v $TARGET_PATH:$TARGET_PATH \
#    -v $PDK_ROOT:$PDK_ROOT -v $CARAVEL_ROOT:$CARAVEL_ROOT \
#    -u `id -u $USER`:`id -g $USER` \
#    -e PDK_ROOT=$PDK_ROOT -e TARGET_PATH=$TARGET_PATH -e CARAVEL_ROOT=$CARAVEL_ROOT \
#    efabless/open_mpw_precheck:latest \
#    /bin/bash -c "python3 open_mpw_prechecker.py --pdk_root $PDK_ROOT --target_path $TARGET_PATH -rfc -c $CARAVEL_ROOT"


make axi_dma
make user_project_wrapper
