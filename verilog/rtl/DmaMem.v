// Generator : SpinalHDL v1.4.3    git head : 4dd3b62906925bc269aee976e75f8918d4132efb
// Component : DmaMem
// Git hash  : f48be781e668caa4d53186beb7dec459d98a9f2d


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

`define readFsm_enumDefinition_binary_sequential_type [1:0]
`define readFsm_enumDefinition_binary_sequential_readFsm_BOOT 2'b00
`define readFsm_enumDefinition_binary_sequential_readFsm_ACTIVE 2'b01
`define readFsm_enumDefinition_binary_sequential_readFsm_SEND_READ_CMD 2'b10
`define readFsm_enumDefinition_binary_sequential_readFsm_BURST_READ 2'b11

`define initFsm_enumDefinition_binary_sequential_type [2:0]
`define initFsm_enumDefinition_binary_sequential_initFsm_BOOT 3'b000
`define initFsm_enumDefinition_binary_sequential_initFsm_INIT_WAIT 3'b001
`define initFsm_enumDefinition_binary_sequential_initFsm_INIT_PRECHARGE 3'b010
`define initFsm_enumDefinition_binary_sequential_initFsm_INIT_REFRESH_1 3'b011
`define initFsm_enumDefinition_binary_sequential_initFsm_INIT_REFRESH_2 3'b100
`define initFsm_enumDefinition_binary_sequential_initFsm_INIT_LOAD_MODE_REG 3'b101

