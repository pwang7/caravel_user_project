// Generator : SpinalHDL v1.4.3    git head : 4dd3b62906925bc269aee976e75f8918d4132efb
// Component : DmaMem
// Git hash  : 56966e3bef1799ddcd271cea346e841ca3728d43


`define fsmR_enumDefinition_binary_sequential_type [2:0]
`define fsmR_enumDefinition_binary_sequential_fsmR_BOOT 3'b000
`define fsmR_enumDefinition_binary_sequential_fsmR_IDLE 3'b001
`define fsmR_enumDefinition_binary_sequential_fsmR_AR 3'b010
`define fsmR_enumDefinition_binary_sequential_fsmR_FR 3'b011
`define fsmR_enumDefinition_binary_sequential_fsmR_BR 3'b100
`define fsmR_enumDefinition_binary_sequential_fsmR_LAST 3'b101

`define fsmW_enumDefinition_binary_sequential_type [2:0]
`define fsmW_enumDefinition_binary_sequential_fsmW_BOOT 3'b000
`define fsmW_enumDefinition_binary_sequential_fsmW_IDLE 3'b001
`define fsmW_enumDefinition_binary_sequential_fsmW_W 3'b010
`define fsmW_enumDefinition_binary_sequential_fsmW_LAST 3'b011
`define fsmW_enumDefinition_binary_sequential_fsmW_B 3'b100


module DmaMem (
  input               io_wb_CYC,
  input               io_wb_STB,
  output              io_wb_ACK,
  input               io_wb_WE,
  input      [31:0]   io_wb_ADR,
  output     [31:0]   io_wb_DAT_MISO,
  input      [31:0]   io_wb_DAT_MOSI,
  input      [3:0]    io_wb_SEL,
  input               io_ctrl_start,
  output              io_ctrl_busy,
  output              io_ctrl_done,
  input               io_ctrl_halt,
  input               clk,
  input               reset
);
  wire                _zz_1;
  wire       [31:0]   _zz_2;
  wire       [31:0]   _zz_3;
  wire       [7:0]    _zz_4;
  wire       [7:0]    _zz_5;
  wire       [7:0]    _zz_6;
  wire       [7:0]    _zz_7;
  wire       [31:0]   _zz_8;
  wire                _zz_9;
  wire                _zz_10;
  wire                mem_io_axi_arw_ready;
  wire                mem_io_axi_w_ready;
  wire                mem_io_axi_b_valid;
  wire       [3:0]    mem_io_axi_b_payload_id;
  wire       [1:0]    mem_io_axi_b_payload_resp;
  wire                mem_io_axi_r_valid;
  wire       [31:0]   mem_io_axi_r_payload_data;
  wire       [3:0]    mem_io_axi_r_payload_id;
  wire       [1:0]    mem_io_axi_r_payload_resp;
  wire                mem_io_axi_r_payload_last;
  wire       [31:0]   mem_io_wb_DAT_MISO;
  wire                mem_io_wb_ACK;
  wire                dmaArea_dma_io_axi_ar_valid;
  wire       [31:0]   dmaArea_dma_io_axi_ar_payload_addr;
  wire       [3:0]    dmaArea_dma_io_axi_ar_payload_id;
  wire       [7:0]    dmaArea_dma_io_axi_ar_payload_len;
  wire       [2:0]    dmaArea_dma_io_axi_ar_payload_size;
  wire       [1:0]    dmaArea_dma_io_axi_ar_payload_burst;
  wire                dmaArea_dma_io_axi_aw_valid;
  wire       [31:0]   dmaArea_dma_io_axi_aw_payload_addr;
  wire       [3:0]    dmaArea_dma_io_axi_aw_payload_id;
  wire       [7:0]    dmaArea_dma_io_axi_aw_payload_len;
  wire       [2:0]    dmaArea_dma_io_axi_aw_payload_size;
  wire       [1:0]    dmaArea_dma_io_axi_aw_payload_burst;
  wire                dmaArea_dma_io_axi_w_valid;
  wire       [31:0]   dmaArea_dma_io_axi_w_payload_data;
  wire       [3:0]    dmaArea_dma_io_axi_w_payload_strb;
  wire                dmaArea_dma_io_axi_w_payload_last;
  wire                dmaArea_dma_io_axi_r_ready;
  wire                dmaArea_dma_io_axi_b_ready;
  wire                dmaArea_dma_io_ctrl_busy;
  wire                dmaArea_dma_io_ctrl_done;
  wire                streamArbiter_1_io_inputs_0_ready;
  wire                streamArbiter_1_io_inputs_1_ready;
  wire                streamArbiter_1_io_output_valid;
  wire       [31:0]   streamArbiter_1_io_output_payload_addr;
  wire       [3:0]    streamArbiter_1_io_output_payload_id;
  wire       [7:0]    streamArbiter_1_io_output_payload_len;
  wire       [2:0]    streamArbiter_1_io_output_payload_size;
  wire       [1:0]    streamArbiter_1_io_output_payload_burst;
  wire       [0:0]    streamArbiter_1_io_chosen;
  wire       [1:0]    streamArbiter_1_io_chosenOH;
  wire                wishbone_CYC;
  wire                wishbone_STB;
  wire                wishbone_ACK;
  wire                wishbone_WE;
  wire       [31:0]   wishbone_ADR;
  wire       [31:0]   wishbone_DAT_MISO;
  wire       [31:0]   wishbone_DAT_MOSI;
  wire       [3:0]    wishbone_SEL;
  wire                wbEmpty_CYC;
  wire                wbEmpty_STB;
  wire                wbEmpty_ACK;
  wire                wbEmpty_WE;
  wire       [31:0]   wbEmpty_ADR;
  wire       [31:0]   wbEmpty_DAT_MISO;
  wire       [31:0]   wbEmpty_DAT_MOSI;
  wire       [3:0]    wbEmpty_SEL;
  reg                 busif_readError;
  reg        [31:0]   busif_readData;
  wire                busif_selMatch;
  wire                busif_askWrite;
  wire                busif_askRead;
  wire                busif_doWrite;
  wire                busif_doRead;
  wire       [31:0]   srcAddr;
  wire       [31:0]   dstAddr;

  Axi4SharedWishboneOnChipRam mem (
    .io_axi_arw_valid            (streamArbiter_1_io_output_valid               ), //i
    .io_axi_arw_ready            (mem_io_axi_arw_ready                          ), //o
    .io_axi_arw_payload_addr     (streamArbiter_1_io_output_payload_addr[31:0]  ), //i
    .io_axi_arw_payload_id       (streamArbiter_1_io_output_payload_id[3:0]     ), //i
    .io_axi_arw_payload_len      (streamArbiter_1_io_output_payload_len[7:0]    ), //i
    .io_axi_arw_payload_size     (streamArbiter_1_io_output_payload_size[2:0]   ), //i
    .io_axi_arw_payload_burst    (streamArbiter_1_io_output_payload_burst[1:0]  ), //i
    .io_axi_arw_payload_write    (_zz_1                                         ), //i
    .io_axi_w_valid              (dmaArea_dma_io_axi_w_valid                    ), //i
    .io_axi_w_ready              (mem_io_axi_w_ready                            ), //o
    .io_axi_w_payload_data       (dmaArea_dma_io_axi_w_payload_data[31:0]       ), //i
    .io_axi_w_payload_strb       (dmaArea_dma_io_axi_w_payload_strb[3:0]        ), //i
    .io_axi_w_payload_last       (dmaArea_dma_io_axi_w_payload_last             ), //i
    .io_axi_b_valid              (mem_io_axi_b_valid                            ), //o
    .io_axi_b_ready              (dmaArea_dma_io_axi_b_ready                    ), //i
    .io_axi_b_payload_id         (mem_io_axi_b_payload_id[3:0]                  ), //o
    .io_axi_b_payload_resp       (mem_io_axi_b_payload_resp[1:0]                ), //o
    .io_axi_r_valid              (mem_io_axi_r_valid                            ), //o
    .io_axi_r_ready              (dmaArea_dma_io_axi_r_ready                    ), //i
    .io_axi_r_payload_data       (mem_io_axi_r_payload_data[31:0]               ), //o
    .io_axi_r_payload_id         (mem_io_axi_r_payload_id[3:0]                  ), //o
    .io_axi_r_payload_resp       (mem_io_axi_r_payload_resp[1:0]                ), //o
    .io_axi_r_payload_last       (mem_io_axi_r_payload_last                     ), //o
    .io_wb_CYC                   (io_wb_CYC                                     ), //i
    .io_wb_STB                   (io_wb_STB                                     ), //i
    .io_wb_ACK                   (mem_io_wb_ACK                                 ), //o
    .io_wb_WE                    (io_wb_WE                                      ), //i
    .io_wb_ADR                   (io_wb_ADR[31:0]                               ), //i
    .io_wb_DAT_MISO              (mem_io_wb_DAT_MISO[31:0]                      ), //o
    .io_wb_DAT_MOSI              (io_wb_DAT_MOSI[31:0]                          ), //i
    .io_wb_SEL                   (io_wb_SEL[3:0]                                ), //i
    .clk                         (clk                                           ), //i
    .reset                       (reset                                         )  //i
  );
  Dma dmaArea_dma (
    .io_param_sar               (_zz_2[31:0]                               ), //i
    .io_param_dar               (_zz_3[31:0]                               ), //i
    .io_param_xsize             (_zz_4[7:0]                                ), //i
    .io_param_ysize             (_zz_5[7:0]                                ), //i
    .io_param_srcystep          (_zz_6[7:0]                                ), //i
    .io_param_dstystep          (_zz_7[7:0]                                ), //i
    .io_param_llr               (_zz_8[31:0]                               ), //i
    .io_param_bf                (_zz_9                                     ), //i
    .io_param_cf                (_zz_10                                    ), //i
    .io_axi_aw_valid            (dmaArea_dma_io_axi_aw_valid               ), //o
    .io_axi_aw_ready            (streamArbiter_1_io_inputs_1_ready         ), //i
    .io_axi_aw_payload_addr     (dmaArea_dma_io_axi_aw_payload_addr[31:0]  ), //o
    .io_axi_aw_payload_id       (dmaArea_dma_io_axi_aw_payload_id[3:0]     ), //o
    .io_axi_aw_payload_len      (dmaArea_dma_io_axi_aw_payload_len[7:0]    ), //o
    .io_axi_aw_payload_size     (dmaArea_dma_io_axi_aw_payload_size[2:0]   ), //o
    .io_axi_aw_payload_burst    (dmaArea_dma_io_axi_aw_payload_burst[1:0]  ), //o
    .io_axi_w_valid             (dmaArea_dma_io_axi_w_valid                ), //o
    .io_axi_w_ready             (mem_io_axi_w_ready                        ), //i
    .io_axi_w_payload_data      (dmaArea_dma_io_axi_w_payload_data[31:0]   ), //o
    .io_axi_w_payload_strb      (dmaArea_dma_io_axi_w_payload_strb[3:0]    ), //o
    .io_axi_w_payload_last      (dmaArea_dma_io_axi_w_payload_last         ), //o
    .io_axi_b_valid             (mem_io_axi_b_valid                        ), //i
    .io_axi_b_ready             (dmaArea_dma_io_axi_b_ready                ), //o
    .io_axi_b_payload_id        (mem_io_axi_b_payload_id[3:0]              ), //i
    .io_axi_b_payload_resp      (mem_io_axi_b_payload_resp[1:0]            ), //i
    .io_axi_ar_valid            (dmaArea_dma_io_axi_ar_valid               ), //o
    .io_axi_ar_ready            (streamArbiter_1_io_inputs_0_ready         ), //i
    .io_axi_ar_payload_addr     (dmaArea_dma_io_axi_ar_payload_addr[31:0]  ), //o
    .io_axi_ar_payload_id       (dmaArea_dma_io_axi_ar_payload_id[3:0]     ), //o
    .io_axi_ar_payload_len      (dmaArea_dma_io_axi_ar_payload_len[7:0]    ), //o
    .io_axi_ar_payload_size     (dmaArea_dma_io_axi_ar_payload_size[2:0]   ), //o
    .io_axi_ar_payload_burst    (dmaArea_dma_io_axi_ar_payload_burst[1:0]  ), //o
    .io_axi_r_valid             (mem_io_axi_r_valid                        ), //i
    .io_axi_r_ready             (dmaArea_dma_io_axi_r_ready                ), //o
    .io_axi_r_payload_data      (mem_io_axi_r_payload_data[31:0]           ), //i
    .io_axi_r_payload_id        (mem_io_axi_r_payload_id[3:0]              ), //i
    .io_axi_r_payload_resp      (mem_io_axi_r_payload_resp[1:0]            ), //i
    .io_axi_r_payload_last      (mem_io_axi_r_payload_last                 ), //i
    .io_ctrl_start              (io_ctrl_start                             ), //i
    .io_ctrl_busy               (dmaArea_dma_io_ctrl_busy                  ), //o
    .io_ctrl_done               (dmaArea_dma_io_ctrl_done                  ), //o
    .io_ctrl_halt               (io_ctrl_halt                              ), //i
    .clk                        (clk                                       ), //i
    .reset                      (reset                                     )  //i
  );
  StreamArbiter streamArbiter_1 (
    .io_inputs_0_valid            (dmaArea_dma_io_axi_ar_valid                   ), //i
    .io_inputs_0_ready            (streamArbiter_1_io_inputs_0_ready             ), //o
    .io_inputs_0_payload_addr     (dmaArea_dma_io_axi_ar_payload_addr[31:0]      ), //i
    .io_inputs_0_payload_id       (dmaArea_dma_io_axi_ar_payload_id[3:0]         ), //i
    .io_inputs_0_payload_len      (dmaArea_dma_io_axi_ar_payload_len[7:0]        ), //i
    .io_inputs_0_payload_size     (dmaArea_dma_io_axi_ar_payload_size[2:0]       ), //i
    .io_inputs_0_payload_burst    (dmaArea_dma_io_axi_ar_payload_burst[1:0]      ), //i
    .io_inputs_1_valid            (dmaArea_dma_io_axi_aw_valid                   ), //i
    .io_inputs_1_ready            (streamArbiter_1_io_inputs_1_ready             ), //o
    .io_inputs_1_payload_addr     (dmaArea_dma_io_axi_aw_payload_addr[31:0]      ), //i
    .io_inputs_1_payload_id       (dmaArea_dma_io_axi_aw_payload_id[3:0]         ), //i
    .io_inputs_1_payload_len      (dmaArea_dma_io_axi_aw_payload_len[7:0]        ), //i
    .io_inputs_1_payload_size     (dmaArea_dma_io_axi_aw_payload_size[2:0]       ), //i
    .io_inputs_1_payload_burst    (dmaArea_dma_io_axi_aw_payload_burst[1:0]      ), //i
    .io_output_valid              (streamArbiter_1_io_output_valid               ), //o
    .io_output_ready              (mem_io_axi_arw_ready                          ), //i
    .io_output_payload_addr       (streamArbiter_1_io_output_payload_addr[31:0]  ), //o
    .io_output_payload_id         (streamArbiter_1_io_output_payload_id[3:0]     ), //o
    .io_output_payload_len        (streamArbiter_1_io_output_payload_len[7:0]    ), //o
    .io_output_payload_size       (streamArbiter_1_io_output_payload_size[2:0]   ), //o
    .io_output_payload_burst      (streamArbiter_1_io_output_payload_burst[1:0]  ), //o
    .io_chosen                    (streamArbiter_1_io_chosen                     ), //o
    .io_chosenOH                  (streamArbiter_1_io_chosenOH[1:0]              ), //o
    .clk                          (clk                                           ), //i
    .reset                        (reset                                         )  //i
  );
  assign wbEmpty_CYC = 1'b0;
  assign wbEmpty_STB = 1'b0;
  assign wbEmpty_WE = 1'b0;
  assign wbEmpty_ADR = 32'h0;
  assign wbEmpty_DAT_MOSI = 32'h0;
  assign wbEmpty_SEL = 4'b0000;
  assign wishbone_ACK = 1'b1;
  assign wishbone_DAT_MISO = busif_readData;
  assign busif_selMatch = wishbone_SEL[0];
  assign busif_askWrite = (((busif_selMatch && wishbone_CYC) && wishbone_STB) && wishbone_WE);
  assign busif_askRead = (((busif_selMatch && wishbone_CYC) && wishbone_STB) && (! wishbone_WE));
  assign busif_doWrite = ((((busif_selMatch && wishbone_CYC) && wishbone_STB) && wishbone_ACK) && wishbone_WE);
  assign busif_doRead = ((((busif_selMatch && wishbone_CYC) && wishbone_STB) && wishbone_ACK) && (! wishbone_WE));
  assign io_wb_DAT_MISO = mem_io_wb_DAT_MISO;
  assign io_wb_ACK = mem_io_wb_ACK;
  assign wishbone_CYC = wbEmpty_CYC;
  assign wishbone_ADR = wbEmpty_ADR;
  assign wishbone_DAT_MOSI = wbEmpty_DAT_MOSI;
  assign wbEmpty_DAT_MISO = wishbone_DAT_MISO;
  assign wishbone_STB = wbEmpty_STB;
  assign wishbone_WE = wbEmpty_WE;
  assign wbEmpty_ACK = wishbone_ACK;
  assign wishbone_SEL = wbEmpty_SEL;
  assign srcAddr = 32'h00000ffb;
  assign dstAddr = 32'h00002001;
  assign _zz_1 = streamArbiter_1_io_chosenOH[1];
  assign io_ctrl_busy = dmaArea_dma_io_ctrl_busy;
  assign io_ctrl_done = dmaArea_dma_io_ctrl_done;
  assign _zz_2 = srcAddr;
  assign _zz_3 = dstAddr;
  assign _zz_4 = 8'h08;
  assign _zz_5 = 8'h01;
  assign _zz_6 = 8'h0;
  assign _zz_7 = 8'h0;
  assign _zz_8 = 32'h0;
  assign _zz_9 = 1'b1;
  assign _zz_10 = 1'b1;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      busif_readError <= 1'b0;
      busif_readData <= 32'h0;
    end else begin
      if(busif_doRead)begin
        case(wishbone_ADR)
          32'h0 : begin
          end
          32'h00000004 : begin
          end
          default : begin
            busif_readData <= 32'h0;
            busif_readError <= 1'b1;
          end
        endcase
      end
    end
  end


endmodule

module StreamArbiter (
  input               io_inputs_0_valid,
  output              io_inputs_0_ready,
  input      [31:0]   io_inputs_0_payload_addr,
  input      [3:0]    io_inputs_0_payload_id,
  input      [7:0]    io_inputs_0_payload_len,
  input      [2:0]    io_inputs_0_payload_size,
  input      [1:0]    io_inputs_0_payload_burst,
  input               io_inputs_1_valid,
  output              io_inputs_1_ready,
  input      [31:0]   io_inputs_1_payload_addr,
  input      [3:0]    io_inputs_1_payload_id,
  input      [7:0]    io_inputs_1_payload_len,
  input      [2:0]    io_inputs_1_payload_size,
  input      [1:0]    io_inputs_1_payload_burst,
  output              io_output_valid,
  input               io_output_ready,
  output     [31:0]   io_output_payload_addr,
  output     [3:0]    io_output_payload_id,
  output     [7:0]    io_output_payload_len,
  output     [2:0]    io_output_payload_size,
  output     [1:0]    io_output_payload_burst,
  output     [0:0]    io_chosen,
  output     [1:0]    io_chosenOH,
  input               clk,
  input               reset
);
  wire       [3:0]    _zz_6;
  wire       [1:0]    _zz_7;
  wire       [3:0]    _zz_8;
  wire       [0:0]    _zz_9;
  wire       [0:0]    _zz_10;
  reg                 locked;
  wire                maskProposal_0;
  wire                maskProposal_1;
  reg                 maskLocked_0;
  reg                 maskLocked_1;
  wire                maskRouted_0;
  wire                maskRouted_1;
  wire       [1:0]    _zz_1;
  wire       [3:0]    _zz_2;
  wire       [3:0]    _zz_3;
  wire       [1:0]    _zz_4;
  wire                _zz_5;

  assign _zz_6 = (_zz_2 - _zz_8);
  assign _zz_7 = {maskLocked_0,maskLocked_1};
  assign _zz_8 = {2'd0, _zz_7};
  assign _zz_9 = _zz_4[0 : 0];
  assign _zz_10 = _zz_4[1 : 1];
  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign maskRouted_1 = (locked ? maskLocked_1 : maskProposal_1);
  assign _zz_1 = {io_inputs_1_valid,io_inputs_0_valid};
  assign _zz_2 = {_zz_1,_zz_1};
  assign _zz_3 = (_zz_2 & (~ _zz_6));
  assign _zz_4 = (_zz_3[3 : 2] | _zz_3[1 : 0]);
  assign maskProposal_0 = _zz_9[0];
  assign maskProposal_1 = _zz_10[0];
  assign io_output_valid = ((io_inputs_0_valid && maskRouted_0) || (io_inputs_1_valid && maskRouted_1));
  assign io_output_payload_addr = (maskRouted_0 ? io_inputs_0_payload_addr : io_inputs_1_payload_addr);
  assign io_output_payload_id = (maskRouted_0 ? io_inputs_0_payload_id : io_inputs_1_payload_id);
  assign io_output_payload_len = (maskRouted_0 ? io_inputs_0_payload_len : io_inputs_1_payload_len);
  assign io_output_payload_size = (maskRouted_0 ? io_inputs_0_payload_size : io_inputs_1_payload_size);
  assign io_output_payload_burst = (maskRouted_0 ? io_inputs_0_payload_burst : io_inputs_1_payload_burst);
  assign io_inputs_0_ready = (maskRouted_0 && io_output_ready);
  assign io_inputs_1_ready = (maskRouted_1 && io_output_ready);
  assign io_chosenOH = {maskRouted_1,maskRouted_0};
  assign _zz_5 = io_chosenOH[1];
  assign io_chosen = _zz_5;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      locked <= 1'b0;
      maskLocked_0 <= 1'b0;
      maskLocked_1 <= 1'b1;
    end else begin
      if(io_output_valid)begin
        maskLocked_0 <= maskRouted_0;
        maskLocked_1 <= maskRouted_1;
      end
      if(io_output_valid)begin
        locked <= 1'b1;
      end
      if((io_output_valid && io_output_ready))begin
        locked <= 1'b0;
      end
    end
  end


endmodule

module Dma (
  input      [31:0]   io_param_sar,
  input      [31:0]   io_param_dar,
  input      [7:0]    io_param_xsize,
  input      [7:0]    io_param_ysize,
  input      [7:0]    io_param_srcystep,
  input      [7:0]    io_param_dstystep,
  input      [31:0]   io_param_llr,
  input               io_param_bf,
  input               io_param_cf,
  output              io_axi_aw_valid,
  input               io_axi_aw_ready,
  output     [31:0]   io_axi_aw_payload_addr,
  output     [3:0]    io_axi_aw_payload_id,
  output     [7:0]    io_axi_aw_payload_len,
  output     [2:0]    io_axi_aw_payload_size,
  output     [1:0]    io_axi_aw_payload_burst,
  output              io_axi_w_valid,
  input               io_axi_w_ready,
  output     [31:0]   io_axi_w_payload_data,
  output     [3:0]    io_axi_w_payload_strb,
  output              io_axi_w_payload_last,
  input               io_axi_b_valid,
  output              io_axi_b_ready,
  input      [3:0]    io_axi_b_payload_id,
  input      [1:0]    io_axi_b_payload_resp,
  output              io_axi_ar_valid,
  input               io_axi_ar_ready,
  output     [31:0]   io_axi_ar_payload_addr,
  output     [3:0]    io_axi_ar_payload_id,
  output     [7:0]    io_axi_ar_payload_len,
  output     [2:0]    io_axi_ar_payload_size,
  output     [1:0]    io_axi_ar_payload_burst,
  input               io_axi_r_valid,
  output              io_axi_r_ready,
  input      [31:0]   io_axi_r_payload_data,
  input      [3:0]    io_axi_r_payload_id,
  input      [1:0]    io_axi_r_payload_resp,
  input               io_axi_r_payload_last,
  input               io_ctrl_start,
  output              io_ctrl_busy,
  output              io_ctrl_done,
  input               io_ctrl_halt,
  input               clk,
  input               reset
);
  wire                _zz_1;
  wire                read_io_dout_valid;
  wire       [31:0]   read_io_dout_payload;
  wire                read_io_axiR_ar_valid;
  wire       [31:0]   read_io_axiR_ar_payload_addr;
  wire       [3:0]    read_io_axiR_ar_payload_id;
  wire       [7:0]    read_io_axiR_ar_payload_len;
  wire       [2:0]    read_io_axiR_ar_payload_size;
  wire       [1:0]    read_io_axiR_ar_payload_burst;
  wire                read_io_axiR_r_ready;
  wire                read_io_ctrl_busy;
  wire                read_io_ctrl_done;
  wire                write_io_din_ready;
  wire                write_io_axiW_aw_valid;
  wire       [31:0]   write_io_axiW_aw_payload_addr;
  wire       [3:0]    write_io_axiW_aw_payload_id;
  wire       [7:0]    write_io_axiW_aw_payload_len;
  wire       [2:0]    write_io_axiW_aw_payload_size;
  wire       [1:0]    write_io_axiW_aw_payload_burst;
  wire                write_io_axiW_w_valid;
  wire       [31:0]   write_io_axiW_w_payload_data;
  wire       [3:0]    write_io_axiW_w_payload_strb;
  wire                write_io_axiW_w_payload_last;
  wire                write_io_axiW_b_ready;
  wire                write_io_ctrl_busy;
  wire                write_io_ctrl_done;
  wire                io_dout_fifo_io_push_ready;
  wire                io_dout_fifo_io_pop_valid;
  wire       [31:0]   io_dout_fifo_io_pop_payload;
  wire       [4:0]    io_dout_fifo_io_occupancy;
  wire       [4:0]    io_dout_fifo_io_availability;

  DmaRead read (
    .io_dout_valid               (read_io_dout_valid                  ), //o
    .io_dout_ready               (io_dout_fifo_io_push_ready          ), //i
    .io_dout_payload             (read_io_dout_payload[31:0]          ), //o
    .io_param_sar                (io_param_sar[31:0]                  ), //i
    .io_param_dar                (io_param_dar[31:0]                  ), //i
    .io_param_xsize              (io_param_xsize[7:0]                 ), //i
    .io_param_ysize              (io_param_ysize[7:0]                 ), //i
    .io_param_srcystep           (io_param_srcystep[7:0]              ), //i
    .io_param_dstystep           (io_param_dstystep[7:0]              ), //i
    .io_param_llr                (io_param_llr[31:0]                  ), //i
    .io_param_bf                 (io_param_bf                         ), //i
    .io_param_cf                 (io_param_cf                         ), //i
    .io_axiR_ar_valid            (read_io_axiR_ar_valid               ), //o
    .io_axiR_ar_ready            (io_axi_ar_ready                     ), //i
    .io_axiR_ar_payload_addr     (read_io_axiR_ar_payload_addr[31:0]  ), //o
    .io_axiR_ar_payload_id       (read_io_axiR_ar_payload_id[3:0]     ), //o
    .io_axiR_ar_payload_len      (read_io_axiR_ar_payload_len[7:0]    ), //o
    .io_axiR_ar_payload_size     (read_io_axiR_ar_payload_size[2:0]   ), //o
    .io_axiR_ar_payload_burst    (read_io_axiR_ar_payload_burst[1:0]  ), //o
    .io_axiR_r_valid             (io_axi_r_valid                      ), //i
    .io_axiR_r_ready             (read_io_axiR_r_ready                ), //o
    .io_axiR_r_payload_data      (io_axi_r_payload_data[31:0]         ), //i
    .io_axiR_r_payload_id        (io_axi_r_payload_id[3:0]            ), //i
    .io_axiR_r_payload_resp      (io_axi_r_payload_resp[1:0]          ), //i
    .io_axiR_r_payload_last      (io_axi_r_payload_last               ), //i
    .io_ctrl_start               (io_ctrl_start                       ), //i
    .io_ctrl_busy                (read_io_ctrl_busy                   ), //o
    .io_ctrl_done                (read_io_ctrl_done                   ), //o
    .io_ctrl_halt                (io_ctrl_halt                        ), //i
    .clk                         (clk                                 ), //i
    .reset                       (reset                               )  //i
  );
  DmaWrite write (
    .io_din_valid                (io_dout_fifo_io_pop_valid            ), //i
    .io_din_ready                (write_io_din_ready                   ), //o
    .io_din_payload              (io_dout_fifo_io_pop_payload[31:0]    ), //i
    .io_param_sar                (io_param_sar[31:0]                   ), //i
    .io_param_dar                (io_param_dar[31:0]                   ), //i
    .io_param_xsize              (io_param_xsize[7:0]                  ), //i
    .io_param_ysize              (io_param_ysize[7:0]                  ), //i
    .io_param_srcystep           (io_param_srcystep[7:0]               ), //i
    .io_param_dstystep           (io_param_dstystep[7:0]               ), //i
    .io_param_llr                (io_param_llr[31:0]                   ), //i
    .io_param_bf                 (io_param_bf                          ), //i
    .io_param_cf                 (io_param_cf                          ), //i
    .io_axiW_aw_valid            (write_io_axiW_aw_valid               ), //o
    .io_axiW_aw_ready            (io_axi_aw_ready                      ), //i
    .io_axiW_aw_payload_addr     (write_io_axiW_aw_payload_addr[31:0]  ), //o
    .io_axiW_aw_payload_id       (write_io_axiW_aw_payload_id[3:0]     ), //o
    .io_axiW_aw_payload_len      (write_io_axiW_aw_payload_len[7:0]    ), //o
    .io_axiW_aw_payload_size     (write_io_axiW_aw_payload_size[2:0]   ), //o
    .io_axiW_aw_payload_burst    (write_io_axiW_aw_payload_burst[1:0]  ), //o
    .io_axiW_w_valid             (write_io_axiW_w_valid                ), //o
    .io_axiW_w_ready             (io_axi_w_ready                       ), //i
    .io_axiW_w_payload_data      (write_io_axiW_w_payload_data[31:0]   ), //o
    .io_axiW_w_payload_strb      (write_io_axiW_w_payload_strb[3:0]    ), //o
    .io_axiW_w_payload_last      (write_io_axiW_w_payload_last         ), //o
    .io_axiW_b_valid             (io_axi_b_valid                       ), //i
    .io_axiW_b_ready             (write_io_axiW_b_ready                ), //o
    .io_axiW_b_payload_id        (io_axi_b_payload_id[3:0]             ), //i
    .io_axiW_b_payload_resp      (io_axi_b_payload_resp[1:0]           ), //i
    .io_ctrl_start               (io_ctrl_start                        ), //i
    .io_ctrl_busy                (write_io_ctrl_busy                   ), //o
    .io_ctrl_done                (write_io_ctrl_done                   ), //o
    .io_ctrl_halt                (io_ctrl_halt                         ), //i
    .clk                         (clk                                  ), //i
    .reset                       (reset                                )  //i
  );
  StreamFifo io_dout_fifo (
    .io_push_valid      (read_io_dout_valid                 ), //i
    .io_push_ready      (io_dout_fifo_io_push_ready         ), //o
    .io_push_payload    (read_io_dout_payload[31:0]         ), //i
    .io_pop_valid       (io_dout_fifo_io_pop_valid          ), //o
    .io_pop_ready       (write_io_din_ready                 ), //i
    .io_pop_payload     (io_dout_fifo_io_pop_payload[31:0]  ), //o
    .io_flush           (_zz_1                              ), //i
    .io_occupancy       (io_dout_fifo_io_occupancy[4:0]     ), //o
    .io_availability    (io_dout_fifo_io_availability[4:0]  ), //o
    .clk                (clk                                ), //i
    .reset              (reset                              )  //i
  );
  assign io_ctrl_busy = (read_io_ctrl_busy || write_io_ctrl_busy);
  assign io_ctrl_done = write_io_ctrl_done;
  assign io_axi_ar_valid = read_io_axiR_ar_valid;
  assign io_axi_ar_payload_addr = read_io_axiR_ar_payload_addr;
  assign io_axi_ar_payload_id = read_io_axiR_ar_payload_id;
  assign io_axi_ar_payload_len = read_io_axiR_ar_payload_len;
  assign io_axi_ar_payload_size = read_io_axiR_ar_payload_size;
  assign io_axi_ar_payload_burst = read_io_axiR_ar_payload_burst;
  assign io_axi_r_ready = read_io_axiR_r_ready;
  assign io_axi_aw_valid = write_io_axiW_aw_valid;
  assign io_axi_aw_payload_addr = write_io_axiW_aw_payload_addr;
  assign io_axi_aw_payload_id = write_io_axiW_aw_payload_id;
  assign io_axi_aw_payload_len = write_io_axiW_aw_payload_len;
  assign io_axi_aw_payload_size = write_io_axiW_aw_payload_size;
  assign io_axi_aw_payload_burst = write_io_axiW_aw_payload_burst;
  assign io_axi_w_valid = write_io_axiW_w_valid;
  assign io_axi_w_payload_data = write_io_axiW_w_payload_data;
  assign io_axi_w_payload_strb = write_io_axiW_w_payload_strb;
  assign io_axi_w_payload_last = write_io_axiW_w_payload_last;
  assign io_axi_b_ready = write_io_axiW_b_ready;
  assign _zz_1 = 1'b0;

endmodule

module Axi4SharedWishboneOnChipRam (
  input               io_axi_arw_valid,
  output reg          io_axi_arw_ready,
  input      [31:0]   io_axi_arw_payload_addr,
  input      [3:0]    io_axi_arw_payload_id,
  input      [7:0]    io_axi_arw_payload_len,
  input      [2:0]    io_axi_arw_payload_size,
  input      [1:0]    io_axi_arw_payload_burst,
  input               io_axi_arw_payload_write,
  input               io_axi_w_valid,
  output              io_axi_w_ready,
  input      [31:0]   io_axi_w_payload_data,
  input      [3:0]    io_axi_w_payload_strb,
  input               io_axi_w_payload_last,
  output              io_axi_b_valid,
  input               io_axi_b_ready,
  output     [3:0]    io_axi_b_payload_id,
  output     [1:0]    io_axi_b_payload_resp,
  output              io_axi_r_valid,
  input               io_axi_r_ready,
  output     [31:0]   io_axi_r_payload_data,
  output     [3:0]    io_axi_r_payload_id,
  output     [1:0]    io_axi_r_payload_resp,
  output              io_axi_r_payload_last,
  input               io_wb_CYC,
  input               io_wb_STB,
  output              io_wb_ACK,
  input               io_wb_WE,
  input      [31:0]   io_wb_ADR,
  output     [31:0]   io_wb_DAT_MISO,
  input      [31:0]   io_wb_DAT_MOSI,
  input      [3:0]    io_wb_SEL,
  input               clk,
  input               reset
);
  reg        [31:0]   _zz_8;
  reg        [31:0]   _zz_9;
  reg        [11:0]   _zz_10;
  wire                _zz_11;
  wire       [5:0]    _zz_12;
  wire       [1:0]    _zz_13;
  wire       [11:0]   _zz_14;
  wire       [11:0]   _zz_15;
  wire       [11:0]   _zz_16;
  wire       [2:0]    _zz_17;
  wire       [2:0]    _zz_18;
  wire       [5:0]    _zz_19;
  reg                 wbArea_memRdyReg;
  wire                wbArea_wbVld;
  wire       [31:0]   _zz_1;
  wire       [31:0]   _zz_2;
  reg                 unburstify_result_valid;
  wire                unburstify_result_ready;
  reg                 unburstify_result_payload_last;
  reg        [31:0]   unburstify_result_payload_fragment_addr;
  reg        [3:0]    unburstify_result_payload_fragment_id;
  reg        [2:0]    unburstify_result_payload_fragment_size;
  reg        [1:0]    unburstify_result_payload_fragment_burst;
  reg                 unburstify_result_payload_fragment_write;
  wire                unburstify_doResult;
  reg                 unburstify_buffer_valid;
  reg        [7:0]    unburstify_buffer_len;
  reg        [7:0]    unburstify_buffer_beat;
  reg        [31:0]   unburstify_buffer_transaction_addr;
  reg        [3:0]    unburstify_buffer_transaction_id;
  reg        [2:0]    unburstify_buffer_transaction_size;
  reg        [1:0]    unburstify_buffer_transaction_burst;
  reg                 unburstify_buffer_transaction_write;
  wire                unburstify_buffer_last;
  wire       [1:0]    Axi4Incr_validSize;
  reg        [31:0]   Axi4Incr_result;
  wire       [19:0]   Axi4Incr_highCat;
  wire       [2:0]    Axi4Incr_sizeValue;
  wire       [11:0]   Axi4Incr_alignMask;
  wire       [11:0]   Axi4Incr_base;
  wire       [11:0]   Axi4Incr_baseIncr;
  reg        [1:0]    _zz_3;
  wire       [2:0]    Axi4Incr_wrapCase;
  wire                _zz_4;
  wire                axiArea_stage0_valid;
  wire                axiArea_stage0_ready;
  wire                axiArea_stage0_payload_last;
  wire       [31:0]   axiArea_stage0_payload_fragment_addr;
  wire       [3:0]    axiArea_stage0_payload_fragment_id;
  wire       [2:0]    axiArea_stage0_payload_fragment_size;
  wire       [1:0]    axiArea_stage0_payload_fragment_burst;
  wire                axiArea_stage0_payload_fragment_write;
  wire       [29:0]   _zz_5;
  wire                _zz_6;
  wire       [31:0]   _zz_7;
  wire                axiArea_stage1_valid;
  wire                axiArea_stage1_ready;
  wire                axiArea_stage1_payload_last;
  wire       [31:0]   axiArea_stage1_payload_fragment_addr;
  wire       [3:0]    axiArea_stage1_payload_fragment_id;
  wire       [2:0]    axiArea_stage1_payload_fragment_size;
  wire       [1:0]    axiArea_stage1_payload_fragment_burst;
  wire                axiArea_stage1_payload_fragment_write;
  reg                 axiArea_stage0_m2sPipe_rValid;
  reg                 axiArea_stage0_m2sPipe_rData_last;
  reg        [31:0]   axiArea_stage0_m2sPipe_rData_fragment_addr;
  reg        [3:0]    axiArea_stage0_m2sPipe_rData_fragment_id;
  reg        [2:0]    axiArea_stage0_m2sPipe_rData_fragment_size;
  reg        [1:0]    axiArea_stage0_m2sPipe_rData_fragment_burst;
  reg                 axiArea_stage0_m2sPipe_rData_fragment_write;
  reg [7:0] ram_symbol0 [0:63];
  reg [7:0] ram_symbol1 [0:63];
  reg [7:0] ram_symbol2 [0:63];
  reg [7:0] ram_symbol3 [0:63];
  reg [7:0] _zz_20;
  reg [7:0] _zz_21;
  reg [7:0] _zz_22;
  reg [7:0] _zz_23;
  reg [7:0] _zz_24;
  reg [7:0] _zz_25;
  reg [7:0] _zz_26;
  reg [7:0] _zz_27;

  assign _zz_11 = (io_axi_arw_payload_len == 8'h0);
  assign _zz_12 = _zz_1[5:0];
  assign _zz_13 = {(2'b01 < Axi4Incr_validSize),(2'b00 < Axi4Incr_validSize)};
  assign _zz_14 = unburstify_buffer_transaction_addr[11 : 0];
  assign _zz_15 = _zz_14;
  assign _zz_16 = {9'd0, Axi4Incr_sizeValue};
  assign _zz_17 = {1'd0, Axi4Incr_validSize};
  assign _zz_18 = {1'd0, _zz_3};
  assign _zz_19 = _zz_5[5:0];
  always @ (*) begin
    _zz_8 = {_zz_23, _zz_22, _zz_21, _zz_20};
  end
  always @ (*) begin
    _zz_9 = {_zz_27, _zz_26, _zz_25, _zz_24};
  end
  always @ (posedge clk) begin
    if(wbArea_wbVld) begin
      _zz_20 <= ram_symbol0[_zz_12];
      _zz_21 <= ram_symbol1[_zz_12];
      _zz_22 <= ram_symbol2[_zz_12];
      _zz_23 <= ram_symbol3[_zz_12];
    end
  end

  always @ (posedge clk) begin
    if(io_wb_SEL[0] && wbArea_wbVld && io_wb_WE ) begin
      ram_symbol0[_zz_12] <= _zz_2[7 : 0];
    end
    if(io_wb_SEL[1] && wbArea_wbVld && io_wb_WE ) begin
      ram_symbol1[_zz_12] <= _zz_2[15 : 8];
    end
    if(io_wb_SEL[2] && wbArea_wbVld && io_wb_WE ) begin
      ram_symbol2[_zz_12] <= _zz_2[23 : 16];
    end
    if(io_wb_SEL[3] && wbArea_wbVld && io_wb_WE ) begin
      ram_symbol3[_zz_12] <= _zz_2[31 : 24];
    end
  end

  always @ (posedge clk) begin
    if(_zz_6) begin
      _zz_24 <= ram_symbol0[_zz_19];
      _zz_25 <= ram_symbol1[_zz_19];
      _zz_26 <= ram_symbol2[_zz_19];
      _zz_27 <= ram_symbol3[_zz_19];
    end
  end

  always @ (posedge clk) begin
    if(io_axi_w_payload_strb[0] && _zz_6 && axiArea_stage0_payload_fragment_write ) begin
      ram_symbol0[_zz_19] <= _zz_7[7 : 0];
    end
    if(io_axi_w_payload_strb[1] && _zz_6 && axiArea_stage0_payload_fragment_write ) begin
      ram_symbol1[_zz_19] <= _zz_7[15 : 8];
    end
    if(io_axi_w_payload_strb[2] && _zz_6 && axiArea_stage0_payload_fragment_write ) begin
      ram_symbol2[_zz_19] <= _zz_7[23 : 16];
    end
    if(io_axi_w_payload_strb[3] && _zz_6 && axiArea_stage0_payload_fragment_write ) begin
      ram_symbol3[_zz_19] <= _zz_7[31 : 24];
    end
  end

  always @(*) begin
    case(Axi4Incr_wrapCase)
      3'b000 : begin
        _zz_10 = {Axi4Incr_base[11 : 1],Axi4Incr_baseIncr[0 : 0]};
      end
      3'b001 : begin
        _zz_10 = {Axi4Incr_base[11 : 2],Axi4Incr_baseIncr[1 : 0]};
      end
      3'b010 : begin
        _zz_10 = {Axi4Incr_base[11 : 3],Axi4Incr_baseIncr[2 : 0]};
      end
      3'b011 : begin
        _zz_10 = {Axi4Incr_base[11 : 4],Axi4Incr_baseIncr[3 : 0]};
      end
      3'b100 : begin
        _zz_10 = {Axi4Incr_base[11 : 5],Axi4Incr_baseIncr[4 : 0]};
      end
      default : begin
        _zz_10 = {Axi4Incr_base[11 : 6],Axi4Incr_baseIncr[5 : 0]};
      end
    endcase
  end

  assign wbArea_wbVld = (io_wb_CYC && io_wb_STB);
  assign io_wb_ACK = wbArea_memRdyReg;
  assign _zz_1 = io_wb_ADR;
  assign _zz_2 = io_wb_DAT_MOSI;
  assign io_wb_DAT_MISO = _zz_8;
  assign unburstify_buffer_last = (unburstify_buffer_beat == 8'h01);
  assign Axi4Incr_validSize = unburstify_buffer_transaction_size[1 : 0];
  assign Axi4Incr_highCat = unburstify_buffer_transaction_addr[31 : 12];
  assign Axi4Incr_sizeValue = {(2'b10 == Axi4Incr_validSize),{(2'b01 == Axi4Incr_validSize),(2'b00 == Axi4Incr_validSize)}};
  assign Axi4Incr_alignMask = {10'd0, _zz_13};
  assign Axi4Incr_base = (_zz_15 & (~ Axi4Incr_alignMask));
  assign Axi4Incr_baseIncr = (Axi4Incr_base + _zz_16);
  always @ (*) begin
    if((((unburstify_buffer_len & 8'h08) == 8'h08))) begin
        _zz_3 = 2'b11;
    end else if((((unburstify_buffer_len & 8'h04) == 8'h04))) begin
        _zz_3 = 2'b10;
    end else if((((unburstify_buffer_len & 8'h02) == 8'h02))) begin
        _zz_3 = 2'b01;
    end else begin
        _zz_3 = 2'b00;
    end
  end

  assign Axi4Incr_wrapCase = (_zz_17 + _zz_18);
  always @ (*) begin
    case(unburstify_buffer_transaction_burst)
      2'b00 : begin
        Axi4Incr_result = unburstify_buffer_transaction_addr;
      end
      2'b10 : begin
        Axi4Incr_result = {Axi4Incr_highCat,_zz_10};
      end
      default : begin
        Axi4Incr_result = {Axi4Incr_highCat,Axi4Incr_baseIncr};
      end
    endcase
  end

  always @ (*) begin
    io_axi_arw_ready = 1'b0;
    if(! unburstify_buffer_valid) begin
      io_axi_arw_ready = unburstify_result_ready;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      unburstify_result_valid = 1'b1;
    end else begin
      unburstify_result_valid = io_axi_arw_valid;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      unburstify_result_payload_last = unburstify_buffer_last;
    end else begin
      if(_zz_11)begin
        unburstify_result_payload_last = 1'b1;
      end else begin
        unburstify_result_payload_last = 1'b0;
      end
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      unburstify_result_payload_fragment_id = unburstify_buffer_transaction_id;
    end else begin
      unburstify_result_payload_fragment_id = io_axi_arw_payload_id;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      unburstify_result_payload_fragment_size = unburstify_buffer_transaction_size;
    end else begin
      unburstify_result_payload_fragment_size = io_axi_arw_payload_size;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      unburstify_result_payload_fragment_burst = unburstify_buffer_transaction_burst;
    end else begin
      unburstify_result_payload_fragment_burst = io_axi_arw_payload_burst;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      unburstify_result_payload_fragment_write = unburstify_buffer_transaction_write;
    end else begin
      unburstify_result_payload_fragment_write = io_axi_arw_payload_write;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      unburstify_result_payload_fragment_addr = Axi4Incr_result;
    end else begin
      unburstify_result_payload_fragment_addr = io_axi_arw_payload_addr;
    end
  end

  assign _zz_4 = (! (unburstify_result_payload_fragment_write && (! io_axi_w_valid)));
  assign axiArea_stage0_valid = (unburstify_result_valid && _zz_4);
  assign unburstify_result_ready = (axiArea_stage0_ready && _zz_4);
  assign axiArea_stage0_payload_last = unburstify_result_payload_last;
  assign axiArea_stage0_payload_fragment_addr = unburstify_result_payload_fragment_addr;
  assign axiArea_stage0_payload_fragment_id = unburstify_result_payload_fragment_id;
  assign axiArea_stage0_payload_fragment_size = unburstify_result_payload_fragment_size;
  assign axiArea_stage0_payload_fragment_burst = unburstify_result_payload_fragment_burst;
  assign axiArea_stage0_payload_fragment_write = unburstify_result_payload_fragment_write;
  assign _zz_5 = axiArea_stage0_payload_fragment_addr[31 : 2];
  assign _zz_6 = (axiArea_stage0_valid && axiArea_stage0_ready);
  assign _zz_7 = io_axi_w_payload_data;
  assign io_axi_r_payload_data = _zz_9;
  assign io_axi_w_ready = ((unburstify_result_valid && unburstify_result_payload_fragment_write) && axiArea_stage0_ready);
  assign axiArea_stage0_ready = ((1'b1 && (! axiArea_stage1_valid)) || axiArea_stage1_ready);
  assign axiArea_stage1_valid = axiArea_stage0_m2sPipe_rValid;
  assign axiArea_stage1_payload_last = axiArea_stage0_m2sPipe_rData_last;
  assign axiArea_stage1_payload_fragment_addr = axiArea_stage0_m2sPipe_rData_fragment_addr;
  assign axiArea_stage1_payload_fragment_id = axiArea_stage0_m2sPipe_rData_fragment_id;
  assign axiArea_stage1_payload_fragment_size = axiArea_stage0_m2sPipe_rData_fragment_size;
  assign axiArea_stage1_payload_fragment_burst = axiArea_stage0_m2sPipe_rData_fragment_burst;
  assign axiArea_stage1_payload_fragment_write = axiArea_stage0_m2sPipe_rData_fragment_write;
  assign axiArea_stage1_ready = ((io_axi_r_ready && (! axiArea_stage1_payload_fragment_write)) || ((io_axi_b_ready || (! axiArea_stage1_payload_last)) && axiArea_stage1_payload_fragment_write));
  assign io_axi_r_valid = (axiArea_stage1_valid && (! axiArea_stage1_payload_fragment_write));
  assign io_axi_r_payload_id = axiArea_stage1_payload_fragment_id;
  assign io_axi_r_payload_last = axiArea_stage1_payload_last;
  assign io_axi_r_payload_resp = 2'b00;
  assign io_axi_b_valid = ((axiArea_stage1_valid && axiArea_stage1_payload_fragment_write) && axiArea_stage1_payload_last);
  assign io_axi_b_payload_resp = 2'b00;
  assign io_axi_b_payload_id = axiArea_stage1_payload_fragment_id;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      wbArea_memRdyReg <= 1'b0;
      unburstify_buffer_valid <= 1'b0;
      axiArea_stage0_m2sPipe_rValid <= 1'b0;
    end else begin
      if(wbArea_wbVld)begin
        wbArea_memRdyReg <= 1'b1;
      end else begin
        wbArea_memRdyReg <= 1'b0;
      end
      if(unburstify_result_ready)begin
        if(unburstify_buffer_last)begin
          unburstify_buffer_valid <= 1'b0;
        end
      end
      if(! unburstify_buffer_valid) begin
        if(! _zz_11) begin
          if(unburstify_result_ready)begin
            unburstify_buffer_valid <= io_axi_arw_valid;
          end
        end
      end
      if(axiArea_stage0_ready)begin
        axiArea_stage0_m2sPipe_rValid <= axiArea_stage0_valid;
      end
    end
  end

  always @ (posedge clk) begin
    if(unburstify_result_ready)begin
      unburstify_buffer_beat <= (unburstify_buffer_beat - 8'h01);
      unburstify_buffer_transaction_addr[11 : 0] <= Axi4Incr_result[11 : 0];
    end
    if(! unburstify_buffer_valid) begin
      if(! _zz_11) begin
        if(unburstify_result_ready)begin
          unburstify_buffer_transaction_addr <= io_axi_arw_payload_addr;
          unburstify_buffer_transaction_id <= io_axi_arw_payload_id;
          unburstify_buffer_transaction_size <= io_axi_arw_payload_size;
          unburstify_buffer_transaction_burst <= io_axi_arw_payload_burst;
          unburstify_buffer_transaction_write <= io_axi_arw_payload_write;
          unburstify_buffer_beat <= io_axi_arw_payload_len;
          unburstify_buffer_len <= io_axi_arw_payload_len;
        end
      end
    end
    if(axiArea_stage0_ready)begin
      axiArea_stage0_m2sPipe_rData_last <= axiArea_stage0_payload_last;
      axiArea_stage0_m2sPipe_rData_fragment_addr <= axiArea_stage0_payload_fragment_addr;
      axiArea_stage0_m2sPipe_rData_fragment_id <= axiArea_stage0_payload_fragment_id;
      axiArea_stage0_m2sPipe_rData_fragment_size <= axiArea_stage0_payload_fragment_size;
      axiArea_stage0_m2sPipe_rData_fragment_burst <= axiArea_stage0_payload_fragment_burst;
      axiArea_stage0_m2sPipe_rData_fragment_write <= axiArea_stage0_payload_fragment_write;
    end
  end


endmodule

module StreamFifo (
  input               io_push_valid,
  output              io_push_ready,
  input      [31:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [31:0]   io_pop_payload,
  input               io_flush,
  output     [4:0]    io_occupancy,
  output     [4:0]    io_availability,
  input               clk,
  input               reset
);
  reg        [31:0]   _zz_3;
  wire       [0:0]    _zz_4;
  wire       [3:0]    _zz_5;
  wire       [0:0]    _zz_6;
  wire       [3:0]    _zz_7;
  wire       [3:0]    _zz_8;
  wire                _zz_9;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [3:0]    logic_pushPtr_valueNext;
  reg        [3:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [3:0]    logic_popPtr_valueNext;
  reg        [3:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_2;
  wire       [3:0]    logic_ptrDif;
  reg [31:0] logic_ram [0:15];

  assign _zz_4 = logic_pushPtr_willIncrement;
  assign _zz_5 = {3'd0, _zz_4};
  assign _zz_6 = logic_popPtr_willIncrement;
  assign _zz_7 = {3'd0, _zz_6};
  assign _zz_8 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_9 = 1'b1;
  always @ (posedge clk) begin
    if(_zz_9) begin
      _zz_3 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @ (posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= io_push_payload;
    end
  end

  always @ (*) begin
    _zz_1 = 1'b0;
    if(logic_pushing)begin
      _zz_1 = 1'b1;
    end
  end

  always @ (*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing)begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush)begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 4'b1111);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @ (*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_5);
    if(logic_pushPtr_willClear)begin
      logic_pushPtr_valueNext = 4'b0000;
    end
  end

  always @ (*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping)begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush)begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 4'b1111);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @ (*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_7);
    if(logic_popPtr_willClear)begin
      logic_popPtr_valueNext = 4'b0000;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_2 && (! logic_full))));
  assign io_pop_payload = _zz_3;
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_8};
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      logic_pushPtr_value <= 4'b0000;
      logic_popPtr_value <= 4'b0000;
      logic_risingOccupancy <= 1'b0;
      _zz_2 <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_2 <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if((logic_pushing != logic_popping))begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush)begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module DmaWrite (
  input               io_din_valid,
  output              io_din_ready,
  input      [31:0]   io_din_payload,
  input      [31:0]   io_param_sar,
  input      [31:0]   io_param_dar,
  input      [7:0]    io_param_xsize,
  input      [7:0]    io_param_ysize,
  input      [7:0]    io_param_srcystep,
  input      [7:0]    io_param_dstystep,
  input      [31:0]   io_param_llr,
  input               io_param_bf,
  input               io_param_cf,
  output              io_axiW_aw_valid,
  input               io_axiW_aw_ready,
  output     [31:0]   io_axiW_aw_payload_addr,
  output     [3:0]    io_axiW_aw_payload_id,
  output     [7:0]    io_axiW_aw_payload_len,
  output     [2:0]    io_axiW_aw_payload_size,
  output     [1:0]    io_axiW_aw_payload_burst,
  output              io_axiW_w_valid,
  input               io_axiW_w_ready,
  output     [31:0]   io_axiW_w_payload_data,
  output     [3:0]    io_axiW_w_payload_strb,
  output              io_axiW_w_payload_last,
  input               io_axiW_b_valid,
  output              io_axiW_b_ready,
  input      [3:0]    io_axiW_b_payload_id,
  input      [1:0]    io_axiW_b_payload_resp,
  input               io_ctrl_start,
  output              io_ctrl_busy,
  output reg          io_ctrl_done,
  input               io_ctrl_halt,
  input               clk,
  input               reset
);
  wire                _zz_1;
  wire                _zz_2;
  wire                _zz_3;
  wire                _zz_4;
  wire                _zz_5;
  wire                _zz_6;
  wire                _zz_7;
  wire       [31:0]   _zz_8;
  wire       [9:0]    _zz_9;
  wire       [31:0]   _zz_10;
  wire       [31:0]   _zz_11;
  wire       [0:0]    _zz_12;
  wire       [3:0]    _zz_13;
  wire       [7:0]    _zz_14;
  wire       [7:0]    _zz_15;
  wire       [7:0]    _zz_16;
  wire       [7:0]    _zz_17;
  wire       [31:0]   _zz_18;
  wire       [11:0]   _zz_19;
  wire       [12:0]   _zz_20;
  wire       [7:0]    _zz_21;
  wire       [12:0]   _zz_22;
  wire       [10:0]   _zz_23;
  wire       [5:0]    _zz_24;
  wire       [5:0]    _zz_25;
  wire       [5:0]    _zz_26;
  wire       [5:0]    _zz_27;
  wire       [5:0]    _zz_28;
  wire       [5:0]    _zz_29;
  wire       [3:0]    _zz_30;
  wire       [3:0]    _zz_31;
  wire       [2:0]    _zz_32;
  wire       [255:0]  _zz_33;
  wire       [255:0]  _zz_34;
  wire       [31:0]   _zz_35;
  wire       [31:0]   _zz_36;
  wire       [31:0]   _zz_37;
  reg                 busyReg;
  reg                 awValidReg;
  reg        [7:0]    burstLenReg;
  reg        [7:0]    nxtBurstLen;
  reg        [31:0]   curRowAddrReg;
  reg        [1:0]    alignOffsetReg;
  wire       [1:0]    alignOffsetNxt;
  reg        [31:0]   curAlignedAddrReg;
  wire       [31:0]   curAlignedRowAddr;
  wire       [31:0]   nxtAlignedAddr;
  wire       [7:0]    dstRowGap;
  wire       [31:0]   nxtRowAddr;
  reg                 beatCnt_willIncrement;
  reg                 beatCnt_willClear;
  reg        [3:0]    beatCnt_valueNext;
  reg        [3:0]    beatCnt_value;
  wire                beatCnt_willOverflowIfInc;
  wire                beatCnt_willOverflow;
  wire                runSignal;
  wire                idMatch;
  reg                 bReadyReg;
  reg        [31:0]   dinPrevReg;
  reg        [2:0]    curBeatBytes;
  reg        [3:0]    strobe;
  reg        [31:0]   payload;
  reg                 dinReady;
  reg                 wValid;
  reg        [7:0]    rowWriteCntReg;
  wire       [7:0]    rowWriteCntNxt;
  reg        [7:0]    colByteWriteCntReg;
  wire       [7:0]    colByteWriteCntNxt;
  reg        [7:0]    colRemainByteCntReg;
  wire       [7:0]    colRemainByteCntNxt;
  reg                 rowFirstBurstReg;
  reg                 rowFirstBeatReg;
  wire                rowLastBeat;
  reg                 nxtRow;
  wire                fsmW_wantExit;
  reg                 fsmW_wantStart;
  wire       [31:0]   computeNextWriteBurstLen_nxtAlignedRowAddr;
  wire       [12:0]   computeNextWriteBurstLen_tmpBurstByteSizeIn4K;
  wire       [7:0]    computeNextWriteBurstLen_nxtAlignedRowByteSize;
  wire                computeNextWriteBurstLen_rowCross4K;
  reg        `fsmW_enumDefinition_binary_sequential_type fsmW_stateReg;
  reg        `fsmW_enumDefinition_binary_sequential_type fsmW_stateNext;
  `ifndef SYNTHESIS
  reg [71:0] fsmW_stateReg_string;
  reg [71:0] fsmW_stateNext_string;
  `endif


  assign _zz_1 = ((runSignal && io_axiW_b_valid) && io_axiW_b_ready);
  assign _zz_2 = (colByteWriteCntReg < io_param_xsize);
  assign _zz_3 = (rowWriteCntNxt < io_param_ysize);
  assign _zz_4 = ((runSignal && io_axiW_w_valid) && io_axiW_w_ready);
  assign _zz_5 = (io_axiW_w_valid && io_axiW_w_ready);
  assign _zz_6 = (((runSignal && io_axiW_w_payload_last) && io_axiW_w_valid) && io_axiW_w_ready);
  assign _zz_7 = (runSignal && io_ctrl_start);
  assign _zz_8 = {30'd0, alignOffsetReg};
  assign _zz_9 = ({2'd0,burstLenReg} <<< 2);
  assign _zz_10 = {22'd0, _zz_9};
  assign _zz_11 = {24'd0, dstRowGap};
  assign _zz_12 = beatCnt_willIncrement;
  assign _zz_13 = {3'd0, _zz_12};
  assign _zz_14 = {4'd0, beatCnt_value};
  assign _zz_15 = (burstLenReg - 8'h01);
  assign _zz_16 = {5'd0, curBeatBytes};
  assign _zz_17 = {5'd0, curBeatBytes};
  assign _zz_18 = {30'd0, alignOffsetNxt};
  assign _zz_19 = computeNextWriteBurstLen_nxtAlignedRowAddr[11 : 0];
  assign _zz_20 = {1'd0, _zz_19};
  assign _zz_21 = {6'd0, alignOffsetNxt};
  assign _zz_22 = {5'd0, computeNextWriteBurstLen_nxtAlignedRowByteSize};
  assign _zz_23 = (computeNextWriteBurstLen_tmpBurstByteSizeIn4K >>> 2);
  assign _zz_24 = (_zz_25 + 6'h01);
  assign _zz_25 = (computeNextWriteBurstLen_nxtAlignedRowByteSize >>> 2);
  assign _zz_26 = (computeNextWriteBurstLen_nxtAlignedRowByteSize >>> 2);
  assign _zz_27 = (_zz_28 + 6'h01);
  assign _zz_28 = (colRemainByteCntReg >>> 2);
  assign _zz_29 = (colRemainByteCntReg >>> 2);
  assign _zz_30 = (_zz_31 - 4'b0001);
  assign _zz_31 = ({3'd0,1'b1} <<< alignOffsetReg);
  assign _zz_32 = {1'd0, alignOffsetReg};
  assign _zz_33 = (_zz_34 - 256'h0000000000000000000000000000000000000000000000000000000000000001);
  assign _zz_34 = ({255'd0,1'b1} <<< colRemainByteCntReg);
  assign _zz_35 = {24'd0, dstRowGap};
  assign _zz_36 = {30'd0, alignOffsetNxt};
  assign _zz_37 = {30'd0, alignOffsetNxt};
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsmW_stateReg)
      `fsmW_enumDefinition_binary_sequential_fsmW_BOOT : fsmW_stateReg_string = "fsmW_BOOT";
      `fsmW_enumDefinition_binary_sequential_fsmW_IDLE : fsmW_stateReg_string = "fsmW_IDLE";
      `fsmW_enumDefinition_binary_sequential_fsmW_W : fsmW_stateReg_string = "fsmW_W   ";
      `fsmW_enumDefinition_binary_sequential_fsmW_LAST : fsmW_stateReg_string = "fsmW_LAST";
      `fsmW_enumDefinition_binary_sequential_fsmW_B : fsmW_stateReg_string = "fsmW_B   ";
      default : fsmW_stateReg_string = "?????????";
    endcase
  end
  always @(*) begin
    case(fsmW_stateNext)
      `fsmW_enumDefinition_binary_sequential_fsmW_BOOT : fsmW_stateNext_string = "fsmW_BOOT";
      `fsmW_enumDefinition_binary_sequential_fsmW_IDLE : fsmW_stateNext_string = "fsmW_IDLE";
      `fsmW_enumDefinition_binary_sequential_fsmW_W : fsmW_stateNext_string = "fsmW_W   ";
      `fsmW_enumDefinition_binary_sequential_fsmW_LAST : fsmW_stateNext_string = "fsmW_LAST";
      `fsmW_enumDefinition_binary_sequential_fsmW_B : fsmW_stateNext_string = "fsmW_B   ";
      default : fsmW_stateNext_string = "?????????";
    endcase
  end
  `endif

  always @ (*) begin
    io_ctrl_done = 1'b0;
    case(fsmW_stateReg)
      `fsmW_enumDefinition_binary_sequential_fsmW_IDLE : begin
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_W : begin
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_LAST : begin
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_B : begin
        if(_zz_1)begin
          if(! _zz_2) begin
            if(! _zz_3) begin
              io_ctrl_done = 1'b1;
            end
          end
        end
      end
      default : begin
      end
    endcase
  end

  assign io_ctrl_busy = busyReg;
  assign curAlignedRowAddr = (curRowAddrReg - _zz_8);
  assign nxtAlignedAddr = (curAlignedAddrReg + _zz_10);
  assign dstRowGap = (io_param_xsize + io_param_dstystep);
  assign nxtRowAddr = (curRowAddrReg + _zz_11);
  always @ (*) begin
    beatCnt_willIncrement = 1'b0;
    case(fsmW_stateReg)
      `fsmW_enumDefinition_binary_sequential_fsmW_IDLE : begin
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_W : begin
        if(_zz_4)begin
          beatCnt_willIncrement = 1'b1;
        end
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_LAST : begin
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_B : begin
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    beatCnt_willClear = 1'b0;
    if(io_axiW_w_payload_last)begin
      beatCnt_willClear = 1'b1;
    end
    case(fsmW_stateReg)
      `fsmW_enumDefinition_binary_sequential_fsmW_IDLE : begin
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_W : begin
        if(runSignal)begin
          if(_zz_5)begin
            if(io_axiW_w_payload_last)begin
              beatCnt_willClear = 1'b1;
            end
          end
        end
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_LAST : begin
        if(_zz_6)begin
          beatCnt_willClear = 1'b1;
        end
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_B : begin
      end
      default : begin
      end
    endcase
    if(((! (fsmW_stateReg == `fsmW_enumDefinition_binary_sequential_fsmW_W)) && (fsmW_stateNext == `fsmW_enumDefinition_binary_sequential_fsmW_W)))begin
      beatCnt_willClear = 1'b1;
    end
  end

  assign beatCnt_willOverflowIfInc = (beatCnt_value == 4'b1000);
  assign beatCnt_willOverflow = (beatCnt_willOverflowIfInc && beatCnt_willIncrement);
  always @ (*) begin
    if(beatCnt_willOverflow)begin
      beatCnt_valueNext = 4'b0000;
    end else begin
      beatCnt_valueNext = (beatCnt_value + _zz_13);
    end
    if(beatCnt_willClear)begin
      beatCnt_valueNext = 4'b0000;
    end
  end

  assign runSignal = (! io_ctrl_halt);
  assign idMatch = (io_axiW_b_payload_id == 4'b0101);
  assign io_axiW_aw_payload_id = 4'b0101;
  assign io_axiW_aw_payload_addr = curAlignedAddrReg;
  assign io_axiW_aw_payload_len = (burstLenReg - 8'h01);
  assign io_axiW_aw_payload_size = 3'b101;
  assign io_axiW_aw_payload_burst = 2'b01;
  assign io_axiW_aw_valid = awValidReg;
  assign io_axiW_b_ready = bReadyReg;
  assign io_axiW_w_payload_last = (_zz_14 == _zz_15);
  always @ (*) begin
    dinReady = 1'b0;
    case(fsmW_stateReg)
      `fsmW_enumDefinition_binary_sequential_fsmW_IDLE : begin
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_W : begin
        dinReady = io_axiW_w_ready;
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_LAST : begin
        dinReady = 1'b0;
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_B : begin
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    wValid = 1'b0;
    case(fsmW_stateReg)
      `fsmW_enumDefinition_binary_sequential_fsmW_IDLE : begin
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_W : begin
        wValid = io_din_valid;
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_LAST : begin
        wValid = 1'b1;
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_B : begin
      end
      default : begin
      end
    endcase
  end

  assign io_axiW_w_valid = wValid;
  assign io_din_ready = dinReady;
  assign io_axiW_w_payload_data = payload;
  assign io_axiW_w_payload_strb = strobe;
  assign rowWriteCntNxt = (rowWriteCntReg + 8'h01);
  assign colByteWriteCntNxt = (colByteWriteCntReg + _zz_16);
  assign colRemainByteCntNxt = (colRemainByteCntReg - _zz_17);
  assign rowLastBeat = (colRemainByteCntReg <= 8'h04);
  always @ (*) begin
    nxtRow = 1'b0;
    case(fsmW_stateReg)
      `fsmW_enumDefinition_binary_sequential_fsmW_IDLE : begin
        if(_zz_7)begin
          nxtRow = 1'b1;
        end
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_W : begin
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_LAST : begin
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_B : begin
        if(_zz_1)begin
          if(! _zz_2) begin
            if(_zz_3)begin
              nxtRow = 1'b1;
            end
          end
        end
      end
      default : begin
      end
    endcase
  end

  assign fsmW_wantExit = 1'b0;
  always @ (*) begin
    fsmW_wantStart = 1'b0;
    case(fsmW_stateReg)
      `fsmW_enumDefinition_binary_sequential_fsmW_IDLE : begin
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_W : begin
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_LAST : begin
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_B : begin
      end
      default : begin
        fsmW_wantStart = 1'b1;
      end
    endcase
  end

  assign alignOffsetNxt = nxtRowAddr[1 : 0];
  assign computeNextWriteBurstLen_nxtAlignedRowAddr = (nxtRowAddr - _zz_18);
  assign computeNextWriteBurstLen_tmpBurstByteSizeIn4K = (13'h1000 - _zz_20);
  assign computeNextWriteBurstLen_nxtAlignedRowByteSize = (io_param_xsize + _zz_21);
  assign computeNextWriteBurstLen_rowCross4K = ((computeNextWriteBurstLen_tmpBurstByteSizeIn4K < 13'h0020) && (computeNextWriteBurstLen_tmpBurstByteSizeIn4K < _zz_22));
  always @ (*) begin
    if(nxtRow)begin
      if(computeNextWriteBurstLen_rowCross4K)begin
        nxtBurstLen = _zz_23[7:0];
      end else begin
        if((8'h20 < computeNextWriteBurstLen_nxtAlignedRowByteSize))begin
          nxtBurstLen = 8'h08;
        end else begin
          if((computeNextWriteBurstLen_nxtAlignedRowByteSize[1 : 0] != 2'b00))begin
            nxtBurstLen = {2'd0, _zz_24};
          end else begin
            nxtBurstLen = {2'd0, _zz_26};
          end
        end
      end
    end else begin
      if((colRemainByteCntReg < 8'h20))begin
        if((colRemainByteCntReg[1 : 0] != 2'b00))begin
          nxtBurstLen = {2'd0, _zz_27};
        end else begin
          nxtBurstLen = {2'd0, _zz_29};
        end
      end else begin
        nxtBurstLen = 8'h08;
      end
    end
  end

  always @ (*) begin
    if(rowFirstBeatReg)begin
      strobe = (4'b1111 - _zz_30);
    end else begin
      if(rowLastBeat)begin
        strobe = _zz_33[3:0];
      end else begin
        strobe = 4'b1111;
      end
    end
  end

  always @ (*) begin
    if(rowFirstBeatReg)begin
      curBeatBytes = (3'b100 - _zz_32);
    end else begin
      if(rowLastBeat)begin
        curBeatBytes = colRemainByteCntReg[2:0];
      end else begin
        curBeatBytes = 3'b100;
      end
    end
  end

  always @ (*) begin
    case(alignOffsetReg)
      2'b00 : begin
        payload = io_din_payload[31 : 0];
      end
      2'b01 : begin
        payload = {io_din_payload[23 : 0],dinPrevReg[31 : 24]};
      end
      2'b10 : begin
        payload = {io_din_payload[15 : 0],dinPrevReg[31 : 16]};
      end
      default : begin
        payload = {io_din_payload[7 : 0],dinPrevReg[31 : 8]};
      end
    endcase
  end

  always @ (*) begin
    fsmW_stateNext = fsmW_stateReg;
    case(fsmW_stateReg)
      `fsmW_enumDefinition_binary_sequential_fsmW_IDLE : begin
        if(_zz_7)begin
          fsmW_stateNext = `fsmW_enumDefinition_binary_sequential_fsmW_W;
        end
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_W : begin
        if(runSignal)begin
          if(_zz_5)begin
            if(io_axiW_w_payload_last)begin
              fsmW_stateNext = `fsmW_enumDefinition_binary_sequential_fsmW_B;
            end else begin
              if(((alignOffsetReg != 2'b00) && (colRemainByteCntNxt < 8'h04)))begin
                fsmW_stateNext = `fsmW_enumDefinition_binary_sequential_fsmW_LAST;
              end
            end
          end
        end
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_LAST : begin
        if(_zz_6)begin
          fsmW_stateNext = `fsmW_enumDefinition_binary_sequential_fsmW_B;
        end
      end
      `fsmW_enumDefinition_binary_sequential_fsmW_B : begin
        if(_zz_1)begin
          if(_zz_2)begin
            fsmW_stateNext = `fsmW_enumDefinition_binary_sequential_fsmW_W;
          end else begin
            if(_zz_3)begin
              fsmW_stateNext = `fsmW_enumDefinition_binary_sequential_fsmW_W;
            end else begin
              fsmW_stateNext = `fsmW_enumDefinition_binary_sequential_fsmW_IDLE;
            end
          end
        end
      end
      default : begin
      end
    endcase
    if(fsmW_wantStart)begin
      fsmW_stateNext = `fsmW_enumDefinition_binary_sequential_fsmW_IDLE;
    end
  end

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      busyReg <= 1'b0;
      awValidReg <= 1'b0;
      burstLenReg <= 8'h0;
      curRowAddrReg <= 32'h0;
      alignOffsetReg <= 2'b00;
      curAlignedAddrReg <= 32'h0;
      beatCnt_value <= 4'b0000;
      bReadyReg <= 1'b0;
      dinPrevReg <= 32'h0;
      rowWriteCntReg <= 8'h0;
      colByteWriteCntReg <= 8'h0;
      colRemainByteCntReg <= io_param_xsize;
      rowFirstBurstReg <= 1'b0;
      rowFirstBeatReg <= 1'b0;
      fsmW_stateReg <= `fsmW_enumDefinition_binary_sequential_fsmW_BOOT;
    end else begin
      if(io_ctrl_start)begin
        busyReg <= 1'b1;
      end else begin
        if(io_ctrl_done)begin
          busyReg <= 1'b0;
        end
      end
      beatCnt_value <= beatCnt_valueNext;
      if((io_din_valid && io_din_ready))begin
        dinPrevReg <= io_din_payload;
      end
      fsmW_stateReg <= fsmW_stateNext;
      case(fsmW_stateReg)
        `fsmW_enumDefinition_binary_sequential_fsmW_IDLE : begin
          awValidReg <= 1'b0;
          alignOffsetReg <= 2'b00;
          burstLenReg <= 8'h0;
          curRowAddrReg <= (io_param_dar - _zz_35);
          curAlignedAddrReg <= 32'h0;
          bReadyReg <= 1'b0;
          dinPrevReg <= 32'h0;
          rowFirstBurstReg <= 1'b0;
          rowFirstBeatReg <= 1'b0;
          rowWriteCntReg <= 8'h0;
          colByteWriteCntReg <= 8'h0;
          colRemainByteCntReg <= io_param_xsize;
          if(_zz_7)begin
            awValidReg <= 1'b1;
            alignOffsetReg <= alignOffsetNxt;
            burstLenReg <= nxtBurstLen;
            curRowAddrReg <= io_param_dar;
            curAlignedAddrReg <= (io_param_dar - _zz_36);
            rowFirstBeatReg <= 1'b1;
            rowFirstBurstReg <= 1'b1;
          end
        end
        `fsmW_enumDefinition_binary_sequential_fsmW_W : begin
          if(((runSignal && io_axiW_aw_valid) && io_axiW_aw_ready))begin
            awValidReg <= 1'b0;
          end
          if(_zz_4)begin
            colByteWriteCntReg <= colByteWriteCntNxt;
            colRemainByteCntReg <= colRemainByteCntNxt;
            rowFirstBeatReg <= 1'b0;
          end
          if(runSignal)begin
            if(_zz_5)begin
              if(io_axiW_w_payload_last)begin
                rowFirstBurstReg <= 1'b0;
                bReadyReg <= 1'b1;
              end
            end
          end
        end
        `fsmW_enumDefinition_binary_sequential_fsmW_LAST : begin
          if(_zz_6)begin
            rowFirstBurstReg <= 1'b0;
            bReadyReg <= 1'b1;
          end
        end
        `fsmW_enumDefinition_binary_sequential_fsmW_B : begin
          if(_zz_1)begin
            bReadyReg <= 1'b0;
            burstLenReg <= nxtBurstLen;
            if(_zz_2)begin
              curAlignedAddrReg <= nxtAlignedAddr;
              awValidReg <= 1'b1;
            end else begin
              colByteWriteCntReg <= 8'h0;
              colRemainByteCntReg <= io_param_xsize;
              if(_zz_3)begin
                rowWriteCntReg <= rowWriteCntNxt;
                rowFirstBeatReg <= 1'b1;
                rowFirstBurstReg <= 1'b1;
                alignOffsetReg <= alignOffsetNxt;
                curAlignedAddrReg <= (nxtRowAddr - _zz_37);
                curRowAddrReg <= nxtRowAddr;
                awValidReg <= 1'b1;
              end
            end
          end
        end
        default : begin
        end
      endcase
    end
  end


endmodule

module DmaRead (
  output              io_dout_valid,
  input               io_dout_ready,
  output     [31:0]   io_dout_payload,
  input      [31:0]   io_param_sar,
  input      [31:0]   io_param_dar,
  input      [7:0]    io_param_xsize,
  input      [7:0]    io_param_ysize,
  input      [7:0]    io_param_srcystep,
  input      [7:0]    io_param_dstystep,
  input      [31:0]   io_param_llr,
  input               io_param_bf,
  input               io_param_cf,
  output              io_axiR_ar_valid,
  input               io_axiR_ar_ready,
  output     [31:0]   io_axiR_ar_payload_addr,
  output     [3:0]    io_axiR_ar_payload_id,
  output     [7:0]    io_axiR_ar_payload_len,
  output     [2:0]    io_axiR_ar_payload_size,
  output     [1:0]    io_axiR_ar_payload_burst,
  input               io_axiR_r_valid,
  output              io_axiR_r_ready,
  input      [31:0]   io_axiR_r_payload_data,
  input      [3:0]    io_axiR_r_payload_id,
  input      [1:0]    io_axiR_r_payload_resp,
  input               io_axiR_r_payload_last,
  input               io_ctrl_start,
  output              io_ctrl_busy,
  output reg          io_ctrl_done,
  input               io_ctrl_halt,
  input               clk,
  input               reset
);
  wire                _zz_1;
  wire                _zz_2;
  wire                _zz_3;
  wire                _zz_4;
  wire                _zz_5;
  wire                _zz_6;
  wire                _zz_7;
  wire                _zz_8;
  wire                _zz_9;
  wire       [31:0]   _zz_10;
  wire       [9:0]    _zz_11;
  wire       [31:0]   _zz_12;
  wire       [31:0]   _zz_13;
  wire       [7:0]    _zz_14;
  wire       [7:0]    _zz_15;
  wire       [31:0]   _zz_16;
  wire       [11:0]   _zz_17;
  wire       [12:0]   _zz_18;
  wire       [7:0]    _zz_19;
  wire       [12:0]   _zz_20;
  wire       [10:0]   _zz_21;
  wire       [5:0]    _zz_22;
  wire       [5:0]    _zz_23;
  wire       [5:0]    _zz_24;
  wire       [5:0]    _zz_25;
  wire       [5:0]    _zz_26;
  wire       [5:0]    _zz_27;
  wire       [2:0]    _zz_28;
  wire       [31:0]   _zz_29;
  wire       [31:0]   _zz_30;
  wire       [31:0]   _zz_31;
  wire       [31:0]   _zz_32;
  reg                 busyReg;
  reg                 arValidReg;
  reg        [7:0]    burstLenReg;
  reg        [7:0]    nxtBurstLen;
  reg        [31:0]   curRowAddrReg;
  reg        [1:0]    alignOffsetReg;
  wire       [1:0]    alignOffsetNxt;
  reg        [31:0]   curAlignedAddrReg;
  wire       [31:0]   curAlignedRowAddr;
  wire       [31:0]   nxtAlignedAddr;
  wire       [7:0]    srcRowGap;
  wire       [31:0]   nxtRowAddr;
  wire                runSignal;
  wire                idMatch;
  reg        [31:0]   dataPreReg;
  reg        [2:0]    curBeatBytes;
  reg        [31:0]   output_1;
  reg                 doutValid;
  reg                 rReady;
  reg        [7:0]    rowReadCntReg;
  wire       [7:0]    rowReadCntNxt;
  reg        [7:0]    colByteReadCntReg;
  wire       [7:0]    colByteReadCntNxt;
  reg        [7:0]    colRemainByteCntReg;
  wire       [7:0]    colRemainByteCntNxt;
  reg                 rowFirstBurstReg;
  reg                 rowFirstBeatReg;
  reg                 nxtRow;
  wire                fsmR_wantExit;
  reg                 fsmR_wantStart;
  wire       [31:0]   computeNextReadBurstLen_nxtAlignedRowAddr;
  wire       [12:0]   computeNextReadBurstLen_tmpBurstByteSizeIn4K;
  wire       [7:0]    computeNextReadBurstLen_nxtAlignedRowByteSize;
  wire                computeNextReadBurstLen_rowCross4K;
  reg        `fsmR_enumDefinition_binary_sequential_type fsmR_stateReg;
  reg        `fsmR_enumDefinition_binary_sequential_type fsmR_stateNext;
  `ifndef SYNTHESIS
  reg [71:0] fsmR_stateReg_string;
  reg [71:0] fsmR_stateNext_string;
  `endif


  assign _zz_1 = (((runSignal && io_axiR_r_valid) && io_axiR_r_ready) && io_axiR_r_payload_last);
  assign _zz_2 = (colByteReadCntNxt < io_param_xsize);
  assign _zz_3 = (alignOffsetReg != 2'b00);
  assign _zz_4 = (rowReadCntNxt < io_param_ysize);
  assign _zz_5 = ((runSignal && io_dout_valid) && io_dout_ready);
  assign _zz_6 = (rowReadCntNxt < io_param_ysize);
  assign _zz_7 = (runSignal && io_ctrl_start);
  assign _zz_8 = ((runSignal && io_axiR_ar_valid) && io_axiR_ar_ready);
  assign _zz_9 = ((runSignal && io_axiR_r_valid) && io_axiR_r_ready);
  assign _zz_10 = {30'd0, alignOffsetReg};
  assign _zz_11 = ({2'd0,burstLenReg} <<< 2);
  assign _zz_12 = {22'd0, _zz_11};
  assign _zz_13 = {24'd0, srcRowGap};
  assign _zz_14 = {5'd0, curBeatBytes};
  assign _zz_15 = {5'd0, curBeatBytes};
  assign _zz_16 = {30'd0, alignOffsetNxt};
  assign _zz_17 = computeNextReadBurstLen_nxtAlignedRowAddr[11 : 0];
  assign _zz_18 = {1'd0, _zz_17};
  assign _zz_19 = {6'd0, alignOffsetNxt};
  assign _zz_20 = {5'd0, computeNextReadBurstLen_nxtAlignedRowByteSize};
  assign _zz_21 = (computeNextReadBurstLen_tmpBurstByteSizeIn4K >>> 2);
  assign _zz_22 = (_zz_23 + 6'h01);
  assign _zz_23 = (computeNextReadBurstLen_nxtAlignedRowByteSize >>> 2);
  assign _zz_24 = (computeNextReadBurstLen_nxtAlignedRowByteSize >>> 2);
  assign _zz_25 = (_zz_26 + 6'h01);
  assign _zz_26 = (colRemainByteCntNxt >>> 2);
  assign _zz_27 = (colRemainByteCntNxt >>> 2);
  assign _zz_28 = {1'd0, alignOffsetReg};
  assign _zz_29 = {24'd0, srcRowGap};
  assign _zz_30 = {30'd0, alignOffsetNxt};
  assign _zz_31 = {30'd0, alignOffsetNxt};
  assign _zz_32 = {30'd0, alignOffsetNxt};
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsmR_stateReg)
      `fsmR_enumDefinition_binary_sequential_fsmR_BOOT : fsmR_stateReg_string = "fsmR_BOOT";
      `fsmR_enumDefinition_binary_sequential_fsmR_IDLE : fsmR_stateReg_string = "fsmR_IDLE";
      `fsmR_enumDefinition_binary_sequential_fsmR_AR : fsmR_stateReg_string = "fsmR_AR  ";
      `fsmR_enumDefinition_binary_sequential_fsmR_FR : fsmR_stateReg_string = "fsmR_FR  ";
      `fsmR_enumDefinition_binary_sequential_fsmR_BR : fsmR_stateReg_string = "fsmR_BR  ";
      `fsmR_enumDefinition_binary_sequential_fsmR_LAST : fsmR_stateReg_string = "fsmR_LAST";
      default : fsmR_stateReg_string = "?????????";
    endcase
  end
  always @(*) begin
    case(fsmR_stateNext)
      `fsmR_enumDefinition_binary_sequential_fsmR_BOOT : fsmR_stateNext_string = "fsmR_BOOT";
      `fsmR_enumDefinition_binary_sequential_fsmR_IDLE : fsmR_stateNext_string = "fsmR_IDLE";
      `fsmR_enumDefinition_binary_sequential_fsmR_AR : fsmR_stateNext_string = "fsmR_AR  ";
      `fsmR_enumDefinition_binary_sequential_fsmR_FR : fsmR_stateNext_string = "fsmR_FR  ";
      `fsmR_enumDefinition_binary_sequential_fsmR_BR : fsmR_stateNext_string = "fsmR_BR  ";
      `fsmR_enumDefinition_binary_sequential_fsmR_LAST : fsmR_stateNext_string = "fsmR_LAST";
      default : fsmR_stateNext_string = "?????????";
    endcase
  end
  `endif

  always @ (*) begin
    io_ctrl_done = 1'b0;
    case(fsmR_stateReg)
      `fsmR_enumDefinition_binary_sequential_fsmR_IDLE : begin
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_AR : begin
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_FR : begin
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_BR : begin
        if(_zz_1)begin
          if(! _zz_2) begin
            if(! _zz_3) begin
              if(! _zz_4) begin
                io_ctrl_done = 1'b1;
              end
            end
          end
        end
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_LAST : begin
        if(_zz_5)begin
          if(! _zz_6) begin
            io_ctrl_done = 1'b1;
          end
        end
      end
      default : begin
      end
    endcase
  end

  assign io_ctrl_busy = busyReg;
  assign curAlignedRowAddr = (curRowAddrReg - _zz_10);
  assign nxtAlignedAddr = (curAlignedAddrReg + _zz_12);
  assign srcRowGap = (io_param_xsize + io_param_srcystep);
  assign nxtRowAddr = (curRowAddrReg + _zz_13);
  assign runSignal = (! io_ctrl_halt);
  assign idMatch = (io_axiR_r_payload_id == 4'b0011);
  assign io_axiR_ar_payload_id = 4'b0011;
  assign io_axiR_ar_payload_addr = curAlignedAddrReg;
  assign io_axiR_ar_payload_len = (burstLenReg - 8'h01);
  assign io_axiR_ar_payload_size = 3'b101;
  assign io_axiR_ar_payload_burst = 2'b01;
  assign io_axiR_ar_valid = arValidReg;
  always @ (*) begin
    doutValid = 1'b0;
    case(fsmR_stateReg)
      `fsmR_enumDefinition_binary_sequential_fsmR_IDLE : begin
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_AR : begin
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_FR : begin
        doutValid = 1'b0;
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_BR : begin
        doutValid = io_axiR_r_valid;
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_LAST : begin
        doutValid = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    rReady = 1'b0;
    case(fsmR_stateReg)
      `fsmR_enumDefinition_binary_sequential_fsmR_IDLE : begin
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_AR : begin
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_FR : begin
        rReady = 1'b1;
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_BR : begin
        rReady = io_dout_ready;
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_LAST : begin
        rReady = 1'b0;
      end
      default : begin
      end
    endcase
  end

  assign io_dout_valid = doutValid;
  assign io_axiR_r_ready = rReady;
  assign io_dout_payload = output_1;
  assign rowReadCntNxt = (rowReadCntReg + 8'h01);
  assign colByteReadCntNxt = (colByteReadCntReg + _zz_14);
  assign colRemainByteCntNxt = (colRemainByteCntReg - _zz_15);
  always @ (*) begin
    nxtRow = 1'b0;
    case(fsmR_stateReg)
      `fsmR_enumDefinition_binary_sequential_fsmR_IDLE : begin
        if(_zz_7)begin
          nxtRow = 1'b1;
        end
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_AR : begin
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_FR : begin
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_BR : begin
        if(_zz_1)begin
          if(! _zz_2) begin
            if(! _zz_3) begin
              if(_zz_4)begin
                nxtRow = 1'b1;
              end
            end
          end
        end
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_LAST : begin
        if(_zz_5)begin
          if(_zz_6)begin
            nxtRow = 1'b1;
          end
        end
      end
      default : begin
      end
    endcase
  end

  assign fsmR_wantExit = 1'b0;
  always @ (*) begin
    fsmR_wantStart = 1'b0;
    case(fsmR_stateReg)
      `fsmR_enumDefinition_binary_sequential_fsmR_IDLE : begin
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_AR : begin
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_FR : begin
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_BR : begin
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_LAST : begin
      end
      default : begin
        fsmR_wantStart = 1'b1;
      end
    endcase
  end

  assign alignOffsetNxt = nxtRowAddr[1 : 0];
  assign computeNextReadBurstLen_nxtAlignedRowAddr = (nxtRowAddr - _zz_16);
  assign computeNextReadBurstLen_tmpBurstByteSizeIn4K = (13'h1000 - _zz_18);
  assign computeNextReadBurstLen_nxtAlignedRowByteSize = (io_param_xsize + _zz_19);
  assign computeNextReadBurstLen_rowCross4K = ((computeNextReadBurstLen_tmpBurstByteSizeIn4K < 13'h0020) && (computeNextReadBurstLen_tmpBurstByteSizeIn4K < _zz_20));
  always @ (*) begin
    if(nxtRow)begin
      if(computeNextReadBurstLen_rowCross4K)begin
        nxtBurstLen = _zz_21[7:0];
      end else begin
        if((8'h20 < computeNextReadBurstLen_nxtAlignedRowByteSize))begin
          nxtBurstLen = 8'h08;
        end else begin
          if((computeNextReadBurstLen_nxtAlignedRowByteSize[1 : 0] != 2'b00))begin
            nxtBurstLen = {2'd0, _zz_22};
          end else begin
            nxtBurstLen = {2'd0, _zz_24};
          end
        end
      end
    end else begin
      if((colRemainByteCntNxt < 8'h20))begin
        if((colRemainByteCntReg[1 : 0] != 2'b00))begin
          nxtBurstLen = {2'd0, _zz_25};
        end else begin
          nxtBurstLen = {2'd0, _zz_27};
        end
      end else begin
        nxtBurstLen = 8'h08;
      end
    end
  end

  always @ (*) begin
    if(rowFirstBeatReg)begin
      curBeatBytes = (3'b100 - _zz_28);
    end else begin
      curBeatBytes = 3'b100;
    end
  end

  always @ (*) begin
    if((alignOffsetReg != 2'b00))begin
      case(alignOffsetReg)
        2'b00 : begin
          output_1 = dataPreReg[31 : 0];
        end
        2'b01 : begin
          output_1 = {io_axiR_r_payload_data[7 : 0],dataPreReg[31 : 8]};
        end
        2'b10 : begin
          output_1 = {io_axiR_r_payload_data[15 : 0],dataPreReg[31 : 16]};
        end
        default : begin
          output_1 = {io_axiR_r_payload_data[23 : 0],dataPreReg[31 : 24]};
        end
      endcase
    end else begin
      output_1 = io_axiR_r_payload_data;
    end
  end

  always @ (*) begin
    fsmR_stateNext = fsmR_stateReg;
    case(fsmR_stateReg)
      `fsmR_enumDefinition_binary_sequential_fsmR_IDLE : begin
        if(_zz_7)begin
          fsmR_stateNext = `fsmR_enumDefinition_binary_sequential_fsmR_AR;
        end
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_AR : begin
        if(_zz_8)begin
          if(((alignOffsetReg != 2'b00) && rowFirstBeatReg))begin
            fsmR_stateNext = `fsmR_enumDefinition_binary_sequential_fsmR_FR;
          end else begin
            fsmR_stateNext = `fsmR_enumDefinition_binary_sequential_fsmR_BR;
          end
        end
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_FR : begin
        if(_zz_9)begin
          if(io_axiR_r_payload_last)begin
            fsmR_stateNext = `fsmR_enumDefinition_binary_sequential_fsmR_AR;
          end else begin
            fsmR_stateNext = `fsmR_enumDefinition_binary_sequential_fsmR_BR;
          end
        end
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_BR : begin
        if(_zz_1)begin
          if(_zz_2)begin
            fsmR_stateNext = `fsmR_enumDefinition_binary_sequential_fsmR_AR;
          end else begin
            if(_zz_3)begin
              fsmR_stateNext = `fsmR_enumDefinition_binary_sequential_fsmR_LAST;
            end else begin
              if(_zz_4)begin
                fsmR_stateNext = `fsmR_enumDefinition_binary_sequential_fsmR_AR;
              end else begin
                fsmR_stateNext = `fsmR_enumDefinition_binary_sequential_fsmR_IDLE;
              end
            end
          end
        end
      end
      `fsmR_enumDefinition_binary_sequential_fsmR_LAST : begin
        if(_zz_5)begin
          if(_zz_6)begin
            fsmR_stateNext = `fsmR_enumDefinition_binary_sequential_fsmR_AR;
          end else begin
            fsmR_stateNext = `fsmR_enumDefinition_binary_sequential_fsmR_IDLE;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsmR_wantStart)begin
      fsmR_stateNext = `fsmR_enumDefinition_binary_sequential_fsmR_IDLE;
    end
  end

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      busyReg <= 1'b0;
      arValidReg <= 1'b0;
      burstLenReg <= 8'h0;
      curRowAddrReg <= 32'h0;
      alignOffsetReg <= 2'b00;
      curAlignedAddrReg <= 32'h0;
      dataPreReg <= 32'h0;
      rowReadCntReg <= 8'h0;
      colByteReadCntReg <= 8'h0;
      colRemainByteCntReg <= io_param_xsize;
      rowFirstBurstReg <= 1'b0;
      rowFirstBeatReg <= 1'b0;
      fsmR_stateReg <= `fsmR_enumDefinition_binary_sequential_fsmR_BOOT;
    end else begin
      if(io_ctrl_start)begin
        busyReg <= 1'b1;
      end else begin
        if(io_ctrl_done)begin
          busyReg <= 1'b0;
        end
      end
      if(((runSignal && io_axiR_r_valid) && io_axiR_r_ready))begin
        dataPreReg <= io_axiR_r_payload_data;
      end
      fsmR_stateReg <= fsmR_stateNext;
      case(fsmR_stateReg)
        `fsmR_enumDefinition_binary_sequential_fsmR_IDLE : begin
          arValidReg <= 1'b0;
          alignOffsetReg <= 2'b00;
          burstLenReg <= 8'h0;
          curRowAddrReg <= (io_param_sar - _zz_29);
          curAlignedAddrReg <= 32'h0;
          dataPreReg <= 32'h0;
          rowFirstBurstReg <= 1'b0;
          rowFirstBeatReg <= 1'b0;
          rowReadCntReg <= 8'h0;
          colByteReadCntReg <= 8'h0;
          colRemainByteCntReg <= io_param_xsize;
          if(_zz_7)begin
            arValidReg <= 1'b1;
            alignOffsetReg <= alignOffsetNxt;
            burstLenReg <= nxtBurstLen;
            curRowAddrReg <= io_param_sar;
            curAlignedAddrReg <= (io_param_sar - _zz_30);
            rowFirstBeatReg <= 1'b1;
            rowFirstBurstReg <= 1'b1;
          end
        end
        `fsmR_enumDefinition_binary_sequential_fsmR_AR : begin
          if(_zz_8)begin
            arValidReg <= 1'b0;
          end
        end
        `fsmR_enumDefinition_binary_sequential_fsmR_FR : begin
          if(_zz_9)begin
            colByteReadCntReg <= colByteReadCntNxt;
            colRemainByteCntReg <= colRemainByteCntNxt;
            rowFirstBeatReg <= 1'b0;
            if(io_axiR_r_payload_last)begin
              curAlignedAddrReg <= nxtAlignedAddr;
              burstLenReg <= nxtBurstLen;
              arValidReg <= 1'b1;
            end
          end
        end
        `fsmR_enumDefinition_binary_sequential_fsmR_BR : begin
          if(((runSignal && io_axiR_r_valid) && io_axiR_r_ready))begin
            colByteReadCntReg <= colByteReadCntNxt;
            colRemainByteCntReg <= colRemainByteCntNxt;
            rowFirstBeatReg <= 1'b0;
          end
          if(_zz_1)begin
            rowFirstBurstReg <= 1'b0;
            if(_zz_2)begin
              curAlignedAddrReg <= nxtAlignedAddr;
              burstLenReg <= nxtBurstLen;
              arValidReg <= 1'b1;
            end else begin
              colByteReadCntReg <= 8'h0;
              colRemainByteCntReg <= io_param_xsize;
              if(! _zz_3) begin
                if(_zz_4)begin
                  burstLenReg <= nxtBurstLen;
                  rowReadCntReg <= rowReadCntNxt;
                  rowFirstBeatReg <= 1'b1;
                  rowFirstBurstReg <= 1'b1;
                  alignOffsetReg <= alignOffsetNxt;
                  curAlignedAddrReg <= (nxtRowAddr - _zz_31);
                  curRowAddrReg <= nxtRowAddr;
                  arValidReg <= 1'b1;
                end
              end
            end
          end
        end
        `fsmR_enumDefinition_binary_sequential_fsmR_LAST : begin
          if(_zz_5)begin
            if(_zz_6)begin
              burstLenReg <= nxtBurstLen;
              rowReadCntReg <= rowReadCntNxt;
              rowFirstBeatReg <= 1'b1;
              rowFirstBurstReg <= 1'b1;
              alignOffsetReg <= alignOffsetNxt;
              curAlignedAddrReg <= (nxtRowAddr - _zz_32);
              curRowAddrReg <= nxtRowAddr;
              arValidReg <= 1'b1;
            end
          end
        end
        default : begin
        end
      endcase
    end
  end


endmodule
