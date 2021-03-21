/********************************************/
/* minimig_openaars_top.v                   */
/* MiST Board Top File                      */
/*                                          */
/* 2019-2020, ranzbak@gmail.com             */
/********************************************/

module mcp23s17_input (
  input  wire           clk,        // Clock in 
  input  wire           rst,        // Reset 

  // Interrupt from mcp23s17
  input  wire           inta,

  // SPI Interface
  input  wire           miso,
  output wire           mosi,
  output reg            cs,
  output wire           sck,

  // State
  output wire           ready,      // Goes high when the MCP23S17 is configured

  // Joystick I/O
  output   [  11:0]     Joy_a,       // Joystick 1 output

  //Joystick SELECT Pin   (for selection of buttons to read)
  output                JOY_SEL
);

// Joystick
reg [5:0]    Joy_raw;       // Joystick 1 input  

// Defines
localparam  MCP_ADDR  = 3'b000;
localparam  MCP_READ  = 1'b1;
localparam  MCP_WRITE = 1'b0;

// MCP23S17 Register addresses (Bank = 0)
localparam [7:0] 
    REG_ADR_IODIRA  = 8'h00,    // IO direction
    REG_ADR_IODIRB  = 8'h01,
    REG_ADR_INTENA  = 8'h04,    // Interrupt enable on bits
    REG_ADR_INTENB  = 8'h05,
    REG_ADR_GPPUA   = 8'h0C,    // Pull-up registers enable
    REG_ADR_GPPUB   = 8'h0D,    
    REG_ADR_INTCAPA = 8'h10,    // Latched GPIO registers
    REG_ADR_INTCAPB = 8'h11,
    REG_ADR_GPIOA   = 8'h12,    // GPIO registers
    REG_ADR_GPIOB   = 8'h13,
    REG_ADR_IOCON   = 8'h0A;    // Configuration register

// MCP23S17 Config values
localparam [7:0]
    REG_VAL_IODIRA = 8'hFF,       // All IO pins input
    REG_VAL_IODIRB = 8'hFF,
    REG_VAL_INTENA = 8'hFF,       // Trigger interrupt any input change
    REG_VAL_INTENB = 8'hFF,
    REG_VAL_IOCON  = 8'b01010010; // {BANK, MIRROR, SEQOP, DISSLW, HAEN, ODR, INTPOL, Unused}

// SPI
reg  [7:0]  TX_Byte;
reg         TX_DV;
wire        TX_Ready;
wire        RX_DV; 
wire [7:0]  RX_Byte;

// State machine registers
reg         st_done     = 1'b0;  // Stage done, move to next stage
reg         st_dv       = 0;     // Data valid
reg         st_wait     = 0;     // 1 when wait is active
reg [4:0]   st_seq      = 0;     // Sequence number of read data
reg [5:0]   st_wait_cnt = 0;     // Wait before starting new transaction
reg [7:0]   st_data     = 0;     // Received data

// Joystick
reg [7:0]   Joya_raw = 8'hff;
reg [7:0]   Joyb_raw = 8'hff;

// Meta stability
reg         inta_;
reg         inta_s;  // Stable inta signal
reg         miso_;
reg         miso_s;
always @(posedge clk) begin
    inta_ <= inta;
    inta_s <= inta_;
    miso_ <= miso;   // Meta stability
    miso_s <= miso_; // Meta stability
end

// MCP23S17 State machine 
localparam [4:0]
    ST_IDLE        = 0,
    ST_SET_IODIRA  = 1,
    ST_SET_IODIRB  = 2,
    ST_SET_INTENA  = 3,
    ST_SET_INTENB  = 4,
    ST_SET_IOCON   = 5,
    ST_WAITINT     = 10,
    ST_READ_GPIOA  = 11,
    ST_READ_GPIOB  = 12,
    ST_DONE        = 13;
reg [4:0] mcp_state = ST_IDLE;

//// SPI Master ////
SPI_Master 
#(
    .SPI_MODE(0),
    .CLKS_PER_HALF_BIT(3)
)
joy_spi_master
(
    // Control/Data Signals,
    .i_Clk     (clk      ), // FPGA Clock
    .i_Rst_L   (~rst     ), // FPGA Reset (al)

    // TX (MOSI) Signals
    .i_TX_Byte (TX_Byte  ), // Byte to transmit on MOSI
    .i_TX_DV   (TX_DV    ), // Data Valid Pulse with i_TX_Byte
    .o_TX_Ready(TX_Ready ), // Transmit Ready for next byte

    // RX (MISO) Signals
    .o_RX_DV   (RX_DV    ), // Data Valid pulse (1 clock cycle)
    .o_RX_Byte (RX_Byte  ), // Byte received on MISO

    // SPI Interface
    .o_SPI_Clk (sck      ),
    .i_SPI_MISO(miso_s   ),
    .o_SPI_MOSI(mosi     )
);

