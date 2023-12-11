create_clock -name {CLK_HPS} -period 10.0 [get_pins -compatibility_mode u0|clocks_resets|h2f_user0_clk]

create_clock -name clk1_50 -period 20 [get_ports {CLK_EXT}]

derive_pll_clocks -create_base_clocks

derive_clock_uncertainty

