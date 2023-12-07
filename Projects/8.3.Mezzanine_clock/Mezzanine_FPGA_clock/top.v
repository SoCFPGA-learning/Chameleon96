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
	output [3:0] 	LED	
);

assign CLK_OUT = CLK_50;

assign LED[0] = 1'b1;

endmodule