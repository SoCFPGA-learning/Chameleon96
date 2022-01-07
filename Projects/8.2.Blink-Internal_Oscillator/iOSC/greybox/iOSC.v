// Copyright (C) 2020  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// VENDOR "Altera"
// PROGRAM "Quartus Prime"
// VERSION "Version 20.1.0 Build 711 06/05/2020 SJ Standard Edition"

// DATE "01/02/2022 17:52:51"

// 
// Device: Altera 5CSEBA6U19I7 Package UFBGA484
// 

// 
// This greybox netlist file is for third party Synthesis Tools
// for timing and resource estimation only.
// 


module iOSC (
	clkout,
	oscena)/* synthesis synthesis_greybox=0 */;
output 	clkout;
input 	oscena;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \int_osc_0|wire_sd1_clkout ;
wire \oscena~_wirecell_combout ;
wire \oscena~input_o ;


iOSC_altera_int_osc int_osc_0(
	.clkout(\int_osc_0|wire_sd1_clkout ),
	.oscena(\oscena~_wirecell_combout ));

cyclonev_lcell_comb \oscena~_wirecell (
	.dataa(!\oscena~input_o ),
	.datab(gnd),
	.datac(gnd),
	.datad(gnd),
	.datae(gnd),
	.dataf(gnd),
	.datag(gnd),
	.cin(gnd),
	.sharein(gnd),
	.combout(\oscena~_wirecell_combout ),
	.sumout(),
	.cout(),
	.shareout());
defparam \oscena~_wirecell .extended_lut = "off";
defparam \oscena~_wirecell .lut_mask = 64'hAAAAAAAAAAAAAAAA;
defparam \oscena~_wirecell .shared_arith = "off";

assign \oscena~input_o  = oscena;

assign clkout = \int_osc_0|wire_sd1_clkout ;

endmodule

module iOSC_altera_int_osc (
	clkout,
	oscena)/* synthesis synthesis_greybox=0 */;
output 	clkout;
input 	oscena;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;



cyclonev_oscillator sd1(
	.oscena(!oscena),
	.clkout(clkout),
	.clkout1());

endmodule
