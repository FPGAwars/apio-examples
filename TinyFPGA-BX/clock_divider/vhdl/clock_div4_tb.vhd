library ieee;
use ieee.std_logic_1164.all;

entity clock_div4_tb is
end;

architecture behaviour of clock_div4_tb is
	component clock_div4
		port (clock_in : in std_logic;
		clock_div4_0 : out std_logic;
		clock_div4_90 : out std_logic
	);
	end component;

	signal CLK : std_logic;
	signal clock : std_logic;
	signal clock_90 : std_logic;
begin
	clockdiv4 : clock_div4 port map (
	clock_in => CLK, clock_div4_0 => clock, clock_div4_90 => clock_90);

	process
	begin
		CLK <= '1';
		wait for 5 ns;
		CLK <= '0';
		wait for 5 ns;
	end process;
end;
