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


module soc_hps_hps_0_fpga_interfaces(
// h2f_loan_io
  output wire [67 - 1 : 0 ] h2f_loan_in
 ,input wire [67 - 1 : 0 ] h2f_loan_out
 ,input wire [67 - 1 : 0 ] h2f_loan_oe
// loanio_gpio
 ,input wire [29 - 1 : 0 ] loanio_gpio_loanio0_i
 ,output wire [29 - 1 : 0 ] loanio_gpio_loanio0_oe
 ,output wire [29 - 1 : 0 ] loanio_gpio_loanio0_o
 ,input wire [29 - 1 : 0 ] loanio_gpio_loanio1_i
 ,output wire [29 - 1 : 0 ] loanio_gpio_loanio1_oe
 ,output wire [29 - 1 : 0 ] loanio_gpio_loanio1_o
 ,input wire [9 - 1 : 0 ] loanio_gpio_loanio2_i
 ,output wire [9 - 1 : 0 ] loanio_gpio_loanio2_oe
 ,output wire [9 - 1 : 0 ] loanio_gpio_loanio2_o
// h2f_reset
 ,output wire [1 - 1 : 0 ] h2f_rst_n
// h2f_user0_clock
 ,output wire [1 - 1 : 0 ] h2f_user0_clk
);


cyclonev_hps_interface_loan_io loan_io_inst(
 .loanio_in({
    h2f_loan_in[66:0] // 66:0
  })
,.loanio_out({
    h2f_loan_out[66:0] // 66:0
  })
,.GPIO_OUT({
    loanio_gpio_loanio2_o[8:0] // 66:58
   ,loanio_gpio_loanio1_o[28:0] // 57:29
   ,loanio_gpio_loanio0_o[28:0] // 28:0
  })
,.GPIO_OE({
    loanio_gpio_loanio2_oe[8:0] // 66:58
   ,loanio_gpio_loanio1_oe[28:0] // 57:29
   ,loanio_gpio_loanio0_oe[28:0] // 28:0
  })
,.GPIO_IN({
    loanio_gpio_loanio2_i[8:0] // 66:58
   ,loanio_gpio_loanio1_i[28:0] // 57:29
   ,loanio_gpio_loanio0_i[28:0] // 28:0
  })
,.loanio_oe({
    h2f_loan_oe[66:0] // 66:0
  })
);


cyclonev_hps_interface_clocks_resets clocks_resets(
 .f2h_pending_rst_ack({
    1'b1 // 0:0
  })
,.f2h_warm_rst_req_n({
    1'b1 // 0:0
  })
,.f2h_dbg_rst_req_n({
    1'b1 // 0:0
  })
,.h2f_rst_n({
    h2f_rst_n[0:0] // 0:0
  })
,.f2h_cold_rst_req_n({
    1'b1 // 0:0
  })
,.h2f_user0_clk({
    h2f_user0_clk[0:0] // 0:0
  })
);


cyclonev_hps_interface_dbg_apb debug_apb(
 .DBG_APB_DISABLE({
    1'b0 // 0:0
  })
,.P_CLK_EN({
    1'b0 // 0:0
  })
);


cyclonev_hps_interface_tpiu_trace tpiu(
 .traceclk_ctl({
    1'b1 // 0:0
  })
);


cyclonev_hps_interface_boot_from_fpga boot_from_fpga(
 .boot_from_fpga_ready({
    1'b0 // 0:0
  })
,.boot_from_fpga_on_failure({
    1'b0 // 0:0
  })
,.bsel_en({
    1'b0 // 0:0
  })
,.csel_en({
    1'b0 // 0:0
  })
,.csel({
    2'b01 // 1:0
  })
,.bsel({
    3'b001 // 2:0
  })
);


cyclonev_hps_interface_fpga2hps fpga2hps(
 .port_size_config({
    2'b11 // 1:0
  })
);


cyclonev_hps_interface_hps2fpga hps2fpga(
 .port_size_config({
    2'b11 // 1:0
  })
);


// cyclonev_hps_interface_fpga2sdram f2sdram(
//  .cfg_cport_rfifo_map({
//     18'b000000000000000000 // 17:0
//   })
// ,.cfg_axi_mm_select({
//     6'b000000 // 5:0
//   })
// ,.cfg_wfifo_cport_map({
//     16'b0000000000000000 // 15:0
//   })
// ,.cfg_cport_type({
//     12'b000000000000 // 11:0
//   })
// ,.cfg_rfifo_cport_map({
//     16'b0000000000000000 // 15:0
//   })
// ,.cfg_port_width({
//     12'b000000000000 // 11:0
//   })
// ,.cfg_cport_wfifo_map({
//     18'b000000000000000000 // 17:0
//   })
// );

endmodule

