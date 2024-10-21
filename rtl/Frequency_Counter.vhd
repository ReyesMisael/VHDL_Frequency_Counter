-- Pulse coincidence Counters (Grey counter)
-- Counte when two square waves had a coincidence
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Frequency_Counter is
    
    generic 
    (
        WIDTHC	: natural := 8;                            	-- WIDHT vector lenght of each counter
	C_CODE 	: std_logic :=  '1'				-- set '1' to select gray code; set '0' to select binary code	 
    );
    port
    (
        Tx      :	in std_logic;				-- Unknown Square wave unknow signal
        T0      :	in std_logic;				-- Reference signal     
        enable :	in std_logic;   
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
signal NX1 : std_logic_vector(WIDTHC - 1 downto 0);			-- Gray counter NX
signal N01 : std_logic_vector(WIDTHC - 1 downto 0);			-- Gray counter N0
signal NX2 : std_logic_vector(WIDTHC - 1 downto 0);			-- Binary Counter NX
signal N02 : std_logic_vector(WIDTHC - 1 downto 0);			-- Binary Counter N0

signal S_NX : std_logic_vector(WIDTHC - 1 downto 0);			-- Output to mux_2_1
signal s_N0 : std_logic_vector(WIDTHC - 1 downto 0);			-- Output to mux_2_1

begin
	-- -----------------------------------------
	--            Gray code counter	
	-- ----------------------------------------
	Nx_GCounter : entity work.Gray_Counter(rtl)
	generic map (
		WIDTH => Counter_WIDTH
	)
	port map (
		clk         =>   Tx,
		reset       =>   rst,
		enable     =>    enable,
		gray_count  =>   NX1
	);	

	No_GCounter : entity work.Gray_Counter(rtl)
	generic map (
		WIDTH => Counter_WIDTH
	)

	port map (
		clk         =>   T0,
		reset       =>   rst,
		enable     =>    enable,
		gray_count  =>   N01
	);

	-- -----------------------------------------
	--        Binary code counter	
	-- ----------------------------------------
	Nx_BCounter : entity work.Simple_Counter(rtl)
	generic map (
		WIDTH => Counter_WIDTH
	)

	port map (
		clk 	=>   T0,
		reset	=>   rst,
		enable	=>   enable,
		count  	=>   N02
	);

	No_BCounter : entity work.Simple_Counter(rtl)
	generic map (
		WIDTH => Counter_WIDTH
	)

	port map (
		clk         =>	Tx,
		reset       =>	rst,
		enable      =>	enable,
		count  =>   NX2
	);
	-- -----------------------------------------
	--        	Mux 2_1	
	-- ----------------------------------------
	mux1 : entity work.mux_2_1(rtl)
	generic map(
		n	=> Counter_WIDTH  
	)
	port map (
		sel	=>	C_CODE,				
		a	=>	N01,			
		b	=>	N02,
		z	=>   	S_N0
	);
	
	mux2 : entity work.mux_2_1(rtl)
	generic map(
		n	=> Counter_WIDTH  
	)
	port map (
		sel	=>	C_CODE,
		a	=>	NX1,
		b	=>	NX2,
		z	=>	S_NX
	);
	-- -----------------------------------------
	--  Parallel input Paralel output register	
	-- ----------------------------------------
	Regiter_PIPO : entity work.PIPO_register(rtl)
	generic map (
		N => Counter_WIDTH
	)

	port map (
		clk	=>   Ts,
		reset	=>   rst,
		Nx	=>   S_NX,
		N0	=>   S_N0,
		Q	=>   Q
	);
	
	Nx <= S_NX;
	No <= S_N0;
	Ts <= Tx and T0; 
	pulseClk <= Ts;
 
end rtl;