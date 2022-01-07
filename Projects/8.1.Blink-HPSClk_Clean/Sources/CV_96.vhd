-----------------------------------------------------------------------------------
-- Company:      
-- Engineer: 
-- 
-- Create Date:         
-- Design Name: 
-- Module Name:         CV_96 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision             0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CV_96 is
    Port (
            FPGA_2V5_RF_LEDS_LED1_PIN_Y19          : out   STD_LOGIC;
				FPGA_2V5_RF_LEDS_LED2_PIN_Y20          : out   STD_LOGIC
		   );
end entity CV_96;

architecture rtl of CV_96 is
	
	component blink is
		port (
			clk: in    std_logic;
			led: out   std_logic
		);
	end component blink;

--	component iOSC is
--		port (
--			oscena : in  std_logic := 'X'; -- oscena
--			clkout : out std_logic         -- clk
--		);
--	end component iOSC;


--	component HPS_CLK is
--		port (
--			hps_0_h2f_user0_clock_clk : out std_logic   -- clk
--		);
--	end component HPS_CLK;

	component HPS is
	port (
		h2f_rst_n : out std_logic;
		h2f_user0_clk : out std_logic
		);
	end component HPS;	
	
	signal 		Clk : STD_LOGIC;
	signal 		Led : STD_LOGIC;

begin

--	u0 : component iOSC
--		port map (
--			oscena => '1', 
--			clkout => Clk  
--		);
	
	u0 : component HPS
		port map (
			h2f_user0_clk => Clk  -- hps_0_h2f_user0_clock.clk
		);

	

 u1 : component blink 
	port map (
	clk => Clk, 
	led => Led
	);
	
	FPGA_2V5_RF_LEDS_LED1_PIN_Y19 <= Led;
	FPGA_2V5_RF_LEDS_LED2_PIN_Y20 <= not Led;
	
end;	

