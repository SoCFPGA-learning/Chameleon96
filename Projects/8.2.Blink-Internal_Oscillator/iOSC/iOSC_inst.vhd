	component iOSC is
		port (
			oscena : in  std_logic := 'X'; -- oscena
			clkout : out std_logic         -- clk
		);
	end component iOSC;

	u0 : component iOSC
		port map (
			oscena => CONNECTED_TO_oscena, -- oscena.oscena
			clkout => CONNECTED_TO_clkout  -- clkout.clk
		);

