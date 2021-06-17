#! /bin/sh

set -o errexit
set -o nounset
set -o xtrace

sudo apt-get update
sudo apt-get install -y default-jdk iverilog verilator

# Add Spinal HDL CocotbLib
git submodule add https://github.com/SpinalHDL/CocotbLib.git SpinalNet/test/src/python/cocotblib
# Local install Cocotb and set PATH env
pip3 install cocotb
export PATH="$HOME/.local/bin:$PATH"

