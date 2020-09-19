# Blink tutorial for totally newbees to Quartus and Chameleon96
## Prerequisites
* [Chameleon96 board](https://www.96boards.org/product/chameleon96/)
* [Quartus lite sofware](https://fpgasoftware.intel.com/?edition=lite)
* [Blink example](./CV_96_blink_Yo_Me.sof) [credits for the very firts blink code goes to community member Yo_Me]

### Considerations
This tutorial has been made with this software configuration: 
  - OS Ubuntu 20.04. 
  - Quartus lite 20.1
 
For board detection I had to add following udev rules:

sudo nano /etc/udev/rules.d/81.fpga-altera.rules
  ```
  # Intel FPGA Download Cable II
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6010", MODE="0666"
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6810", MODE="0666"
  ```
sudo udevadm control --reload

## Steps for loading firts blink example

* Power up the board with original SD inserted

* Shutdown linux (recommended step by community member Sysadmin)

  Shutdown linux properly from console (I got an error when trying to shutdown from graphical interface). 
  Access to linux console though HDMI output or from serial output with an USB-TTL cable 
  
    Pins B W G on board correspond to colors from usb-ttl included in the kit)
	  B = Black (Ground), 	W = White (Rx), 	G = Green (Tx)
	  
    From host computer:
    picocom -b 115200 /dev/ttyUSB0   
      login: root
      shutdown -h now

* Connect the micro usb cable to the Blaster usb port (next to black low speed expansion port)

* Run Quartus software  (binary is in the installation folder .../intelFPGA_lite/20.1/quartus/bin/quartus   in my setup)

* Open the programmer (Tools menu > Programmer)

Now a blue led should be lighting indicating the programming usb blaster cable is connected.

* Hardware Setup... > Hardware Settings

  In available hardware items shoud show up the "Arrow 96 CV SoC Board". Double click on it and press Close button.
  If no hardware is detected double check the udev rules.
  Check also output from command .../quartus/bin/jtagconfig -d

* Add File...   load the .sof blink example

* Add Device... > Soc Series V > double click SOCVHPS > Ok

* Select the "SOCVHPS" and press "Up" button so configuration should be like this

![Programmer configuration](./programmer-config.png)

* Finally press the "Start" button and after few seconds you should have both leds (Wifi & BT) blinking.

### Final considerations

* You can now power down the board
* Next time you power up the board it will load linux normally (because u-boot reprograms the FPGA with the default file CV96.rbf from SD card which loads linux)
* Is it possible to convert the blink project to rbf format and substitute CV96.rbf in the SD card so the board will always start with the blink program.
* Is it possible to program the FPGA without inserting SD card on startup (in this case the blinking frecuency will be slower).
