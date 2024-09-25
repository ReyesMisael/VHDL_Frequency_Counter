-- Pulse coincidence Counters (Grey counter)
-- Counte when two square waves had a coincidence
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Frequency_Counter is
    
    generic 
    (
        WIDTHC : natural := 8                            	-- WIDHT vector lenght of each counter
    );
    port
    (
        Tx      :	in std_logic;				-- Unknown Square wave unknow signal
        T0      :	in std_logic;				-- Reference signal     
        eneable :	in std_logic;   
        rst     :	in std_logic;
	pulseClk:	out std_logic;
	Nx	:	out std_logic_vector(WIDTHC - 1 downto 0);
	No	:	out std_logic_vector(WIDTHC - 1 downto 0);
        Q	:	out std_logic_vector(2*WIDTHC - 1 downto 0)	-- Coincidence vectors Nx concatenate with No	
    );
end entity;

architecture rtl of Frequency_Counter is 

constant Counter_WIDTH : natural := WIDTHC;  
signal Ts : std_logic	:='0';
signal NX1 : std_logic_vector(WIDTHC - 1 downto 0);
signal N01 : std_logic_vector(WIDTHC - 1 downto 0);

begin
	-- -----------------------------------------
	--             Binary counter	
	-- ----------------------------------------
	Nx_Counter : entity work.Gray_Counter(rtl)
	generic map (
		WIDTH => Counter_WIDTH
	)
	port map (
		clk         =>   Tx,
		reset       =>   rst,
		eneable     =>   eneable,
		gray_count  =>   NX1
	);	

	No_Counter : entity work.Gray_Counter(rtl)
	generic map (
		WIDTH => Counter_WIDTH
	)

	port map (
		clk         =>   T0,
		reset       =>   rst,
		eneable     =>   eneable,
		gray_count  =>   N01
	);
	
	Regiter_PIPO : entity work.PIPO_register(rtl)
	generic map (
		N => Counter_WIDTH
	)

	port map (
		clk	=>   Ts,
		reset	=>   rst,
		Nx	=>   NX1, 
		N0	=>   N01,
		Q	=>   Q
	);
	
	Nx <= NX1;
	No <= N01;
	Ts <= Tx and T0; 
	pulseClk <= Ts; 
end rtl;