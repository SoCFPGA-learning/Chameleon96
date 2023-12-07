# create input clock which is 50MHz
create_clock -name  CLK_50 -period 20.000 [get_ports {CLK_50}]

#derive clock uncertainty
derive_clock_uncertainty

# set false paths - these pins are trivial
set_false_path -from [get_ports {DIP[0] DIP[1]}]
set_false_path -to   [get_ports {LED[0] LED[1] LED[2] LED[3]}]


