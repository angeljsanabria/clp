----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.09.2026 19:57:27
-- Design Name: 
-- Module Name: secure_inputs - Behavioral
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
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity secure_inputs is
    Port ( 
            clk                 : in STD_LOGIC;
            btn_duty_10_subir   : in STD_LOGIC;
            btn_duty_10_bajar   : in STD_LOGIC;
            btn_duty_1_subir    : in STD_LOGIC;
            btn_duty_1_bajar    : in STD_LOGIC;
            btn_duty_reset      : in STD_LOGIC;
            sw_sel_frec         : in STD_LOGIC_VECTOR (1 downto 0);
            -- Salidas fisicas
            leds_rgb            : out STD_LOGIC_VECTOR (2 downto 0);
            led_subir           : out STD_LOGIC := '0';
            led_bajar           : out STD_LOGIC := '0';
            led_reset           : out STD_LOGIC := '0';
            -- Salidas logicas
            sel_frec            : out STD_LOGIC_VECTOR (1 downto 0);
            duty_10_subir       : out STD_LOGIC := '0';
            duty_10_bajar       : out STD_LOGIC := '0';
            duty_1_subir        : out STD_LOGIC := '0';
            duty_1_bajar        : out STD_LOGIC := '0';
            duty_reset          : out STD_LOGIC := '0';
            duty_10_pwm         : out unsigned(3 downto 0);
            duty_1_pwm          : out unsigned(3 downto 0)
    );
end secure_inputs;

architecture Behavioral of secure_inputs is
    -- Solo constantes de color
    constant color_azul     : STD_LOGIC_VECTOR (2 downto 0) := "001";
    constant color_verde    : STD_LOGIC_VECTOR (2 downto 0) := "010";
    constant color_amarillo : STD_LOGIC_VECTOR (2 downto 0) := "110";
    constant color_rojo     : STD_LOGIC_VECTOR (2 downto 0) := "100";
    -- Signals para leds
    signal sel_color        : STD_LOGIC_VECTOR (1 downto 0) := "00";
    signal led_subir_duty_10      : STD_LOGIC := '0';
    signal led_bajar_duty_10      : STD_LOGIC := '0';
    signal led_subir_duty_1       : STD_LOGIC := '0';
    signal led_bajar_duty_1       : STD_LOGIC := '0';
    signal led_reset_s      : STD_LOGIC := '0';
    -- Signals para aplicar meta harden
    signal sel_frec_mh      : STD_LOGIC_VECTOR (1 downto 0);
    
    signal duty_10_subir_aux    : STD_LOGIC := '0';
    signal duty_10_bajar_aux    : STD_LOGIC := '0';
    signal duty_1_subir_aux     : STD_LOGIC := '0';
    signal duty_1_bajar_aux     : STD_LOGIC := '0';
    signal duty_reset_aux       : STD_LOGIC := '0';
    signal sel_frec_aux         : STD_LOGIC_VECTOR (1 downto 0) := "00";

    -- control de duty paso 10 - hasta 100
    constant paso_10_duty  : unsigned(3 downto 0) := to_unsigned(1, 4);
    signal duty         : unsigned(3 downto 0) := to_unsigned(5, 4);
    -- control de duty fino: 0 a 9 
    constant paso_1_duty   : unsigned(3 downto 0) := to_unsigned(1, 4);
    signal duty_1       : unsigned(3 downto 0) := to_unsigned(0, 4);
    
    component button_input is
        port(
            clk_i: 	in std_logic;	-- Destination clock
            signal_i: in std_logic;	-- Button value to be detected
            pulse_o: out std_logic := '0';	-- Pulse signal when button is pressed
            signal_o: out std_logic := '0'	-- Debounced signal
        );
    end component;

    component switch_input is
        port(
            clk_i:  	in std_logic;	-- Destination clock
            signal_i: in std_logic;	-- Switch value to be detected
            signal_o: out std_logic := '0'	-- Debounced switch value
        );
    end component;