`define writeFsm_enumDefinition_binary_sequential_type [1:0]
`define writeFsm_enumDefinition_binary_sequential_writeFsm_BOOT 2'b00
`define writeFsm_enumDefinition_binary_sequential_writeFsm_ACTIVE_WRITE 2'b01
`define writeFsm_enumDefinition_binary_sequential_writeFsm_BURST_WRITE 2'b10
`define writeFsm_enumDefinition_binary_sequential_writeFsm_TERM_WRITE 2'b11

`define refreshFsm_enumDefinition_binary_sequential_type [1:0]
`define refreshFsm_enumDefinition_binary_sequential_refreshFsm_BOOT 2'b00
`define refreshFsm_enumDefinition_binary_sequential_refreshFsm_REFRESH_PRECHARGE 2'b01
`define refreshFsm_enumDefinition_binary_sequential_refreshFsm_REFRESH 2'b10

`define fsm_enumDefinition_binary_sequential_type [2:0]
`define fsm_enumDefinition_binary_sequential_fsm_BOOT 3'b000
`define fsm_enumDefinition_binary_sequential_fsm_INIT 3'b001
`define fsm_enumDefinition_binary_sequential_fsm_IDLE 3'b010
`define fsm_enumDefinition_binary_sequential_fsm_REFRESH 3'b011
`define fsm_enumDefinition_binary_sequential_fsm_WRITE 3'b100
`define fsm_enumDefinition_binary_sequential_fsm_READ 3'b101
`define fsm_enumDefinition_binary_sequential_fsm_PRECHARGE 3'b110


module DmaMem (
  input               io_ctrl_start,
  output              io_ctrl_busy,
  output              io_ctrl_done,
  input               io_ctrl_halt,
  output     [12:0]   io_sdram_ADDR,
  output     [1:0]    io_sdram_BA,
  input      [15:0]   io_sdram_DQ_read,
  output     [15:0]   io_sdram_DQ_write,
  output     [15:0]   io_sdram_DQ_writeEnable,
  output     [1:0]    io_sdram_DQM,
  output              io_sdram_CASn,
  output              io_sdram_CKE,
  output              io_sdram_CSn,
  output              io_sdram_RASn,
  output              io_sdram_WEn,
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
  wire       [31:0]   _zz_1;
  wire       [31:0]   _zz_2;
  wire       [7:0]    _zz_3;
  wire       [7:0]    _zz_4;
  wire       [7:0]    _zz_5;
  wire       [7:0]    _zz_6;
  wire       [31:0]   _zz_7;
  wire                _zz_8;
  wire                _zz_9;
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
  wire                sdramArea_sdramController_io_axi_ar_ready;
  wire                sdramArea_sdramController_io_axi_aw_ready;
  wire                sdramArea_sdramController_io_axi_w_ready;
  wire                sdramArea_sdramController_io_axi_r_valid;
  wire       [31:0]   sdramArea_sdramController_io_axi_r_payload_data;
  wire       [3:0]    sdramArea_sdramController_io_axi_r_payload_id;
  wire       [1:0]    sdramArea_sdramController_io_axi_r_payload_resp;
  wire                sdramArea_sdramController_io_axi_r_payload_last;
  wire                sdramArea_sdramController_io_axi_b_valid;
  wire       [3:0]    sdramArea_sdramController_io_axi_b_payload_id;
  wire       [1:0]    sdramArea_sdramController_io_axi_b_payload_resp;
  wire       [12:0]   sdramArea_sdramController_io_sdram_ADDR;
  wire       [1:0]    sdramArea_sdramController_io_sdram_BA;
  wire                sdramArea_sdramController_io_sdram_CASn;
  wire                sdramArea_sdramController_io_sdram_CKE;
  wire                sdramArea_sdramController_io_sdram_CSn;
  wire       [1:0]    sdramArea_sdramController_io_sdram_DQM;
  wire                sdramArea_sdramController_io_sdram_RASn;
  wire                sdramArea_sdramController_io_sdram_WEn;
  wire       [15:0]   sdramArea_sdramController_io_sdram_DQ_write;
  wire       [15:0]   sdramArea_sdramController_io_sdram_DQ_writeEnable;
  wire                sdramArea_sdramController_io_initDone;
  reg                 busif_readError;
  reg        [31:0]   busif_readData;
  wire                busif_selMatch;
  wire                busif_askWrite;
  wire                busif_askRead;
  wire                busif_doWrite;
  wire                busif_doRead;
  reg        [31:0]   srcAddr;
  reg        [31:0]   dstAddr;

  Dma dmaArea_dma (
    .io_param_sar               (_zz_1[31:0]                                            ), //i
    .io_param_dar               (_zz_2[31:0]                                            ), //i
    .io_param_xsize             (_zz_3[7:0]                                             ), //i
    .io_param_ysize             (_zz_4[7:0]                                             ), //i
    .io_param_srcystep          (_zz_5[7:0]                                             ), //i
    .io_param_dstystep          (_zz_6[7:0]                                             ), //i
    .io_param_llr               (_zz_7[31:0]                                            ), //i
    .io_param_bf                (_zz_8                                                  ), //i
    .io_param_cf                (_zz_9                                                  ), //i
    .io_axi_aw_valid            (dmaArea_dma_io_axi_aw_valid                            ), //o
    .io_axi_aw_ready            (sdramArea_sdramController_io_axi_aw_ready              ), //i
    .io_axi_aw_payload_addr     (dmaArea_dma_io_axi_aw_payload_addr[31:0]               ), //o
    .io_axi_aw_payload_id       (dmaArea_dma_io_axi_aw_payload_id[3:0]                  ), //o
    .io_axi_aw_payload_len      (dmaArea_dma_io_axi_aw_payload_len[7:0]                 ), //o
    .io_axi_aw_payload_size     (dmaArea_dma_io_axi_aw_payload_size[2:0]                ), //o
    .io_axi_aw_payload_burst    (dmaArea_dma_io_axi_aw_payload_burst[1:0]               ), //o
    .io_axi_w_valid             (dmaArea_dma_io_axi_w_valid                             ), //o
    .io_axi_w_ready             (sdramArea_sdramController_io_axi_w_ready               ), //i
    .io_axi_w_payload_data      (dmaArea_dma_io_axi_w_payload_data[31:0]                ), //o
    .io_axi_w_payload_strb      (dmaArea_dma_io_axi_w_payload_strb[3:0]                 ), //o
    .io_axi_w_payload_last      (dmaArea_dma_io_axi_w_payload_last                      ), //o
    .io_axi_b_valid             (sdramArea_sdramController_io_axi_b_valid               ), //i
    .io_axi_b_ready             (dmaArea_dma_io_axi_b_ready                             ), //o
    .io_axi_b_payload_id        (sdramArea_sdramController_io_axi_b_payload_id[3:0]     ), //i
    .io_axi_b_payload_resp      (sdramArea_sdramController_io_axi_b_payload_resp[1:0]   ), //i
    .io_axi_ar_valid            (dmaArea_dma_io_axi_ar_valid                            ), //o
    .io_axi_ar_ready            (sdramArea_sdramController_io_axi_ar_ready              ), //i
    .io_axi_ar_payload_addr     (dmaArea_dma_io_axi_ar_payload_addr[31:0]               ), //o
    .io_axi_ar_payload_id       (dmaArea_dma_io_axi_ar_payload_id[3:0]                  ), //o
    .io_axi_ar_payload_len      (dmaArea_dma_io_axi_ar_payload_len[7:0]                 ), //o
    .io_axi_ar_payload_size     (dmaArea_dma_io_axi_ar_payload_size[2:0]                ), //o
    .io_axi_ar_payload_burst    (dmaArea_dma_io_axi_ar_payload_burst[1:0]               ), //o
    .io_axi_r_valid             (sdramArea_sdramController_io_axi_r_valid               ), //i
    .io_axi_r_ready             (dmaArea_dma_io_axi_r_ready                             ), //o
    .io_axi_r_payload_data      (sdramArea_sdramController_io_axi_r_payload_data[31:0]  ), //i
    .io_axi_r_payload_id        (sdramArea_sdramController_io_axi_r_payload_id[3:0]     ), //i
    .io_axi_r_payload_resp      (sdramArea_sdramController_io_axi_r_payload_resp[1:0]   ), //i
    .io_axi_r_payload_last      (sdramArea_sdramController_io_axi_r_payload_last        ), //i
    .io_ctrl_start              (io_ctrl_start                                          ), //i
    .io_ctrl_busy               (dmaArea_dma_io_ctrl_busy                               ), //o
    .io_ctrl_done               (dmaArea_dma_io_ctrl_done                               ), //o
    .io_ctrl_halt               (io_ctrl_halt                                           ), //i
    .clk                        (clk                                                    ), //i
    .reset                      (reset                                                  )  //i
  );
  SdramController sdramArea_sdramController (
    .io_axi_aw_valid            (dmaArea_dma_io_axi_aw_valid                              ), //i
    .io_axi_aw_ready            (sdramArea_sdramController_io_axi_aw_ready                ), //o
    .io_axi_aw_payload_addr     (dmaArea_dma_io_axi_aw_payload_addr[31:0]                 ), //i
    .io_axi_aw_payload_id       (dmaArea_dma_io_axi_aw_payload_id[3:0]                    ), //i
    .io_axi_aw_payload_len      (dmaArea_dma_io_axi_aw_payload_len[7:0]                   ), //i
    .io_axi_aw_payload_size     (dmaArea_dma_io_axi_aw_payload_size[2:0]                  ), //i
    .io_axi_aw_payload_burst    (dmaArea_dma_io_axi_aw_payload_burst[1:0]                 ), //i
    .io_axi_w_valid             (dmaArea_dma_io_axi_w_valid                               ), //i
    .io_axi_w_ready             (sdramArea_sdramController_io_axi_w_ready                 ), //o
    .io_axi_w_payload_data      (dmaArea_dma_io_axi_w_payload_data[31:0]                  ), //i
    .io_axi_w_payload_strb      (dmaArea_dma_io_axi_w_payload_strb[3:0]                   ), //i
    .io_axi_w_payload_last      (dmaArea_dma_io_axi_w_payload_last                        ), //i
    .io_axi_b_valid             (sdramArea_sdramController_io_axi_b_valid                 ), //o
    .io_axi_b_ready             (dmaArea_dma_io_axi_b_ready                               ), //i
    .io_axi_b_payload_id        (sdramArea_sdramController_io_axi_b_payload_id[3:0]       ), //o
    .io_axi_b_payload_resp      (sdramArea_sdramController_io_axi_b_payload_resp[1:0]     ), //o
    .io_axi_ar_valid            (dmaArea_dma_io_axi_ar_valid                              ), //i
    .io_axi_ar_ready            (sdramArea_sdramController_io_axi_ar_ready                ), //o
    .io_axi_ar_payload_addr     (dmaArea_dma_io_axi_ar_payload_addr[31:0]                 ), //i
    .io_axi_ar_payload_id       (dmaArea_dma_io_axi_ar_payload_id[3:0]                    ), //i
    .io_axi_ar_payload_len      (dmaArea_dma_io_axi_ar_payload_len[7:0]                   ), //i
    .io_axi_ar_payload_size     (dmaArea_dma_io_axi_ar_payload_size[2:0]                  ), //i
    .io_axi_ar_payload_burst    (dmaArea_dma_io_axi_ar_payload_burst[1:0]                 ), //i
    .io_axi_r_valid             (sdramArea_sdramController_io_axi_r_valid                 ), //o
    .io_axi_r_ready             (dmaArea_dma_io_axi_r_ready                               ), //i
    .io_axi_r_payload_data      (sdramArea_sdramController_io_axi_r_payload_data[31:0]    ), //o
    .io_axi_r_payload_id        (sdramArea_sdramController_io_axi_r_payload_id[3:0]       ), //o
    .io_axi_r_payload_resp      (sdramArea_sdramController_io_axi_r_payload_resp[1:0]     ), //o
    .io_axi_r_payload_last      (sdramArea_sdramController_io_axi_r_payload_last          ), //o
    .io_sdram_ADDR              (sdramArea_sdramController_io_sdram_ADDR[12:0]            ), //o
    .io_sdram_BA                (sdramArea_sdramController_io_sdram_BA[1:0]               ), //o
    .io_sdram_DQ_read           (io_sdram_DQ_read[15:0]                                   ), //i
    .io_sdram_DQ_write          (sdramArea_sdramController_io_sdram_DQ_write[15:0]        ), //o
    .io_sdram_DQ_writeEnable    (sdramArea_sdramController_io_sdram_DQ_writeEnable[15:0]  ), //o
    .io_sdram_DQM               (sdramArea_sdramController_io_sdram_DQM[1:0]              ), //o
    .io_sdram_CASn              (sdramArea_sdramController_io_sdram_CASn                  ), //o
    .io_sdram_CKE               (sdramArea_sdramController_io_sdram_CKE                   ), //o
    .io_sdram_CSn               (sdramArea_sdramController_io_sdram_CSn                   ), //o
    .io_sdram_RASn              (sdramArea_sdramController_io_sdram_RASn                  ), //o
    .io_sdram_WEn               (sdramArea_sdramController_io_sdram_WEn                   ), //o
    .io_initDone                (sdramArea_sdramController_io_initDone                    ), //o
    .clk                        (clk                                                      ), //i
    .reset                      (reset                                                    )  //i
  );
  assign io_wb_ACK = 1'b1;
  assign io_wb_DAT_MISO = busif_readData;
  assign busif_selMatch = io_wb_SEL[0];
  assign busif_askWrite = (((busif_selMatch && io_wb_CYC) && io_wb_STB) && io_wb_WE);
  assign busif_askRead = (((busif_selMatch && io_wb_CYC) && io_wb_STB) && (! io_wb_WE));
  assign busif_doWrite = ((((busif_selMatch && io_wb_CYC) && io_wb_STB) && io_wb_ACK) && io_wb_WE);
  assign busif_doRead = ((((busif_selMatch && io_wb_CYC) && io_wb_STB) && io_wb_ACK) && (! io_wb_WE));
  assign io_ctrl_busy = dmaArea_dma_io_ctrl_busy;
  assign io_ctrl_done = dmaArea_dma_io_ctrl_done;
  assign _zz_1 = srcAddr;
  assign _zz_2 = dstAddr;
  assign _zz_3 = 8'h08;
  assign _zz_4 = 8'h01;
  assign _zz_5 = 8'h0;
  assign _zz_6 = 8'h0;
  assign _zz_7 = 32'h0;
  assign _zz_8 = 1'b1;
  assign _zz_9 = 1'b1;
  assign io_sdram_ADDR = sdramArea_sdramController_io_sdram_ADDR;
  assign io_sdram_BA = sdramArea_sdramController_io_sdram_BA;
  assign io_sdram_DQ_write = sdramArea_sdramController_io_sdram_DQ_write;
  assign io_sdram_DQ_writeEnable = sdramArea_sdramController_io_sdram_DQ_writeEnable;
  assign io_sdram_DQM = sdramArea_sdramController_io_sdram_DQM;
  assign io_sdram_CASn = sdramArea_sdramController_io_sdram_CASn;
  assign io_sdram_CKE = sdramArea_sdramController_io_sdram_CKE;
  assign io_sdram_CSn = sdramArea_sdramController_io_sdram_CSn;
  assign io_sdram_RASn = sdramArea_sdramController_io_sdram_RASn;
  assign io_sdram_WEn = sdramArea_sdramController_io_sdram_WEn;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      busif_readError <= 1'b0;
      busif_readData <= 32'h0;
      srcAddr <= 32'h0;
      dstAddr <= 32'h0;
    end else begin
      if(((io_wb_ADR == 32'h0) && busif_doWrite))begin
        srcAddr <= io_wb_DAT_MISO[31 : 0];
      end
      if(((io_wb_ADR == 32'h00000004) && busif_doWrite))begin
        dstAddr <= io_wb_DAT_MISO[31 : 0];
      end
      if(busif_doRead)begin
        case(io_wb_ADR)
          32'h0 : begin
            busif_readData <= srcAddr;
            busif_readError <= 1'b0;
          end
          32'h00000004 : begin
            busif_readData <= dstAddr;
            busif_readError <= 1'b0;
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

module SdramController (
  (* IOB = "TRUE" *) input               io_axi_aw_valid,
  (* IOB = "TRUE" *) output              io_axi_aw_ready,
  (* IOB = "TRUE" *) input      [31:0]   io_axi_aw_payload_addr,
  (* IOB = "TRUE" *) input      [3:0]    io_axi_aw_payload_id,
  (* IOB = "TRUE" *) input      [7:0]    io_axi_aw_payload_len,
  (* IOB = "TRUE" *) input      [2:0]    io_axi_aw_payload_size,
  (* IOB = "TRUE" *) input      [1:0]    io_axi_aw_payload_burst,
  (* IOB = "TRUE" *) input               io_axi_w_valid,
  (* IOB = "TRUE" *) output              io_axi_w_ready,
  (* IOB = "TRUE" *) input      [31:0]   io_axi_w_payload_data,
  (* IOB = "TRUE" *) input      [3:0]    io_axi_w_payload_strb,
  (* IOB = "TRUE" *) input               io_axi_w_payload_last,
  (* IOB = "TRUE" *) output              io_axi_b_valid,
  (* IOB = "TRUE" *) input               io_axi_b_ready,
  (* IOB = "TRUE" *) output     [3:0]    io_axi_b_payload_id,
  (* IOB = "TRUE" *) output     [1:0]    io_axi_b_payload_resp,
  (* IOB = "TRUE" *) input               io_axi_ar_valid,
  (* IOB = "TRUE" *) output              io_axi_ar_ready,
  (* IOB = "TRUE" *) input      [31:0]   io_axi_ar_payload_addr,
  (* IOB = "TRUE" *) input      [3:0]    io_axi_ar_payload_id,
  (* IOB = "TRUE" *) input      [7:0]    io_axi_ar_payload_len,
  (* IOB = "TRUE" *) input      [2:0]    io_axi_ar_payload_size,
  (* IOB = "TRUE" *) input      [1:0]    io_axi_ar_payload_burst,
  (* IOB = "TRUE" *) output              io_axi_r_valid,
  (* IOB = "TRUE" *) input               io_axi_r_ready,
  (* IOB = "TRUE" *) output     [31:0]   io_axi_r_payload_data,
  (* IOB = "TRUE" *) output     [3:0]    io_axi_r_payload_id,
  (* IOB = "TRUE" *) output     [1:0]    io_axi_r_payload_resp,
  (* IOB = "TRUE" *) output              io_axi_r_payload_last,
  (* IOB = "TRUE" *) output     [12:0]   io_sdram_ADDR,
  (* IOB = "TRUE" *) output     [1:0]    io_sdram_BA,
  (* IOB = "TRUE" *) input      [15:0]   io_sdram_DQ_read,
  (* IOB = "TRUE" *) output     [15:0]   io_sdram_DQ_write,
  (* IOB = "TRUE" *) output reg [15:0]   io_sdram_DQ_writeEnable,
  (* IOB = "TRUE" *) output     [1:0]    io_sdram_DQM,
  (* IOB = "TRUE" *) output              io_sdram_CASn,
  (* IOB = "TRUE" *) output              io_sdram_CKE,
  (* IOB = "TRUE" *) output              io_sdram_CSn,
  (* IOB = "TRUE" *) output              io_sdram_RASn,
  (* IOB = "TRUE" *) output              io_sdram_WEn,
  (* IOB = "TRUE" *) output reg          io_initDone,
  input               clk,
  input               reset
);
  reg                 _zz_9;
  wire                _zz_10;
  reg                 _zz_11;
  wire                _zz_12;
  reg                 _zz_13;
  wire       [1:0]    _zz_14;
  wire                _zz_15;
  reg                 _zz_16;
  wire                _zz_17;
  wire       [1:0]    _zz_18;
  wire                _zz_19;
  wire                awFifo_io_push_ready;
  wire                awFifo_io_pop_valid;
  wire       [31:0]   awFifo_io_pop_payload_addr;
  wire       [3:0]    awFifo_io_pop_payload_id;
  wire       [7:0]    awFifo_io_pop_payload_len;
  wire       [2:0]    awFifo_io_pop_payload_size;
  wire       [1:0]    awFifo_io_pop_payload_burst;
  wire       [6:0]    awFifo_io_occupancy;
  wire       [6:0]    awFifo_io_availability;
  wire                wFifo_io_push_ready;
  wire                wFifo_io_pop_valid;
  wire       [31:0]   wFifo_io_pop_payload_data;
  wire       [3:0]    wFifo_io_pop_payload_strb;
  wire                wFifo_io_pop_payload_last;
  wire       [6:0]    wFifo_io_occupancy;
  wire       [6:0]    wFifo_io_availability;
  wire                bFifo_io_push_ready;
  wire                bFifo_io_pop_valid;
  wire       [3:0]    bFifo_io_pop_payload_id;
  wire       [1:0]    bFifo_io_pop_payload_resp;
  wire       [6:0]    bFifo_io_occupancy;
  wire       [6:0]    bFifo_io_availability;
  wire                arFifo_io_push_ready;
  wire                arFifo_io_pop_valid;
  wire       [31:0]   arFifo_io_pop_payload_addr;
  wire       [3:0]    arFifo_io_pop_payload_id;
  wire       [7:0]    arFifo_io_pop_payload_len;
  wire       [2:0]    arFifo_io_pop_payload_size;
  wire       [1:0]    arFifo_io_pop_payload_burst;
  wire       [6:0]    arFifo_io_occupancy;
  wire       [6:0]    arFifo_io_availability;
  wire                rFifo_io_push_ready;
  wire                rFifo_io_pop_valid;
  wire       [31:0]   rFifo_io_pop_payload_data;
  wire       [3:0]    rFifo_io_pop_payload_id;
  wire       [1:0]    rFifo_io_pop_payload_resp;
  wire                rFifo_io_pop_payload_last;
  wire       [6:0]    rFifo_io_occupancy;
  wire       [6:0]    rFifo_io_availability;
  wire                _zz_20;
  wire                _zz_21;
  wire                _zz_22;
  wire                _zz_23;
  wire                _zz_24;
  wire                _zz_25;
  wire                _zz_26;
  wire                _zz_27;
  wire                _zz_28;
  wire       [0:0]    _zz_29;
  wire       [9:0]    _zz_30;
  wire       [7:0]    _zz_31;
  wire       [7:0]    _zz_32;
  wire       [8:0]    _zz_33;
  wire       [7:0]    _zz_34;
  wire       [1:0]    _zz_35;
  wire       [15:0]   _zz_36;
  wire       [8:0]    _zz_37;
  wire       [7:0]    _zz_38;
  wire       [3:0]    CMD_UNSELECTED;
  wire       [3:0]    CMD_NOP;
  wire       [3:0]    CMD_ACTIVE;
  wire       [3:0]    CMD_READ;
  wire       [3:0]    CMD_WRITE;
  wire       [3:0]    CMD_BURST_TERMINATE;
  wire       [3:0]    CMD_PRECHARGE;
  wire       [3:0]    CMD_REFRESH;
  wire       [3:0]    CMD_LOAD_MODE_REG;
  wire       [1:0]    DQM_ALL_VALID;
  wire       [1:0]    DQM_ALL_INVALID;
  wire       [12:0]   MODE_VALUE;
  reg        [3:0]    commandReg;
  reg        [12:0]   addressReg;
  reg        [1:0]    bankAddrReg;
  reg        [7:0]    burstLenReg;
  reg        [8:0]    columnAddrReg;
  reg        [31:0]   busReadDataReg;
  reg                 busReadDataVldReg;
  reg                 busReadDataLastReg;
  reg        [3:0]    opIdReg;
  reg        [3:0]    strobeReg;
  reg        [31:0]   busWriteDataReg;
  reg        [1:0]    busDataShiftCnt;
  wire       [1:0]    writeMask;
  wire       [15:0]   busWrite;
  reg        [1:0]    mask;
  reg        [13:0]   initCounter_counter;
  wire                initCounter_busy;
  reg        [2:0]    stateCounter_counter;
  wire                stateCounter_busy;
  wire                refreshCounter_willIncrement;
  wire                refreshCounter_willClear;
  reg        [9:0]    refreshCounter_valueNext;
  reg        [9:0]    refreshCounter_value;
  wire                refreshCounter_willOverflowIfInc;
  wire                refreshCounter_willOverflow;
  wire                initPeriod;
  reg                 refreshReqReg;
  reg                 preReqIsWriteReg;
  wire                readReq;
  wire                writeReq;
  reg                 initFsm_wantExit;
  reg                 initFsm_wantStart;
  reg                 refreshFsm_wantExit;
  reg                 refreshFsm_wantStart;
  reg                 writeFsm_wantExit;
  reg                 writeFsm_wantStart;
  reg                 readFsm_wantExit;
  reg                 readFsm_wantStart;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  reg        [15:0]   readArea_readReg;
  reg                 startBurstReadReg;
  reg        `readFsm_enumDefinition_binary_sequential_type readFsm_stateReg;
  reg        `readFsm_enumDefinition_binary_sequential_type readFsm_stateNext;
  wire                _zz_1;
  wire                _zz_2;
  reg        `initFsm_enumDefinition_binary_sequential_type initFsm_stateReg;
  reg        `initFsm_enumDefinition_binary_sequential_type initFsm_stateNext;
  reg        `writeFsm_enumDefinition_binary_sequential_type writeFsm_stateReg;
  reg        `writeFsm_enumDefinition_binary_sequential_type writeFsm_stateNext;
  wire                _zz_3;
  wire                _zz_4;
  reg        `refreshFsm_enumDefinition_binary_sequential_type refreshFsm_stateReg;
  reg        `refreshFsm_enumDefinition_binary_sequential_type refreshFsm_stateNext;
  wire                _zz_5;
  wire                _zz_6;
  reg        `fsm_enumDefinition_binary_sequential_type fsm_stateReg;
  reg        `fsm_enumDefinition_binary_sequential_type fsm_stateNext;
  wire                _zz_7;
  wire                _zz_8;
  `ifndef SYNTHESIS
  reg [167:0] readFsm_stateReg_string;
  reg [167:0] readFsm_stateNext_string;
  reg [207:0] initFsm_stateReg_string;
  reg [207:0] initFsm_stateNext_string;
  reg [167:0] writeFsm_stateReg_string;
  reg [167:0] writeFsm_stateNext_string;
  reg [223:0] refreshFsm_stateReg_string;
  reg [223:0] refreshFsm_stateNext_string;
  reg [103:0] fsm_stateReg_string;
  reg [103:0] fsm_stateNext_string;
  `endif


  assign _zz_20 = ((! (writeFsm_stateReg == `writeFsm_enumDefinition_binary_sequential_writeFsm_ACTIVE_WRITE)) && (writeFsm_stateNext == `writeFsm_enumDefinition_binary_sequential_writeFsm_ACTIVE_WRITE));
  assign _zz_21 = (2'b00 < busDataShiftCnt);
  assign _zz_22 = ((! (writeFsm_stateReg == `writeFsm_enumDefinition_binary_sequential_writeFsm_BURST_WRITE)) && (writeFsm_stateNext == `writeFsm_enumDefinition_binary_sequential_writeFsm_BURST_WRITE));
  assign _zz_23 = (_zz_3 && (! _zz_4));
  assign _zz_24 = ((! (readFsm_stateReg == `readFsm_enumDefinition_binary_sequential_readFsm_ACTIVE)) && (readFsm_stateNext == `readFsm_enumDefinition_binary_sequential_readFsm_ACTIVE));
  assign _zz_25 = (! stateCounter_busy);
  assign _zz_26 = (! stateCounter_busy);
  assign _zz_27 = (stateCounter_counter == 3'b011);
  assign _zz_28 = (! stateCounter_busy);
  assign _zz_29 = refreshCounter_willIncrement;
  assign _zz_30 = {9'd0, _zz_29};
  assign _zz_31 = {1'd0, rFifo_io_availability};
  assign _zz_32 = {1'd0, wFifo_io_occupancy};
  assign _zz_33 = ({1'd0,arFifo_io_pop_payload_len} <<< 1);
  assign _zz_34 = (burstLenReg - 8'h01);
  assign _zz_35 = (strobeReg >>> 2);
  assign _zz_36 = (busWriteDataReg >>> 16);
  assign _zz_37 = ({1'd0,awFifo_io_pop_payload_len} <<< 1);
  assign _zz_38 = (burstLenReg - 8'h01);
  StreamFifo_1 awFifo (
    .io_push_valid            (io_axi_aw_valid                   ), //i
    .io_push_ready            (awFifo_io_push_ready              ), //o
    .io_push_payload_addr     (io_axi_aw_payload_addr[31:0]      ), //i
    .io_push_payload_id       (io_axi_aw_payload_id[3:0]         ), //i
    .io_push_payload_len      (io_axi_aw_payload_len[7:0]        ), //i
    .io_push_payload_size     (io_axi_aw_payload_size[2:0]       ), //i
    .io_push_payload_burst    (io_axi_aw_payload_burst[1:0]      ), //i
    .io_pop_valid             (awFifo_io_pop_valid               ), //o
    .io_pop_ready             (_zz_9                             ), //i
    .io_pop_payload_addr      (awFifo_io_pop_payload_addr[31:0]  ), //o
    .io_pop_payload_id        (awFifo_io_pop_payload_id[3:0]     ), //o
    .io_pop_payload_len       (awFifo_io_pop_payload_len[7:0]    ), //o
    .io_pop_payload_size      (awFifo_io_pop_payload_size[2:0]   ), //o
    .io_pop_payload_burst     (awFifo_io_pop_payload_burst[1:0]  ), //o
    .io_flush                 (_zz_10                            ), //i
    .io_occupancy             (awFifo_io_occupancy[6:0]          ), //o
    .io_availability          (awFifo_io_availability[6:0]       ), //o
    .clk                      (clk                               ), //i
    .reset                    (reset                             )  //i
  );
  StreamFifo_2 wFifo (
    .io_push_valid           (io_axi_w_valid                   ), //i
    .io_push_ready           (wFifo_io_push_ready              ), //o
    .io_push_payload_data    (io_axi_w_payload_data[31:0]      ), //i
    .io_push_payload_strb    (io_axi_w_payload_strb[3:0]       ), //i
    .io_push_payload_last    (io_axi_w_payload_last            ), //i
    .io_pop_valid            (wFifo_io_pop_valid               ), //o
    .io_pop_ready            (_zz_11                           ), //i
    .io_pop_payload_data     (wFifo_io_pop_payload_data[31:0]  ), //o
    .io_pop_payload_strb     (wFifo_io_pop_payload_strb[3:0]   ), //o
    .io_pop_payload_last     (wFifo_io_pop_payload_last        ), //o
    .io_flush                (_zz_12                           ), //i
    .io_occupancy            (wFifo_io_occupancy[6:0]          ), //o
    .io_availability         (wFifo_io_availability[6:0]       ), //o
    .clk                     (clk                              ), //i
    .reset                   (reset                            )  //i
  );
  StreamFifo_3 bFifo (
    .io_push_valid           (_zz_13                          ), //i
    .io_push_ready           (bFifo_io_push_ready             ), //o
    .io_push_payload_id      (opIdReg[3:0]                    ), //i
    .io_push_payload_resp    (_zz_14[1:0]                     ), //i
    .io_pop_valid            (bFifo_io_pop_valid              ), //o
    .io_pop_ready            (io_axi_b_ready                  ), //i
    .io_pop_payload_id       (bFifo_io_pop_payload_id[3:0]    ), //o
    .io_pop_payload_resp     (bFifo_io_pop_payload_resp[1:0]  ), //o
    .io_flush                (_zz_15                          ), //i
    .io_occupancy            (bFifo_io_occupancy[6:0]         ), //o
    .io_availability         (bFifo_io_availability[6:0]      ), //o
    .clk                     (clk                             ), //i
    .reset                   (reset                           )  //i
  );
  StreamFifo_1 arFifo (
    .io_push_valid            (io_axi_ar_valid                   ), //i
    .io_push_ready            (arFifo_io_push_ready              ), //o
    .io_push_payload_addr     (io_axi_ar_payload_addr[31:0]      ), //i
    .io_push_payload_id       (io_axi_ar_payload_id[3:0]         ), //i
    .io_push_payload_len      (io_axi_ar_payload_len[7:0]        ), //i
    .io_push_payload_size     (io_axi_ar_payload_size[2:0]       ), //i
    .io_push_payload_burst    (io_axi_ar_payload_burst[1:0]      ), //i
    .io_pop_valid             (arFifo_io_pop_valid               ), //o
    .io_pop_ready             (_zz_16                            ), //i
    .io_pop_payload_addr      (arFifo_io_pop_payload_addr[31:0]  ), //o
    .io_pop_payload_id        (arFifo_io_pop_payload_id[3:0]     ), //o
    .io_pop_payload_len       (arFifo_io_pop_payload_len[7:0]    ), //o
    .io_pop_payload_size      (arFifo_io_pop_payload_size[2:0]   ), //o
    .io_pop_payload_burst     (arFifo_io_pop_payload_burst[1:0]  ), //o
    .io_flush                 (_zz_17                            ), //i
    .io_occupancy             (arFifo_io_occupancy[6:0]          ), //o
    .io_availability          (arFifo_io_availability[6:0]       ), //o
    .clk                      (clk                               ), //i
    .reset                    (reset                             )  //i
  );
  StreamFifo_5 rFifo (
    .io_push_valid           (busReadDataVldReg                ), //i
    .io_push_ready           (rFifo_io_push_ready              ), //o
    .io_push_payload_data    (busReadDataReg[31:0]             ), //i
    .io_push_payload_id      (opIdReg[3:0]                     ), //i
    .io_push_payload_resp    (_zz_18[1:0]                      ), //i
    .io_push_payload_last    (busReadDataLastReg               ), //i
    .io_pop_valid            (rFifo_io_pop_valid               ), //o
    .io_pop_ready            (io_axi_r_ready                   ), //i
    .io_pop_payload_data     (rFifo_io_pop_payload_data[31:0]  ), //o
    .io_pop_payload_id       (rFifo_io_pop_payload_id[3:0]     ), //o
    .io_pop_payload_resp     (rFifo_io_pop_payload_resp[1:0]   ), //o
    .io_pop_payload_last     (rFifo_io_pop_payload_last        ), //o
    .io_flush                (_zz_19                           ), //i
    .io_occupancy            (rFifo_io_occupancy[6:0]          ), //o
    .io_availability         (rFifo_io_availability[6:0]       ), //o
    .clk                     (clk                              ), //i
    .reset                   (reset                            )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(readFsm_stateReg)
      `readFsm_enumDefinition_binary_sequential_readFsm_BOOT : readFsm_stateReg_string = "readFsm_BOOT         ";
      `readFsm_enumDefinition_binary_sequential_readFsm_ACTIVE : readFsm_stateReg_string = "readFsm_ACTIVE       ";
      `readFsm_enumDefinition_binary_sequential_readFsm_SEND_READ_CMD : readFsm_stateReg_string = "readFsm_SEND_READ_CMD";
      `readFsm_enumDefinition_binary_sequential_readFsm_BURST_READ : readFsm_stateReg_string = "readFsm_BURST_READ   ";
      default : readFsm_stateReg_string = "?????????????????????";
    endcase
  end
  always @(*) begin
    case(readFsm_stateNext)
      `readFsm_enumDefinition_binary_sequential_readFsm_BOOT : readFsm_stateNext_string = "readFsm_BOOT         ";
      `readFsm_enumDefinition_binary_sequential_readFsm_ACTIVE : readFsm_stateNext_string = "readFsm_ACTIVE       ";
      `readFsm_enumDefinition_binary_sequential_readFsm_SEND_READ_CMD : readFsm_stateNext_string = "readFsm_SEND_READ_CMD";
      `readFsm_enumDefinition_binary_sequential_readFsm_BURST_READ : readFsm_stateNext_string = "readFsm_BURST_READ   ";
      default : readFsm_stateNext_string = "?????????????????????";
    endcase
  end
  always @(*) begin
    case(initFsm_stateReg)
      `initFsm_enumDefinition_binary_sequential_initFsm_BOOT : initFsm_stateReg_string = "initFsm_BOOT              ";
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_WAIT : initFsm_stateReg_string = "initFsm_INIT_WAIT         ";
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_PRECHARGE : initFsm_stateReg_string = "initFsm_INIT_PRECHARGE    ";
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_REFRESH_1 : initFsm_stateReg_string = "initFsm_INIT_REFRESH_1    ";
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_REFRESH_2 : initFsm_stateReg_string = "initFsm_INIT_REFRESH_2    ";
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_LOAD_MODE_REG : initFsm_stateReg_string = "initFsm_INIT_LOAD_MODE_REG";
      default : initFsm_stateReg_string = "??????????????????????????";
    endcase
  end
  always @(*) begin
    case(initFsm_stateNext)
      `initFsm_enumDefinition_binary_sequential_initFsm_BOOT : initFsm_stateNext_string = "initFsm_BOOT              ";
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_WAIT : initFsm_stateNext_string = "initFsm_INIT_WAIT         ";
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_PRECHARGE : initFsm_stateNext_string = "initFsm_INIT_PRECHARGE    ";
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_REFRESH_1 : initFsm_stateNext_string = "initFsm_INIT_REFRESH_1    ";
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_REFRESH_2 : initFsm_stateNext_string = "initFsm_INIT_REFRESH_2    ";
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_LOAD_MODE_REG : initFsm_stateNext_string = "initFsm_INIT_LOAD_MODE_REG";
      default : initFsm_stateNext_string = "??????????????????????????";
    endcase
  end
  always @(*) begin
    case(writeFsm_stateReg)
      `writeFsm_enumDefinition_binary_sequential_writeFsm_BOOT : writeFsm_stateReg_string = "writeFsm_BOOT        ";
      `writeFsm_enumDefinition_binary_sequential_writeFsm_ACTIVE_WRITE : writeFsm_stateReg_string = "writeFsm_ACTIVE_WRITE";
      `writeFsm_enumDefinition_binary_sequential_writeFsm_BURST_WRITE : writeFsm_stateReg_string = "writeFsm_BURST_WRITE ";
      `writeFsm_enumDefinition_binary_sequential_writeFsm_TERM_WRITE : writeFsm_stateReg_string = "writeFsm_TERM_WRITE  ";
      default : writeFsm_stateReg_string = "?????????????????????";
    endcase
  end
  always @(*) begin
    case(writeFsm_stateNext)
      `writeFsm_enumDefinition_binary_sequential_writeFsm_BOOT : writeFsm_stateNext_string = "writeFsm_BOOT        ";
      `writeFsm_enumDefinition_binary_sequential_writeFsm_ACTIVE_WRITE : writeFsm_stateNext_string = "writeFsm_ACTIVE_WRITE";
      `writeFsm_enumDefinition_binary_sequential_writeFsm_BURST_WRITE : writeFsm_stateNext_string = "writeFsm_BURST_WRITE ";
      `writeFsm_enumDefinition_binary_sequential_writeFsm_TERM_WRITE : writeFsm_stateNext_string = "writeFsm_TERM_WRITE  ";
      default : writeFsm_stateNext_string = "?????????????????????";
    endcase
  end
  always @(*) begin
    case(refreshFsm_stateReg)
      `refreshFsm_enumDefinition_binary_sequential_refreshFsm_BOOT : refreshFsm_stateReg_string = "refreshFsm_BOOT             ";
      `refreshFsm_enumDefinition_binary_sequential_refreshFsm_REFRESH_PRECHARGE : refreshFsm_stateReg_string = "refreshFsm_REFRESH_PRECHARGE";
      `refreshFsm_enumDefinition_binary_sequential_refreshFsm_REFRESH : refreshFsm_stateReg_string = "refreshFsm_REFRESH          ";
      default : refreshFsm_stateReg_string = "????????????????????????????";
    endcase
  end
  always @(*) begin
    case(refreshFsm_stateNext)
      `refreshFsm_enumDefinition_binary_sequential_refreshFsm_BOOT : refreshFsm_stateNext_string = "refreshFsm_BOOT             ";
      `refreshFsm_enumDefinition_binary_sequential_refreshFsm_REFRESH_PRECHARGE : refreshFsm_stateNext_string = "refreshFsm_REFRESH_PRECHARGE";
      `refreshFsm_enumDefinition_binary_sequential_refreshFsm_REFRESH : refreshFsm_stateNext_string = "refreshFsm_REFRESH          ";
      default : refreshFsm_stateNext_string = "????????????????????????????";
    endcase
  end
  always @(*) begin
    case(fsm_stateReg)
      `fsm_enumDefinition_binary_sequential_fsm_BOOT : fsm_stateReg_string = "fsm_BOOT     ";
      `fsm_enumDefinition_binary_sequential_fsm_INIT : fsm_stateReg_string = "fsm_INIT     ";
      `fsm_enumDefinition_binary_sequential_fsm_IDLE : fsm_stateReg_string = "fsm_IDLE     ";
      `fsm_enumDefinition_binary_sequential_fsm_REFRESH : fsm_stateReg_string = "fsm_REFRESH  ";
      `fsm_enumDefinition_binary_sequential_fsm_WRITE : fsm_stateReg_string = "fsm_WRITE    ";
      `fsm_enumDefinition_binary_sequential_fsm_READ : fsm_stateReg_string = "fsm_READ     ";
      `fsm_enumDefinition_binary_sequential_fsm_PRECHARGE : fsm_stateReg_string = "fsm_PRECHARGE";
      default : fsm_stateReg_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      `fsm_enumDefinition_binary_sequential_fsm_BOOT : fsm_stateNext_string = "fsm_BOOT     ";
      `fsm_enumDefinition_binary_sequential_fsm_INIT : fsm_stateNext_string = "fsm_INIT     ";
      `fsm_enumDefinition_binary_sequential_fsm_IDLE : fsm_stateNext_string = "fsm_IDLE     ";
      `fsm_enumDefinition_binary_sequential_fsm_REFRESH : fsm_stateNext_string = "fsm_REFRESH  ";
      `fsm_enumDefinition_binary_sequential_fsm_WRITE : fsm_stateNext_string = "fsm_WRITE    ";
      `fsm_enumDefinition_binary_sequential_fsm_READ : fsm_stateNext_string = "fsm_READ     ";
      `fsm_enumDefinition_binary_sequential_fsm_PRECHARGE : fsm_stateNext_string = "fsm_PRECHARGE";
      default : fsm_stateNext_string = "?????????????";
    endcase
  end
  `endif

  assign CMD_UNSELECTED = 4'b1000;
  assign CMD_NOP = 4'b0111;
  assign CMD_ACTIVE = 4'b0011;
  assign CMD_READ = 4'b0101;
  assign CMD_WRITE = 4'b0100;
  assign CMD_BURST_TERMINATE = 4'b0110;
  assign CMD_PRECHARGE = 4'b0010;
  assign CMD_REFRESH = 4'b0001;
  assign CMD_LOAD_MODE_REG = 4'b0000;
  assign DQM_ALL_VALID = 2'b00;
  assign DQM_ALL_INVALID = (~ DQM_ALL_VALID);
  assign MODE_VALUE = {{6'h0,3'b011},4'b0111};
  assign io_axi_aw_ready = awFifo_io_push_ready;
  assign io_axi_w_ready = wFifo_io_push_ready;
  assign io_axi_b_valid = bFifo_io_pop_valid;
  assign io_axi_b_payload_id = bFifo_io_pop_payload_id;
  assign io_axi_b_payload_resp = bFifo_io_pop_payload_resp;
  assign io_axi_ar_ready = arFifo_io_push_ready;
  assign io_axi_r_valid = rFifo_io_pop_valid;
  assign io_axi_r_payload_data = rFifo_io_pop_payload_data;
  assign io_axi_r_payload_id = rFifo_io_pop_payload_id;
  assign io_axi_r_payload_resp = rFifo_io_pop_payload_resp;
  assign io_axi_r_payload_last = rFifo_io_pop_payload_last;
  assign writeMask = strobeReg[1 : 0];
  assign busWrite = busWriteDataReg[15 : 0];
  always @ (*) begin
    _zz_9 = 1'b0;
    if(_zz_20)begin
      _zz_9 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_11 = 1'b0;
    case(writeFsm_stateReg)
      `writeFsm_enumDefinition_binary_sequential_writeFsm_ACTIVE_WRITE : begin
      end
      `writeFsm_enumDefinition_binary_sequential_writeFsm_BURST_WRITE : begin
        if(! _zz_21) begin
          _zz_11 = 1'b1;
        end
      end
      `writeFsm_enumDefinition_binary_sequential_writeFsm_TERM_WRITE : begin
      end
      default : begin
      end
    endcase
    if(_zz_22)begin
      _zz_11 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_13 = 1'b0;
    if(_zz_23)begin
      _zz_13 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_16 = 1'b0;
    if(_zz_24)begin
      _zz_16 = 1'b1;
    end
  end

  assign _zz_14 = 2'b00;
  assign _zz_18 = 2'b00;
  assign io_sdram_BA = bankAddrReg;
  assign io_sdram_ADDR = addressReg;
  assign io_sdram_DQM = mask;
  assign io_sdram_CKE = 1'b1;
  assign io_sdram_CSn = commandReg[3];
  assign io_sdram_RASn = commandReg[2];
  assign io_sdram_CASn = commandReg[1];
  assign io_sdram_WEn = commandReg[0];
  assign io_sdram_DQ_write = busWrite;
  always @ (*) begin
    io_initDone = 1'b0;
    if((_zz_7 && (! _zz_8)))begin
      io_initDone = 1'b1;
    end
  end

  assign initCounter_busy = (initCounter_counter != 14'h0);
  assign stateCounter_busy = (stateCounter_counter != 3'b000);
  assign refreshCounter_willClear = 1'b0;
  assign refreshCounter_willOverflowIfInc = (refreshCounter_value == 10'h30d);
  assign refreshCounter_willOverflow = (refreshCounter_willOverflowIfInc && refreshCounter_willIncrement);
  always @ (*) begin
    if(refreshCounter_willOverflow)begin
      refreshCounter_valueNext = 10'h0;
    end else begin
      refreshCounter_valueNext = (refreshCounter_value + _zz_30);
    end
    if(refreshCounter_willClear)begin
      refreshCounter_valueNext = 10'h0;
    end
  end

  assign refreshCounter_willIncrement = 1'b1;
  assign readReq = (arFifo_io_pop_valid && (arFifo_io_pop_payload_len <= _zz_31));
  assign writeReq = ((awFifo_io_pop_valid && (awFifo_io_pop_payload_len <= _zz_32)) && (7'h0 < bFifo_io_availability));
  always @ (*) begin
    initFsm_wantExit = 1'b0;
    case(initFsm_stateReg)
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_WAIT : begin
      end
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_PRECHARGE : begin
      end
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_REFRESH_1 : begin
      end
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_REFRESH_2 : begin
      end
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_LOAD_MODE_REG : begin
        if(_zz_25)begin
          initFsm_wantExit = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    initFsm_wantStart = 1'b0;
    if(((! _zz_7) && _zz_8))begin
      initFsm_wantStart = 1'b1;
    end
  end

  always @ (*) begin
    refreshFsm_wantExit = 1'b0;
    case(refreshFsm_stateReg)
      `refreshFsm_enumDefinition_binary_sequential_refreshFsm_REFRESH_PRECHARGE : begin
      end
      `refreshFsm_enumDefinition_binary_sequential_refreshFsm_REFRESH : begin
        if(_zz_26)begin
          refreshFsm_wantExit = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    refreshFsm_wantStart = 1'b0;
    if(((! (fsm_stateReg == `fsm_enumDefinition_binary_sequential_fsm_REFRESH)) && (fsm_stateNext == `fsm_enumDefinition_binary_sequential_fsm_REFRESH)))begin
      refreshFsm_wantStart = 1'b1;
    end
  end

  always @ (*) begin
    writeFsm_wantExit = 1'b0;
    case(writeFsm_stateReg)
      `writeFsm_enumDefinition_binary_sequential_writeFsm_ACTIVE_WRITE : begin
      end
      `writeFsm_enumDefinition_binary_sequential_writeFsm_BURST_WRITE : begin
      end
      `writeFsm_enumDefinition_binary_sequential_writeFsm_TERM_WRITE : begin
        writeFsm_wantExit = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    writeFsm_wantStart = 1'b0;
    if(((! (fsm_stateReg == `fsm_enumDefinition_binary_sequential_fsm_WRITE)) && (fsm_stateNext == `fsm_enumDefinition_binary_sequential_fsm_WRITE)))begin
      writeFsm_wantStart = 1'b1;
    end
  end

  always @ (*) begin
    readFsm_wantExit = 1'b0;
    case(readFsm_stateReg)
      `readFsm_enumDefinition_binary_sequential_readFsm_ACTIVE : begin
      end
      `readFsm_enumDefinition_binary_sequential_readFsm_SEND_READ_CMD : begin
      end
      `readFsm_enumDefinition_binary_sequential_readFsm_BURST_READ : begin
        if(! _zz_27) begin
          if(_zz_28)begin
            readFsm_wantExit = 1'b1;
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    readFsm_wantStart = 1'b0;
    if(((! (fsm_stateReg == `fsm_enumDefinition_binary_sequential_fsm_READ)) && (fsm_stateNext == `fsm_enumDefinition_binary_sequential_fsm_READ)))begin
      readFsm_wantStart = 1'b1;
    end
  end

  assign fsm_wantExit = 1'b0;
  always @ (*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      `fsm_enumDefinition_binary_sequential_fsm_INIT : begin
      end
      `fsm_enumDefinition_binary_sequential_fsm_IDLE : begin
      end
      `fsm_enumDefinition_binary_sequential_fsm_REFRESH : begin
      end
      `fsm_enumDefinition_binary_sequential_fsm_WRITE : begin
      end
      `fsm_enumDefinition_binary_sequential_fsm_READ : begin
      end
      `fsm_enumDefinition_binary_sequential_fsm_PRECHARGE : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign initPeriod = (fsm_stateReg == `fsm_enumDefinition_binary_sequential_fsm_INIT);
  always @ (*) begin
    if((writeFsm_stateReg == `writeFsm_enumDefinition_binary_sequential_writeFsm_BURST_WRITE))begin
      mask = (DQM_ALL_VALID | (~ writeMask));
    end else begin
      if((fsm_stateReg == `fsm_enumDefinition_binary_sequential_fsm_READ))begin
        mask = DQM_ALL_VALID;
      end else begin
        mask = DQM_ALL_INVALID;
      end
    end
  end

  always @ (*) begin
    if((writeFsm_stateReg == `writeFsm_enumDefinition_binary_sequential_writeFsm_BURST_WRITE))begin
      io_sdram_DQ_writeEnable = 16'hffff;
    end else begin
      io_sdram_DQ_writeEnable = 16'h0;
    end
  end

  assign _zz_1 = (readFsm_stateReg == `readFsm_enumDefinition_binary_sequential_readFsm_BURST_READ);
  assign _zz_2 = (readFsm_stateNext == `readFsm_enumDefinition_binary_sequential_readFsm_BURST_READ);
  always @ (*) begin
    readFsm_stateNext = readFsm_stateReg;
    case(readFsm_stateReg)
      `readFsm_enumDefinition_binary_sequential_readFsm_ACTIVE : begin
        if((! stateCounter_busy))begin
          readFsm_stateNext = `readFsm_enumDefinition_binary_sequential_readFsm_SEND_READ_CMD;
        end
      end
      `readFsm_enumDefinition_binary_sequential_readFsm_SEND_READ_CMD : begin
        if((! stateCounter_busy))begin
          readFsm_stateNext = `readFsm_enumDefinition_binary_sequential_readFsm_BURST_READ;
        end
      end
      `readFsm_enumDefinition_binary_sequential_readFsm_BURST_READ : begin
        if(! _zz_27) begin
          if(_zz_28)begin
            readFsm_stateNext = `readFsm_enumDefinition_binary_sequential_readFsm_BOOT;
          end
        end
      end
      default : begin
      end
    endcase
    if(readFsm_wantStart)begin
      readFsm_stateNext = `readFsm_enumDefinition_binary_sequential_readFsm_ACTIVE;
    end
  end

  always @ (*) begin
    initFsm_stateNext = initFsm_stateReg;
    case(initFsm_stateReg)
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_WAIT : begin
        if((! initCounter_busy))begin
          initFsm_stateNext = `initFsm_enumDefinition_binary_sequential_initFsm_INIT_PRECHARGE;
        end
      end
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_PRECHARGE : begin
        if((! stateCounter_busy))begin
          initFsm_stateNext = `initFsm_enumDefinition_binary_sequential_initFsm_INIT_REFRESH_1;
        end
      end
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_REFRESH_1 : begin
        if((! stateCounter_busy))begin
          initFsm_stateNext = `initFsm_enumDefinition_binary_sequential_initFsm_INIT_REFRESH_2;
        end
      end
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_REFRESH_2 : begin
        if((! stateCounter_busy))begin
          initFsm_stateNext = `initFsm_enumDefinition_binary_sequential_initFsm_INIT_LOAD_MODE_REG;
        end
      end
      `initFsm_enumDefinition_binary_sequential_initFsm_INIT_LOAD_MODE_REG : begin
        if(_zz_25)begin
          initFsm_stateNext = `initFsm_enumDefinition_binary_sequential_initFsm_BOOT;
        end
      end
      default : begin
      end
    endcase
    if(initFsm_wantStart)begin
      initFsm_stateNext = `initFsm_enumDefinition_binary_sequential_initFsm_INIT_WAIT;
    end
  end

  assign _zz_3 = (writeFsm_stateReg == `writeFsm_enumDefinition_binary_sequential_writeFsm_TERM_WRITE);
  assign _zz_4 = (writeFsm_stateNext == `writeFsm_enumDefinition_binary_sequential_writeFsm_TERM_WRITE);
  always @ (*) begin
    writeFsm_stateNext = writeFsm_stateReg;
    case(writeFsm_stateReg)
      `writeFsm_enumDefinition_binary_sequential_writeFsm_ACTIVE_WRITE : begin
        if((! stateCounter_busy))begin
          writeFsm_stateNext = `writeFsm_enumDefinition_binary_sequential_writeFsm_BURST_WRITE;
        end
      end
      `writeFsm_enumDefinition_binary_sequential_writeFsm_BURST_WRITE : begin
        if((! stateCounter_busy))begin
          writeFsm_stateNext = `writeFsm_enumDefinition_binary_sequential_writeFsm_TERM_WRITE;
        end
      end
      `writeFsm_enumDefinition_binary_sequential_writeFsm_TERM_WRITE : begin
        writeFsm_stateNext = `writeFsm_enumDefinition_binary_sequential_writeFsm_BOOT;
      end
      default : begin
      end
    endcase
    if(writeFsm_wantStart)begin
      writeFsm_stateNext = `writeFsm_enumDefinition_binary_sequential_writeFsm_ACTIVE_WRITE;
    end
  end

  assign _zz_5 = (refreshFsm_stateReg == `refreshFsm_enumDefinition_binary_sequential_refreshFsm_REFRESH);
  assign _zz_6 = (refreshFsm_stateNext == `refreshFsm_enumDefinition_binary_sequential_refreshFsm_REFRESH);
  always @ (*) begin
    refreshFsm_stateNext = refreshFsm_stateReg;
    case(refreshFsm_stateReg)
      `refreshFsm_enumDefinition_binary_sequential_refreshFsm_REFRESH_PRECHARGE : begin
        if((! stateCounter_busy))begin
          refreshFsm_stateNext = `refreshFsm_enumDefinition_binary_sequential_refreshFsm_REFRESH;
        end
      end
      `refreshFsm_enumDefinition_binary_sequential_refreshFsm_REFRESH : begin
        if(_zz_26)begin
          refreshFsm_stateNext = `refreshFsm_enumDefinition_binary_sequential_refreshFsm_BOOT;
        end
      end
      default : begin
      end
    endcase
    if(refreshFsm_wantStart)begin
      refreshFsm_stateNext = `refreshFsm_enumDefinition_binary_sequential_refreshFsm_REFRESH_PRECHARGE;
    end
  end

  assign _zz_7 = (fsm_stateReg == `fsm_enumDefinition_binary_sequential_fsm_INIT);
  assign _zz_8 = (fsm_stateNext == `fsm_enumDefinition_binary_sequential_fsm_INIT);
  always @ (*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      `fsm_enumDefinition_binary_sequential_fsm_INIT : begin
        if(initFsm_wantExit)begin
          fsm_stateNext = `fsm_enumDefinition_binary_sequential_fsm_IDLE;
        end
      end
      `fsm_enumDefinition_binary_sequential_fsm_IDLE : begin
        if(refreshReqReg)begin
          fsm_stateNext = `fsm_enumDefinition_binary_sequential_fsm_REFRESH;
        end else begin
          if((readReq && writeReq))begin
            if(preReqIsWriteReg)begin
              fsm_stateNext = `fsm_enumDefinition_binary_sequential_fsm_READ;
            end else begin
              fsm_stateNext = `fsm_enumDefinition_binary_sequential_fsm_WRITE;
            end
          end else begin
            if((writeReq && (! readReq)))begin
              fsm_stateNext = `fsm_enumDefinition_binary_sequential_fsm_WRITE;
            end else begin
              if((readReq && (! writeReq)))begin
                fsm_stateNext = `fsm_enumDefinition_binary_sequential_fsm_READ;
              end
            end
          end
        end
      end
      `fsm_enumDefinition_binary_sequential_fsm_REFRESH : begin
        if(refreshFsm_wantExit)begin
          fsm_stateNext = `fsm_enumDefinition_binary_sequential_fsm_IDLE;
        end
      end
      `fsm_enumDefinition_binary_sequential_fsm_WRITE : begin
        if(writeFsm_wantExit)begin
          fsm_stateNext = `fsm_enumDefinition_binary_sequential_fsm_PRECHARGE;
        end
      end
      `fsm_enumDefinition_binary_sequential_fsm_READ : begin
        if(readFsm_wantExit)begin
          fsm_stateNext = `fsm_enumDefinition_binary_sequential_fsm_PRECHARGE;
        end
      end
      `fsm_enumDefinition_binary_sequential_fsm_PRECHARGE : begin
        fsm_stateNext = `fsm_enumDefinition_binary_sequential_fsm_IDLE;
      end
      default : begin
      end
    endcase
    if(fsm_wantStart)begin
      fsm_stateNext = `fsm_enumDefinition_binary_sequential_fsm_INIT;
    end
  end

  assign _zz_10 = 1'b0;
  assign _zz_12 = 1'b0;
  assign _zz_15 = 1'b0;
  assign _zz_17 = 1'b0;
  assign _zz_19 = 1'b0;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      commandReg <= 4'b0000;
      addressReg <= 13'h0;
      bankAddrReg <= 2'b00;
      burstLenReg <= 8'h0;
      columnAddrReg <= 9'h0;
      busReadDataReg <= 32'h0;
      busReadDataVldReg <= 1'b0;
      busReadDataLastReg <= 1'b0;
      opIdReg <= 4'b0000;
      strobeReg <= 4'b0000;
      busWriteDataReg <= 32'h0;
      busDataShiftCnt <= 2'b00;
      initCounter_counter <= 14'h0;
      stateCounter_counter <= 3'b000;
      refreshCounter_value <= 10'h0;
      refreshReqReg <= 1'b0;
      preReqIsWriteReg <= 1'b0;
      readFsm_stateReg <= `readFsm_enumDefinition_binary_sequential_readFsm_BOOT;
      initFsm_stateReg <= `initFsm_enumDefinition_binary_sequential_initFsm_BOOT;
      writeFsm_stateReg <= `writeFsm_enumDefinition_binary_sequential_writeFsm_BOOT;
      refreshFsm_stateReg <= `refreshFsm_enumDefinition_binary_sequential_refreshFsm_BOOT;
      fsm_stateReg <= `fsm_enumDefinition_binary_sequential_fsm_BOOT;
    end else begin
      commandReg <= CMD_NOP;
      busReadDataLastReg <= 1'b0;
      `ifndef SYNTHESIS
        `ifdef FORMAL
          assert((columnAddrReg < 9'h1f0));
        `else
          if(!(columnAddrReg < 9'h1f0)) begin
            $display("ERROR invalid column address and burst length");
          end
        `endif
      `endif
      `ifndef SYNTHESIS
        `ifdef FORMAL
          assert(((awFifo_io_pop_payload_burst == 2'b01) && (arFifo_io_pop_payload_burst == 2'b01)));
        `else
          if(!((awFifo_io_pop_payload_burst == 2'b01) && (arFifo_io_pop_payload_burst == 2'b01))) begin
            $display("ERROR only burst type INCR allowed");
          end
        `endif
      `endif
      `ifndef SYNTHESIS
        `ifdef FORMAL
          assert((awFifo_io_pop_payload_len < 8'h40));
        `else
          if(!(awFifo_io_pop_payload_len < 8'h40)) begin
            $display("ERROR burst length should be less than 256/2");
          end
        `endif
      `endif
      if(initCounter_busy)begin
        initCounter_counter <= (initCounter_counter - 14'h0001);
      end
      if(stateCounter_busy)begin
        stateCounter_counter <= (stateCounter_counter - 3'b001);
      end
      refreshCounter_value <= refreshCounter_valueNext;
      if(startBurstReadReg)begin
        busDataShiftCnt <= 2'b01;
      end
      busReadDataVldReg <= 1'b0;
      if((readFsm_stateReg == `readFsm_enumDefinition_binary_sequential_readFsm_BURST_READ))begin
        busReadDataReg <= {readArea_readReg,busReadDataReg[31 : 16]};
        if((2'b00 < busDataShiftCnt))begin
          busDataShiftCnt <= (busDataShiftCnt - 2'b01);
        end else begin
          busReadDataVldReg <= 1'b1;
          busDataShiftCnt <= 2'b01;
        end
      end
      if(((! initPeriod) && refreshCounter_willOverflow))begin
        refreshReqReg <= 1'b1;
      end
      readFsm_stateReg <= readFsm_stateNext;
      case(readFsm_stateReg)
        `readFsm_enumDefinition_binary_sequential_readFsm_ACTIVE : begin
        end
        `readFsm_enumDefinition_binary_sequential_readFsm_SEND_READ_CMD : begin
        end
        `readFsm_enumDefinition_binary_sequential_readFsm_BURST_READ : begin
          if(_zz_27)begin
            commandReg <= CMD_BURST_TERMINATE;
          end
        end
        default : begin
        end
      endcase
      if((_zz_1 && (! _zz_2)))begin
        preReqIsWriteReg <= 1'b0;
        busReadDataLastReg <= 1'b1;
      end
      if(_zz_24)begin
        commandReg <= CMD_ACTIVE;
        bankAddrReg <= arFifo_io_pop_payload_addr[22 : 21];
        addressReg <= arFifo_io_pop_payload_addr[21 : 9];
        columnAddrReg <= arFifo_io_pop_payload_addr[8 : 0];
        opIdReg <= arFifo_io_pop_payload_id;
        burstLenReg <= _zz_33[7:0];
        stateCounter_counter <= 3'b001;
      end
      if(((! (readFsm_stateReg == `readFsm_enumDefinition_binary_sequential_readFsm_SEND_READ_CMD)) && (readFsm_stateNext == `readFsm_enumDefinition_binary_sequential_readFsm_SEND_READ_CMD)))begin
        addressReg <= {4'd0, columnAddrReg};
        commandReg <= CMD_READ;
        stateCounter_counter <= 3'b010;
      end
      if(((! _zz_1) && _zz_2))begin
        `ifndef SYNTHESIS
          `ifdef FORMAL
            assert(((burstLenReg <= 8'h07) && (8'h0 < burstLenReg)));
          `else
            if(!((burstLenReg <= 8'h07) && (8'h0 < burstLenReg))) begin
              $display("FAILURE invalid counter cycle=(toplevel/[SdramController]/burstLenReg :  UInt[8 bits]), cycleMax=7");
              $finish;
            end
          `endif
        `endif
        stateCounter_counter <= _zz_34[2:0];
      end
      initFsm_stateReg <= initFsm_stateNext;
      if(((! (initFsm_stateReg == `initFsm_enumDefinition_binary_sequential_initFsm_INIT_WAIT)) && (initFsm_stateNext == `initFsm_enumDefinition_binary_sequential_initFsm_INIT_WAIT)))begin
        initCounter_counter <= 14'h270f;
      end
      if(((! (initFsm_stateReg == `initFsm_enumDefinition_binary_sequential_initFsm_INIT_PRECHARGE)) && (initFsm_stateNext == `initFsm_enumDefinition_binary_sequential_initFsm_INIT_PRECHARGE)))begin
        addressReg <= 13'h0400;
        commandReg <= CMD_PRECHARGE;
        stateCounter_counter <= 3'b001;
      end
      if(((! (initFsm_stateReg == `initFsm_enumDefinition_binary_sequential_initFsm_INIT_REFRESH_1)) && (initFsm_stateNext == `initFsm_enumDefinition_binary_sequential_initFsm_INIT_REFRESH_1)))begin
        commandReg <= CMD_REFRESH;
        stateCounter_counter <= 3'b110;
      end
      if(((! (initFsm_stateReg == `initFsm_enumDefinition_binary_sequential_initFsm_INIT_REFRESH_2)) && (initFsm_stateNext == `initFsm_enumDefinition_binary_sequential_initFsm_INIT_REFRESH_2)))begin
        commandReg <= CMD_REFRESH;
        stateCounter_counter <= 3'b110;
      end
      if(((! (initFsm_stateReg == `initFsm_enumDefinition_binary_sequential_initFsm_INIT_LOAD_MODE_REG)) && (initFsm_stateNext == `initFsm_enumDefinition_binary_sequential_initFsm_INIT_LOAD_MODE_REG)))begin
        addressReg <= MODE_VALUE;
        commandReg <= CMD_LOAD_MODE_REG;
        stateCounter_counter <= 3'b001;
      end
      writeFsm_stateReg <= writeFsm_stateNext;
      case(writeFsm_stateReg)
        `writeFsm_enumDefinition_binary_sequential_writeFsm_ACTIVE_WRITE : begin
        end
        `writeFsm_enumDefinition_binary_sequential_writeFsm_BURST_WRITE : begin
          strobeReg <= {2'd0, _zz_35};
          busWriteDataReg <= {16'd0, _zz_36};
          if(_zz_21)begin
            busDataShiftCnt <= (busDataShiftCnt - 2'b01);
          end else begin
            strobeReg <= wFifo_io_pop_payload_strb;
            busWriteDataReg <= wFifo_io_pop_payload_data;
            busDataShiftCnt <= 2'b01;
          end
        end
        `writeFsm_enumDefinition_binary_sequential_writeFsm_TERM_WRITE : begin
        end
        default : begin
        end
      endcase
      if(_zz_23)begin
        preReqIsWriteReg <= 1'b1;
      end
      if(_zz_20)begin
        commandReg <= CMD_ACTIVE;
        bankAddrReg <= awFifo_io_pop_payload_addr[22 : 21];
        addressReg <= awFifo_io_pop_payload_addr[21 : 9];
        columnAddrReg <= awFifo_io_pop_payload_addr[8 : 0];
        opIdReg <= awFifo_io_pop_payload_id;
        burstLenReg <= _zz_37[7:0];
        stateCounter_counter <= 3'b001;
      end
      if(_zz_22)begin
        addressReg <= {4'd0, columnAddrReg};
        commandReg <= CMD_WRITE;
        `ifndef SYNTHESIS
          `ifdef FORMAL
            assert(((burstLenReg <= 8'h07) && (8'h0 < burstLenReg)));
          `else
            if(!((burstLenReg <= 8'h07) && (8'h0 < burstLenReg))) begin
              $display("FAILURE invalid counter cycle=(toplevel/[SdramController]/burstLenReg :  UInt[8 bits]), cycleMax=7");
              $finish;
            end
          `endif
        `endif
        stateCounter_counter <= _zz_38[2:0];
        strobeReg <= wFifo_io_pop_payload_strb;
        busWriteDataReg <= wFifo_io_pop_payload_data;
        busDataShiftCnt <= 2'b01;
      end
      if(((! _zz_3) && _zz_4))begin
        commandReg <= CMD_BURST_TERMINATE;
      end
      refreshFsm_stateReg <= refreshFsm_stateNext;
      if((_zz_5 && (! _zz_6)))begin
        refreshReqReg <= 1'b0;
      end
      if(((! (refreshFsm_stateReg == `refreshFsm_enumDefinition_binary_sequential_refreshFsm_REFRESH_PRECHARGE)) && (refreshFsm_stateNext == `refreshFsm_enumDefinition_binary_sequential_refreshFsm_REFRESH_PRECHARGE)))begin
        addressReg <= 13'h0400;
        commandReg <= CMD_REFRESH;
        stateCounter_counter <= 3'b001;
      end
      if(((! _zz_5) && _zz_6))begin
        commandReg <= CMD_PRECHARGE;
        stateCounter_counter <= 3'b110;
      end
      fsm_stateReg <= fsm_stateNext;
      if(((! (fsm_stateReg == `fsm_enumDefinition_binary_sequential_fsm_PRECHARGE)) && (fsm_stateNext == `fsm_enumDefinition_binary_sequential_fsm_PRECHARGE)))begin
        commandReg <= CMD_PRECHARGE;
      end
    end
  end

  always @ (negedge clk) begin
    if((io_sdram_DQ_writeEnable == 16'h0))begin
      readArea_readReg <= io_sdram_DQ_read;
    end
  end

  always @ (posedge clk) begin
    startBurstReadReg <= ((readFsm_stateNext == `readFsm_enumDefinition_binary_sequential_readFsm_BURST_READ) && (readFsm_stateReg != `readFsm_enumDefinition_binary_sequential_readFsm_BURST_READ));
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

module StreamFifo_5 (
  input               io_push_valid,
  output              io_push_ready,
  input      [31:0]   io_push_payload_data,
  input      [3:0]    io_push_payload_id,
  input      [1:0]    io_push_payload_resp,
  input               io_push_payload_last,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [31:0]   io_pop_payload_data,
  output     [3:0]    io_pop_payload_id,
  output     [1:0]    io_pop_payload_resp,
  output              io_pop_payload_last,
  input               io_flush,
  output     [6:0]    io_occupancy,
  output     [6:0]    io_availability,
  input               clk,
  input               reset
);
  reg        [38:0]   _zz_4;
  wire       [0:0]    _zz_5;
  wire       [5:0]    _zz_6;
  wire       [0:0]    _zz_7;
  wire       [5:0]    _zz_8;
  wire       [0:0]    _zz_9;
  wire       [5:0]    _zz_10;
  wire                _zz_11;
  wire       [38:0]   _zz_12;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [5:0]    logic_pushPtr_valueNext;
  reg        [5:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [5:0]    logic_popPtr_valueNext;
  reg        [5:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_2;
  wire       [38:0]   _zz_3;
  wire       [5:0]    logic_ptrDif;
  reg [38:0] logic_ram [0:63];

  assign _zz_5 = logic_pushPtr_willIncrement;
  assign _zz_6 = {5'd0, _zz_5};
  assign _zz_7 = logic_popPtr_willIncrement;
  assign _zz_8 = {5'd0, _zz_7};
  assign _zz_9 = _zz_3[38 : 38];
  assign _zz_10 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_11 = 1'b1;
  assign _zz_12 = {io_push_payload_last,{io_push_payload_resp,{io_push_payload_id,io_push_payload_data}}};
  always @ (posedge clk) begin
    if(_zz_11) begin
      _zz_4 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @ (posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_12;
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

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 6'h3f);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @ (*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_6);
    if(logic_pushPtr_willClear)begin
      logic_pushPtr_valueNext = 6'h0;
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

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 6'h3f);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @ (*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_8);
    if(logic_popPtr_willClear)begin
      logic_popPtr_valueNext = 6'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_2 && (! logic_full))));
  assign _zz_3 = _zz_4;
  assign io_pop_payload_data = _zz_3[31 : 0];
  assign io_pop_payload_id = _zz_3[35 : 32];
  assign io_pop_payload_resp = _zz_3[37 : 36];
  assign io_pop_payload_last = _zz_9[0];
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_10};
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      logic_pushPtr_value <= 6'h0;
      logic_popPtr_value <= 6'h0;
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

//StreamFifo_1 replaced by StreamFifo_1

module StreamFifo_3 (
  input               io_push_valid,
  output              io_push_ready,
  input      [3:0]    io_push_payload_id,
  input      [1:0]    io_push_payload_resp,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [3:0]    io_pop_payload_id,
  output     [1:0]    io_pop_payload_resp,
  input               io_flush,
  output     [6:0]    io_occupancy,
  output     [6:0]    io_availability,
  input               clk,
  input               reset
);
  reg        [5:0]    _zz_4;
  wire       [0:0]    _zz_5;
  wire       [5:0]    _zz_6;
  wire       [0:0]    _zz_7;
  wire       [5:0]    _zz_8;
  wire       [5:0]    _zz_9;
  wire                _zz_10;
  wire       [5:0]    _zz_11;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [5:0]    logic_pushPtr_valueNext;
  reg        [5:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [5:0]    logic_popPtr_valueNext;
  reg        [5:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_2;
  wire       [5:0]    _zz_3;
  wire       [5:0]    logic_ptrDif;
  reg [5:0] logic_ram [0:63];

  assign _zz_5 = logic_pushPtr_willIncrement;
  assign _zz_6 = {5'd0, _zz_5};
  assign _zz_7 = logic_popPtr_willIncrement;
  assign _zz_8 = {5'd0, _zz_7};
  assign _zz_9 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_10 = 1'b1;
  assign _zz_11 = {io_push_payload_resp,io_push_payload_id};
  always @ (posedge clk) begin
    if(_zz_10) begin
      _zz_4 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @ (posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_11;
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

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 6'h3f);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @ (*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_6);
    if(logic_pushPtr_willClear)begin
      logic_pushPtr_valueNext = 6'h0;
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

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 6'h3f);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @ (*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_8);
    if(logic_popPtr_willClear)begin
      logic_popPtr_valueNext = 6'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_2 && (! logic_full))));
  assign _zz_3 = _zz_4;
  assign io_pop_payload_id = _zz_3[3 : 0];
  assign io_pop_payload_resp = _zz_3[5 : 4];
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_9};
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      logic_pushPtr_value <= 6'h0;
      logic_popPtr_value <= 6'h0;
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

module StreamFifo_2 (
  input               io_push_valid,
  output              io_push_ready,
  input      [31:0]   io_push_payload_data,
  input      [3:0]    io_push_payload_strb,
  input               io_push_payload_last,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [31:0]   io_pop_payload_data,
  output     [3:0]    io_pop_payload_strb,
  output              io_pop_payload_last,
  input               io_flush,
  output     [6:0]    io_occupancy,
  output     [6:0]    io_availability,
  input               clk,
  input               reset
);
  reg        [36:0]   _zz_4;
  wire       [0:0]    _zz_5;
  wire       [5:0]    _zz_6;
  wire       [0:0]    _zz_7;
  wire       [5:0]    _zz_8;
  wire       [0:0]    _zz_9;
  wire       [5:0]    _zz_10;
  wire                _zz_11;
  wire       [36:0]   _zz_12;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [5:0]    logic_pushPtr_valueNext;
  reg        [5:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [5:0]    logic_popPtr_valueNext;
  reg        [5:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_2;
  wire       [36:0]   _zz_3;
  wire       [5:0]    logic_ptrDif;
  reg [36:0] logic_ram [0:63];

  assign _zz_5 = logic_pushPtr_willIncrement;
  assign _zz_6 = {5'd0, _zz_5};
  assign _zz_7 = logic_popPtr_willIncrement;
  assign _zz_8 = {5'd0, _zz_7};
  assign _zz_9 = _zz_3[36 : 36];
  assign _zz_10 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_11 = 1'b1;
  assign _zz_12 = {io_push_payload_last,{io_push_payload_strb,io_push_payload_data}};
  always @ (posedge clk) begin
    if(_zz_11) begin
      _zz_4 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @ (posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_12;
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

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 6'h3f);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @ (*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_6);
    if(logic_pushPtr_willClear)begin
      logic_pushPtr_valueNext = 6'h0;
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

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 6'h3f);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @ (*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_8);
    if(logic_popPtr_willClear)begin
      logic_popPtr_valueNext = 6'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_2 && (! logic_full))));
  assign _zz_3 = _zz_4;
  assign io_pop_payload_data = _zz_3[31 : 0];
  assign io_pop_payload_strb = _zz_3[35 : 32];
  assign io_pop_payload_last = _zz_9[0];
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_10};
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      logic_pushPtr_value <= 6'h0;
      logic_popPtr_value <= 6'h0;
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

module StreamFifo_1 (
  input               io_push_valid,
  output              io_push_ready,
  input      [31:0]   io_push_payload_addr,
  input      [3:0]    io_push_payload_id,
  input      [7:0]    io_push_payload_len,
  input      [2:0]    io_push_payload_size,
  input      [1:0]    io_push_payload_burst,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [31:0]   io_pop_payload_addr,
  output     [3:0]    io_pop_payload_id,
  output     [7:0]    io_pop_payload_len,
  output     [2:0]    io_pop_payload_size,
  output     [1:0]    io_pop_payload_burst,
  input               io_flush,
  output     [6:0]    io_occupancy,
  output     [6:0]    io_availability,
  input               clk,
  input               reset
);
  reg        [48:0]   _zz_4;
  wire       [0:0]    _zz_5;
  wire       [5:0]    _zz_6;
  wire       [0:0]    _zz_7;
  wire       [5:0]    _zz_8;
  wire       [5:0]    _zz_9;
  wire                _zz_10;
  wire       [48:0]   _zz_11;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [5:0]    logic_pushPtr_valueNext;
  reg        [5:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [5:0]    logic_popPtr_valueNext;
  reg        [5:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_2;
  wire       [48:0]   _zz_3;
  wire       [5:0]    logic_ptrDif;
  reg [48:0] logic_ram [0:63];

  assign _zz_5 = logic_pushPtr_willIncrement;
  assign _zz_6 = {5'd0, _zz_5};
  assign _zz_7 = logic_popPtr_willIncrement;
  assign _zz_8 = {5'd0, _zz_7};
  assign _zz_9 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_10 = 1'b1;
  assign _zz_11 = {io_push_payload_burst,{io_push_payload_size,{io_push_payload_len,{io_push_payload_id,io_push_payload_addr}}}};
  always @ (posedge clk) begin
    if(_zz_10) begin
      _zz_4 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @ (posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_11;
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

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 6'h3f);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @ (*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_6);
    if(logic_pushPtr_willClear)begin
      logic_pushPtr_valueNext = 6'h0;
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

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 6'h3f);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @ (*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_8);
    if(logic_popPtr_willClear)begin
      logic_popPtr_valueNext = 6'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_2 && (! logic_full))));
  assign _zz_3 = _zz_4;
  assign io_pop_payload_addr = _zz_3[31 : 0];
  assign io_pop_payload_id = _zz_3[35 : 32];
  assign io_pop_payload_len = _zz_3[43 : 36];
  assign io_pop_payload_size = _zz_3[46 : 44];
  assign io_pop_payload_burst = _zz_3[48 : 47];
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_9};
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      logic_pushPtr_value <= 6'h0;
      logic_popPtr_value <= 6'h0;
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
