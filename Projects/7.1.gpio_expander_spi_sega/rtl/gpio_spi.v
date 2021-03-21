`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Module Name: gpio_spi
// Create Date: 08/01/2021
// Description: 
// 
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module gpio_spi(
    input           CLK,
    input           LOCKED,        // Goes high when the clock is stable
    input           RESET_N,        //KEY0

    // LED output
    output          CORE_LED,       //H_LED0
    output [3:0]    BOARD_LEDS,     //LED0..3

    //Joystick SELECT Pin   (for selection of buttons to read)
    output          JOY_SEL,

    // MCP23S17 interface
    input           JS_INTA,        // Interrupt from mcp23s17
    input           JS_MISO,
    output          JS_MOSI,
    output          JS_CS,
    output          JS_SCK
);

// io 
reg         reset;        // System reset state

// SPI Joystick
wire        ready;        // Indicates when the interface is ready
wire [11:0] Joya;         // Joystick A results

// Reset
always @(posedge CLK) begin
    reset <= 1'b0;
    if(~LOCKED || ~RESET_N) begin
        reset <= 1'b1;
    end
end

    
 mcp23s17_input joy_test (
  .clk(CLK),        // Clock in   
  .rst(reset),      // Reset 

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
  .Joy_a(Joya),   // Joystick 1 output

  // Joystick SEGA SELECT Pin   (for selection of buttons to read)
  .JOY_SEL(JOY_SEL)     
);

// Button pressed = Led ON. Multiplex 12 buttons into the 4 fpga board leds 
assign BOARD_LEDS[0] = Joya[0] || Joya[4] || Joya[8];  // Joya[0]=GPA0 (PIN21), Joyb[0]=GPA6 (PIN7)
assign BOARD_LEDS[1] = Joya[1] || Joya[5] || Joya[9];
assign BOARD_LEDS[2] = Joya[2] || Joya[6] || Joya[10];
assign BOARD_LEDS[3] = Joya[3] || Joya[7] || Joya[11];  // Joya[3]=GPA3 (PIN24), Joyb[3]=GPA3 (PIN4)


// The LED remains lid if something goes wrong
assign CORE_LED = LOCKED && ready;

endmodule
