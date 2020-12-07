//////////////////////////////////////////////////////////////////////////////////
//    This file is knight_rider
//    Creation date is 00:26:37 10/27/2020 by Miguel Angel Rodriguez Jodar
//    (c)2020 Miguel Angel Rodriguez Jodar. ZXProjects
//
//    This core is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This core is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this core.  If not, see <https://www.gnu.org/licenses/>.
//
//    All copies of this file must keep this notice intact.
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ns
`default_nettype none

module knight_rider (
  input wire clk,
  output wire [7:0] led
  );  
  
  reg [26:0] count_per_shift = 'd0;
  reg [26:0] count_per_fade  = 'd0;
  reg [26:0] count_per_pwm   = 'd0;

  parameter [26:0] FREQ_CLK = 'd100_000_000;  
  parameter [26:0] FREQ_SHIFT = 'd10;
  parameter [26:0] FREQ_FADEOUT = 'd1000;					//cuanto más alto, más rápido se apagan los leds (>1000 no tiene efecto)
  parameter [26:0] FREQ_PWM = 25 * FREQ_CLK / 128;		
  
  localparam [26:0] PERIOD_SHIFT   = (FREQ_CLK / FREQ_SHIFT)-1;
  localparam [26:0] PERIOD_FADEOUT = (FREQ_CLK / FREQ_FADEOUT)-1;
  localparam [26:0] PERIOD_PWM     = (FREQ_CLK / FREQ_PWM)-1;		
  
  always @(posedge clk) begin
    if (count_per_shift == PERIOD_SHIFT)
      count_per_shift <= 'd0;
    else
      count_per_shift <= count_per_shift + 'd1;
      
    if (count_per_fade == PERIOD_FADEOUT)
      count_per_fade <= 'd0;
    else
      count_per_fade <= count_per_fade + 'd1;
      
    if (count_per_pwm == PERIOD_PWM)		
      count_per_pwm <= 'd0;
    else
      count_per_pwm <= count_per_pwm + 'd1;
  end      
    
  wire enable_shift   = (count_per_shift == 'd0);
  wire enable_fadeout = (count_per_fade == 'd0);
  wire enable_pwm     = (count_per_pwm == 'd0);
  
  reg [7:0] estado_led = 8'b10000000;
  reg sentido = 1'b0;  							// 0=izq-der, 1=der-izq
  
  genvar i;
  generate
    for (i=0; i<=7; i=i+1) begin : controlador_led
      ledpwm l (clk, enable_fadeout, enable_pwm, estado_led[i], led[i]);
    end 
  endgenerate
  
  always @(posedge clk) begin
    if (enable_shift == 1'b1) begin
      if (sentido == 1'b0)
        estado_led <= {1'b0, estado_led[7:1]};
      else
        estado_led <= {estado_led[6:0], 1'b0};
      if (estado_led[6] == 1'b1 && sentido == 1'b1 || estado_led[1] == 1'b1 && sentido == 1'b0)
          sentido <= ~sentido;
    end
  end

endmodule

module ledpwm (
  input wire clk,
  input wire clkefade,
  input wire clkepwm,
  input wire pulso_encendido,
  output wire led
  );
  
  reg [7:0] cnt = 'h00;
  reg [7:0] brillo = 'h00;

  reg [7:0] lut[0:255];
  reg [7:0] indxlut = 'd255;
  
  integer i;
  localparam NUMERO_E = 2.7182818284590452353602874713527;
  initial begin
 //   for (i=0; i<256; i=i+1) begin
 //     lut[i] = 255*(NUMERO_E ** (1-i/40.0))/NUMERO_E;
 //   end
 //bucle for solo funciona en Vivado 
 
  // Grafica de la función generada:
  // http://fooplot.com/?lang=es#W3sidHlwZSI6MCwiZXEiOiJlXigxLXgvNDApKjI1NS9lIiwiY29sb3IiOiIjMDAwMDAwIn0seyJ0eXBlIjoxMDAwLCJ3aW5kb3ciOlsiMCIsIjI1NSIsIjAiLCIyNTUiXSwiZ3JpZCI6WyI1IiwiNSJdfV0-
  
	 lut[  0] = 255;
    lut[  1] = 249;
    lut[  2] = 243;
    lut[  3] = 237;
    lut[  4] = 231;
    lut[  5] = 225;
    lut[  6] = 219;
    lut[  7] = 214;
    lut[  8] = 209;
    lut[  9] = 204;
    lut[ 10] = 199;
    lut[ 11] = 194;
    lut[ 12] = 189;
    lut[ 13] = 184;
    lut[ 14] = 180;
    lut[ 15] = 175;
    lut[ 16] = 171;
    lut[ 17] = 167;
    lut[ 18] = 163;
    lut[ 19] = 159;
    lut[ 20] = 155;
    lut[ 21] = 151;
    lut[ 22] = 147;
    lut[ 23] = 143;
    lut[ 24] = 140;
    lut[ 25] = 136;
    lut[ 26] = 133;
    lut[ 27] = 130;
    lut[ 28] = 127;
    lut[ 29] = 124;
    lut[ 30] = 120;
    lut[ 31] = 117;
    lut[ 32] = 115;
    lut[ 33] = 112;
    lut[ 34] = 109;
    lut[ 35] = 106;
    lut[ 36] = 104;
    lut[ 37] = 101;
    lut[ 38] =  99;
    lut[ 39] =  96;
    lut[ 40] =  94;
    lut[ 41] =  91;
    lut[ 42] =  89;
    lut[ 43] =  87;
    lut[ 44] =  85;
    lut[ 45] =  83;
    lut[ 46] =  81;
    lut[ 47] =  79;
    lut[ 48] =  77;
    lut[ 49] =  75;
    lut[ 50] =  73;
    lut[ 51] =  71;
    lut[ 52] =  69;
    lut[ 53] =  68;
    lut[ 54] =  66;
    lut[ 55] =  64;
    lut[ 56] =  63;
    lut[ 57] =  61;
    lut[ 58] =  60;
    lut[ 59] =  58;
    lut[ 60] =  57;
    lut[ 61] =  55;
    lut[ 62] =  54;
    lut[ 63] =  53;
    lut[ 64] =  51;
    lut[ 65] =  50;
    lut[ 66] =  49;
    lut[ 67] =  48;
    lut[ 68] =  47;
    lut[ 69] =  45;
    lut[ 70] =  44;
    lut[ 71] =  43;
    lut[ 72] =  42;
    lut[ 73] =  41;
    lut[ 74] =  40;
    lut[ 75] =  39;
    lut[ 76] =  38;
    lut[ 77] =  37;
    lut[ 78] =  36;
    lut[ 79] =  35;
    lut[ 80] =  35;
    lut[ 81] =  34;
    lut[ 82] =  33;
    lut[ 83] =  32;
    lut[ 84] =  31;
    lut[ 85] =  30;
    lut[ 86] =  30;
    lut[ 87] =  29;
    lut[ 88] =  28;
    lut[ 89] =  28;
    lut[ 90] =  27;
    lut[ 91] =  26;
    lut[ 92] =  26;
    lut[ 93] =  25;
    lut[ 94] =  24;
    lut[ 95] =  24;
    lut[ 96] =  23;
    lut[ 97] =  23;
    lut[ 98] =  22;
    lut[ 99] =  21;
    lut[100] =  21;
    lut[101] =  20;
    lut[102] =  20;
    lut[103] =  19;
    lut[104] =  19;
    lut[105] =  18;
    lut[106] =  18;
    lut[107] =  18;
    lut[108] =  17;
    lut[109] =  17;
    lut[110] =  16;
    lut[111] =  16;
    lut[112] =  16;
    lut[113] =  15;
    lut[114] =  15;
    lut[115] =  14;
    lut[116] =  14;
    lut[117] =  14;
    lut[118] =  13;
    lut[119] =  13;
    lut[120] =  13;
    lut[121] =  12;
    lut[122] =  12;
    lut[123] =  12;
    lut[124] =  11;
    lut[125] =  11;
    lut[126] =  11;
    lut[127] =  11;
    lut[128] =  10;
    lut[129] =  10;
    lut[130] =  10;
    lut[131] =  10;
    lut[132] =   9;
    lut[133] =   9;
    lut[134] =   9;
    lut[135] =   9;
    lut[136] =   9;
    lut[137] =   8;
    lut[138] =   8;
    lut[139] =   8;
    lut[140] =   8;
    lut[141] =   8;
    lut[142] =   7;
    lut[143] =   7;
    lut[144] =   7;
    lut[145] =   7;
    lut[146] =   7;
    lut[147] =   6;
    lut[148] =   6;
    lut[149] =   6;
    lut[150] =   6;
    lut[151] =   6;
    lut[152] =   6;
    lut[153] =   6;
    lut[154] =   5;
    lut[155] =   5;
    lut[156] =   5;
    lut[157] =   5;
    lut[158] =   5;
    lut[159] =   5;
    lut[160] =   5;
    lut[161] =   5;
    lut[162] =   4;
    lut[163] =   4;
    lut[164] =   4;
    lut[165] =   4;
    lut[166] =   4;
    lut[167] =   4;
    lut[168] =   4;
    lut[169] =   4;
    lut[170] =   4;
    lut[171] =   4;
    lut[172] =   3;
    lut[173] =   3;
    lut[174] =   3;
    lut[175] =   3;
    lut[176] =   3;
    lut[177] =   3;
    lut[178] =   3;
    lut[179] =   3;
    lut[180] =   3;
    lut[181] =   3;
    lut[182] =   3;
    lut[183] =   3;
    lut[184] =   3;
    lut[185] =   2;
    lut[186] =   2;
    lut[187] =   2;
    lut[188] =   2;
    lut[189] =   2;
    lut[190] =   2;
    lut[191] =   2;
    lut[192] =   2;
    lut[193] =   2;
    lut[194] =   2;
    lut[195] =   2;
    lut[196] =   2;
    lut[197] =   2;
    lut[198] =   2;
    lut[199] =   2;
    lut[200] =   2;
    lut[201] =   2;
	 lut[202] =   2;
    lut[203] =   2;
    lut[204] =   2;
    lut[205] =   2;
    lut[206] =   1;
    lut[207] =   1;
    lut[208] =   1;
    lut[209] =   1;
    lut[210] =   1;
    lut[211] =   1;
    lut[212] =   1;
    lut[213] =   1;
    lut[214] =   1;
    lut[215] =   1;
    lut[216] =   1;
    lut[217] =   1;
    lut[218] =   1;
    lut[219] =   1;
    lut[220] =   1;
    lut[221] =   1;
    lut[222] =   1;
    lut[223] =   1;
    lut[224] =   1;
    lut[225] =   1;
    lut[226] =   1;
    lut[227] =   1;
    lut[228] =   1;
    lut[229] =   1;
    lut[230] =   1;
    lut[231] =   1;
    lut[232] =   1;
    lut[233] =   1;
    lut[234] =   1;
    lut[235] =   1;
    lut[236] =   1;
    lut[237] =   1;
    lut[238] =   1;
    lut[239] =   1;
    lut[240] =   1;
    lut[241] =   1;
    lut[242] =   1;
    lut[243] =   1;
    lut[244] =   1;
    lut[245] =   1;
    lut[246] =   1;
    lut[247] =   1;
    lut[248] =   1;
    lut[249] =   1;
    lut[250] =   0;
    lut[251] =   0;
    lut[252] =   0;
    lut[253] =   0;
    lut[254] =   0;
    lut[255] =   0;

  end
  
  always @(posedge clk) begin
    if (clkepwm == 1'b1)
      cnt <= cnt + 'h01;
  end
  
  always @(posedge clk) begin
    brillo <= lut[indxlut];
    if (pulso_encendido == 1'b1)
      indxlut <= 'h00;
    else if (clkefade == 1'b1 && indxlut != 'd255) begin
       indxlut <= indxlut + 'h01;
    end
  end
  
  assign led = (brillo > cnt || brillo == 'hFF)? 1'b1: 1'b0;	//con PWM
  //assign led = pulso_encendido;										//sin PWM
endmodule
  