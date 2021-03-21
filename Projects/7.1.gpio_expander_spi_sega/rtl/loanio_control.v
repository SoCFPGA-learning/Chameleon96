module loanio_control (					
			// define input / output parameters of the module
			input  wire			clk,			//clock input from pll
    		input  		        locked,         // Goes high when the clock is stable
			output wire 		WIFI_LED,
			output wire 		BT_LED,
			input  wire [66:0] loan_io_in,		//loan io inputs coming from soc_system block
			output wire [66:0] loan_io_out,		//loan io outputs going to soc_system block
			output wire [66:0] loan_io_oe		//loan io enable outputs going to soc_system block
			);

reg  [26:0] counter;	
wire 		RESET_KEY;
wire [3:0]  BOARD_LEDS;

//enable oe (1) the outputs
assign loan_io_oe[14] = 1'b1;			//user led 3
assign loan_io_oe[22] = 1'b1;			//user led 2
assign loan_io_oe[25] = 1'b1;			//user led 1
assign loan_io_oe[32] = 1'b1;			//user led 0
assign loan_io_oe[34:33] = 2'b11;
assign loan_io_oe[30:29] = 2'b11;
assign loan_io_oe[17] = 1'b1;
assign loan_io_oe[48] = 1'b1;
assign loan_io_oe[54:53] = 2'b11;
assign loan_io_oe[23] = 1'b1;			//LS_PIN 33


//disable oe (0) the inputs
assign loan_io_oe[19] = 1'b0;			//LS pin 23  Connected to an external button	 	
assign loan_io_oe[28] = 1'b0;			//SPI MISO signal	            //LS pin 32 ok 
assign loan_io_oe[27] = 1'b0;			//INTA Interrupt from mcp23s17	//LS pin 28 ok 	


debouncer resetkey0 (
			.clk(clk),
			.in (loan_io_in[19]),		//loanio input coming from soc_hps block
			.out (RESET_KEY)
); 


always @ (posedge clk)  		// on positive clock edge
	counter <= counter + 1;		// increment counter
			
gpio_spi gpio_spi_0 (
    .CLK(clk),
    .LOCKED(locked),
    .RESET_N(~RESET_KEY),        	//KEY 0
    // LED output
    .CORE_LED(BT_LED),     			//BT LED
    .BOARD_LEDS(BOARD_LEDS),     	//USER LEDS 0..3
    //Joystick SELECT Pin   (for selection of buttons to read)
	.JOY_SEL(loan_io_out[34]),		//LS pin 26	ok			
    // MCP23S17 interface
    .JS_INTA(loan_io_in[27]),     	//INTA Interrupt from mcp23s17	//LS pin 28 ok  
    .JS_MISO(loan_io_in[28]),		//LS pin 32 ok 
    .JS_MOSI(loan_io_out[29]),		//LS pin 30 ok
    .JS_CS(loan_io_out[53]),		//LS pin 31 ok
    .JS_SCK(loan_io_out[23])		//LS pin 33 ok
);
				
//LEDS
assign loan_io_out[14] = ~BOARD_LEDS[3];		// user led 3
assign loan_io_out[22] = ~BOARD_LEDS[2];	    // user led 2
assign loan_io_out[25] = ~BOARD_LEDS[1];		// user led 1 
assign loan_io_out[32] = ~BOARD_LEDS[0];		// user led 0 
assign WIFI_LED = counter [22] && ~RESET_KEY ;	//activity leds to show the core is working
							
/*
//LS_Connector 		FREE PINS				LS_PIN			
assign loan_io_out[33] = vsync;				//LS pin 24 
assign loan_io_out[48] = BLUE[1];			//LS pin 29
assign loan_io_out[30] = counter[24];		//LS pin 34	
assign loan_io_oe[54] = 1'b0;			    //LS pin 27  	         
.JOY_SEL(loan_io_out[17]),		            //LS pin 25				
*/  

endmodule					
