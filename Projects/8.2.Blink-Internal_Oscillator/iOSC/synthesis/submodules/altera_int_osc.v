//altint_osc CBX_AUTO_BLACKBOX="ALL" CBX_SINGLE_OUTPUT_FILE="ON" DEVICE_FAMILY="Cyclone V" clkout oscena
//VERSION_BEGIN 20.1 cbx_altint_osc 2020:06:05:12:04:51:SJ cbx_arriav 2020:06:05:12:04:49:SJ cbx_cycloneii 2020:06:05:12:04:51:SJ cbx_lpm_add_sub 2020:06:05:12:04:51:SJ cbx_lpm_compare 2020:06:05:12:04:51:SJ cbx_lpm_counter 2020:06:05:12:04:51:SJ cbx_lpm_decode 2020:06:05:12:04:51:SJ cbx_mgl 2020:06:05:12:11:10:SJ cbx_nadder 2020:06:05:12:04:51:SJ cbx_nightfury 2020:06:05:12:04:50:SJ cbx_stratix 2020:06:05:12:04:51:SJ cbx_stratixii 2020:06:05:12:04:51:SJ cbx_stratixiii 2020:06:05:12:04:51:SJ cbx_stratixv 2020:06:05:12:04:51:SJ cbx_tgx 2020:06:05:12:04:51:SJ cbx_zippleback 2020:06:05:12:04:51:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 2020  Intel Corporation. All rights reserved.
//  Your use of Intel Corporation's design tools, logic functions 
//  and other software and tools, and any partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Intel Program License 
//  Subscription Agreement, the Intel Quartus Prime License Agreement,
//  the Intel FPGA IP License Agreement, or other applicable license
//  agreement, including, without limitation, that your use is for
//  the sole purpose of programming logic devices manufactured by
//  Intel and sold by Intel or its authorized distributors.  Please
//  refer to the applicable agreement for further details, at
//  https://fpgasoftware.intel.com/eula.



//synthesis_resources = cyclonev_oscillator 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  altera_int_osc
	( 
	clkout,
	oscena) /* synthesis synthesis_clearbox=1 */;
	output   clkout;
	input   oscena;

	wire  wire_sd1_clkout;

	cyclonev_oscillator   sd1
	( 
	.clkout(wire_sd1_clkout),
	.clkout1(),
	.oscena(oscena));
	assign
		clkout = wire_sd1_clkout;
endmodule //altera_int_osc
//VALID FILE
