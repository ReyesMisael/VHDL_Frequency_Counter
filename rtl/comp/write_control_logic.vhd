-- Quartus Prime VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;

entity write_control_logic is

	port(
		clk		: in	std_logic;
		reset		: in	std_logic;
		wrfull	: in	std_logic;
		start		: in std_logic;
		Coincidence: in std_logic;
		rdempty	: in 	std_logic;
		initRst	: out std_logic;
		eneable	: out std_logic;
		wreq		: out std_logic
	);

end entity;

architecture rtl of Write_Control_Logic is
	--IDLE => , WR => WRITE DATA IN FIFO, => INCR = INCREMENT COUNTER, => WT => WAIT 
	-- Build an enumerated type for the state machine
	type state_type is (IDLE, WR, WT, final);

	-- Register to hold the current state
	signal state   : state_type;

begin
	
	-- Logic to advance to the next state
	process (clk, reset)
	begin
		if reset = '1' then
			state <= IDLE;
		elsif (rising_edge(clk)) then
			case state is
				when IDLE=>
					if start = '1' and Coincidence = '1' then
						state <= WT;
					else
						state <= IDLE;
					end if;
				when WR=>
					if wrfull = '1' then
						state <= final;
					else
						state <= WR;
					end if;
				when WT =>
					if rdempty = '1' then	--use rdempty = '1' or wrfull = '0'
 						state <= WR;
					else
						state <= WT;
					end if;
				when final =>
					state <= final;
			end case;
		end if;
	end process;

	-- Output depends solely on the current state
	--eneable	 : enable counter
	--wreq		 : assert for read fifo
	--dataOut	 : fifo data
	--Incctr		 :	increment counter
	
	process (state)
	begin
		case state is
			when IDLE =>
				eneable <= '0';
				wreq <= '0';
				initRst <= '1';
			when WR =>
				eneable <= '1';
				wreq <= '1';
				initRst <= '0';
			when WT =>
				eneable <= '1';
				wreq <= '0';
				initRst <= '0';
			when final =>
				eneable <= '0';
				wreq <= '0';
				initRst <= '0';
		end case;
	end process;
end rtl;
