---------------------------------------------------------------------------------
-- DECA Top level for Pooyan by Somhic & Shaeon (27/06/21) adapted 
-- from DE10_lite port by Dar (https://sourceforge.net/projects/darfpga/files/Software%20VHDL/pooyan/)
-- v1 VGA 15 kHz
-- v2 VGA with scandoubler, audio pwm
-- v3 HDMI video  (25.175 Mhz just works on my 'special' monitor, at 1048x224@61)
-- v4 Audio HDMI & Line out
-- v5 HDMI video  (video clock set to 12 MHz for 512x224@61)
-- v6 Commented VGA and PWM audio.
-- v7.0 revised qsf. Added joystick. VGA & RGB output now working, toggle with F8
--
---------------------------------------------------------------------------------
-- DE10_lite Top level for Pooyan by Dar (darfpga@aol.fr) (29/10/2017)
-- http://darfpga.blogspot.fr
--
-- release rev 02 - (26/04/2020)
--   replace T80 version 247 by version 350: solve arrows collision error
--   fix line count and vblank
--
---------------------------------------------------------------------------------
-- Educational use only
-- Do not redistribute synthetized file with roms
-- Do not redistribute roms whatever the form
-- Use at your own risk
---------------------------------------------------------------------------------
-- Use pooyan_sockit.sdc to compile (Timequest constraints)
-- /!\
-- Don't forget to set device configuration mode with memory initialization 
--  (Assignments/Device/Pin options/Configuration mode)
---------------------------------------------------------------------------------
--
-- Main features :
--  PS2 keyboard input @gpio pins 35/34 (beware voltage translation/protection) 
--  Audio pwm output   @gpio pins 1/3 (beware voltage translation/protection) 
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
--   RIGHT arrow : rotate right
--   LEFT  arrow : rotate left
--   UP    arrow : rotate up 
--   DOWN  arrow : rotate down
--
-- Other details : see pooyan.vhd
-- For USB inputs and SGT5000 audio output see my other project: xevious_de10_lite
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;

entity pooyan_sockit is
port(
  OSC_50_B8A  : in std_logic;
  -- ledr           : out std_logic_vector(9 downto 0);
  KEY            : in std_logic_vector(2 downto 0);

  VGA_R     : out std_logic_vector(7 downto 0);
  VGA_G     : out std_logic_vector(7 downto 0);
  VGA_B     : out std_logic_vector(7 downto 0);
  VGA_HS    : out std_logic;
  VGA_VS    : out std_logic;
  VGA_BLANK_n	:	OUT	STD_LOGIC;	--direct blacking output to DAC
  VGA_SYNC_n	  :	OUT	STD_LOGIC;  --sync-on-green output to DAC
  VGA_CLK		  :	OUT STD_LOGIC;	--clock output to Video DAC

  ps2clk   : in std_logic;
  ps2dat   : in std_logic;

  -- pwm_l    : out std_logic;
  -- pwm_r    : out std_logic;

  -- JOYSTICK
  JOY1_B2_P9		: IN    STD_LOGIC;
  JOY1_B1_P6		: IN    STD_LOGIC;
  JOY1_UP		    : IN    STD_LOGIC;
  JOY1_DOWN		  : IN    STD_LOGIC;
  JOY1_LEFT	  	: IN    STD_LOGIC;
  JOY1_RIGHT		: IN    STD_LOGIC;
  JOYX_SEL_O		: OUT   STD_LOGIC := '1'; 

-- AUDIO CODEC SOCKIT 
  AUD_ADCDAT   : in std_logic;
  AUD_ADCLRCK  : inout std_logic;
  AUD_BCLK     : inout std_logic;
  AUD_DACDAT   : out std_logic;
  AUD_DACLRCK  : inout std_logic;
  AUD_I2C_SCLK : out std_logic;
  AUD_I2C_SDAT : inout std_logic;
  AUD_MUTE     : out std_logic;
  AUD_XCK      : out std_logic

);
end pooyan_sockit;

architecture struct of pooyan_sockit is

 signal clock_12  : std_logic;
 signal clock_14  : std_logic;
 signal reset     : std_logic;
 signal clock_6   : std_logic;
  
 signal r         : std_logic_vector(2 downto 0);
 signal g         : std_logic_vector(2 downto 0);
 signal b         : std_logic_vector(1 downto 0);
 signal csync     : std_logic;
 signal blankn    : std_logic;
 signal hsync     : std_logic;   -- mod by somhic
 signal vsync     : std_logic;   -- mod by somhic
 signal audio     : std_logic_vector(10 downto 0);
 signal pwm_accumulator : std_logic_vector(12 downto 0);
 signal tv15Khz_mode : std_logic := '0';


 alias reset_n         : std_logic is KEY(0);
 alias ps2_clk         : std_logic is ps2clk; 
 alias ps2_dat         : std_logic is ps2dat; 
--  alias pwm_audio_out_l : std_logic is pwm_l;  
--  alias pwm_audio_out_r : std_logic is pwm_r;  
 
 signal kbd_intr      : std_logic;
 signal kbd_scancode  : std_logic_vector(7 downto 0);
 signal joyPCFRLDU    : std_logic_vector(8 downto 0);
 signal fn_pulse      : std_logic_vector(7 downto 0);
 signal fn_toggle     : std_logic_vector(7 downto 0);

 signal dbg_cpu_addr : std_logic_vector(15 downto 0);

-- video signals   -- mod by somhic
--  signal clock_vga       : std_logic;   
 signal vga_g_i         : std_logic_vector(5 downto 0);   
 signal vga_r_i         : std_logic_vector(5 downto 0);   
 signal vga_b_i         : std_logic_vector(5 downto 0);   
 signal vga_r_o         : std_logic_vector(5 downto 0);   
 signal vga_g_o         : std_logic_vector(5 downto 0);   
 signal vga_b_o         : std_logic_vector(5 downto 0);   
 signal vga_hs_o      : std_logic;   
 signal vga_vs_o      : std_logic;   

 signal vga_r_c         : std_logic_vector(7 downto 0);
 signal vga_g_c         : std_logic_vector(7 downto 0);
 signal vga_b_c         : std_logic_vector(7 downto 0);
 signal vga_hs_c        : std_logic;
 signal vga_vs_c        : std_logic;

 signal left_i          : std_logic; 
 signal right_i         : std_logic; 
 signal up_i            : std_logic;
 signal down_i          : std_logic;
 signal fire_i          : std_logic;
 
-- signals for I2S output    -- mod by somhic
 signal I2S_SCLK         : std_logic;   
 signal I2S_LRCLK        : std_logic;   
 signal sample_data      : std_logic_vector(31 downto 0); -- audio data : 16bits left channel + 16bits right channel    
 signal tx_data          : std_logic;   
 signal sample_data_reg  : std_logic_vector(31 downto 0);
 signal audio_out        : std_logic := '0';
 signal audio_bit_cnt    : integer range 0 to 31 := 0;

component vga_scandoubler is          -- mod by somhic
   port (
        clkvideo               : in std_logic;
        clkvga                 : in std_logic;      -- has to be double of clkvideo
        enable_scandoubling    : in std_logic;
        disable_scaneffect     : in std_logic;       
        ri                : in std_logic_vector( 5 downto 0);
        gi                : in std_logic_vector( 5 downto 0);
        bi                : in std_logic_vector( 5 downto 0);
        hsync_ext_n       : in std_logic;
        vsync_ext_n       : in std_logic;
        csync_ext_n       : in std_logic; 
        ro                : out std_logic_vector( 5 downto 0);
        go                : out std_logic_vector( 5 downto 0);
        bo                : out std_logic_vector( 5 downto 0); 
        hsync             : out std_logic;
        vsync             : out std_logic
   );
   end component;

signal exchan : std_logic;
signal mix : std_logic;
signal audio_r : std_logic_vector  ( 15-1 downto 0);
signal audio_l : std_logic_vector  ( 15-1 downto 0);

component audio_top
  port (
  clk : in std_logic;
  rst_n : in std_logic;
  mix : in std_logic;
  rdata : in std_logic_vector  ( 15-1 downto 0);
  ldata : in std_logic_vector  ( 15-1 downto 0);
  exchan : in std_logic;
  aud_bclk : out std_logic;
  aud_daclrck : out std_logic;
  aud_dacdat : out std_logic;
  aud_xck : out std_logic;
  i2c_sclk : out std_logic;
  i2c_sdat : inout std_logic
);
end component;

begin

reset <= not reset_n;

-- Clock 12.288MHz for pooyan core, 14.318MHz for sound_board
clocks : entity work.max10_pll_12M_14M
port map(
 inclk0 => OSC_50_B8A,
 c0 => clock_12,
 c1 => clock_14,
 locked => open --pll_locked
);

-- Pooyan
pooyan : entity work.pooyan
port map(
 clock_12   => clock_12,
 clock_14   => clock_14,
 reset      => reset,
 
-- tv15Khz_mode => tv15Khz_mode,
 video_r      => r,
 video_g      => g,
 video_b      => b,
 video_csync  => csync,
 video_blankn => blankn,
 video_hs     => hsync,   --mod by somhic
 video_vs     => vsync,   --mod by somhic
 audio_out    => audio,
 
 dip_switch_2 => X"21", -- Sound(8)/Difficulty(7-5)/Bonus(4)/Cocktail(3)/lives(2-1)  --mod by somhic  Shaeon config
-- dip_switch_2 => X"7B", -- Sound(8)/Difficulty(7-5)/Bonus(4)/Cocktail(3)/lives(2-1)  --mod by somhic No Flip screen
-- dip_switch_2 => X"7F", -- Sound(8)/Difficulty(7-5)/Bonus(4)/Cocktail(3)/lives(2-1)
 dip_switch_1 => X"FF", -- Coinage_B / Coinage_A

 coin1       => fn_pulse(0), -- F1
 start1      => fn_pulse(1), -- F2
 start2      => fn_pulse(2), -- F3
 
 fire1       => not fire_i,  -- space
 right1      => not right_i, -- right
 left1       => not left_i,  -- left
 down1       => not down_i,  -- down
 up1         => not up_i,    -- up

 fire2       => joyPCFRLDU(4),  -- space
 right2      => joyPCFRLDU(3),  -- right
 left2       => joyPCFRLDU(2),  -- left
 down2       => joyPCFRLDU(1),  -- down
 up2         => joyPCFRLDU(0),  -- up

 dbg_cpu_addr => dbg_cpu_addr
);


-- VGA 
-- adapt video to 6bits/color only and blank
vga_r_i <= r & r     when blankn = '1' else "000000";
vga_g_i <= g & g     when blankn = '1' else "000000";
vga_b_i <= b & b & b when blankn = '1' else "000000";

-- vga scandoubler
scandoubler : vga_scandoubler
port map(
  --input
  clkvideo  => clock_6,
  clkvga    => clock_12,      -- has to be double of clkvideo
  enable_scandoubling => '1',
  disable_scaneffect  => '1',  -- 1 to disable scanlines
  ri  => vga_r_i,
  gi  => vga_g_i,
  bi  => vga_b_i,
  hsync_ext_n => hsync,
  vsync_ext_n => vsync,
  csync_ext_n => csync,
  --output
  ro  => vga_r_o,
  go  => vga_g_o,
  bo  => vga_b_o,
  hsync => vga_hs_o,
  vsync => vga_vs_o
);


-- RGB
-- adapt video to 8bits/color only and blank
vga_r_c <= r & r & r(2 downto 1)     when blankn = '1' else "00000000";
vga_g_c <= g & g & g(2 downto 1)     when blankn = '1' else "00000000";
vga_b_c <= b & b & b & b       when blankn = '1' else "00000000";
-- synchro composite/ synchro horizontale
vga_hs_c <= csync;
-- VGA_HS <= csync when tv15Khz_mode = '1' else hsync;
-- commutation rapide / synchro verticale
vga_vs_c <= '1';
-- VGA_vS <= '1'   when tv15Khz_mode = '1' else vsync;


--VIDEO OUTPUT VGA/RGB
tv15Khz_mode <= fn_toggle(7);          -- F8 key
process (clock_12)
begin
		if rising_edge(clock_12) then
			if tv15Khz_mode = '1' then
        --RGB
        VGA_R  <= vga_r_c;
        VGA_G  <= vga_g_c;
        VGA_B  <= vga_b_c;
        VGA_HS <= vga_hs_c;
        VGA_VS <= vga_vs_c; 
		VGA_BLANK_n <= vga_hs_c and vga_vs_c;  --'1'

			else
        --VGA
        -- adapt video to 4 bits/color only
        VGA_R  <= vga_r_o & vga_r_o (5 downto 4);
        VGA_G  <= vga_g_o & vga_g_o (5 downto 4);
        VGA_B  <= vga_b_o & vga_b_o (5 downto 4);
        VGA_HS <= vga_hs_o;       
        VGA_VS <= vga_vs_o; 	    	
		VGA_BLANK_n <= vga_hs_o and vga_vs_o;  --'1'
			end if;
		end if;
end process;

VGA_SYNC_n <= '0';   --no sync on green
VGA_CLK <= clock_12; 

-- -- Clock MHz for video & I2S        -- mod by somhic
-- clocks2 : entity work.pll    
-- port map(
--  inclk0 => OSC_50_B8A,
--  --c0 => clock_vga,               
--  c1 => I2S_SCLK,
--  c2 => I2S_LRCLK,
--  locked => open --pll_locked
-- );


-- I2S interface audio
sample_data <= "00" & audio & "000" & "00" & audio & "000";  -- audio data : 16bits left channel + 16bits right channel 
tx_data <= sample_data_reg(audio_bit_cnt) when audio_out = '1' else '0';
 
-- 3 timing requeriments due to this process
-- Taken from Dar Xevious sgtl5000_dac.vhd
process(I2S_SCLK)
begin
	if rising_edge(I2S_SCLK) then
		if I2S_LRCLK  = '1' then			--0 = Left channel, 1 = Right channel
			audio_bit_cnt <= 31;
			sample_data_reg <= sample_data;
			audio_out <= '1';
		else
			if audio_bit_cnt = 0 then
				audio_out <= '0';				
			else
				audio_bit_cnt <= audio_bit_cnt -1;
			end if;
		end if;
  end if;
end process;




-- SOCKIT AUDIO CODEC

AUD_MUTE <= KEY(2);
exchan <= '0';
mix <= '0';

audio_r <= "00" & audio & "00";
audio_l <= "00" & audio & "00";

audio_top_inst : audio_top
  port map (
  clk     =>      OSC_50_B8A,  -- input clock
  rst_n   =>      reset_n,		  -- active low reset (from reset button)
  -- config
  exchan  =>      exchan,		  -- switch audio left / right channel
  mix     =>      mix,			  -- normal / centered mix (play some left channel on the right channel and vise-versa)
  -- audio shifter
  rdata   =>      audio_r,		-- right channel sample data
  ldata   =>      audio_l,		-- left channel sample data
  aud_bclk=>      AUD_BCLK,	  -- CODEC data clock
  aud_daclrck=>   AUD_DACLRCK,-- CODEC data clock
  aud_dacdat =>   AUD_DACDAT,	-- CODEC data
  aud_xck =>      AUD_XCK,  	-- CODEC data clock
  -- I2C audio config
  i2c_sclk=>      AUD_I2C_SCLK,  	-- CODEC config clock
  i2c_sdat=>      AUD_I2C_SDAT    -- CODEC config data
);


-- get scancode from keyboard
process (reset, clock_12)
begin
	if reset='1' then
		clock_6  <= '0';
	else 
		if rising_edge(clock_12) then
				clock_6  <= not clock_6;
		end if;
	end if;
end process;

keyboard : entity work.io_ps2_keyboard
port map (
  clk       => clock_6, -- synchrounous clock with core
  kbd_clk   => ps2_clk,
  kbd_dat   => ps2_dat,
  interrupt => kbd_intr,
  scancode  => kbd_scancode
);

-- translate scancode to joystick
joystick : entity work.kbd_joystick
port map (
  clk           => clock_6, -- synchrounous clock with core
  kbdint        => kbd_intr,
  kbdscancode   => std_logic_vector(kbd_scancode), 
  joy_BBBBFRLDU => joyPCFRLDU,
  fn_pulse      => fn_pulse,
  fn_toggle     => fn_toggle
);

--Sega megadrive gamepad
JOYX_SEL_O <= '1';  --not needed. core uses 1 button only

left_i   <= not joyPCFRLDU(2) and JOY1_LEFT;  -- left
right_i  <= not joyPCFRLDU(3) and JOY1_RIGHT; -- right
up_i     <= not joyPCFRLDU(0) and JOY1_UP;    -- up
down_i   <= not joyPCFRLDU(1) and JOY1_DOWN;  -- down
fire_i   <= not joyPCFRLDU(4) and JOY1_B1_P6; -- space

--ledr(8 downto 0) <= joyBCPPFRLDU;

-- pwm sound output
-- process(clock_14)  -- use same clock as pooyan_sound_board
-- begin
--   if rising_edge(clock_14) then
--     pwm_accumulator  <=  std_logic_vector(unsigned('0' & pwm_accumulator(11 downto 0)) + unsigned(audio & "00"));
--   end if;
-- end process;

-- pwm_audio_out_l <= pwm_accumulator(12);
-- pwm_audio_out_r <= pwm_accumulator(12); 


end struct;
