library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Simple_Counter is 
    generic
    (
        WIDTH  :   natural :=  8;
    );
    port
    (
        clk		   : in std_logic;                              -- clock triggers the count 
		reset	   : in std_logic;                              -- reset 
		eneable	   : in std_logic;                              -- eneable the device
		count : out std_logic_vector(WIDTH-1 downto 0)

    );

end entity;

architecture rtl of Simple_Counter is 
signal c : std_logic_vector(WIDTH-1 downto 0);              -- count signal 
    begin
    
        process(clk, rst)
        if (reset = '1') then  
            c <= (others => '0'); 
        elsif (eneable = '1') then
            c = c + 1;
        end if;    
    end process;
    
    count <= c;

end rtl;