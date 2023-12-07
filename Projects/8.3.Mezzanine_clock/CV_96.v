// `define CLK_HPS

module CV_96 (
	input  CLK_EXT,

	output FPGA_2V5_RF_LEDS_LED1_PIN_Y19,
	output FPGA_2V5_RF_LEDS_LED2_PIN_Y20
);

wire led;
wire clk;
wire clk_pll;

`ifdef CLK_HPS
	// Internal HPS clock (100 MHz)
	HPS   u0(
		.h2f_user0_clk(clk)  	//hps_0_h2f_user0_clock.clk
	);
`else
	// External pin clock (50 MHz)
	assign clk = CLK_EXT;
`endif

pll pll_inst (
	.inclk0 (clk    ),
	.c0		(clk_pll)		
);


blink u1 (
	.clk  ( clk_pll ), 
	.LED  ( led )
);
	   
assign FPGA_2V5_RF_LEDS_LED1_PIN_Y19 = led;
assign FPGA_2V5_RF_LEDS_LED2_PIN_Y20 = ~led;	
		   
endmodule



