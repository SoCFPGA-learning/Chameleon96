`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Module Name: gpio_expander
// Create Date: 08/01/2021
// Description: 
// 
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module gpio_expander(
    input           clk28,         // 28 MHz clock
    input           locked,        // Goes high when the clock is stable
    input           RESET_N,        //KEY0

    // LED output
    output          CORE_LED,       //H_LED0
    output [3:0]    BOARD_LEDS,     //LED0..3

    // MCP23S17 interface
    input           JS_INTA,        // Interrupt from mcp23s17
    input           JS_MISO,
    output          JS_MOSI,
    output          JS_CS,
    output          JS_SCK
);

// io 
reg         reset;         // System reset state

// SPI Joystick
wire        ready;        // Indicates when the interface is ready
wire [7:0]  Joya;         // Joystick A results
wire [7:0]  Joyb;         // Joystick B results

// Reset
always @(posedge clk28) begin
    reset <= 1'b0;
    if(~locked || ~RESET_N) begin
        reset <= 1'b1;
    end
end

    
 mcp23s17_input joy_test (
  .clk(clk28),    // 28MHz Clock in
  .rst(reset),    // Reset 

  // Interrupt from mcp23s17
  .inta(JS_INTA),

  // SPI Interface
  .miso(JS_MISO),
  .mosi(JS_MOSI),
  .cs(JS_CS),
  .sck(JS_SCK),

  // State
  .ready(ready),  // Goes high when the MCP23S17 is configured

  // Joystick I/O
  .Joya(Joya),   // Joystick 1 output
  .Joyb(Joyb)    // Joystick 2 output
);

// Assign joystick signals to 4 leds, as defined in https://github.com/ranzbak/aars_joystick 
//assign BOARD_LEDS[0] = Joya[0] && Joya[4] && Joyb[0] && Joyb[4];
//assign BOARD_LEDS[1] = Joya[1] && Joya[5] && Joyb[1] && Joyb[5];
//assign BOARD_LEDS[2] = Joya[2] && Joya[6] && Joyb[2] && Joyb[6];
//assign BOARD_LEDS[3] = Joya[3] && Joya[7] && Joyb[3] && Joyb[7];

// Change for testing just 4 inputs 
assign BOARD_LEDS[0] = Joya[0];  // Joya[0]=GPA0 (PIN21), Joyb[0]=GPA6 (PIN7)
assign BOARD_LEDS[1] = Joya[1];
assign BOARD_LEDS[2] = Joya[2];
assign BOARD_LEDS[3] = Joya[3];  // Joya[3]=GPA3 (PIN24), Joyb[3]=GPA3 (PIN4)
//

// The LED remains lid if something goes wrong
assign CORE_LED = locked && ready;

endmodule
