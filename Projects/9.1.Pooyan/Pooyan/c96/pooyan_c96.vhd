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
-- Use pooyan_c96.sdc to compile (Timequest constraints)
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

entity pooyan_c96 is
port(
--  CLK_EXT  : in std_logic;

-- ledr           : out std_logic_vector(9 downto 0);
--  key            : in std_logic_vector(1 downto 0);

--  vga_r     : out std_logic_vector(3 downto 0);
--  vga_g     : out std_logic_vector(3 downto 0);
--  vga_b     : out std_logic_vector(3 downto 0);
--  vga_hs    : out std_logic;
--  vga_vs    : out std_logic;

--  ps2clk   : in std_logic;
--  ps2dat   : in std_logic;

--  pwm_l    : out std_logic;
--  pwm_r    : out std_logic;

-- -- JOYSTICK
-- JOY1_B2_P9		: IN    STD_LOGIC;
-- JOY1_B1_P6		: IN    STD_LOGIC;
-- JOY1_UP		    : IN    STD_LOGIC;
-- JOY1_DOWN		  : IN    STD_LOGIC;
-- JOY1_LEFT	  	: IN    STD_LOGIC;
-- JOY1_RIGHT		: IN    STD_LOGIC;
-- JOYX_SEL_O		: OUT   STD_LOGIC := '1'

hps_io_hps_io_sdio_inst_CMD      : inout std_logic;
hps_io_hps_io_sdio_inst_D0       : inout std_logic;
hps_io_hps_io_sdio_inst_D1       : inout std_logic;
hps_io_hps_io_sdio_inst_CLK      : out   std_logic;
hps_io_hps_io_sdio_inst_D2       : inout std_logic;
hps_io_hps_io_sdio_inst_D3       : inout std_logic;
hps_io_hps_io_uart0_inst_RX      : in    std_logic;
hps_io_hps_io_uart0_inst_TX      : out   std_logic;

hps_io_hps_io_gpio_inst_LOANIO14 : inout std_logic;
hps_io_hps_io_gpio_inst_LOANIO17 : inout std_logic;
hps_io_hps_io_gpio_inst_LOANIO19 : inout std_logic;
hps_io_hps_io_gpio_inst_LOANIO22 : inout std_logic;
hps_io_hps_io_gpio_inst_LOANIO23 : inout std_logic;
hps_io_hps_io_gpio_inst_LOANIO25 : inout std_logic;
hps_io_hps_io_gpio_inst_LOANIO27 : inout std_logic;
hps_io_hps_io_gpio_inst_LOANIO28 : inout std_logic;
hps_io_hps_io_gpio_inst_LOANIO29 : inout std_logic;
hps_io_hps_io_gpio_inst_LOANIO30 : inout std_logic;
hps_io_hps_io_gpio_inst_LOANIO32 : inout std_logic;
hps_io_hps_io_gpio_inst_LOANIO33 : inout std_logic;
hps_io_hps_io_gpio_inst_LOANIO34 : inout std_logic;
hps_io_hps_io_gpio_inst_LOANIO48 : inout std_logic;
hps_io_hps_io_gpio_inst_LOANIO53 : inout std_logic;
hps_io_hps_io_gpio_inst_LOANIO54 : inout std_logic

);
end pooyan_c96;

architecture struct of pooyan_c96 is

 signal vga_r     : std_logic_vector(3 downto 0);
 signal vga_g     : std_logic_vector(3 downto 0);
 signal vga_b     : std_logic_vector(3 downto 0);
 signal vga_hs    : std_logic;
 signal vga_vs    : std_logic;

 signal ps2_clk : std_logic; 
 signal ps2_dat : std_logic; 

 signal pwm_audio_out_l : std_logic;  
 signal pwm_audio_out_r : std_logic;  

 signal loan_io_in  : std_logic_vector(66 downto 0);  -- loan io inputs coming from soc_hps block
 signal loan_io_out : std_logic_vector(66 downto 0); 	-- loan io outputs going to soc_hps block
 signal loan_io_oe  : std_logic_vector(66 downto 0);  -- loan io enable outputs going to soc_hps block

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

