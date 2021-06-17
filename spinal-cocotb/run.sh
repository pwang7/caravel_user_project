#! /bin/sh

set -o errexit
set -o nounset
set -o xtrace

MILL_VERSION=0.9.7

if [ ! -f mill ]; then
  curl -L https://github.com/com-lihaoyi/mill/releases/download/$MILL_VERSION/$MILL_VERSION > mill && chmod +x mill
fi

./mill version

# Check format
./mill SpinalNet.checkFormat
./mill SpinalNet.fix --check


# Run test and simulation
./mill SpinalNet.test.testOnly dma.DmaControllerTest
./mill SpinalNet.test.testOnly sdram.SdramControllerTest
./mill SpinalNet.test.testOnly udp.UdpTest

# Generate Verilog code for Caravel
./mill SpinalNet.runMain dma.DmaMem

