library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Frequenccy_Counter_Tb is 
end entity;

architecture sim of Frequenccy_Counter_Tb is 
-- Unknown and reference signal (Input)
signal Tx : std_logic;
signal T0 : std_logic;

-- Operational signals 
signal rst 	: std_logic := '0';
signal enable 	: std_logic := '0';
signal ctr_mode	: std_logic := '0';
-- Constans
Constant Ctr_Size 	: natural := 8;
constant Tx_period : time := 1 ns;
constant To_period : time := 2 ns;

-- System Output

signal Nx_count	: std_Logic_vector(Ctr_Size - 1 downto 0);
signal No_count	: std_Logic_vector(Ctr_Size - 1 downto 0);
signal Output_1	: std_logic_vector(2*Ctr_Size -1 downto 0);

begin

rst <= '1', '0' after 2 ns;
enable <= '0', '1' after 1 ns;

-- Instance device under test
DUT: entity work.Frequency_Counter(rtl)
generic map(
	 WIDTHC => Ctr_Size 
)
port map(
	Tx	=>	Tx,
        T0	=>	T0,
        enable	=>	enable,
	code	=>	ctr_mode,	    
        rst     =>	rst,
	Nx	=>	Nx_count,
	No	=>	No_count,
	Q	=>	Output_1
); 

-- Stimulus
clk_Tx :process
   	begin
    		Tx <= '0';
    		wait for Tx_period/2; 
    		Tx <= '1';
    		wait for Tx_period/2;
   	end process;

clk_To :process
   	begin
    		T0 <= '0';
    		wait for To_period/2; 
    		T0 <= '1';
    		wait for To_period/2;
   	end process;

stimulus :process
	begin 
		wait until enable = '1';
			report "Start enable";		
		wait for 10 ns;
			ctr_mode <= '1';
			report "Change mode";
		wait;
	end process;

end architecture;