# AXI-DMA by Spinal HDL

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml)
[![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)


This is a DMA controller with AMBA AXI4 interface.
This DMA controller is part of an ongoing effort to build an SoC with the state-of-art open source hardware development kits, such as [Spinal HDL](https://github.com/SpinalHDL/SpinalHDL) and [cocotb](https://github.com/cocotb/cocotb).

## Spinal HDL

Spinal HDL is a very powerful hardware description language, which is especially suitable for SoC or FPGA.
Spinal HDL leverages many advanced language features from Scala, such as functional, object-oriented programming, to facilitate hardware development,
which overcomes many shortages of traditional HDL, e.g. Verilog and VHDL.
With Spinal HDL, the RTL code becomes much concise, error-prone, parameterized, and most important code-reuse friendly.

Spinal HDL will generate Verilog or VHDL code to be used in synthesis, since currently no synthesizer supports Spinal HDL.

## cocotb

cocotb is a Python-based simulation library, which supports many mainstream simulators, from `iverilog`, `veriator` to `ModelSim`, `VCS`, etc.
Since cocotb is implemented in Python, it's much easier than SystemVerilog or C to build a reference model by leveraging abundant libraries in Python ecosystem,
such as SciPy and NumPy for easy algorithm implementation, Scrapy for network communication, etc.
Also, implementing test bench in cocotb is quite concise, reduces much verbosity.


## AXI-DMA

This DMA controller is very flexible:
* multiple bus data width, e.g. 8, 16, 32, 64, as long as a valid AMBA AXI4 bus data width;
* unaligned read and write, w.r.t. data width, that if data width is 32 bits, the read or write address does not need to align to 4 bytes;
* burst read and write with varying burst length, as long as a valid AMBA AXI4 burst length;
* compatible to AMBA AXI4 4K boundary constraint, that burst read or write cannot cross 4K boundary;
* batch DMA task, that this DMA controller can conduct multiple DMA operations in a batch.

## SDRAM Controller

To ease debug this DMA controller, we also implemented an SDRAM controller with AMBA AXI4 interface.
The SDRAM controller assumes to store data in a Micron SDRAM `MT48LC16M16A2`, this Micron SDRAM has 16-bit data width.
This SDRAM controller is quite flexible too:
* multiple bus data width, e.g. 16, 32, 64, that the SDRAM controller converts AMBA AXI4 bus data with varying width into 16-bit width when read from or write to the Micron SDRAM, note 8-bit width not supported;
* burst read and write with varying burst length, not just fixed burst length;
* buffered bus read and write using two FIFO's before burst operation, because Micron SDRAM requires non-stop burst operation:
    - the burst write data from AMBA AXI4 interface will be buffered in a write FIFO first, and then write to SDRAM in a non-stop burst way;
    - the burst read data will be buffered in a read FIFO first, before send to AMBA AXI interface.

To test the SDRAM controller, Micron provided an SDRAM reference model in Verilog, we use cocotb to test SDRAM controller w.r.t. the SDRAM reference model.

## Code Structure

To compatible with Caravel user project, the Spinal HDL, cocotb code is seperated from Caravel user project code.

### Spinal HDL and cocotb Code

The Spinal HDL and cocotb code is located in [spinal-cocotb](./spinal-cocotb). Some important code files are:
* [DmaController.scala](./spinal-cocotb/SpinalNet/src/main/scala/dma/DmaController.scala) is the DMA controller implemented in Spinal HDL;
* [DmaMem.scala](./spinal-cocotb/SpinalNet/src/main/scala/dma/DmaMem.scala) is the top module that connect the DMA controller and the SDRAM controller;
* [DmaControllerSim.scala](./spinal-cocotb/SpinalNet/src/main/scala/sdram/DmaControllerSim.scala) is the DMA controller simulation implemented in Spinal HDL;
* [SdramController.scala](./spinal-cocotb/SpinalNet/src/main/scala/sdram/SdramController.scala) is the SDRAM controller implemented in Spinal HDL;
* [SdramControllerTest.py](./spinal-cocotb/SpinalNet/test/src/python/sdram/SdramControllerTest.py) is the SDRAM controller test bench implemented in cocotb.

To build and test the Spinal HDL code, there are two shell scripts:
* [setup.sh](./spinal-cocotb/setup.sh) is the script to install the dependent libraries;
* [run.sh](./spinal-cocotb/run.sh) is the script to build and run the Spinal HDL and cocotb code.

The `run.sh` script will generate the Verilog code, [DmaMem.v](./spinal-cocotb/DmaMem.v), used in Caravel user project for post processing.
`DmaMem.v` will be moved to the Verilog code directory of the Caravel user project.

### Caravel Code

The Caravel user project follows the code structure of the example project exactly. Some important code files are:
* [DmaMem.v](./verilog/rtl/DmaMem.v) is the Verilog code generated from `DmaMem.scala` by Spinal HDL;
* [axi_dma.v](./verilog/rtl/axi_dma.v) is the wrapper to `DmaMem.v`, and is instantiated in `user_project_wrapper.v`;
