----------------------------------------------------------------------------------
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity todo_junto is
    Port ( clk_in_pe        : in STD_LOGIC;
           btn_subir_pe     : in STD_LOGIC;
           btn_bajar_pe     : in STD_LOGIC;
           btn_subir_1_pe   : in STD_LOGIC;
           btn_bajar_1_pe   : in STD_LOGIC;
           btn_reset_pe     : in STD_LOGIC;
           btn_reset_clk_pe : in STD_LOGIC;
           -- Agrego AXI GPIO (PS -> PL); OR con botones anteriores
           -- ps_duty_10_subir : in STD_LOGIC;
           -- ps_duty_10_bajar : in STD_LOGIC;
           -- ps_duty_1_subir  : in STD_LOGIC;
           -- ps_duty_1_bajar  : in STD_LOGIC;
           -- ps_duty_reset    : in STD_LOGIC;
           -- AXI GPIO (PL -> PS): status 32 bits para lectura
           pl_to_ps_status  : out STD_LOGIC_VECTOR (31 downto 0);
           sw_frec_pe       : in STD_LOGIC_VECTOR (1 downto 0);
           led_subir_pe_o   : out STD_LOGIC;
           led_bajar_pe_o   : out STD_LOGIC;
           led_reset_pe_o   : out STD_LOGIC;
           leds_rgb_pe_o    : out STD_LOGIC_VECTOR (2 downto 0);
           leds_duty_pe_o   : out STD_LOGIC_VECTOR (3 downto 0);
           pwm_pe_o         : out STD_LOGIC);
end todo_junto;

architecture Behavioral of todo_junto is

    -- Declaro todos los componentes
    -- Bloque de Clock a 100 Mhz
    component clk_wiz_0
        port (
            clk_out1 : out STD_LOGIC;
            reset    : in  STD_LOGIC;
            clk_in1  : in  STD_LOGIC
        );
    end component;
    
    -- Bloque de entradas seguras
    component secure_inputs
        port (
            clk               : in  STD_LOGIC;
            btn_duty_10_subir : in  STD_LOGIC;
            btn_duty_10_bajar : in  STD_LOGIC;
            btn_duty_1_subir  : in  STD_LOGIC;
            btn_duty_1_bajar  : in  STD_LOGIC;
            btn_duty_reset    : in  STD_LOGIC;
            sw_sel_frec       : in  STD_LOGIC_VECTOR (1 downto 0);
            leds_rgb          : out STD_LOGIC_VECTOR (2 downto 0);
            led_subir         : out STD_LOGIC;
            led_bajar         : out STD_LOGIC;
            led_reset         : out STD_LOGIC;
            sel_frec          : out STD_LOGIC_VECTOR (1 downto 0);
            duty_10_subir     : out STD_LOGIC;
            duty_10_bajar     : out STD_LOGIC;
            duty_1_subir      : out STD_LOGIC;
            duty_1_bajar      : out STD_LOGIC;
            duty_reset        : out STD_LOGIC;
            duty_10_pwm       : out unsigned(3 downto 0);
            duty_1_pwm        : out unsigned(3 downto 0)
        );
    end component;

    -- Bloque de control de la salida PWM
    component control_pwm
        port (
            clk      : in  STD_LOGIC;
            reset    : in  STD_LOGIC;
            duty     : in  unsigned(3 downto 0);
            duty_1   : in  unsigned(3 downto 0);
            sel_frec : in  STD_LOGIC_VECTOR (1 downto 0);
            pwm_out  : out STD_LOGIC
        );
    end component;

    -- Senales internas: uniones intermedias entre bloques
    signal clk_10m      : STD_LOGIC;
    signal sel_frec_s   : STD_LOGIC_VECTOR (1 downto 0);
    signal duty_s       : unsigned(3 downto 0);
    signal duty_1_s     : unsigned(3 downto 0);
    signal duty_reset_s : STD_LOGIC;
    -- Temporal hasta AXI GPIO: ports comentados arriba; aca en '0'
    signal ps_duty_10_subir : STD_LOGIC := '0';
    signal ps_duty_10_bajar : STD_LOGIC := '0';
    signal ps_duty_1_subir  : STD_LOGIC := '0';
    signal ps_duty_1_bajar  : STD_LOGIC := '0';
    signal ps_duty_reset    : STD_LOGIC := '0';
    -- Borrar ahsta aca cuando agrege el AXI GPIO
    -- Entradas que combinan con OR el boton del hardware que era entrada PL y el gpio PS
    signal btn_10_subir_ps_pl : STD_LOGIC;
    signal btn_10_bajar_ps_pl : STD_LOGIC;
    signal btn_1_subir_ps_pl  : STD_LOGIC;
    signal btn_1_bajar_ps_pl  : STD_LOGIC;
    signal btn_reset_ps_pl    : STD_LOGIC;

