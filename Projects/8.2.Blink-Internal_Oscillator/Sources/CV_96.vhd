 ----------------------------------------------------------------------------------
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

	component iOSC is
		port (
			oscena : in  std_logic := 'X'; -- oscena
			clkout : out std_logic         -- clk
		);
	end component iOSC;

	
	
	--signal   	CONNECTED_TO_hps_0_h2f_user0_clock_clk             :  STD_LOGIC;
	signal 		iOSC_clk : STD_LOGIC;
	signal 		Led : STD_LOGIC;

begin

	u0 : component iOSC
		port map (
			oscena => '1', -- oscena.oscena
			clkout => iOSC_clk  -- clkout.clk
		);
	


 u1 : component blink 
	port map (
	clk => iOSC_clk, --CONNECTED_TO_hps_0_h2f_user0_clock_clk,
	led => Led
	);
	
	FPGA_2V5_RF_LEDS_LED1_PIN_Y19 <= Led;
	FPGA_2V5_RF_LEDS_LED2_PIN_Y20 <= not Led;
	
	
--	FPGA_2V5_RF_LEDS_LED2_PIN_Y20 := not FPGA_2V5_RF_LEDS_LED1_PIN_Y19;

--	u2 : component blink 
--	port map (
--	clk => not iOSC_clk, --CONNECTED_TO_hps_0_h2f_user0_clock_clk,
--	led => FPGA_2V5_RF_LEDS_LED2_PIN_Y20
--	);

	
	
 
end;	

