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

entity button_pulse_detector is
	port(
		clk_i: 	in std_logic;	-- Destination clock
		signal_i: in std_logic;	-- Button value to be detected
		signal_o: out std_logic := '0'	-- Pulse signal when button is pressed
	);
end;

architecture button_pulse_detector_arq of button_pulse_detector is
	signal last_value: std_logic := '0';	-- Last value of the button
begin
	process(clk_i)
	begin
		if rising_edge(clk_i) then
			if last_value = '0' and signal_i = '1' then
				signal_o <= '1';
			else
				signal_o <= '0';
			end if;
			last_value <= signal_i;
		end if;
	end process;
end;
