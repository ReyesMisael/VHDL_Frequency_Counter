-- Quartus Prime VHDL Template
-- Gray Counter
-- Source: https://www.engineersgarage.com/n-bit-gray-counter-using-vhdl/

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gray_counter is

	generic
	(
		WIDTH : natural := 8
	);

	port 
	(
		clk		   : in std_logic;
		reset	   : in std_logic;
		enable	   : in std_logic;
		gray_count : out std_logic_vector(WIDTH-1 downto 0)
	);

end entity;

architecture rtl of gray_counter is
signal Currstate, Nextstate, hold, next_hold: std_logic_vector (WIDTH-1 downto 0);
begin
StateReg: PROCESS (Clk)
begin
	if (clk = '1' and clk'event) then
		if (reset = '1') then
 			Currstate <= (others =>'0');
 		elsif (enable = '1') then
			Currstate <= Nextstate;
 		end if;
	end if;
 end process;

	hold <= Currstate XOR ('0' & hold(WIDTH-1 downto 1));
	next_hold <= std_logic_vector(unsigned(hold) + 1);
	Nextstate <= next_hold XOR ('0' & next_hold(WIDTH-1 downto 1)); 
	gray_count <= Currstate;	  

end rtl;