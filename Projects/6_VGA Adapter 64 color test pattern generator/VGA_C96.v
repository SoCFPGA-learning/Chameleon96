//////////////////////////////////////////////////////////////////////////////////
// VGA 64 colors test
// Antonio Sánchez
// for the Chameleon 96 Group
//////////////////////////////////////////////////////////////////////////////////

//http://tinyvga.com/vga-timing/640x480@60Hz
//Screen refresh rate	60 Hz
//Vertical refresh	31.46875 kHz
//Pixel freq.	25.175 MHz
//Horizontal timing (line)
//Polarity of horizontal sync pulse is negative.
//Scanline part	Pixels	Time [µs]
//Visible area	640	25.422045680238
//Front porch	16	0.63555114200596
//Sync pulse	96	3.8133068520357
//Back porch	48	1.9066534260179
//Whole line	800	31.777557100298

//Vertical timing (frame)
//Polarity of vertical sync pulse is negative.
//Frame part	Lines	Time [ms]
//Visible area	480	15.253227408143
//Front porch	10	0.31777557100298
//Sync pulse	2	0.063555114200596
//Back porch	33	1.0486593843098
//Whole frame	525	16.683217477656

//For a 12.05MHz Clock we try divide by 2
`define VisibleX    320
`define FrontX      8
`define SyncX       48
`define BackX       24
`define TotalX      400

`define VisibleY    480
`define FrontY      10
`define SyncY       2
`define BackY       33
`define TotalY      525

module VGA_C96(
    input wire  clk12,
    output wire [1:0]red,
    output wire [1:0]green,
    output wire [1:0]blue,
    output wire hsync,
    output wire vsync);
    
reg [8:0] CounterX=0;
reg [9:0] CounterY=0;
reg [5:0] Color=0;

assign hsync=(CounterX>(`BackX+`VisibleX+`FrontX-1)) ?1'h0:1'h1;
assign vsync=(CounterY>(`VisibleY+`FrontY-1)) && (CounterY<(`VisibleY+`FrontY+`SyncY)) ?1'h0:1'h1;

assign visible=(CounterX>=`BackX && CounterX<=`BackX+`VisibleX)
                && (CounterY>=`BackY && CounterY<=`BackY+`VisibleY);
assign red=(visible)?Color[5:4]:0;
assign green=(visible)?Color[3:2]:0;
assign blue=(visible)?Color[1:0]:0;

always  @(posedge clk12)begin
    Color[2:0]<=((CounterX-`BackX)/40);
    Color[5:3]<=((CounterY-`BackY)/60);
    if (CounterX==`TotalX) begin
        CounterX<=0;
        CounterY<=CounterY+1'b1;
        if (CounterY==`TotalY) begin
            CounterY<=0;
        end
        else begin
            CounterY<=CounterY+1'b1;
        end
    end
    else begin
        CounterX<=CounterX+1'b1;
    end
end

endmodule


