library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_pwm_tb is
end entity control_pwm_tb;

architecture control_pwm_tb_arc of control_pwm_tb is
    signal clk_tb: std_logic := '0';
    signal reset_tb: std_logic := '0';
    signal duty_tb: unsigned (3 downto 0) := to_unsigned(5, 4); -- Valor de duty cycle inicial (50%)
    signal duty_1_tb: unsigned (3 downto 0) := (others => '0');
    signal sel_frec_tb: std_logic_vector (1 downto 0) := (others => '0');
    signal pwm_out_tb: std_logic;

    component control_pwm is
        port(
            clk: 	in std_logic;	-- Clock
            reset: in std_logic;	-- Reset
            duty: in unsigned (3 downto 0);	-- Duty cycle
            duty_1: in unsigned (3 downto 0);	-- Duty cycle
            sel_frec: in std_logic_vector (1 downto 0);	-- Frequency selection
            pwm_out: out std_logic	-- PWM output
        );
    end component;

begin

    clk_tb <= not clk_tb after 5 ns;

    stim_proc: process
    begin
        -- Frequencia a 1 kHz Duty 50%
        wait until rising_edge(clk_tb);
        wait for 2 ms;
        
        -- Frequencia a 10 kHz Duty 50%
        wait until rising_edge(clk_tb);
        sel_frec_tb <= "01";
        wait for 200 us;

        -- Frecuencia a 100 kHz Duty 50%
        wait until rising_edge(clk_tb);
        sel_frec_tb <= "10";
        wait for 20 us;  

        -- Frecuencia a 1 MHz Duty 50%
        wait until rising_edge(clk_tb);
        sel_frec_tb <= "11";
        wait for 2 us;


        -- Frequencia a 1 kHz Duty 60
        wait until rising_edge(clk_tb);
        sel_frec_tb <= "00";
        duty_tb <= to_unsigned(6,4);
        wait for 2 ms;

        -- Frequencia a 1 kHz Duty 75
        wait until rising_edge(clk_tb);
        duty_tb <= to_unsigned(7,4);
        duty_1_tb <= to_unsigned(5,4);
        wait for 2 ms;

        -- Frequencia a 1 kHz Duty 90
        wait until rising_edge(clk_tb);
        duty_tb <= to_unsigned(9,4);
        duty_1_tb <= to_unsigned(0,4);
        wait for 2 ms;

        -- Frequencia a 1 kHz Duty 15
        wait until rising_edge(clk_tb);
        duty_tb <= to_unsigned(1,4);
        duty_1_tb <= to_unsigned(5,4);
        wait for 2 ms;

        -- Reset
        wait until rising_edge(clk_tb);
        reset_tb <= '1';
        duty_1_tb <= to_unsigned(5,4);
        wait for 2 ms;

        wait until rising_edge(clk_tb);
        reset_tb <= '0';
        duty_1_tb <= to_unsigned(5,4);
        wait for 2 ms;

    end process;

    DUT: control_pwm
        port map (
            clk => clk_tb,
            reset => reset_tb,
            duty => duty_tb,
            duty_1 => duty_1_tb,
            sel_frec => sel_frec_tb,
            pwm_out => pwm_out_tb
        );
end;
  