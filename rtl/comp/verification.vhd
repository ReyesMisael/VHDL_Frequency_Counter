library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Verification is
	port 
	(
		TX	: in  std_logic_vector (7 downto 0);
		Start	: out std_logic;
		rstCount	: out std_logic;
		rstFIFO	: out std_logic;
		rstAll	: out std_logic
	);
end entity;

architecture Recived of Verification is
begin

	Start <= '1' when TX = "00100000" else	'0'; 
	rstCount <= '1' when TX = "01100011" else '0';	-- c letter ASCII CODE
	rstFIFO <= '1' when TX = "01100110" else '0';	-- f letter ASCII CODE
	rstAll <= '1' when TX = "01110010" else '0';		-- r letter ASCII CODE
	
end architecture Recived;