// Triggers
reg tx_ready_  = 0;
reg tx_ready_t = 0; // Trigger value
reg rx_ready_   = 0;
reg rx_ready_t = 0;
always @(posedge clk) begin
    // rx_ready pos edge trigger
    rx_ready_ <= RX_DV;
    rx_ready_t <= 1'b0;
    if(~rx_ready_ && RX_DV) begin
        rx_ready_t <= 1'b1;
    end

    // tx_ready_ pos edge trigger
    tx_ready_ <= TX_Ready;
    tx_ready_t <= 1'b0;
    if (~tx_ready_ && TX_Ready) begin
        tx_ready_t <= 1'b1;
    end
end

// MCP23S17 Write Register
reg [3:0] tx_pos = 0;
reg [2:0] tx_wait_cnt = 0;
reg       tx_start = 0;
task write_mcp;
    input [7:0] reg_addr;
    input [7:0] cfg_value;
    input [4:0] next_stage;
    begin 
        // Init
        TX_DV <= 1'b0;
        tx_start <= 1'b0;
        st_wait <= 1'b0;
        st_wait_cnt <= 6'b011111;


        // Chip select
        if (~st_wait) begin
            if (cs) begin
                cs <= 1'b0;
                tx_pos <= 4'b0;
                tx_start <= 1'b1;
            end else begin
                // CS is asserted start!
                if(tx_ready_t || tx_start) begin
                    case(tx_pos) 
                        0: begin
                            TX_Byte <= 8'h40; // 0,1,0,0,a2,a1,a0,rw
                            TX_DV <= 1'b1;
                        end
                        1: begin
                            TX_Byte <= reg_addr;
                            TX_DV <= 1'b1;
                        end
                        2: begin
                            TX_Byte <= cfg_value;
                            TX_DV <= 1'b1;
                        end
                        default: begin
                            cs <= 1'b1;
                            st_wait <= 1'b1;
                        end
                    endcase
                    tx_pos <= tx_pos + 1;
                end
            end
        end else begin
            // Pause after exchange, to make the CS signal visible for the IC
            // Max Clock if the MCP21S17 is 10MHZ, systemclk is 28MHZ, so keep
            // CS high for multiple clock cycles.
            st_wait_cnt <= st_wait_cnt - 1;
            if(st_wait_cnt == 0) begin
                st_done <= 1'b0; // Ack done
                mcp_state <= next_stage;
            end else begin
                st_wait <= 1'b1; // When we are not done stay in wait mode
            end
        end
    end
endtask

// MCP23S17 Read n registers
reg [4:0] rx_pos      = 0;
reg [2:0] rx_wait_cnt = 0;
reg       rx_wait     = 0;
reg       rx_ready_p  = 0;
reg       rx_start    = 0;
task read_mcp;
    input   [7:0] reg_addr;   // Address to start reading
    input   [4:0] num;        // Number of values to read in sequence
    input   [4:0] next_stage;
    output  [7:0] rx_data;    // Received data
    output  [4:0] rx_seq;     // Sequence number of the received byte
    output        rx_dv;      // Data received
    begin 

        // Init
        TX_DV    <= 1'b0;
        rx_dv    <= 1'b0;
        rx_start <= 1'b0;
        st_wait  <= 1'b0;
        st_wait_cnt <= 6'b011111;

        // Update data after rx_pos
        rx_ready_p <= 1'b0;
        if(rx_ready_t) begin
            rx_ready_p <= 1'b1;
            rx_pos <= rx_pos + 1;
        end

        // Chip select
        if(~st_wait) begin
            if (cs) begin
                cs <= 1'b0;
                tx_pos <= 4'b0;
                rx_start <= 1'b1;
            end else begin
                // CS is asserted start!
                if(tx_ready_t || rx_start == 1) begin
                    case(tx_pos)
                        0: begin
                            TX_Byte <= 8'h41;
                            TX_DV <= 1'b1;
                        end
                        1: begin
                            TX_Byte <= reg_addr;
                            TX_DV <= 1'b1;
                        end
                        default: begin
                            TX_Byte <= 8'h00;
                            TX_DV <= 1'b1;
                        end
                    endcase;

                    tx_pos <= tx_pos + 1;
                end

                // Byte received, after header return received bytes
                if(rx_pos >= 2 && rx_ready_p) begin
                    rx_dv <= 1'b1;
                    rx_seq <= rx_pos - 2; // position - header length
                    rx_data <= RX_Byte;

                    // When we are done, say so :-)
                    if(rx_pos >= (num + 2)) begin
                        cs <= 1'b1;
                        rx_wait <= 1'b1; 
                        rx_wait_cnt <= 3'b111;
                        st_wait <= 1'b1;
                    end
                end
            end
        end else begin
            // Pause after exchange, to make the CS signal visible for the IC
            // Max Clock if the MCP21S17 is 10MHZ, systemclk is 28MHZ, so keep
            // CS high for multiple clock cycles.
            rx_pos <= 0;
            st_wait_cnt <= st_wait_cnt - 1;
            if(st_wait_cnt == 0) begin
                st_done <= 1'b0; // Ack done
                mcp_state <= next_stage;
            end else begin
                st_wait <= 1'b1; // When we are not done stay in wait mode
            end
        end
    end
