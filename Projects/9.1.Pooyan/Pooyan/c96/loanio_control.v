module loanio_control (					
			// define input / output parameters of the module
			input  wire	clk,						//clock input
			input  wire [1:0] RED,
			input  wire [1:0] GREEN,
			input  wire [1:0] BLUE,
			input  wire hsync,
			input  wire vsync,

			input  wire pwm_l,
			input  wire pwm_r,

			output wire ps2_clk, 
			output wire ps2_dat, 

			// input  wire [31:0] counter,		//counter input coming from the simple_counter module
			input  wire [66:0] loan_io_in,	//loan io inputs coming from soc_hps block
			output wire [66:0] loan_io_out,	//loan io outputs going to soc_hps block
			output wire [66:0] loan_io_oe		//loan io enable outputs going to soc_hps block
			);

//enable (1) the outputs
assign loan_io_oe[14] = 1'b1;
assign loan_io_oe[22] = 1'b1;
assign loan_io_oe[25] = 1'b1;
assign loan_io_oe[32] = 1'b1;

assign loan_io_oe[17] = 1'b1;
assign loan_io_oe[19] = 1'b1;
assign loan_io_oe[30:28] = 3'b111;
assign loan_io_oe[34:33] = 2'b11;
assign loan_io_oe[48] = 1'b1;

assign loan_io_oe[23] = 1'b1;
assign loan_io_oe[27] = 1'b1;

//enable (0) the inputs
assign loan_io_oe[54:53] = 2'b00;

//set the enable output value to zero for the rest of pins (this is just to avoid warnings from compiler)
assign loan_io_oe[13:0] = 14'b0;		


//LS_Connector Outputs						LS_PIN		    WIRE 		--		SIGNAL	RESISTOR
assign loan_io_out[48] = vsync;				//pin 29		marron		D0		VS			100 Ohm
assign loan_io_out[17] = hsync;				//pin 25		taronja		D1		HS			100 Ohm
assign loan_io_out[19] = BLUE[1];			//pin 23		groc		D2		B0			390 Ohm
assign loan_io_out[33] = BLUE[0];			//pin 24		verd		D3		B1			200 Ohm
assign loan_io_out[34] = GREEN[1];			//pin 26		blau		D4		G0			390 Ohm
assign loan_io_out[29] = GREEN[0];			//pin 30		lila		D5		G1			200 Ohm
assign loan_io_out[28] = RED[1];			//pin 32		gris		D6		R0			390 Ohm
assign loan_io_out[30] = RED[0];			//pin 34		blanc		D7		R1			200 Ohm

assign loan_io_out[23] = pwm_l;	
assign loan_io_out[27] = pwm_r;	

//LS_Connector Inputs
assign ps2_clk = loan_io_in[53];	
assign ps2_dat = loan_io_in[54];	

///////////////  frequency   counter[24] =  3Hz  =  (100MHz / 2^24) / 2     ////////////////

// //LS_Connector 
// assign loan_io_out[27] = counter[24];		//pin 28		----
// assign loan_io_out[54] = counter[22];		//pin 27		---
// assign loan_io_out[53] = counter[24];		//pin 31		

// //USER LEDS
// assign loan_io_out[14] = button_status;	// user led 3
// assign loan_io_out[22] = counter[23];	// user led 2
// assign loan_io_out[25] = counter[24]		// user led 1 
// assign loan_io_out[32] = button_status;	// user led 0 

// Debug leds
// assign loan_io_out[14] = ~ps2_clk;	// user led 3
// assign loan_io_out[32] = ~ps2_dat;	// user led 2

//assign to the rest of outputs a zero value (this is just to avoid warnings from compiler)
assign loan_io_out[13:0] = 14'b0;
//......

endmodule					
