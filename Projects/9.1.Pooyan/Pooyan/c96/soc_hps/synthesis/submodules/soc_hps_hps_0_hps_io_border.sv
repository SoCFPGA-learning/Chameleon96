// (C) 2001-2017 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


module soc_hps_hps_0_hps_io_border(
// gpio_loanio
  output wire [29 - 1 : 0 ] gpio_loanio_loanio0_i
 ,input wire [29 - 1 : 0 ] gpio_loanio_loanio0_oe
 ,input wire [29 - 1 : 0 ] gpio_loanio_loanio0_o
 ,output wire [29 - 1 : 0 ] gpio_loanio_loanio1_i
 ,input wire [29 - 1 : 0 ] gpio_loanio_loanio1_oe
 ,input wire [29 - 1 : 0 ] gpio_loanio_loanio1_o
 ,output wire [9 - 1 : 0 ] gpio_loanio_loanio2_i
 ,input wire [9 - 1 : 0 ] gpio_loanio_loanio2_oe
 ,input wire [9 - 1 : 0 ] gpio_loanio_loanio2_o
// memory
 ,output wire [15 - 1 : 0 ] mem_a
 ,output wire [3 - 1 : 0 ] mem_ba
 ,output wire [1 - 1 : 0 ] mem_ck
 ,output wire [1 - 1 : 0 ] mem_ck_n
 ,output wire [1 - 1 : 0 ] mem_cke
 ,output wire [1 - 1 : 0 ] mem_cs_n
 ,output wire [1 - 1 : 0 ] mem_ras_n
 ,output wire [1 - 1 : 0 ] mem_cas_n
 ,output wire [1 - 1 : 0 ] mem_we_n
 ,output wire [1 - 1 : 0 ] mem_reset_n
 ,inout wire [16 - 1 : 0 ] mem_dq
 ,inout wire [2 - 1 : 0 ] mem_dqs
 ,inout wire [2 - 1 : 0 ] mem_dqs_n
 ,output wire [1 - 1 : 0 ] mem_odt
 ,output wire [2 - 1 : 0 ] mem_dm
 ,input wire [1 - 1 : 0 ] oct_rzqin
// hps_io
 ,inout wire [1 - 1 : 0 ] hps_io_sdio_inst_CMD
 ,inout wire [1 - 1 : 0 ] hps_io_sdio_inst_D0
 ,inout wire [1 - 1 : 0 ] hps_io_sdio_inst_D1
 ,output wire [1 - 1 : 0 ] hps_io_sdio_inst_CLK
 ,inout wire [1 - 1 : 0 ] hps_io_sdio_inst_D2
 ,inout wire [1 - 1 : 0 ] hps_io_sdio_inst_D3
 ,input wire [1 - 1 : 0 ] hps_io_uart0_inst_RX
 ,output wire [1 - 1 : 0 ] hps_io_uart0_inst_TX
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_LOANIO14
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_LOANIO17
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_LOANIO19
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_LOANIO22
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_LOANIO23
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_LOANIO25
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_LOANIO27
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_LOANIO28
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_LOANIO29
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_LOANIO30
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_LOANIO32
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_LOANIO33
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_LOANIO34
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_LOANIO48
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_LOANIO53
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_LOANIO54
);

assign hps_io_sdio_inst_CMD = intermediate[1] ? intermediate[0] : 'z;
assign hps_io_sdio_inst_D0 = intermediate[3] ? intermediate[2] : 'z;
assign hps_io_sdio_inst_D1 = intermediate[5] ? intermediate[4] : 'z;
assign hps_io_sdio_inst_D2 = intermediate[7] ? intermediate[6] : 'z;
assign hps_io_sdio_inst_D3 = intermediate[9] ? intermediate[8] : 'z;
assign hps_io_gpio_inst_LOANIO14 = intermediate[11] ? intermediate[10] : 'z;
assign hps_io_gpio_inst_LOANIO17 = intermediate[13] ? intermediate[12] : 'z;
assign hps_io_gpio_inst_LOANIO19 = intermediate[15] ? intermediate[14] : 'z;
assign hps_io_gpio_inst_LOANIO22 = intermediate[17] ? intermediate[16] : 'z;
assign hps_io_gpio_inst_LOANIO23 = intermediate[19] ? intermediate[18] : 'z;
assign hps_io_gpio_inst_LOANIO25 = intermediate[21] ? intermediate[20] : 'z;
assign hps_io_gpio_inst_LOANIO27 = intermediate[23] ? intermediate[22] : 'z;
assign hps_io_gpio_inst_LOANIO28 = intermediate[25] ? intermediate[24] : 'z;
assign hps_io_gpio_inst_LOANIO29 = intermediate[27] ? intermediate[26] : 'z;
assign hps_io_gpio_inst_LOANIO30 = intermediate[29] ? intermediate[28] : 'z;
assign hps_io_gpio_inst_LOANIO32 = intermediate[31] ? intermediate[30] : 'z;
assign hps_io_gpio_inst_LOANIO33 = intermediate[33] ? intermediate[32] : 'z;
assign hps_io_gpio_inst_LOANIO34 = intermediate[35] ? intermediate[34] : 'z;
assign hps_io_gpio_inst_LOANIO48 = intermediate[37] ? intermediate[36] : 'z;
assign hps_io_gpio_inst_LOANIO53 = intermediate[39] ? intermediate[38] : 'z;
assign hps_io_gpio_inst_LOANIO54 = intermediate[41] ? intermediate[40] : 'z;

