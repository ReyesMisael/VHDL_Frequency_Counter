library ieee;
use ieee.std_logic_1164.all;


entity top is 
	generic (
		WIDTHC	: natural := 16	-- the lengh of each counter 
	);
	port(
	tdx	: out	std_logic;	-- uart tx transmition 
	rdx	: in	std_logic;	-- uart rx transmition
	tx 	: in 	std_logic;	-- unknown signal
	to_ref	: in	std_logic;	-- reference oscillator signal
	rst	: in	std_logic;	-- reset system 
	code	: in	std_logic
	);
end entity;


architecture rtl of top is 

signal wreq 	: std_logic;
signal coin 	: std_logic;
signal en	: std_logic;
signal pulse_clk: std_logic;
signal Nx	: std_logic_vector(WIDTHC - 1 downto 0);
signal No	: std_logic_vector(WIDTHC - 1 downto 0);
signal Q	: std_logic_vector(WIDTHC - 1 downto 0);

begin

	start : process (wreq, rst) IS							-- latch to start the measurement when booth pulses are high 
		begin
			if rst = '1' THEN
        			coin <= '0';
        		else if  en = '1' and (tx and to_ref) then
       			 	coin <= '1';
       		 end if;
	end process ;
	
	frequency_counter : entity work.Frequency_Counter(rtl)
	generic map (
		WIDTH => Counter_WIDTH
	)
	port map (
		Tx      =>	tx,		-- Unknown Square wave unknow signal
        	T0      =>	to_ref,		-- Reference signal     
        	enable  => 	en,   
        	rst     =>	rst,
		code	=>	code,		-- set '1' to select gray code; set '0' to select binary code
		pulseClk=>	pulseClk,
		Nx	=>	Nx,	
		No	=>	No,	
        	Q	=>			-- Coincidence vectors Nx concatenate with No	
	);	


end rtl;


 