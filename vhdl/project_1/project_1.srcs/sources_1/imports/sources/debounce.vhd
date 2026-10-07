-----------------------------------------------------------------------------
--  
--  Copyright (c) 2008 Xilinx Inc.
--
--  Project  : 
--  Module   : 
--  Parent   : 
--  Children : 
--
--  Description: 
--
--  Parameters:
--    None
--
--  Notes       : 
--
--

library IEEE;
use IEEE.std_logic_1164.all;

entity debounce is
	port(
		clk_i: 	in std_logic;	-- Clock
		signal_i: in std_logic;	-- Noisy signal to be debounced
		signal_o: out std_logic := '0' -- Debounced signal
	);
end;

architecture debounce_arq of debounce is

	constant DEBOUNCE_TICKS : integer := 5_000_000; 			-- Debounce 50 ms at 10 MHz clock
	signal signal_src_aux: std_logic := '0'; 				-- Debounced signal
	signal signal_o_aux: std_logic := '0'; 					-- Debounced signal aux
	signal counter_debug: integer range 0 to DEBOUNCE_TICKS := 0; -- Debug counter for simulation


begin
	process(clk_i)
		variable counter: integer := 0; -- Counter for debouncing
	begin
		counter_debug <= counter; -- Debug counter for simulation
		if rising_edge(clk_i) then
			if signal_i /= signal_src_aux then
				signal_src_aux <= signal_i;
				counter := 0;
			else
				counter := counter + 1;
				if counter = DEBOUNCE_TICKS then
					signal_o_aux <= signal_src_aux;
					counter := 0;
				end if;
			end if;
		end if;
	end process;

	signal_o <= signal_o_aux;
end;
