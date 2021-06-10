// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module axi_dma #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
/*
    wire clk;
    wire rst;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire [31:0] rdata; 
    wire [31:0] wdata;
    wire [BITS-1:0] count;

    wire valid;
    wire ready;
    wire [3:0] wstrb;
    wire [31:0] la_write;

    // WB MI A
    assign valid = wbs_cyc_i && wbs_stb_i; 
    assign wstrb = wbs_sel_i & {4{wbs_we_i}};
    //assign wbs_dat_o = rdata;
    assign wdata = wbs_dat_i;

    // IO
    assign io_out = count;
    assign io_oeb = {(`MPRJ_IO_PADS-1){rst}};

    // IRQ
    assign irq = 3'b000;	// Unused

    // LA
    assign la_data_out = {{(127-BITS){1'b0}}, count};
    // Assuming LA probes [63:32] are for controlling the count register  
    assign la_write = ~la_oenb[63:32] & ~{BITS{valid}};
    // Assuming LA probes [65:64] are for controlling the count clk & reset  
    assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
    assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;

    counter #(
        .BITS(BITS)
    ) counter(
        .clk(clk),
        .reset(rst),
        .ready(ready),
        .valid(valid),
        .rdata(rdata),
        .wdata(wdata),
        .wstrb(wstrb),
        .la_write(la_write),
        .la_input(la_data_in[63:32]),
        .count(count)
    );
*/

DmaMem u_DmaMem(
    .io_ctrl_start           (io_oeb[22]    ), //i
    .io_ctrl_busy            (irq[1]        ), //o
    .io_ctrl_done            (irq[0]        ), //o
    .io_ctrl_halt            (io_oeb[23]    ), //i
    .io_sdram_ADDR           (io_oeb[12:0]  ), //o
    .io_sdram_BA             (io_oeb[14:13] ), //o
    .io_sdram_DQ_read        (io_in[15:0]   ), //i
    .io_sdram_DQ_write       (io_out[15:0]  ), //o
    .io_sdram_DQ_writeEnable (io_out[31:16] ), //o
    .io_sdram_DQM            (io_oeb[16:15] ), //o
    .io_sdram_CASn           (io_oeb[17]    ), //o
    .io_sdram_CKE            (io_oeb[18]    ), //o
    .io_sdram_CSn            (io_oeb[19]    ), //o
    .io_sdram_RASn           (io_oeb[20]    ), //o
    .io_sdram_WEn            (io_oeb[21]    ), //o
    .io_wb_CYC               (wbs_cyc_i     ), //i
    .io_wb_STB               (wbs_stb_i     ), //i
    .io_wb_ACK               (wbs_ack_o     ), //o
    .io_wb_WE                (wbs_we_i      ), //i
    .io_wb_ADR               (wbs_adr_i     ), //i
    .io_wb_DAT_MISO          (wbs_dat_o     ), //o
    .io_wb_DAT_MOSI          (wbs_dat_i     ), //i
    .io_wb_SEL               (wbs_sel_i     ), //i
    .clk                     (wb_clk_i      ), //i
    .reset                   (wb_rst_i      )  //i
);
/*
DmaMem u_DmaMem(
    .io_wb_CYC      (wbs_cyc_i),
    .io_wb_STB      (wbs_stb_i),
    .io_wb_ACK      (wbs_ack_o),
    .io_wb_WE       (wbs_we_i ),
    .io_wb_ADR      (wbs_adr_i),
    .io_wb_DAT_MISO (wbs_dat_o),
    .io_wb_DAT_MOSI (wbs_dat_i),
    .io_wb_SEL      (wbs_sel_i),
    .io_ctrl_start  (io_in[0] ),
    .io_ctrl_busy   (io_out[0]),
    .io_ctrl_done   (irq[0]   ),
    .io_ctrl_halt   (io_in[1] ),
    .clk            (wb_clk_i ),
    .reset          (wb_rst_i )
);
*/
endmodule
/*
module counter #(
    parameter BITS = 32
)(
    input clk,
    input reset,
    input valid,
    input [3:0] wstrb,
    input [BITS-1:0] wdata,
    input [BITS-1:0] la_write,
    input [BITS-1:0] la_input,
    output ready,
    output [BITS-1:0] rdata,
    output [BITS-1:0] count
);
    reg ready;
    reg [BITS-1:0] count;
    reg [BITS-1:0] rdata;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            ready <= 0;
        end else begin
            ready <= 1'b0;
            if (~|la_write) begin
                count <= count + 1;
            end
            if (valid && !ready) begin
                ready <= 1'b1;
                rdata <= count;
                if (wstrb[0]) count[7:0]   <= wdata[7:0];
                if (wstrb[1]) count[15:8]  <= wdata[15:8];
                if (wstrb[2]) count[23:16] <= wdata[23:16];
                if (wstrb[3]) count[31:24] <= wdata[31:24];
            end else if (|la_write) begin
                count <= la_write & la_input;
            end
        end
    end

endmodule
*/
`default_nettype wire
