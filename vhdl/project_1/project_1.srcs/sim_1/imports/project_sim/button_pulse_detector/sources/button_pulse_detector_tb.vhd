library ieee;
use ieee.std_logic_1164.all;

entity button_pulse_detector_tb is
end entity button_pulse_detector_tb;

architecture button_pulse_detector_tb_arc of button_pulse_detector_tb is
    signal clk_tb: std_logic := '0';
    signal signal_i_tb: std_logic := '0';
    signal signal_o_tb: std_logic := '0';

    component button_pulse_detector is
        port(
            clk_i: 	in std_logic;	-- Destination clock
            signal_i: in std_logic;	-- Button value to be detected
            signal_o: out std_logic := '0'	-- Pulse signal when button is pressed
        );
    end component;

begin

    clk_tb <= not clk_tb after 5 ns;

    stim_proc: process
    begin
        signal_i_tb <= '0';
        wait for 50 ns;
        signal_i_tb <= '1';
        wait for 800 ns;
        signal_i_tb <= '0';
        wait for 200 ns;
        signal_i_tb <= '1';
        wait for 200 ns;

    end process;

    DUT: button_pulse_detector
        port map (
            clk_i => clk_tb,
            signal_i => signal_i_tb,
            signal_o => signal_o_tb
        );
end;
  