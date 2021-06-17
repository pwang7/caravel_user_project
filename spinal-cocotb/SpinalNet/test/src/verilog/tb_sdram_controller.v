
module tb_sdram_controller (
  input               io_axi_aw_valid,
  output              io_axi_aw_ready,
  input      [31:0]   io_axi_aw_payload_addr,
  input      [3:0]    io_axi_aw_payload_id,
  input      [7:0]    io_axi_aw_payload_len,
  input      [2:0]    io_axi_aw_payload_size,
  input      [1:0]    io_axi_aw_payload_burst,
  input               io_axi_w_valid,
  output              io_axi_w_ready,
  input      [31:0]   io_axi_w_payload_data,
  input      [3:0]    io_axi_w_payload_strb,
  input               io_axi_w_payload_last,
  output              io_axi_b_valid,
  input               io_axi_b_ready,
  output     [3:0]    io_axi_b_payload_id,
  output     [1:0]    io_axi_b_payload_resp,
  input               io_axi_ar_valid,
  output              io_axi_ar_ready,
  input      [31:0]   io_axi_ar_payload_addr,
  input      [3:0]    io_axi_ar_payload_id,
  input      [7:0]    io_axi_ar_payload_len,
  input      [2:0]    io_axi_ar_payload_size,
  input      [1:0]    io_axi_ar_payload_burst,
  output              io_axi_r_valid,
  input               io_axi_r_ready,
  output     [31:0]   io_axi_r_payload_data,
  output     [3:0]    io_axi_r_payload_id,
  output     [1:0]    io_axi_r_payload_resp,
  output              io_axi_r_payload_last,
  output              io_initDone,
  input               clk,
  input               reset
);
  wire       [12:0]   controller_io_sdram_ADDR;
  wire       [1:0]    controller_io_sdram_BA;
  wire                controller_io_sdram_CASn;
  wire                controller_io_sdram_CKE;
  wire                controller_io_sdram_CSn;
  wire       [1:0]    controller_io_sdram_DQM;
  wire                controller_io_sdram_RASn;
  wire                controller_io_sdram_WEn;
  wire       [15:0]   controller_io_sdram_DQ_write;
  wire       [15:0]   controller_io_sdram_DQ_writeEnable;
  wire       [15:0]   sdramDevice_DQ_read;

  SdramController controller (
    .io_axi_aw_valid                (io_axi_aw_valid                           ), //i
    .io_axi_aw_ready                (io_axi_aw_ready                           ), //o
    .io_axi_aw_payload_addr         (io_axi_aw_payload_addr                    ), //i
    .io_axi_aw_payload_id           (io_axi_aw_payload_id                      ), //i
    .io_axi_aw_payload_len          (io_axi_aw_payload_len                     ), //i
    .io_axi_aw_payload_size         (io_axi_aw_payload_size                    ), //i
    .io_axi_aw_payload_burst        (io_axi_aw_payload_burst                   ), //i
    .io_axi_w_valid                 (io_axi_w_valid                            ), //i
    .io_axi_w_ready                 (io_axi_w_ready                            ), //o
    .io_axi_w_payload_data          (io_axi_w_payload_data                     ), //i
    .io_axi_w_payload_strb          (io_axi_w_payload_strb                     ), //i
    .io_axi_w_payload_last          (io_axi_w_payload_last                     ), //i
    .io_axi_b_valid                 (io_axi_b_valid                            ), //o
    .io_axi_b_ready                 (io_axi_b_ready                            ), //i
    .io_axi_b_payload_id            (io_axi_b_payload_id                       ), //o
    .io_axi_b_payload_resp          (io_axi_b_payload_resp                     ), //o
    .io_axi_ar_valid                (io_axi_ar_valid                           ), //i
    .io_axi_ar_ready                (io_axi_ar_ready                           ), //o
    .io_axi_ar_payload_addr         (io_axi_ar_payload_addr                    ), //i
    .io_axi_ar_payload_id           (io_axi_ar_payload_id                      ), //i
    .io_axi_ar_payload_len          (io_axi_ar_payload_len                     ), //i
    .io_axi_ar_payload_size         (io_axi_ar_payload_size                    ), //i
    .io_axi_ar_payload_burst        (io_axi_ar_payload_burst                   ), //i
    .io_axi_r_valid                 (io_axi_r_valid                            ), //o
    .io_axi_r_ready                 (io_axi_r_ready                            ), //i
    .io_axi_r_payload_data          (io_axi_r_payload_data                     ), //o
    .io_axi_r_payload_id            (io_axi_r_payload_id                       ), //o
    .io_axi_r_payload_resp          (io_axi_r_payload_resp                     ), //o
    .io_axi_r_payload_last          (io_axi_r_payload_last                     ), //o
    .io_sdram_ADDR                  (controller_io_sdram_ADDR[12:0]            ), //o
    .io_sdram_BA                    (controller_io_sdram_BA[1:0]               ), //o
    .io_sdram_DQ_read               (sdramDevice_DQ_read[15:0]                 ), //i
    .io_sdram_DQ_write              (controller_io_sdram_DQ_write[15:0]        ), //o
    .io_sdram_DQ_writeEnable        (controller_io_sdram_DQ_writeEnable[15:0]  ), //o
    .io_sdram_DQM                   (controller_io_sdram_DQM[1:0]              ), //o
    .io_sdram_CASn                  (controller_io_sdram_CASn                  ), //o
    .io_sdram_CKE                   (controller_io_sdram_CKE                   ), //o
    .io_sdram_CSn                   (controller_io_sdram_CSn                   ), //o
    .io_sdram_RASn                  (controller_io_sdram_RASn                  ), //o
    .io_sdram_WEn                   (controller_io_sdram_WEn                   ), //o
    .io_initDone                    (io_initDone                               ), //o
    .clk                            (clk                                       ), //i
    .reset                          (reset                                     )  //i
  );

  wire [15:0] io_sdram_DQ;
  assign sdramDevice_DQ_read = io_sdram_DQ;
  assign io_sdram_DQ = controller_io_sdram_DQ_writeEnable ? controller_io_sdram_DQ_write : 16'bZZZZZZZZZZZZZZZZ;

  // sdram_model_plus #(
  //   .addr_bits        (12           ),   // 地址位宽
  //   .data_bits        (16           ),   // 数据位宽
  //   .col_bits         (9            ),   // col地址位宽A0-A8
  //   .mem_sizes        (2*1024*1024-1)    // 2M
  // ) sdramDeivce (
  //   .Debug             (1'b1                                      ), //i
  mt48lc16m16a2 sdramDevice (
    .Clk               (~clk                                      ), //i
    .Addr              (controller_io_sdram_ADDR[12:0]            ), //i
    .Ba                (controller_io_sdram_BA[1:0]               ), //i
    .Dq                (io_sdram_DQ                               ), //io
    .Dqm               (controller_io_sdram_DQM[1:0]              ), //i
    .Cas_n             (controller_io_sdram_CASn                  ), //i
    .Cke               (controller_io_sdram_CKE                   ), //i
    .Cs_n              (controller_io_sdram_CSn                   ), //i
    .Ras_n             (controller_io_sdram_RASn                  ), //i
    .We_n              (controller_io_sdram_WEn                   )  //i
  );

  initial begin
    $dumpfile ("wave.vcd");
    $dumpvars;
    #1;
  end
endmodule