begin
    --  Harcode de las señales en 0, hasta que tenga el AXI GPIO
    ps_duty_10_subir <= '0';
    ps_duty_10_bajar <= '0';
    ps_duty_1_subir  <= '0';
    ps_duty_1_bajar  <= '0';
    ps_duty_reset    <= '0';

    -- Estas son las que reemplazan btn_subir_pe; en secure_inputs
    btn_10_subir_ps_pl <= btn_subir_pe   or ps_duty_10_subir;
    btn_10_bajar_ps_pl <= btn_bajar_pe   or ps_duty_10_bajar;
    btn_1_subir_ps_pl  <= btn_subir_1_pe or ps_duty_1_subir;
    btn_1_bajar_ps_pl  <= btn_bajar_1_pe or ps_duty_1_bajar;
    btn_reset_ps_pl    <= btn_reset_pe   or ps_duty_reset;

    clock_wiz_unit : clk_wiz_0
        port map (
            clk_out1 => clk_10m,
            reset    => '0',
            clk_in1  => clk_in_pe
        );

    secure_inputs_unit : secure_inputs
        port map (
            clk               => clk_10m,
            btn_duty_10_subir => btn_10_subir_ps_pl,
            btn_duty_10_bajar => btn_10_bajar_ps_pl,
            btn_duty_1_subir  => btn_1_subir_ps_pl,
            btn_duty_1_bajar  => btn_1_bajar_ps_pl,
            btn_duty_reset    => btn_reset_ps_pl,
            sw_sel_frec       => sw_frec_pe,
            leds_rgb          => leds_rgb_pe_o,
            led_subir         => led_subir_pe_o,
            led_bajar         => led_bajar_pe_o,
            led_reset         => led_reset_pe_o,
            sel_frec          => sel_frec_s,
            duty_10_subir     => open,
            duty_10_bajar     => open,
            duty_1_subir      => open,
            duty_1_bajar      => open,
            duty_reset        => duty_reset_s,
            duty_10_pwm       => duty_s,
            duty_1_pwm        => duty_1_s
        );

    control_pwm_unit : control_pwm
        port map (
            clk      => clk_10m,
            reset    => duty_reset_s,
            duty     => duty_s,
            duty_1   => duty_1_s,
            sel_frec => sel_frec_s,
            pwm_out  => pwm_pe_o
        );

    -- Valor binario del duty (0 a 10) en LED0 a LED3
    leds_duty_pe_o <= std_logic_vector(duty_1_s);

    -- Para AXI GPIO de lectura
    -- Menos significativo [3:0]=duty_1
    -- [7:4]=duty_10
    -- mas significativo [9:8]=sel_frec
    -- relleno 0
    pl_to_ps_status(3 downto 0)   <= std_logic_vector(duty_1_s);
    pl_to_ps_status(7 downto 4)   <= std_logic_vector(duty_s);
    pl_to_ps_status(9 downto 8)   <= sel_frec_s;
    pl_to_ps_status(31 downto 10) <= (others => '0');

end Behavioral;
