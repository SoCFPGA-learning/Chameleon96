---------------------------------------------------------------------------------
-- Pooyan by Dar (darfpga@aol.fr) (29/10/2017)
-- http://darfpga.blogspot.fr
--
-- release rev 02 - (26/04/2020)
--   replace T80 version 247 by version 350: solve arrows collision error
--   fix line count and vblank
--
---------------------------------------------------------------------------------
-- gen_ram.vhd & io_ps2_keyboard
-------------------------------- 
-- Copyright 2005-2008 by Peter Wendrich (pwsoft@syntiac.com)
-- http://www.syntiac.com/fpga64.html
---------------------------------------------------------------------------------
-- T80/T80se - Version : 350
-----------------------------
-- Z80 compatible microprocessor core
-- Copyright (c) 2001-2002 Daniel Wallner (jesus@opencores.org)
-- Version 350 Copyright (c) 2018 Sorgelig
---------------------------------------------------------------------------------
-- YM2149 (AY-3-8910)
-- Copyright (c) MikeJ - Jan 2005
---------------------------------------------------------------------------------
-- Educational use only
-- Do not redistribute synthetized file with roms
-- Do not redistribute roms whatever the form
-- Use at your own risk
---------------------------------------------------------------------------------
--  Features :
--   TV 15KHz mode only (atm)
--   Coctail mode ok
--   Sound ok
--   No external RAM/SDRAM required

--  Use with MAME roms from pooyan.zip
--
--  Use make_pooyan_proms.bat to build vhd file from binaries
--
--  Pooyan Hardware caracteristics :
--
--  VIDEO : 1xZ80@3MHz CPU accessing its program rom, working ram,
--    sprite data ram, I/O, sound board register and trigger.
--		  32Kx8bits program rom
--
--    One char tile map 32x28
--      8Kx16bits graphics rom 4bits/pixel
--      16colors/16sets among 16 colors
--
--    24 sprites with priorities and flip H/V
--      16Kx16bits graphics rom 4bits/pixel
--      15 colors/16sets among 16 colors (different of char colors).
--
--    Char/sprites color palette 2x16 colors among 256 colors
--      3red 3green 2blue
--
--    Working ram : 4Kx8bits
--    Sprites data ram : 256x16bits
--    Sprites line buffer rams : 1 scan line delay flip/flop 2x256x4bits  

--  SOUND : 1xZ80@1.79MHz CPU accessing its program rom, working ram, 2x-AY3-8910
--		  16Kx8bits program rom
--
--      1xAY-3-8910
-- 		I/O noise input and command/trigger from video board.
--			3 sound channels
--
--      1xAY-3-8910
--			3 sound channels
--
--		  6 RC filters with 4 states : transparent or cut 600Hz, 700Hz, 3.4KHz
--
---------------------------------------------------------------------------------
--
-- Uses 1 pll for 12MHz and 14MHz generation from 50MHz
--
-- Board key :
--   0 : reset game
--
-- Keyboard players inputs :
--
--   F3 : Add coin
--   F2 : Start 2 players
--   F1 : Start 1 player
--   SPACE       : Fire  
--   RIGHT arrow : right
--   LEFT  arrow : left
--   UP    arrow : up 
--   DOWN  arrow : down
--
-- Other details : see pooyan.vhd

---------------------------------------------------------------------------------
-- Use pooyan_lite.sdc to compile (Timequest constraints)
-- /!\
-- Don't forget to set device configuration mode with memory initialization 
--  (Assignments/Device/Pin options/Configuration mode)
---------------------------------------------------------------------------------

+----------------------------------------------------------------------------------+
; Fitter Summary                                                                   ;
+------------------------------------+---------------------------------------------+
; Fitter Status                      ; Successful - Thu Nov 09 18:42:43 2017       ;
; Quartus Prime Version              ; 16.1.0 Build 196 10/24/2016 SJ Lite Edition ;
; Revision Name                      ; pooyan_de10_lite                            ;
; Top-level Entity Name              ; pooyan_de10_lite                            ;
; Family                             ; MAX 10                                      ;
; Device                             ; 10M50DAF484C6GES                            ;
; Timing Models                      ; Preliminary                                 ;
; Total logic elements               ; 6,223 / 49,760 ( 13 % )                     ;
;     Total combinational functions  ; 5,992 / 49,760 ( 12 % )                     ;
;     Dedicated logic registers      ; 1,578 / 49,760 ( 3 % )                      ;
; Total registers                    ; 1578                                        ;
; Total pins                         ; 105 / 360 ( 29 % )                          ;
; Total virtual pins                 ; 0                                           ;
; Total memory bits                  ; 507,904 / 1,677,312 ( 30 % )                ;
; Embedded Multiplier 9-bit elements ; 2 / 288 ( < 1 % )                           ;
; Total PLLs                         ; 1 / 4 ( 25 % )                              ;
; UFM blocks                         ; 0 / 1 ( 0 % )                               ;
; ADC blocks                         ; 0 / 2 ( 0 % )                               ;
+------------------------------------+---------------------------------------------+

