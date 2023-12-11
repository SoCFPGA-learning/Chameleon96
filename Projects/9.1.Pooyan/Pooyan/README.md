# Pooyan DECA port 

DECA port for Pooyan by Somhic (27/06/2021) adapted from DE10_lite by Dar https://sourceforge.net/projects/darfpga/files/Software%20VHDL/pooyan/

[Read history of Pooyan Arcade.](https://www.arcade-museum.com/game_detail.php?game_id=12757)

**Features:**

* **It does not require SDRAM.**
* HDMI video output (special resolution will not work on all LCD monitors)
* VGA 444 video output is available through GPIO (see pinout below). 
  * VGA (30 kHz) & RGB (15 kHz) modes available (toggle VGA / RGB mode with F8 key)
  * Tested with PS2 & R2R VGA adapter (333)  https://www.waveshare.com/vga-ps2-board.htm
* Line out (3.5 jack green connector) and HDMI audio output
* PWM audio is available through GPIO (see pinout below)
* Joystick available through GPIO  (see pinout below).  **Joystick power pin must be 2.5 V**
  * **DANGER: Connecting power pin above 2.6 V may damage the FPGA**
  * This core is prepared for Megadrive 6 button gamepads as it outputs a permanent high level on pin 7 of DB9

**Additional hardware required**:

- PS/2 Keyboard connected to GPIO  (see pinout below)

**Versions**:

- v7.0. VGA & RGB versions working. Added Joystick 


see changelog in top level file /deca/pooyan_deca.vhd

**Compiling:**

* Load project from /deca/pooyan_deca.qpf

* sof/svf files already included in /deca/output_files/

**Pinout connections:**

![pinout_deca](pinout_deca.png)

**Others:**

* Button KEY0 is a reset button

### STATUS

* Working fine

* HDMI video outputs special resolution so will not work on all monitors. 


### Keyboard players inputs :

F1 : Add coin
F2 : Start 1 player
F3 : Start 2 players

SPACE       : fire
RIGHT arrow : move right
LEFT  arrow : move left
UP    arrow : move up
DOWN  arrow : move down

F8 : toggles VGA / RGB video mode



Other details : see original README.txt / pooyan.vhd

---------------------------------
Compiling for DECA
---------------------------------

 - You would need the original MAME ROM files
 - Use tools included to convert ROM files to VHDL (read original README.txt)
 - put the VHDL ROM files (.vhd) into the rtl_dar/proms directory
 - build pooyan_deca
 - program pooyan_deca.sof

You can build the project with ROM image embedded in the sof file.
*DO NOT REDISTRIBUTE THESE FILES*

See original [README.txt](README.txt)
------------------------

