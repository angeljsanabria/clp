library ieee;
use ieee.std_logic_1164.all;

entity button_input_tb is
end entity button_input_tb;

architecture button_input_tb_arc of button_input_tb is
    signal clk_tb: std_logic := '0';
    signal signal_i_tb: std_logic := '0';
    signal pulse_o_tb: std_logic := '0';
    signal signal_o_tb: std_logic := '0';

    component button_input is
        port(
            clk_i: 	in std_logic;	-- Destination clock
            signal_i: in std_logic;	-- Button value to be detected
            pulse_o: out std_logic := '0';	-- Pulse signal when button is pressed
            signal_o: out std_logic := '0'	-- Pulse signal when button is pressed
        );
    end component;

begin

    clk_tb <= not clk_tb after 5 ns;

    stim_proc : process
    begin
        signal_i_tb <= '0'; 

        -- dejar estable al inicio
        for i in 0 to 10 loop
            wait until rising_edge(clk_tb);
        end loop;

        -- pulso rebote
        wait until rising_edge(clk_tb);
        signal_i_tb <= '1';
        wait for 10 ms;

        -- pulso 1
        wait until rising_edge(clk_tb);
        signal_i_tb <= '0';
        wait for 8 ms;

        -- pulso 1
        wait until rising_edge(clk_tb);
        signal_i_tb <= '1';
        wait for 10 ms;

        -- pulso 
        wait until rising_edge(clk_tb);
        signal_i_tb <= '0';
        wait for 5 ms;

        -- pulso 1
        wait until rising_edge(clk_tb);
        signal_i_tb <= '1';
        wait for 100 ms;

        -- pulso 0
        wait until rising_edge(clk_tb);
        signal_i_tb <= '0';
        wait for 200 ms;

        wait;
    end process;


    DUT: button_input
        port map (
            clk_i => clk_tb,
            signal_i => signal_i_tb,
            pulse_o => pulse_o_tb,
            signal_o => signal_o_tb
        );
end;
  