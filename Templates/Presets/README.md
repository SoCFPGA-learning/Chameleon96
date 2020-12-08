# Preloaders for Chameleon96 board

See below how to load the presets into Platform Designer (Qsys).

This folders contains the following preset configuration files:

* DDR3_c96_Preset_1.qprs
  * It contains the memory presets for the Chameleon96 board



Load memory preset settings for Chameleon96 board (Qsys)
--------------------------------------------------------

This point explains how to configure the memory settings of the Chameleon96 board into the platform designer. 
We will load a presets file which has proven to work.  

Follow these steps from a file explorer:

* Browse to the project folder
* create a new folder named "ip" and inside it another folder named "presets"
* Copy this file ( [./DDR3_c96_Preset_1.qprs](./README_files/DDR3_c96_Preset_1.qprs) ) inside the [/ip/presets/](file:///ip/presets) folder. This file contains the preset settings for the Chameleon96 board.


If Qsys is still open, close it.  
From Quartus open the platform designer file: File > Open > select "soc_hps.qsys" > Open

* Select View menu > Presets
* Select the preset "DDR3_c96_Preset_1" from the Project tree and press "Apply" button
* Close the presets window
* Check that the  SDRAM settings of the hps_0 component have changed
  * Double click hps_0 component from System Contents to open its properties.
  * Press the SDRAM tab and see all the new parameters have loaded (you should compare before and after applying presets).
* Click Generate HDL button at bottom page > Generate > Close  
* Click Finish to close Qsys.