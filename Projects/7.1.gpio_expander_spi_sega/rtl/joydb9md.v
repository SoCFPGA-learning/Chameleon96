//Control module for Megadrive DB9 Splitter of Antonio Villena by Aitor Pelaez (NeuroRulez)
//Based on the module written by Victor Trucco and modified by Fernando Mosquera
//https://github.com/MiSTer-DB9/NeoGeo_MiSTer/blob/master/src/joydb9md.v
//
//Modified by Somhic. 
// - To simplify example joystick 2 code was erased. 
// - Some counters were changed (see comments for original values)
////////////////////////////////////////////////////////////////////////////////////

module joy_db9md (
  input  clk,
  input  [5:0] joy_in,    	//CBUDLR
  output joy_mdsel,       	//p7 DB9 (low/high Func select)
  output [11:0] joystick1
  );

reg [5:0]state = 8'd0;  		//[7:0]
reg joy1_6btn = 1'b0;
reg [11:0] joyMDdat1 = 12'hFFF;
reg [5:0] joy1_in;
reg joyMDsel, joySEL = 1'b0;
reg [8:0] delay;     			//[7:0]

always @(negedge clk) 
	delay<=delay+1;

always @(negedge delay[6])     	//[5]
	joy1_in <= joy_in;


//Gestion de Joystick
	always @(negedge delay[8])	//[7]
	begin
		state <= state + 1;		
		case (state)					//-- joy_s format MXYZ SACB UDLR
			8'd0:  
				joyMDsel <=  1'b0;					
								
			8'd1:
				joyMDsel <=  1'b1;
			8'd2:
				begin
					joyMDdat1[5:0] <= joy1_in[5:0]; //-- CBUDLR	
					joyMDsel <= 1'b0;
					joy1_6btn <= 1'b0; 	//-- Assume it's not a six-button controller
				end				
			8'd3:
				begin 					// Si derecha e Izda es 0 es un mando de megadrive
					if (joy1_in[1:0] == 2'b00) joyMDdat1[7:6] <= joy1_in[5:4]; //-- Start, A
					else  	 joyMDdat1[7:4] <= { 1'b1, 1'b1, joy1_in[5:4] }; //-- read A/B as master System													
					joyMDsel <= 1'b1;
				end					
			8'd4:  
				joyMDsel <= 1'b0;
			8'd5:
				begin
					if (joy1_in[3:0] == 4'b000) joy1_6btn <= 1'b1; 			// --it's a six button
					joyMDsel <= 1'b1;
				end		
			8'd6:
				begin
					if (joy1_6btn == 1'b1) joyMDdat1[11:8] <= joy1_in[4:0]; //-- Mode, X, Y e Z
					joyMDsel <= 1'b0;
				end 
			default:
				joyMDsel <= 1'b1;					
		endcase

	end

//joyMDdat1 	
//   11 1098 7654 3210   
//----Z  YXM SACB UDLR
//SALIDA joystick[11:0]:
//BA98 7654 3210
//MSZY XCBA UDLR	
assign joystick1 = ~{joyMDdat1[8],joyMDdat1[7],joyMDdat1[11:9],joyMDdat1[5:4],joyMDdat1[6],joyMDdat1[3:0]};
assign joy_mdsel = joyMDsel;

endmodule
