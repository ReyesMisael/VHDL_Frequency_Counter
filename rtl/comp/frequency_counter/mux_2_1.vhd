library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mux_2_1 is 
	generic (
		n  : integer := 8
	);
	port	(
		sel	:	in std_logic;				-- selector
		a	:	in std_logic_vector(n-1 downto 0);	-- input A
		b	:	in std_logic_vector(n-1 downto 0);	-- input B
		z	:	out std_logic_vector(n-1 downto 0)	-- Out Z
	);
end entity;


architecture rtl of mux_2_1 is
begin 
	
	z <= a when (sel = '1') else b;

end  architecture;