--  alias reset_n         : std_logic is key(0);
--  alias ps2_clk         : std_logic is ps2clk; 
--  alias ps2_dat         : std_logic is ps2dat; 
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

 signal vga_r_c         : std_logic_vector(3 downto 0);
 signal vga_g_c         : std_logic_vector(3 downto 0);
 signal vga_b_c         : std_logic_vector(3 downto 0);
 signal vga_hs_c        : std_logic;
 signal vga_vs_c        : std_logic;

 signal left_i          : std_logic; 
 signal right_i         : std_logic; 
 signal up_i            : std_logic;
 signal down_i          : std_logic;
 signal fire_i          : std_logic;


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

   component loanio_control
    port (
      clk : in std_logic;
      RED : in std_logic_vector  (1 downto 0);
      GREEN : in std_logic_vector  (1 downto 0);
      BLUE : in std_logic_vector  (1 downto 0);
      hsync : in std_logic;
      vsync : in std_logic;
      pwm_l     : in std_logic;
      pwm_r     : in std_logic;
      ps2_clk   : out std_logic;
      ps2_dat   : out std_logic;
      loan_io_in : in std_logic_vector   (66 downto 0);
      loan_io_out: out std_logic_vector  (66 downto 0);
      loan_io_oe : out std_logic_vector  (66 downto 0)
    );
  end component;

  component soc_hps is
		port (
			clock_bridge_0_out_clk_clk       : out   std_logic;                                        -- clk
			hps_0_h2f_loan_io_in             : out   std_logic_vector(66 downto 0);                    -- in
			hps_0_h2f_loan_io_out            : in    std_logic_vector(66 downto 0) := (others => 'X'); -- out
			hps_0_h2f_loan_io_oe             : in    std_logic_vector(66 downto 0) := (others => 'X'); -- oe
			hps_io_hps_io_sdio_inst_CMD      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0       : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1       : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_CLK      : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2       : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3       : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_io_hps_io_uart0_inst_RX      : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX      : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_io_hps_io_gpio_inst_LOANIO14 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO14
			hps_io_hps_io_gpio_inst_LOANIO17 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO17
			hps_io_hps_io_gpio_inst_LOANIO19 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO19
			hps_io_hps_io_gpio_inst_LOANIO22 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO22
			hps_io_hps_io_gpio_inst_LOANIO23 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO23
			hps_io_hps_io_gpio_inst_LOANIO25 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO25
			hps_io_hps_io_gpio_inst_LOANIO27 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO27
			hps_io_hps_io_gpio_inst_LOANIO28 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO28
			hps_io_hps_io_gpio_inst_LOANIO29 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO29
			hps_io_hps_io_gpio_inst_LOANIO30 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO30
			hps_io_hps_io_gpio_inst_LOANIO32 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO32
			hps_io_hps_io_gpio_inst_LOANIO33 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO33
			hps_io_hps_io_gpio_inst_LOANIO34 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO34
			hps_io_hps_io_gpio_inst_LOANIO48 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO48
			hps_io_hps_io_gpio_inst_LOANIO53 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO53
			hps_io_hps_io_gpio_inst_LOANIO54 : inout std_logic                     := 'X'              -- hps_io_gpio_inst_LOANIO54
			-- memory_mem_a                     : out   std_logic_vector(14 downto 0);                    -- mem_a
			-- memory_mem_ba                    : out   std_logic_vector(2 downto 0);                     -- mem_ba
			-- memory_mem_ck                    : out   std_logic;                                        -- mem_ck
			-- memory_mem_ck_n                  : out   std_logic;                                        -- mem_ck_n
			-- memory_mem_cke                   : out   std_logic;                                        -- mem_cke
			-- memory_mem_cs_n                  : out   std_logic;                                        -- mem_cs_n
			-- memory_mem_ras_n                 : out   std_logic;                                        -- mem_ras_n
			-- memory_mem_cas_n                 : out   std_logic;                                        -- mem_cas_n
			-- memory_mem_we_n                  : out   std_logic;                                        -- mem_we_n
			-- memory_mem_reset_n               : out   std_logic;                                        -- mem_reset_n
			-- memory_mem_dq                    : inout std_logic_vector(15 downto 0) := (others => 'X'); -- mem_dq
			-- memory_mem_dqs                   : inout std_logic_vector(1 downto 0)  := (others => 'X'); -- mem_dqs
			-- memory_mem_dqs_n                 : inout std_logic_vector(1 downto 0)  := (others => 'X'); -- mem_dqs_n
			-- memory_mem_odt                   : out   std_logic;                                        -- mem_odt
			-- memory_mem_dm                    : out   std_logic_vector(1 downto 0);                     -- mem_dm
			-- memory_oct_rzqin                 : in    std_logic                     := 'X'              -- oct_rzqin
		);
	end component soc_hps;


  signal clk  : std_logic;

begin

reset <= '0';   -- not reset_n;

