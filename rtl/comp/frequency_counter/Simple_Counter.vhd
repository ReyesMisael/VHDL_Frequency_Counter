library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Simple_Counter is 
    generic
    (
        WIDTH  :   natural :=  8
    );
    port
    (
        	clk	: in std_logic;                              -- clock triggers the count 
		reset	: in std_logic;                              -- reset 
		enable	: in std_logic;                              -- eneable the device
		count	: out std_logic_vector(WIDTH-1 downto 0)

    );

end entity;

architecture rtl of Simple_Counter is 
signal c : std_logic_vector(WIDTH-1 downto 0);              -- count signal 
begin
	process(clk, reset, enable)	
		begin
		if(reset = '1') then  
           		c <= (others => '0'); 
        	elsif (clk = '1' and clk'event and enable = '1') then
            		c <= c + 1;
		end if;     
    	end process;
    count <= c;

end rtl;