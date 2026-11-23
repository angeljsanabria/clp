library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity secure_inputs_tb is
end entity secure_inputs_tb;

architecture secure_inputs_tb_arc of secure_inputs_tb is
    signal clk_tb               : std_logic := '0';
    signal btn_duty_10_subir_tb : std_logic := '0';
    signal btn_duty_10_bajar_tb : std_logic := '0';
    signal btn_duty_1_subir_tb  : std_logic := '0';
    signal btn_duty_1_bajar_tb  : std_logic := '0';
    signal btn_duty_reset_tb    : std_logic := '0';
    signal sw_sel_frec_tb       : std_logic_vector(1 downto 0) := "00";

    signal leds_rgb_tb          : std_logic_vector(2 downto 0);
    signal led_subir_tb         : std_logic := '0';
    signal led_bajar_tb         : std_logic := '0';
    signal led_reset_tb         : std_logic := '0';

    signal sel_frec_tb          : std_logic_vector(1 downto 0);
    signal duty_10_subir_tb     : std_logic := '0';
    signal duty_10_bajar_tb     : std_logic := '0';
    signal duty_1_subir_tb      : std_logic := '0';
    signal duty_1_bajar_tb      : std_logic := '0';
    signal duty_reset_tb        : std_logic := '0';
    signal duty_10_pwm_tb       : unsigned(3 downto 0);
    signal duty_1_pwm_tb        : unsigned(3 downto 0);

    component secure_inputs is
        port (
            clk             : in  std_logic;
            btn_duty_10_subir : in  std_logic;
            btn_duty_10_bajar : in  std_logic;
            btn_duty_1_subir  : in  std_logic;
            btn_duty_1_bajar  : in  std_logic;
            btn_duty_reset    : in  std_logic;
            sw_sel_frec       : in  std_logic_vector(1 downto 0);
            leds_rgb          : out std_logic_vector(2 downto 0);
            led_subir         : out std_logic;
            led_bajar         : out std_logic;
            led_reset         : out std_logic;
            sel_frec          : out std_logic_vector(1 downto 0);
            duty_10_subir     : out std_logic;
            duty_10_bajar     : out std_logic;
            duty_1_subir      : out std_logic;
            duty_1_bajar      : out std_logic;
            duty_reset        : out std_logic;
            duty_10_pwm       : out unsigned(3 downto 0);
            duty_1_pwm        : out unsigned(3 downto 0)
        );
    end component;

begin

    clk_tb <= not clk_tb after 5 ns;

    stim_proc : process
    begin
        wait until rising_edge(clk_tb);
        btn_duty_10_subir_tb <= '0';
        wait for 2 us;

        -- Prueba antirebote
        wait until rising_edge(clk_tb);
        btn_duty_10_subir_tb <= '1';
        wait for 1 ms;
        
        wait until rising_edge(clk_tb);
        btn_duty_10_subir_tb <= '0';
        wait for 1 ms;
        
        wait until rising_edge(clk_tb);
        btn_duty_10_subir_tb <= '1';
        wait for 1 ms;
        
        wait until rising_edge(clk_tb);
        btn_duty_10_subir_tb <= '0';
        wait for 1 ms;
        
        wait until rising_edge(clk_tb);
        btn_duty_10_subir_tb <= '1';
        wait for 60 ms;    
        
        wait until rising_edge(clk_tb);
        btn_duty_10_subir_tb <= '0';
        wait for 60 ms;
        
        -- Prueba control fino
        wait until rising_edge(clk_tb);
        btn_duty_1_subir_tb <= '1';
        wait for 60 ms;

        wait until rising_edge(clk_tb);
        btn_duty_1_subir_tb <= '0';
        wait for 60 ms;

        wait until rising_edge(clk_tb);
        btn_duty_1_bajar_tb <= '1';
        wait for 60 ms;

        wait until rising_edge(clk_tb);
        btn_duty_1_bajar_tb <= '0';
        wait for 60 ms;

        -- Prueba cambio de frecuencia
        wait until rising_edge(clk_tb);
        sw_sel_frec_tb <= "01";
        wait for 60 ms;

        wait until rising_edge(clk_tb);
        sw_sel_frec_tb <= "11";
        wait for 60 ms;

        -- Prueba reset
        wait until rising_edge(clk_tb);
        btn_duty_reset_tb <= '1';
        wait for 60 ms;

        wait;
    end process;


    DUT: secure_inputs
        port map (
            clk             => clk_tb,
            btn_duty_10_subir => btn_duty_10_subir_tb,
            btn_duty_10_bajar => btn_duty_10_bajar_tb,
            btn_duty_1_subir  => btn_duty_1_subir_tb,
            btn_duty_1_bajar  => btn_duty_1_bajar_tb,
            btn_duty_reset    => btn_duty_reset_tb,
            sw_sel_frec       => sw_sel_frec_tb,
            leds_rgb          => leds_rgb_tb,
            led_subir         => led_subir_tb,
            led_bajar         => led_bajar_tb,
            led_reset         => led_reset_tb,
            sel_frec          => sel_frec_tb,
            duty_10_subir     => duty_10_subir_tb,
            duty_10_bajar     => duty_10_bajar_tb,
            duty_1_subir      => duty_1_subir_tb,
            duty_1_bajar      => duty_1_bajar_tb,
            duty_reset        => duty_reset_tb,
            duty_10_pwm       => duty_10_pwm_tb,
            duty_1_pwm        => duty_1_pwm_tb
        );
end architecture secure_inputs_tb_arc;