-- Clock 12.288MHz for pooyan core, 14.318MHz for sound_board
clocks : entity work.max10_pll_12M_14M
port map(
 inclk0 => clk,
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
-- adapt video to 4bits/color only and blank
vga_r_c <= r & r(2)     when blankn = '1' else "0000";
vga_g_c <= g & g(2)     when blankn = '1' else "0000";
vga_b_c <= b & b        when blankn = '1' else "0000";
-- synchro composite/ synchro horizontale
vga_hs_c <= csync;
-- vga_hs <= csync when tv15Khz_mode = '1' else hsync;
-- commutation rapide / synchro verticale
vga_vs_c <= '1';
-- vga_vs <= '1'   when tv15Khz_mode = '1' else vsync;


--VIDEO OUTPUT VGA/RGB
tv15Khz_mode <= fn_toggle(7);          -- F8 key
process (clock_12)
begin
		if rising_edge(clock_12) then
			if tv15Khz_mode = '1' then
        --RGB
        vga_r  <= vga_r_c;
        vga_g  <= vga_g_c;
        vga_b  <= vga_b_c;
        vga_hs <= vga_hs_c;
        vga_vs <= vga_vs_c; 
			else
        --VGA
        -- adapt video to 4 bits/color only
        vga_r  <= vga_r_o (5 downto 2);
        vga_g  <= vga_g_o (5 downto 2);
        vga_b  <= vga_b_o (5 downto 2);
        vga_hs <= vga_hs_o;       
        vga_vs <= vga_vs_o; 	    	
			end if;
		end if;
end process;


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
-- JOYX_SEL_O <= '1';  --not needed. core uses 1 button only

-- left_i   <= not joyPCFRLDU(2) and JOY1_LEFT;  -- left
-- right_i  <= not joyPCFRLDU(3) and JOY1_RIGHT; -- right
-- up_i     <= not joyPCFRLDU(0) and JOY1_UP;    -- up
-- down_i   <= not joyPCFRLDU(1) and JOY1_DOWN;  -- down
-- fire_i   <= not joyPCFRLDU(4) and JOY1_B1_P6; -- space

left_i   <= not joyPCFRLDU(2) and '1';  -- left
right_i  <= not joyPCFRLDU(3) and '1';  -- right
up_i     <= not joyPCFRLDU(0) and '1';  -- up
down_i   <= not joyPCFRLDU(1) and '1';  -- down
fire_i   <= not joyPCFRLDU(4) and '1';  -- space

--ledr(8 downto 0) <= joyBCPPFRLDU;

-- pwm sound output
process(clock_14)  -- use same clock as pooyan_sound_board
begin
  if rising_edge(clock_14) then
    pwm_accumulator  <=  std_logic_vector(unsigned('0' & pwm_accumulator(11 downto 0)) + unsigned(audio & "00"));
  end if;
end process;

pwm_audio_out_l <= pwm_accumulator(12);
pwm_audio_out_r <= pwm_accumulator(12); 


loanio_control_inst : component loanio_control
  port map (
    clk => clk,
    RED => vga_r(3 downto 2),
    GREEN => vga_g(3 downto 2),
    BLUE => vga_b(3 downto 2),
    hsync => vga_hs,
    vsync => vga_vs,
    pwm_l => pwm_audio_out_l,
    pwm_r => pwm_audio_out_r,
    ps2_clk => ps2_clk,
    ps2_dat => ps2_dat,
    loan_io_in => loan_io_in,
    loan_io_out => loan_io_out,
    loan_io_oe => loan_io_oe
  );

  
-- // External pin clock (50 MHz)
-- clk <= CLK_EXT;

u0 : component soc_hps
  port map (
    clock_bridge_0_out_clk_clk       => clk,                    -- clock_bridge_0_out_clk.clk
    hps_0_h2f_loan_io_in             => loan_io_in,             --      hps_0_h2f_loan_io.in
    hps_0_h2f_loan_io_out            => loan_io_out,            --                       .out
    hps_0_h2f_loan_io_oe             => loan_io_oe,             --                       .oe
    hps_io_hps_io_sdio_inst_CMD      => hps_io_hps_io_sdio_inst_CMD,      --                 hps_io.hps_io_sdio_inst_CMD
    hps_io_hps_io_sdio_inst_D0       => hps_io_hps_io_sdio_inst_D0,       --                       .hps_io_sdio_inst_D0
    hps_io_hps_io_sdio_inst_D1       => hps_io_hps_io_sdio_inst_D1,       --                       .hps_io_sdio_inst_D1
    hps_io_hps_io_sdio_inst_CLK      => hps_io_hps_io_sdio_inst_CLK,      --                       .hps_io_sdio_inst_CLK
    hps_io_hps_io_sdio_inst_D2       => hps_io_hps_io_sdio_inst_D2,       --                       .hps_io_sdio_inst_D2
    hps_io_hps_io_sdio_inst_D3       => hps_io_hps_io_sdio_inst_D3,       --                       .hps_io_sdio_inst_D3
    hps_io_hps_io_uart0_inst_RX      => hps_io_hps_io_uart0_inst_RX,      --                       .hps_io_uart0_inst_RX
    hps_io_hps_io_uart0_inst_TX      => hps_io_hps_io_uart0_inst_TX,      --                       .hps_io_uart0_inst_TX
    hps_io_hps_io_gpio_inst_LOANIO14 => hps_io_hps_io_gpio_inst_LOANIO14, --                       .hps_io_gpio_inst_LOANIO14
    hps_io_hps_io_gpio_inst_LOANIO17 => hps_io_hps_io_gpio_inst_LOANIO17, --                       .hps_io_gpio_inst_LOANIO17
    hps_io_hps_io_gpio_inst_LOANIO19 => hps_io_hps_io_gpio_inst_LOANIO19, --                       .hps_io_gpio_inst_LOANIO19
    hps_io_hps_io_gpio_inst_LOANIO22 => hps_io_hps_io_gpio_inst_LOANIO22, --                       .hps_io_gpio_inst_LOANIO22
    hps_io_hps_io_gpio_inst_LOANIO23 => hps_io_hps_io_gpio_inst_LOANIO23, --                       .hps_io_gpio_inst_LOANIO23
    hps_io_hps_io_gpio_inst_LOANIO25 => hps_io_hps_io_gpio_inst_LOANIO25, --                       .hps_io_gpio_inst_LOANIO25
    hps_io_hps_io_gpio_inst_LOANIO27 => hps_io_hps_io_gpio_inst_LOANIO27, --                       .hps_io_gpio_inst_LOANIO27
    hps_io_hps_io_gpio_inst_LOANIO28 => hps_io_hps_io_gpio_inst_LOANIO28, --                       .hps_io_gpio_inst_LOANIO28
    hps_io_hps_io_gpio_inst_LOANIO29 => hps_io_hps_io_gpio_inst_LOANIO29, --                       .hps_io_gpio_inst_LOANIO29
    hps_io_hps_io_gpio_inst_LOANIO30 => hps_io_hps_io_gpio_inst_LOANIO30, --                       .hps_io_gpio_inst_LOANIO30
    hps_io_hps_io_gpio_inst_LOANIO32 => hps_io_hps_io_gpio_inst_LOANIO32, --                       .hps_io_gpio_inst_LOANIO32
    hps_io_hps_io_gpio_inst_LOANIO33 => hps_io_hps_io_gpio_inst_LOANIO33, --                       .hps_io_gpio_inst_LOANIO33
    hps_io_hps_io_gpio_inst_LOANIO34 => hps_io_hps_io_gpio_inst_LOANIO34, --                       .hps_io_gpio_inst_LOANIO34
    hps_io_hps_io_gpio_inst_LOANIO48 => hps_io_hps_io_gpio_inst_LOANIO48, --                       .hps_io_gpio_inst_LOANIO48
    hps_io_hps_io_gpio_inst_LOANIO53 => hps_io_hps_io_gpio_inst_LOANIO53, --                       .hps_io_gpio_inst_LOANIO53
    hps_io_hps_io_gpio_inst_LOANIO54 => hps_io_hps_io_gpio_inst_LOANIO54  --                       .hps_io_gpio_inst_LOANIO54
    -- memory_mem_a                     => CONNECTED_TO_memory_mem_a,                     --                 memory.mem_a
    -- memory_mem_ba                    => CONNECTED_TO_memory_mem_ba,                    --                       .mem_ba
    -- memory_mem_ck                    => CONNECTED_TO_memory_mem_ck,                    --                       .mem_ck
    -- memory_mem_ck_n                  => CONNECTED_TO_memory_mem_ck_n,                  --                       .mem_ck_n
    -- memory_mem_cke                   => CONNECTED_TO_memory_mem_cke,                   --                       .mem_cke
    -- memory_mem_cs_n                  => CONNECTED_TO_memory_mem_cs_n,                  --                       .mem_cs_n
    -- memory_mem_ras_n                 => CONNECTED_TO_memory_mem_ras_n,                 --                       .mem_ras_n
    -- memory_mem_cas_n                 => CONNECTED_TO_memory_mem_cas_n,                 --                       .mem_cas_n
    -- memory_mem_we_n                  => CONNECTED_TO_memory_mem_we_n,                  --                       .mem_we_n
    -- memory_mem_reset_n               => CONNECTED_TO_memory_mem_reset_n,               --                       .mem_reset_n
    -- memory_mem_dq                    => CONNECTED_TO_memory_mem_dq,                    --                       .mem_dq
    -- memory_mem_dqs                   => CONNECTED_TO_memory_mem_dqs,                   --                       .mem_dqs
    -- memory_mem_dqs_n                 => CONNECTED_TO_memory_mem_dqs_n,                 --                       .mem_dqs_n
    -- memory_mem_odt                   => CONNECTED_TO_memory_mem_odt,                   --                       .mem_odt
    -- memory_mem_dm                    => CONNECTED_TO_memory_mem_dm,                    --                       .mem_dm
    -- memory_oct_rzqin                 => CONNECTED_TO_memory_oct_rzqin                  --                       .oct_rzqin
  );


end struct;