wire [42 - 1 : 0] intermediate;

wire [117 - 1 : 0] floating;

cyclonev_hps_peripheral_sdmmc sdio_inst(
 .SDMMC_DATA_I({
    hps_io_sdio_inst_D3[0:0] // 3:3
   ,hps_io_sdio_inst_D2[0:0] // 2:2
   ,hps_io_sdio_inst_D1[0:0] // 1:1
   ,hps_io_sdio_inst_D0[0:0] // 0:0
  })
,.SDMMC_CMD_O({
    intermediate[0:0] // 0:0
  })
,.SDMMC_CCLK({
    hps_io_sdio_inst_CLK[0:0] // 0:0
  })
,.SDMMC_DATA_O({
    intermediate[8:8] // 3:3
   ,intermediate[6:6] // 2:2
   ,intermediate[4:4] // 1:1
   ,intermediate[2:2] // 0:0
  })
,.SDMMC_CMD_OE({
    intermediate[1:1] // 0:0
  })
,.SDMMC_CMD_I({
    hps_io_sdio_inst_CMD[0:0] // 0:0
  })
,.SDMMC_DATA_OE({
    intermediate[9:9] // 3:3
   ,intermediate[7:7] // 2:2
   ,intermediate[5:5] // 1:1
   ,intermediate[3:3] // 0:0
  })
);


cyclonev_hps_peripheral_uart uart0_inst(
 .UART_RXD({
    hps_io_uart0_inst_RX[0:0] // 0:0
  })
,.UART_TXD({
    hps_io_uart0_inst_TX[0:0] // 0:0
  })
);


