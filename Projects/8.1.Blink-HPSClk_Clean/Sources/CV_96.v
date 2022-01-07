
module CV_96 (
	output FPGA_2V5_RF_LEDS_LED1_PIN_Y19,
	output FPGA_2V5_RF_LEDS_LED2_PIN_Y20
);

wire clk;
wire led;		


HPS   u0(
	.h2f_user0_clk( clk)  	//hps_0_h2f_user0_clock.clk
);
	

blink u1 (
	.clk  ( clk ), 
	.LED  ( led )
);
	   
assign FPGA_2V5_RF_LEDS_LED1_PIN_Y19 = led;
assign FPGA_2V5_RF_LEDS_LED2_PIN_Y20 = ~led;	
		   
endmodule



