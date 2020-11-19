# Blink with external button
Intro
-----

### Objective

* Design and compile an FPGA core using the LOAN I/O function to use pins from the low speed 40 pin connector.
* Load memory settings of Chameleon96 board
* Do a blink with an external led when an external button is pressed


### Prerequisites

* Chameleon96 board
* [Quartus lite sofware](https://fpgasoftware.intel.com/?edition=lite)
* [Intel SoC EDS](https://fpgasoftware.intel.com/soceds/) (Embedded Development Suite) 


### Considerations
This tutorial has been made with this software setup:

* OS Ubuntu 20.04
* Quartus lite 20.1

There shouldn't be any major problem for following this tutorial with older versions of Quartus and/or if you are on Windows OS.  

**Note: From now on the tutorials will have less explanations and contain more technical detail as you should have enough level to develop yourself if you followed the previous tutorials.  **

### Sources of information

* [Chameleon96 telegram group](https://t.me/Chameleon96)
* __[github.com/somhi/kameleon96/](https://github.com/somhi/kameleon96)__


### Download files

* Complete Quartus project __xxxxxxxxxxxxxx__
* Memory settings __xxxxxxxxx__


Preparation
-----------

We will start from were we left it in the previous tutorials.  

From a file browser, copy the folder containing all the code of the previous tutorial (Blink loanIOs) into another folder and rename it to e.g. "blink-loanio-LS_connector".

Quartus app starting
--------------------

Launch the Quartus app.

Open the project file: File > Open project > browse inside folder you copied in previous step > select .qpf file (e.g. blink.qpf) > Open

Open the platform designer file: File > Open > select "soc_hps.qsys" > Open


Platform designer (Qsys)
------------------------

Double click hps_0 component from System Contents to open its properties.
Select the Peripheral Pins tab. In the Peripherals Mux Table, we will select the pins that we want to use with the FPGA.

LoanIO's for user leds  already selected in the previous tutorial (Blink loanios):

* LOANIO14	CV_HPS_1V8_GPIO14_via_NAND_ALE	user led 3	BANK 7B
* LOANIO22 	CV_HPS_1V8_GPIO22_via_NAND_DQ3	user led 2	BANK 7B
* LOANIO25   	CV_HPS_1V8_GPIO25_via_NAND_DQ6	user led 1	BANK 7B
* LOANIO32   	CV_HPS_1V8_GPIO32_via_QSPI_IO3		user led 0	BANK 7B



LoanIO's for LS connector GPIO pins:

* LOANIO33  	CV_HPS_1V8_GPIO33_via_QSPI_SS0       	LS_P24		BANK 7B	
* LOANIO34  	CV_HPS_1V8_GPIO34_via_QSPI_CLK      	LS_P26		BANK 7B	



* LOANIO27	CV_HPS_1V8_GPIO27_via_NAND_WP	LS_28		BANK 7B	
* LOANIO29	CV_HPS_1V8_GPIO29_via_QSPI_IO0		LS_30		BANK 7B	
* LOANIO28	CV_HPS_1V8_GPIO28_via_NAND_WE	LS_32		BANK 7B		
* LOANIO30	CV_HPS_1V8_GPIO30_via_QSPI_IO1		LS_34		BANK 7B	



* LOANIO19	CV_HPS_1V8_GPIO19_via_NAND_DQ0	LS_23		BANK 7B	
* LOANIO17	CV_HPS_1V8_GPIO17_via_NAND_RE	LS_25		BANK 7B	
* LOANIO54	CV_HPS_1V8_GPIO54_via_TRACE_D5	LS_27		BANK 7A	
* LOANIO48 	CV_HPS_1V8_GPIO48_via_TRACE_CLK	LS_29		BANK 7A	
* LOANIO53 	CV_HPS_1V8_GPIO53_via_TRACE_D4	LS_31		BANK 7A	
* LOANIO23	CV_HPS_1V8_GPIO23_via_NAND_DQ4	LS_33		BANK 7B	


| Loanio number | Schematic name                 | Pin number | FPGA Bank |
|:--------------|:-------------------------------|:-----------|:----------|
| LOANIO14      | CV_HPS_1V8_GPIO14_via_NAND_ALE | user led 3 | BANK 7B   |
| LOANIO22      | CV_HPS_1V8_GPIO22_via_NAND_DQ3 | user led 2 | BANK 7B   |
| LOANIO25      | CV_HPS_1V8_GPIO25_via_NAND_DQ6 | user led 1 | BANK 7B   |
| LOANIO32      | CV_HPS_1V8_GPIO32_via_QSPI_IO3 | user led 0 | BANK 7B   |



Note: Voltage out of LoanIO pins in low speed connector is 1,8 VDC

Close the parameter window.

File > Save

Click Generate HDL button at bottom page > Generate > Close  

Click Finish button 

Quartus app development
-----------------------

Back in Quartus app, you should have already open in the block editor the file "blink.bdf".  



Quartus
-------


* update block
* add pins
* update loan_control block verilog code for loan_oe, loan_out










*****


Run
Start Analisys & synthesis
Start I/O assignment analysis


* __Al qsys si he d'utilitzar el h2f_user0_clock, no el puc exportar, però sí el connecto al clock_bridge_0 el duplico i ja el puc exportar__



*****


__Tools > Timing Analyzer__
__File > New SDC file__
__create_clock -name "CLOCK_50" -period 20.000ns [get_ports {CLOCK_50}]__
__derive_pll_clocks__
__derive_clock_uncertainty__
__File > save as > blink.sdc__




*****


Guia Joseba Compilar U-BOOT y PRE-LOADER en Altera Quartus     <http://www.forofpga.es/viewtopic.php?f=29&t=364>  


<https://zhehaomao.com/blog/fpga/2013/12/24/sockit-2.html>

<https://blog.aignacio.com/getting-through-fpga-cylcone-v/>

<https://www.youtube.com/watch?v=cRwzmsJ1Jkg&feature=youtu.be>
<https://community.intel.com/t5/FPGA-Wiki/Using-HPS-IO-in-Cyclone-V-and-Arria-V/ta-p/735656>

[/home/jordi/bin/intelFPGA_lite/20.1/quartus/common/help](file:///home/jordi/bin/intelFPGA_lite/20.1/quartus/common/help)


*****