cyclonev_hps_peripheral_gpio gpio_inst(
 .GPIO1_PORTA_I({
    hps_io_gpio_inst_LOANIO54[0:0] // 25:25
   ,hps_io_gpio_inst_LOANIO53[0:0] // 24:24
   ,floating[3:0] // 23:20
   ,hps_io_gpio_inst_LOANIO48[0:0] // 19:19
   ,floating[16:4] // 18:6
   ,hps_io_gpio_inst_LOANIO34[0:0] // 5:5
   ,hps_io_gpio_inst_LOANIO33[0:0] // 4:4
   ,hps_io_gpio_inst_LOANIO32[0:0] // 3:3
   ,floating[17:17] // 2:2
   ,hps_io_gpio_inst_LOANIO30[0:0] // 1:1
   ,hps_io_gpio_inst_LOANIO29[0:0] // 0:0
  })
,.LOANIO1_O({
    gpio_loanio_loanio1_o[28:0] // 28:0
  })
,.LOANIO0_OE({
    gpio_loanio_loanio0_oe[28:0] // 28:0
  })
,.LOANIO0_I({
    gpio_loanio_loanio0_i[28:0] // 28:0
  })
,.GPIO1_PORTA_OE({
    intermediate[41:41] // 25:25
   ,intermediate[39:39] // 24:24
   ,floating[21:18] // 23:20
   ,intermediate[37:37] // 19:19
   ,floating[34:22] // 18:6
   ,intermediate[35:35] // 5:5
   ,intermediate[33:33] // 4:4
   ,intermediate[31:31] // 3:3
   ,floating[35:35] // 2:2
   ,intermediate[29:29] // 1:1
   ,intermediate[27:27] // 0:0
  })
,.LOANIO2_O({
    gpio_loanio_loanio2_o[8:0] // 8:0
  })
,.LOANIO1_I({
    gpio_loanio_loanio1_i[28:0] // 28:0
  })
,.GPIO0_PORTA_O({
    intermediate[24:24] // 28:28
   ,intermediate[22:22] // 27:27
   ,floating[36:36] // 26:26
   ,intermediate[20:20] // 25:25
   ,floating[37:37] // 24:24
   ,intermediate[18:18] // 23:23
   ,intermediate[16:16] // 22:22
   ,floating[39:38] // 21:20
   ,intermediate[14:14] // 19:19
   ,floating[40:40] // 18:18
   ,intermediate[12:12] // 17:17
   ,floating[42:41] // 16:15
   ,intermediate[10:10] // 14:14
   ,floating[56:43] // 13:0
  })
,.LOANIO2_OE({
    gpio_loanio_loanio2_oe[8:0] // 8:0
  })
,.LOANIO2_I({
    gpio_loanio_loanio2_i[8:0] // 8:0
  })
,.GPIO0_PORTA_I({
    hps_io_gpio_inst_LOANIO28[0:0] // 28:28
   ,hps_io_gpio_inst_LOANIO27[0:0] // 27:27
   ,floating[57:57] // 26:26
   ,hps_io_gpio_inst_LOANIO25[0:0] // 25:25
   ,floating[58:58] // 24:24
   ,hps_io_gpio_inst_LOANIO23[0:0] // 23:23
   ,hps_io_gpio_inst_LOANIO22[0:0] // 22:22
   ,floating[60:59] // 21:20
   ,hps_io_gpio_inst_LOANIO19[0:0] // 19:19
   ,floating[61:61] // 18:18
   ,hps_io_gpio_inst_LOANIO17[0:0] // 17:17
   ,floating[63:62] // 16:15
   ,hps_io_gpio_inst_LOANIO14[0:0] // 14:14
   ,floating[77:64] // 13:0
  })
,.GPIO0_PORTA_OE({
    intermediate[25:25] // 28:28
   ,intermediate[23:23] // 27:27
   ,floating[78:78] // 26:26
   ,intermediate[21:21] // 25:25
   ,floating[79:79] // 24:24
   ,intermediate[19:19] // 23:23
   ,intermediate[17:17] // 22:22
   ,floating[81:80] // 21:20
   ,intermediate[15:15] // 19:19
   ,floating[82:82] // 18:18
   ,intermediate[13:13] // 17:17
   ,floating[84:83] // 16:15
   ,intermediate[11:11] // 14:14
   ,floating[98:85] // 13:0
  })
,.GPIO1_PORTA_O({
    intermediate[40:40] // 25:25
   ,intermediate[38:38] // 24:24
   ,floating[102:99] // 23:20
   ,intermediate[36:36] // 19:19
   ,floating[115:103] // 18:6
   ,intermediate[34:34] // 5:5
   ,intermediate[32:32] // 4:4
   ,intermediate[30:30] // 3:3
   ,floating[116:116] // 2:2
   ,intermediate[28:28] // 1:1
   ,intermediate[26:26] // 0:0
  })
,.LOANIO1_OE({
    gpio_loanio_loanio1_oe[28:0] // 28:0
  })
,.LOANIO0_O({
    gpio_loanio_loanio0_o[28:0] // 28:0
  })
);


// hps_sdram hps_sdram_inst(
//  .mem_dq({
//     mem_dq[15:0] // 15:0
//   })
// ,.mem_odt({
//     mem_odt[0:0] // 0:0
//   })
// ,.mem_ras_n({
//     mem_ras_n[0:0] // 0:0
//   })
// ,.mem_dqs_n({
//     mem_dqs_n[1:0] // 1:0
//   })
// ,.mem_dqs({
//     mem_dqs[1:0] // 1:0
//   })
// ,.mem_dm({
//     mem_dm[1:0] // 1:0
//   })
// ,.mem_we_n({
//     mem_we_n[0:0] // 0:0
//   })
// ,.mem_cas_n({
//     mem_cas_n[0:0] // 0:0
//   })
// ,.mem_ba({
//     mem_ba[2:0] // 2:0
//   })
// ,.mem_a({
//     mem_a[14:0] // 14:0
//   })
// ,.mem_cs_n({
//     mem_cs_n[0:0] // 0:0
//   })
// ,.mem_ck({
//     mem_ck[0:0] // 0:0
//   })
// ,.mem_cke({
//     mem_cke[0:0] // 0:0
//   })
// ,.oct_rzqin({
//     oct_rzqin[0:0] // 0:0
//   })
// ,.mem_reset_n({
//     mem_reset_n[0:0] // 0:0
//   })
// ,.mem_ck_n({
//     mem_ck_n[0:0] // 0:0
//   })
// );

endmodule

