# VGA adapter 64 color test generator

Intro
-----

### Objective

* Build a custom made 6 bit VGA adapter and test it with the Chameleon96 board
  
* Code used for the test is VGA_C96 by Antonio Sánchez


### Considerations
This tutorial has been made with this software setup:

* Quartus lite & EDS 17.1

  There shouldn't be any major problem for following this tutorial with other versions of Quartus.

**The project did not work with my LCD monitor, but it does in a CRT tube monitor I have.** 

### Sources of information

* [Chameleon96 telegram group](https://t.me/Chameleon96)
* [github.com/somhi/kameleon96/](https://github.com/somhi/kameleon96)
* https://github.com/Alhambra-bits/AP-VGA
* https://github.com/Obijuan/Cuadernos-tecnicos-FPGAs-libres/wiki/CT.2:-VGA-Retro:-Puesta-en-marcha.-MonsterLED


### Download files

* Complete Quartus project [6.2.c96-vgaretro-pll-test.zip](./6.2.c96-vgaretro-pll-test.zip)  
* VGA_C96 Verilog code [VGA_C96.v](./VGA_C96.v) by Antonio Sánchez



Quartus & Qsys project
--------------------

I'm using the project template T01 from /Templates/Project_templates folder.



**TO BE FINISHED.**



External circuit schematic
--------------------------

To test the core we need to mount an external circuit, adapting the following schematic to your circuit. 

![](./schematic.jpg)
![](./vga-03.png)

If you want to connect dupont wired directly to the VGA connector take a bit of care but it is feasible. The ground connection in the middle is not really necessary so you would only need to connect 4 wires on top row, and 2 wire in the following rows.

