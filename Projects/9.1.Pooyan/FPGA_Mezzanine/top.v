//  10M04DAF256C8G TEMPLATE 
//  
//  Date : 
// 
//  Description :
// 

module top (
	// CLOCK
	input  	 		CLK_50,
	output 	 		CLK_OUT,

	// DIP Switches
	input [3:0]  	DIP,

	// LED
	output [3:0] 	LED,	

	// LOW SPEED CONNECTOR  ////////
	//VGA
	input LS_GPIOA19,
	input LS_GPIOB33,
	input LS_GPIOC17,
	input LS_GPIOD34,
	input LS_GPIOG48,
	input LS_GPIOH29,
	input LS_GPIOJ28,
	input LS_GPIOL30,
	//PWM AUDIO
	output LS_GPIOI53,
	output LS_GPIOE54,
	//PS2 KEYBOARD
	input LS_GPIOK23,
	input LS_GPIOF27,


	// ARDUINO CONNECTOR ////////
	// audio sigma-delta
	output ARD_PD0,
	output ARD_PD1,
	// ps2 keyboard
	input ARD_PD2,
	input ARD_PD3,

	output ARD_PD4,
	output ARD_PD5,
	output ARD_PD6,
	output ARD_PD7,


	// RPI CONNECTOR ////////
	output RPI_GPIO2,
	output RPI_GPIO3,
	output RPI_GPIO4,
	output RPI_GPIO5,
	output RPI_GPIO6,
	output RPI_GPIO7,
	output RPI_GPIO8,
	output RPI_GPIO9,
	output RPI_GPIO10,
	output RPI_GPIO11,
	output RPI_GPIO12,
	output RPI_GPIO13,
	output RPI_GPIO14,
	output RPI_GPIO15,
	output RPI_GPIO16,
	output RPI_GPIO17,
	output RPI_GPIO18,
	output RPI_GPIO19,
	output RPI_GPIO20,
	output RPI_GPIO21,
	output RPI_GPIO22,
	output RPI_GPIO23,
	output RPI_GPIO24,
	output RPI_GPIO25,
	output RPI_GPIO26,
	output RPI_GPIO27,
	output RPI_ID_SC,	
	output RPI_ID_SD


);

assign CLK_OUT = CLK_50;
assign LED[0] = 1'b1;

assign RPI_GPIO2 = LS_GPIOG48;	//VS
assign RPI_GPIO3 = LS_GPIOC17;	//HS

assign RPI_GPIO21 = LS_GPIOJ28;	//R1
assign RPI_GPIO20 = LS_GPIOL30;	//R0

assign RPI_GPIO15 = LS_GPIOD34;	//G1
assign RPI_GPIO14 = LS_GPIOH29;	//G0

assign RPI_GPIO9 = LS_GPIOA19;	//B1
assign RPI_GPIO8 = LS_GPIOB33;	//B0

assign ARD_PD0 = LS_GPIOK23;	//PWM_R
assign ARD_PD1 = LS_GPIOF27;	//PWM_L

assign LS_GPIOI53 = ARD_PD2;	//KCLK		
assign LS_GPIOE54 = ARD_PD3;	//KDAT

// assign  LED[2] = ~LS_GPIOI53;
// assign  LED[3] = ~LS_GPIOE54;

endmodule