endtask

always @(posedge clk) begin
    case (mcp_state)
        ST_IDLE: begin
            mcp_state <= ST_SET_IODIRA;
            st_done <= 0;
        end
        ST_SET_IOCON: begin
            write_mcp(REG_ADR_IOCON, REG_VAL_IOCON, ST_WAITINT);
        end
        ST_SET_IODIRA: begin
            write_mcp(REG_ADR_IODIRA, REG_VAL_IODIRA, ST_SET_IODIRB);
        end
        ST_SET_IODIRB: begin
            write_mcp(REG_ADR_IODIRB, REG_VAL_IODIRB, ST_SET_INTENA);
        end
        ST_SET_INTENA: begin
            write_mcp(REG_ADR_INTENA, REG_VAL_INTENA, ST_SET_INTENB);
        end
        ST_SET_INTENB: begin
            write_mcp(REG_ADR_INTENB, REG_VAL_INTENB, ST_SET_IOCON);
        end
        ST_WAITINT: begin
            if(inta_s)
                mcp_state <= ST_READ_GPIOA;
        end
        ST_READ_GPIOA: begin
            read_mcp(REG_ADR_GPIOA, 1, ST_READ_GPIOB, st_data, st_seq, st_dv);
            if (st_dv) begin
                Joya_raw <= st_data;
            end
        end
        ST_READ_GPIOB: begin
            read_mcp(REG_ADR_GPIOB, 1, ST_WAITINT, st_data, st_seq, st_dv);
            if (st_dv) begin
                Joyb_raw <= st_data;
            end
        end
    endcase

    // When reset the world stops
    if(rst) begin
        // Reset state machine
        mcp_state <= ST_IDLE;
        // Output all high, no switches activated
        Joya_raw <= 8'hff;
        Joyb_raw <= 8'hff;
    end
end

/*    
// Byte to pin mapping
// Connects the received values to the Joystick pinout of the Amiga
// 7  6  5       4     3   2     1     0
// 1, 1, Fire 2, Fire, Up, Down, Left, right
always @(posedge clk) begin
    Joya <= { 2'b11, Joya_raw[5], Joya_raw[4], Joya_raw[3], Joya_raw[2], Joya_raw[1], Joya_raw[0] }; // Joystick A mapping
    Joyb <= { 2'b11, Joyb_raw[1], Joyb_raw[2], Joyb_raw[3], Joyb_raw[4], Joyb_raw[5], Joyb_raw[6] }; // Joystick B mapping
end
*/

always @(posedge clk) begin
    Joy_raw <= { Joya_raw[5], Joya_raw[4], Joya_raw[0], Joya_raw[1], Joya_raw[2], Joya_raw[3] }; // Joystick A mapping  //CBUDLR
end

joy_db9md joy_db9md1 (
  .clk       ( clk       ),     //
  .joy_in    ( Joy_raw   ),     //CBUDLR
  .joy_mdsel ( JOY_SEL   ),     //pin 7 DB9   
  .joystick1 ( Joy_a     )      //MS ZYXCBAUDLR
);

endmodule
