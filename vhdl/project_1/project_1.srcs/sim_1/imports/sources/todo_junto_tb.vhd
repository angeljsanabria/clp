-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.09.2026 21:15:53
-- Design Name: 
-- Module Name: todo_junto - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--  Click derecho en el archivo y marcar como "Set as top"; Esto es para que sea 
--  el archivo principal del diseño como guia para la sintesis.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity todo_junto_tb is
end entity todo_junto_tb;


architecture todo_junto_tb_arc of todo_junto_tb is
    
    signal clk_tb         : STD_LOGIC := '0';
    signal btn_subir_pe_tb      : STD_LOGIC := '0';
    signal btn_bajar_pe_tb      : STD_LOGIC := '0';
    signal btn_subir_1_pe_tb    : STD_LOGIC := '0';
    signal btn_bajar_1_pe_tb    : STD_LOGIC := '0';
    signal btn_reset_pe_tb      : STD_LOGIC := '0';
    signal btn_reset_clk_pe_tb  : STD_LOGIC := '0';
    signal sw_frec_pe_tb           : STD_LOGIC_VECTOR (1 downto 0) := "00";
    signal led_subir_pe_o_tb       : STD_LOGIC;
    signal led_bajar_pe_o_tb       : STD_LOGIC;
    signal led_reset_pe_o_tb       : STD_LOGIC;
    signal leds_rgb_pe_o_tb        : STD_LOGIC_VECTOR (2 downto 0);
    signal leds_duty_pe_o_tb       : STD_LOGIC_VECTOR (3 downto 0);
    signal pwm_pe_o_tb             : STD_LOGIC;


    component todo_junto is
        Port ( 
            clk_in_pe        : in STD_LOGIC;
            btn_subir_pe     : in STD_LOGIC;
            btn_bajar_pe     : in STD_LOGIC;
            btn_subir_1_pe   : in STD_LOGIC;
            btn_bajar_1_pe   : in STD_LOGIC;
            btn_reset_pe     : in STD_LOGIC;
            btn_reset_clk_pe : in STD_LOGIC;
            sw_frec_pe       : in STD_LOGIC_VECTOR (1 downto 0);
            led_subir_pe_o   : out STD_LOGIC;
            led_bajar_pe_o   : out STD_LOGIC;
            led_reset_pe_o   : out STD_LOGIC;
            leds_rgb_pe_o    : out STD_LOGIC_VECTOR (2 downto 0);
            leds_duty_pe_o   : out STD_LOGIC_VECTOR (3 downto 0);
            pwm_pe_o         : out STD_LOGIC
        );
    end component;
begin


    clk_tb <= not clk_tb after 4 ns;

    stim_proc : process
    begin
        wait until rising_edge(clk_tb);
        btn_subir_pe_tb <= '0';
        wait for 2 us;

        -- Prueba antirebote
        wait until rising_edge(clk_tb);
        btn_subir_pe_tb <= '1';
        wait for 1 ms;
        
        wait until rising_edge(clk_tb);
        btn_subir_pe_tb <= '0';
        wait for 1 ms;
        
        wait until rising_edge(clk_tb);
        btn_subir_pe_tb <= '1';
        wait for 1 ms;
        
        wait until rising_edge(clk_tb);
        btn_subir_pe_tb <= '0';
        wait for 1 ms;
        
        wait until rising_edge(clk_tb);
        btn_subir_pe_tb <= '1';
        wait for 60 ms;    
        
        wait until rising_edge(clk_tb);
        btn_subir_pe_tb <= '0';
        wait for 60 ms;
        
        -- Prueba control fino
        wait until rising_edge(clk_tb);
        btn_subir_1_pe_tb <= '1';
        wait for 60 ms;

        wait until rising_edge(clk_tb);
        btn_subir_1_pe_tb <= '0';
        wait for 60 ms;

        wait until rising_edge(clk_tb);
        btn_bajar_1_pe_tb <= '1';
        wait for 60 ms;

        wait until rising_edge(clk_tb);
        btn_bajar_1_pe_tb <= '0';
        wait for 60 ms;

        -- Prueba cambio de frecuencia
        wait until rising_edge(clk_tb);
        sw_frec_pe_tb <= "01";
        wait for 60 ms;

        wait until rising_edge(clk_tb);
        sw_frec_pe_tb <= "11";
        wait for 60 ms;

        -- Prueba reset
        wait until rising_edge(clk_tb);
        btn_reset_pe_tb <= '1';
        wait for 60 ms;

        wait;
    end process;

    DUT: todo_junto port map (
        clk_in_pe        => clk_tb,
        btn_subir_pe     => btn_subir_pe_tb,
        btn_bajar_pe     => btn_bajar_pe_tb,
        btn_subir_1_pe   => btn_subir_1_pe_tb,
        btn_bajar_1_pe   => btn_bajar_1_pe_tb,
        btn_reset_pe     => btn_reset_pe_tb,
        btn_reset_clk_pe => btn_reset_clk_pe_tb,
        sw_frec_pe       => sw_frec_pe_tb,
        led_subir_pe_o   => led_subir_pe_o_tb,
        led_bajar_pe_o   => led_bajar_pe_o_tb,
        led_reset_pe_o   => led_reset_pe_o_tb,
        leds_rgb_pe_o    => leds_rgb_pe_o_tb,
        leds_duty_pe_o   => leds_duty_pe_o_tb,
        pwm_pe_o         => pwm_pe_o_tb
    );

end;
