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

entity switch_input is
	port(
		clk_i: 	in std_logic;	-- Destination clock
		signal_i: in std_logic;	-- Switch value to be detected
		signal_o: out std_logic := '0'	-- Pulse signal when switch is pressed
	);
end;
    
architecture switch_input_arq of switch_input is
    
    component meta_harden is
        port(
            clk_dst: 	in std_logic;	-- Destination clock
            rst_dst: 	in std_logic;	-- Reset - synchronous to destination clock
            signal_src: in std_logic;	-- Asynchronous signal to be synchronized
            signal_dst: out std_logic	-- Synchronized signal
        );
    end component;    
    
    component debounce is
        port(
            clk_i: 	in std_logic;	-- Clock
            signal_i: in std_logic;	-- Noisy signal to be debounced
            signal_o: out std_logic := '0' -- Debounced signal
        );
    end component;


    signal signal_meta: std_logic := '0';	-- After sampling the async signal, this has
                                    -- a high probability of being metastable.
                                    -- The second sampling (signal_dst) has
                                    -- a much lower probability of being
                                    -- metastable

begin
	
    meta_harden_inst : meta_harden
        port map(
            clk_dst => clk_i,
            rst_dst => '0',
            signal_src => signal_i,
            signal_dst => signal_meta
        );

    debounce_inst : debounce
        port map(
            clk_i => clk_i,
            signal_i => signal_meta,
            signal_o => signal_o
        );

end;
