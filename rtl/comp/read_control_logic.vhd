-- Quartus Prime VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;

entity Read_Control_Logic is

	port(
		clk		: in	std_logic;
		reset		: in std_logic;
		rdempty	: in std_logic;
		DIN_RDY	: in std_logic;
		rdreq		: out std_logic;
		DIN_VLD	: out std_logic
	);

end entity;

architecture rtl of Read_Control_Logic is

	-- Build an enumerated type for the state machine
	type state_type is (IDLE, RD, SEND, WT);

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
					if rdempty = '0'  then
						state <= RD;
					else
						state <= IDLE;
					end if;
				when RD=>
					if rdempty = '0' then
						state <= SEND;
					else
						state <= IDLE;
					end if;
				when SEND=>
						state <= WT;
				when WT=>
					if DIN_RDY = '1'  then
							state <= RD;
					end if;
			end case;
		end if;
	end process;
	-- Output depends solely on the current state
	-- rdreq  : out std_logic;    read request to FIFO
	--	DIN_VLD : out std_logic;	assert valid data to UART
	process (state)
	begin
		case state is
			when IDLE =>
				rdreq <= '0';
				DIN_VLD <= '0';
			when RD =>
				rdreq <= '0';
				DIN_VLD <= '1';
			when SEND => -- banarse en la riqueza
				rdreq <= '1';
				DIN_VLD <= '0';
			when WT =>
				rdreq <= '0';
				DIN_VLD <= '0';
		end case;
	end process;

end rtl;