---------------
VHDL File list 
---------------

de_10/max10_pll_12M_14M.vhd        Pll 12MHz and 14 MHz from 50MHz altera mf

rtl_dar/pooyan_de10_lite.vhd       Top level for de10_lite board
rtl_dar/pooyan.vhd                 Main video board logic
rtl_dar/pooyan_sound_board.vhd     Main sound board logic

rtl_mikej/YM2149_linmix_sep.vhd    Copyright (c) MikeJ - Jan 2005

rtl_T80/T80se.vhdT80               Copyright (c) 2001-2002 Daniel Wallner (jesus@opencores.org)
rtl_T80/T80_Reg.vhd
rtl_T80/T80_Pack.vhd
rtl_T80/T80_MCode.vhd
rtl_T80/T80_ALU.vhd
rtl_T80/T80.vhd

rtl_dar/kbd_joystick.vhd           Keyboard key to player/coin input
rtl_dar/io_ps2_keyboard.vhd        Copyright 2005-2008 by Peter Wendrich (pwsoft@syntiac.com)
rtl_dar/gen_ram.vhd                Generic RAM (Peter Wendrich + DAR Modification)
rtl_dar/decodeur_7_seg.vhd         7 segments display decoder


rtl_dar/proms/pooyan_prog.vhd       PROMS
rtl_dar/proms/pooyan_sound_prog.vhd
rtl_dar/proms/pooyan_sprite_grphx2.vhd    
rtl_dar/proms/pooyan_sprite_grphx1.vhd
rtl_dar/proms/pooyan_char_grphx2.vhd
rtl_dar/proms/pooyan_char_grphx1.vhd
rtl_dar/proms/pooyan_sprite_grphx.vhd
rtl_dar/proms/pooyan_sprite_color_lut.vhd
rtl_dar/proms/pooyan_palette.vhd
rtl_dar/proms/pooyan_char_color_lut.vhd

----------------------
Quartus project files
----------------------
de10_lite/pooyan_de10_lite.sdc   Timequest constraints file
de10_lite/pooyan_de10_lite.qsf   de10_lite settings (files,pins...) 
de10_lite/pooyan_de10_lite.qpf   de10_lite project

-----------------------------
Required ROMs (Not included)
-----------------------------
You need the following 13 ROMs binary files from pooyan.zip (MAME)

1.4a, 2.5a, 3.6a, 4.7a 
xx.7a, xx.8a
6.9a, 5.8a, 8.10g, 7.9g 
pooyan.pr1, pooyan.pr3, pooyan.pr2 

------
Tools 
------
You need to build vhdl files from the binary file :
 - Unzip the roms file in the tools/pooyan_unzip directory
 - Double click (execute) the script tools/make_pooyan_proms.bat to get the following files

pooyan_prog.vhd           1.4a + 2.5a + 3.6a + 4.7a 
pooyan_sound_prog.vhd     xx.7a + xx.8a

pooyan_sprite_grphx1.vhd  6.9a 
pooyan_sprite_grphx2.vhd  5.8a 

pooyan_char_grphx1.vhd    8.10g 
pooyan_char_grphx2.vhd    7.9g  

pooyan_palette.vhd           pooyan.pr1  
pooyan_char_color_lut.vhd    pooyan.pr3  
pooyan_sprite_color_lut.vhd  pooyan.pr2  


*DO NOT REDISTRIBUTE THESE FILES*

VHDL files are needed to compile and include roms into the project 

The script make_pooyan_proms.bat uses make_vhdl_prom executables delivered both in linux and windows version. The script itself is delivered only in windows version (.bat) but should be easily ported to linux.

Source code of make_vhdl_prom.c is also delivered.

---------------------------------
Compiling for de10_lite
---------------------------------
You can build the project with ROM image embeded in the sof file.
*DO NOT REDISTRIBUTE THESE FILES*

3 steps

 - put the VHDL ROM files (.vhd) into the rtl_dar directory
 - build pooyan_de10_lite
 - program pooyan_de10_lite.sof

------------------------
------------------------
End of file
------------------------
