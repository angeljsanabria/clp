library ieee;
use ieee.std_logic_1164.all;

entity debounce_tb is
end entity debounce_tb;

architecture debounce_tb_arc of debounce_tb is
    signal clk_tb: std_logic := '0';
    signal signal_i_tb: std_logic := '0';
    signal signal_o_tb: std_logic := '0';

    component debounce is
        port(
            clk_i: 	in std_logic;	-- Clock
            signal_i: in std_logic;	-- Noisy signal to be debounced
            signal_o: out std_logic	-- Debounced signal
        );
    end component;

begin

    clk_tb <= not clk_tb after 5 ns;

    stim_proc: process
    begin
        signal_i_tb <= '0';
        wait for 10 ms;
        signal_i_tb <= '1';
        wait for 10 ms;
        signal_i_tb <= '0';
        wait for 10 ms;
        assert signal_o_tb = '0' report "Debounced signal should be 0" severity error;

        signal_i_tb <= '1';
        wait for 70 ms;
        assert signal_o_tb = '1' report "Debounced signal should be 1" severity error;

        signal_i_tb <= '0';
        wait for 60 ms;
        assert signal_o_tb = '0' report "Debounced signal should be 0" severity error;



    end process;

    DUT: debounce
        port map (
            clk_i => clk_tb,
            signal_i => signal_i_tb,
            signal_o => signal_o_tb
        );
end;
  