library ieee;
use ieee.std_logic_1164.all;

entity fstr is
	port (
		     CLK : in std_logic;
		     LED : out std_logic;
		     USBPU : out std_logic
);
end;

architecture RTL of fstr is
	signal clock : std_logic;
	signal clock_90 : std_logic;

	component clock_div4 is
		port (clock_in : in std_logic;
		clock_div4_0 : out std_logic;
		clock_div4_90 : out std_logic
	);
	end component;
begin
	USBPU <= '0';

	clockdiv4 : clock_div4 port map (
	clock_in => CLK, clock_div4_0 => clock, clock_div4_90 => clock_90);

	LED <= clock;
end;
