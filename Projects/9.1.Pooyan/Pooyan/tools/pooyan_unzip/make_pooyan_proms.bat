
copy /B 1.4a + 2.5a + 3.6a + 4.7a pooyan_prog.bin
copy /B xx.7a + xx.8a pooyan_sound.bin

make_vhdl_prom pooyan_prog.bin pooyan_prog.vhd

make_vhdl_prom 6.9a pooyan_sprite_grphx1.vhd
make_vhdl_prom 5.8a pooyan_sprite_grphx2.vhd

make_vhdl_prom 8.10g pooyan_char_grphx1.vhd
make_vhdl_prom 7.9g  pooyan_char_grphx2.vhd

make_vhdl_prom pooyan_sound.bin pooyan_sound_prog.vhd

make_vhdl_prom pooyan.pr1  pooyan_palette.vhd
make_vhdl_prom pooyan.pr3  pooyan_char_color_lut.vhd
make_vhdl_prom pooyan.pr2  pooyan_sprite_color_lut.vhd

del pooyan_prog.bin
del pooyan_sound.bin

