library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity PIPO_Register is 
 generic 
    (
        N : natural := 8                            				-- WIDHT of one counter
    );
					
Port(clk,reset  :	in std_logic;
	Nx	:	in std_logic_vector(N - 1 downto 0);
	N0	:	in std_logic_vector(N - 1 downto 0);	
	Q	:	out std_logic_vector(2*N - 1 downto 0));		-- Concatenate two counters counts 
end PIPO_Register;

Architecture rtl of PIPO_Register is 
	begin
		Process(clk,reset)
		begin
		if (Reset ='1') then
			Q <= (others => '0');
		elsif(clk'event and clk = '0') then
			Q(2*N - 1 downto N) <= Nx(N - 1 downto 0);
			Q(N-1 downto 0)	<= N0(N - 1 downto 0);
		end if;
	end Process;
end rtl;