

**Top file**: rtl/CV_96.v

With ``define CLK_HPS`  uses internal HPS clock at 100 MHz.

With  `// define CLK_HPS`  uses external clock PIN_W12  CLK_EXT

For external clock it has been used a FPGA Mezzanine board https://www.96boards.org/documentation/mezzanine/shiratech-fpga/

Buy it at Arrow  https://www.arrow.com/en/products/srt-96b-mez-fpga/shiratech

![FPGA_Mezzanine](FPGA_Mezzanine.jpg)



Bend 90º UART pins in order to mount FPGA Mezzanine on top of Chameleon96 board. That board receives power supply from Chameleon96.

I flashed project [Mezzanine_FPGA_clock](Mezzanine_FPGA_clock) (mezzanine_top_50MHz.pof) into the MAX10 FPGA.  I got difficulties flashing this FPGA until I removed stock bitstream from internal FPGA flash.  Just keep pressing the Start button in Quartus programmer, connect & disconnect multiple times.

