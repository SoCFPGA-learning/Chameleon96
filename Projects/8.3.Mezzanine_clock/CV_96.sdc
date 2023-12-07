create_clock -name {CLK_HPS} -period 10.0 [get_pins -compatibility_mode u0|clocks_resets|h2f_user0_clk]

create_clock -name {CLK_EXT} -period 20.0 [get_ports {CLK_EXT}]

derive_clock_uncertainty
