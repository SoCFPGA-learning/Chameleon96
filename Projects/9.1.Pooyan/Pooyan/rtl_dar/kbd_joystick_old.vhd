library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Kbd_Joystick is
port (
  Clk          : in std_logic;
  KbdInt       : in std_logic;
  KbdScanCode  : in std_logic_vector(7 downto 0);
  JoyPCFRLDU   : out std_logic_vector(7 downto 0);
  fn_pulse      : inout std_logic_vector(7 downto 0);
  fn_toggle     : inout std_logic_vector(7 downto 0)
);
end Kbd_Joystick;

architecture Behavioral of Kbd_Joystick is

signal IsReleased : std_logic;
signal fn_pulse_r : std_logic_vector(7 downto 0);

begin 

process(Clk)
begin
  if rising_edge(Clk) then
  
    fn_pulse_r <= fn_pulse;

    if KbdInt = '1' then
      if KbdScanCode = "11110000" then IsReleased <= '1'; else IsReleased <= '0'; end if; 
      if KbdScanCode = "01110101" then JoyPCFRLDU(0) <= not(IsReleased); end if; -- up
      if KbdScanCode = "01110010" then JoyPCFRLDU(1) <= not(IsReleased); end if; -- down
      if KbdScanCode = "01101011" then JoyPCFRLDU(2) <= not(IsReleased); end if; -- left
      if KbdScanCode = "01110100" then JoyPCFRLDU(3) <= not(IsReleased); end if; -- right
      if KbdScanCode = "00101001" then JoyPCFRLDU(4) <= not(IsReleased); end if; -- space
      if KbdScanCode = "00000101" then JoyPCFRLDU(5) <= not(IsReleased); end if; -- F1 : 0x05
      if KbdScanCode = "00000110" then JoyPCFRLDU(6) <= not(IsReleased); end if; -- F2 : 0x06
      if KbdScanCode = "00000100" then JoyPCFRLDU(7) <= not(IsReleased); end if; -- F3 : 0x04
    
      if KbdScanCode = "00001010" then fn_pulse(7) <= not(IsReleased); end if; -- F8
    end if;

 	 if fn_pulse_r(7) = '1' and fn_pulse(7) = '0' then fn_toggle(7) <= not fn_toggle(7); end if;
  end if;
end process;

end Behavioral;