begin
    
    -- Leds RGB dependiendo de switchs
    leds_rgb <= color_rojo      when (sel_color ="11") else 
                color_amarillo  when (sel_color ="10") else
                color_verde     when (sel_color ="01") else
                color_azul;    
    -- leds botones
    led_subir <= led_subir_duty_10 or led_subir_duty_1;
    led_bajar <= led_bajar_duty_10 or led_bajar_duty_1;
    led_reset <= led_reset_s;
    -- Fin Leds RGB y leds botones
    
    duty_10_subir_inst : button_input
        port map(
            clk_i => clk,
            signal_i => btn_duty_10_subir,
            pulse_o => duty_10_subir_aux,
            signal_o => led_subir_duty_10
        );

    duty_10_bajar_inst : button_input
        port map(
            clk_i => clk,
            signal_i => btn_duty_10_bajar,
            pulse_o => duty_10_bajar_aux,
            signal_o => led_bajar_duty_10
        );

    duty_1_subir_inst : button_input
        port map(
            clk_i => clk,
            signal_i => btn_duty_1_subir,
            pulse_o => duty_1_subir_aux,
            signal_o => led_subir_duty_1
        );

    duty_1_bajar_inst : button_input
        port map(
            clk_i => clk,
            signal_i => btn_duty_1_bajar,
            pulse_o => duty_1_bajar_aux,
            signal_o => led_bajar_duty_1
        );

    duty_reset_inst : button_input
        port map(
            clk_i => clk,
            signal_i => btn_duty_reset,
            pulse_o => duty_reset_aux,
            signal_o => led_reset_s
        );

    sel_frec_inst_1 : switch_input
        port map(
            clk_i => clk,
            signal_i => sw_sel_frec(0),
            signal_o => sel_frec_aux(0)
        );

    sel_frec_inst_2 : switch_input
        port map(
            clk_i => clk,
            signal_i => sw_sel_frec(1),
            signal_o => sel_frec_aux(1)
        );
    

    process(clk)    -- process con el clock de 10 MHz
    begin
        if rising_edge(clk) then
            
            duty_10_subir <= duty_10_subir_aux;
            duty_10_bajar <= duty_10_bajar_aux;
            duty_1_subir <= duty_1_subir_aux;
            duty_1_bajar <= duty_1_bajar_aux;
            duty_reset <= duty_reset_aux;
            sel_frec <= sel_frec_aux;    
            
            duty_10_pwm <= duty;
            duty_1_pwm <= duty_1;

            -- Si presiono subir; arranco el anti rebote y espero a que termine para bajar la signal
            if duty_10_subir_aux = '1' then
                if duty < 10 then
                    duty <= duty + paso_10_duty;
                    if duty = 9 then
                        duty_1 <= to_unsigned(0, 4);
                    end if;
                end if;
            end if;

            -- Si presiono bajar; arranco el anti rebote y espero a que termine para bajar la signal
            if duty_10_bajar_aux = '1' then
                 if duty > 0 then
                    duty <= duty - paso_10_duty;
                end if;
            end if;
            
            -- Si presiono subir 1%; arranco el anti rebote y espero a que termine para bajar la signal
            if duty_1_subir_aux = '1' then
                if duty_1 < 9 and duty < 10 then
                    duty_1 <= duty_1 + paso_1_duty;
                end if;
            end if;
            
            -- Si presiono bajar 1%; arranco el anti rebote y espero a que termine para bajar la signal
            if duty_1_bajar_aux = '1' then
                 if duty_1 > 0 then
                    duty_1 <= duty_1 - paso_1_duty;
                 end if;
            end if;
            
            -- Si presiono resetjar; arranco el anti rebote y espero a que termine para bajar la signal
            if duty_reset_aux = '1' then
                duty <= to_unsigned(5, 4);
                duty_1 <= to_unsigned(0, 4);
            end if;  
            
        end if;
    end process; -- clk
    -- 

end Behavioral;
