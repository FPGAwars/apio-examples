library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_div4 is
  port (clock_in       : in  std_logic;
        clock_div4_0   : out std_logic;
        clock_div4_90  : out std_logic
        );
end;

architecture RTL of clock_div4 is
  	signal div2 : std_logic := '0';
  	signal div4_0 : std_logic := '0';
  	signal div4_90 : std_logic := '0';
begin
	process (clock_in)
	begin
		if rising_edge(clock_in) then
			div2 <= not div2;
		end if;
	end process;

	process (div2)
	begin
		if rising_edge(div2) then
			div4_0 <= not div4_0;
		end if;
		if falling_edge(div2) then
			div4_90 <= not div4_90;
		end if;
	end process;

	clock_div4_0 <= div4_0;
	clock_div4_90 <= div4_90;
end;
