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
            clk            : in STD_LOGIC;
            btn_duty_10_subir : in STD_LOGIC;
            btn_duty_10_bajar : in STD_LOGIC;
            btn_duty_1_subir : in STD_LOGIC;
            btn_duty_1_bajar : in STD_LOGIC;
            btn_duty_reset : in STD_LOGIC;
            sw_sel_frec     : in STD_LOGIC_VECTOR (1 downto 0);
            -- Salidas fisicas
            leds_rgb        : out STD_LOGIC_VECTOR (2 downto 0);
            led_subir      : out STD_LOGIC := '0';
            led_bajar      : out STD_LOGIC := '0';
            led_reset      : out STD_LOGIC := '0';
            -- Salidas logicas
            sel_frec        : out STD_LOGIC_VECTOR (1 downto 0);
            duty_10_subir      : out STD_LOGIC := '0';
            duty_10_bajar      : out STD_LOGIC := '0';
            duty_1_subir      : out STD_LOGIC := '0';
            duty_1_bajar      : out STD_LOGIC := '0';
            duty_reset      : out STD_LOGIC := '0';
            duty_10_pwm        : out unsigned(3 downto 0);
            duty_1_pwm         : out unsigned(3 downto 0)
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
    signal led_subir_s      : STD_LOGIC := '0';
    signal led_bajar_s      : STD_LOGIC := '0';
    signal led_reset_s      : STD_LOGIC := '0';
    -- Signals para aplicar meta harden
    signal sel_frec_mh      : STD_LOGIC_VECTOR (1 downto 0);
    signal duty_10_subir_mh    : STD_LOGIC := '0';
    signal duty_10_bajar_mh    : STD_LOGIC := '0';
    signal duty_1_subir_mh    : STD_LOGIC := '0';
    signal duty_1_bajar_mh    : STD_LOGIC := '0';
    signal duty_reset_mh    : STD_LOGIC := '0';
    signal duty_10_subir_mh_2  : STD_LOGIC := '0';
    signal duty_10_bajar_mh_2  : STD_LOGIC := '0';
    signal duty_1_subir_mh_2  : STD_LOGIC := '0';
    signal duty_1_bajar_mh_2  : STD_LOGIC := '0';
    signal duty_reset_mh_2  : STD_LOGIC := '0';
    -- contador para rebote en funcion de los 10 MHz de clock -> 30 ms es 300000 ticks de clock -> lo subi a 300 ms
    signal rebote       : unsigned(24 downto 0) := to_unsigned(0, 25);  -- Conversion function/type casting
    constant set_rebote : unsigned(24 downto 0) := to_unsigned(30000000, 25);
    -- control de duty paso 10 - hasta 100
    constant paso_10_duty  : unsigned(3 downto 0) := to_unsigned(1, 4);
    signal duty         : unsigned(3 downto 0) := to_unsigned(5, 4);
    -- control de duty fino: 0 a 9 
    constant paso_1_duty   : unsigned(3 downto 0) := to_unsigned(1, 4);
    signal duty_1       : unsigned(3 downto 0) := to_unsigned(0, 4);
    
   
begin
    
    -- Leds RGB dependiendo de switchs
    leds_rgb <= color_rojo      when (sel_color ="11") else 
                color_amarillo  when (sel_color ="10") else
                color_verde     when (sel_color ="01") else
                color_azul;    
    -- leds botones
    led_subir <= led_subir_s;
    led_bajar <= led_bajar_s;
    led_reset <= led_reset_s;
    -- Fin Leds RGB y leds botones
    
    process(clk)    -- process con el clock de 10 MHz
    begin
        if rising_edge(clk) then
            -- etapas de meta harden para sincronismo
            duty_10_subir_mh <= btn_duty_10_subir;
            duty_10_subir_mh_2 <= duty_10_subir_mh;
            
            duty_1_subir_mh <= btn_duty_1_subir;
            duty_1_subir_mh_2 <= duty_1_subir_mh;

            duty_10_bajar_mh <= btn_duty_10_bajar;
            duty_10_bajar_mh_2 <= duty_10_bajar_mh;
            
            duty_1_bajar_mh <= btn_duty_1_bajar;
            duty_1_bajar_mh_2 <= duty_1_bajar_mh;

            duty_reset_mh <= btn_duty_reset;
            duty_reset_mh_2 <= duty_reset_mh;
            
            sel_frec_mh <= sw_sel_frec;
            sel_frec <= sel_frec_mh;
            sel_color <= sel_frec_mh;
            -- fin etapas mh
            
            
            duty_10_pwm <= duty;
            duty_1_pwm <= duty_1;
            -- Si presiono subir; arranco el anti rebote y espero a que termine para bajar la signal
            if duty_10_subir_mh_2 = '1' and rebote = 0 then
                 if duty < 10 then
                    duty <= duty + paso_10_duty;
                    if duty = 9 then
                        duty_1 <= to_unsigned(0, 4);
                    end if;
                  end if;
                duty_10_subir <= '1';
                led_subir_s <= '1';    
                rebote <= set_rebote;
            elsif duty_10_subir_mh_2 = '0' and rebote = 0 then
                duty_10_subir <= '0';
                led_subir_s <= '0';
            end if;
            
            -- Si presiono bajar; arranco el anti rebote y espero a que termine para bajar la signal
            if duty_10_bajar_mh_2 = '1' and rebote = 0 then
                 if duty > 0 then
                    duty <= duty - paso_10_duty;
                 end if;
                duty_10_bajar <= '1';
                led_bajar_s <= '1';
                rebote <= set_rebote;
            elsif duty_10_bajar_mh_2 = '0' and rebote = 0 then
                duty_10_bajar <= '0';
                led_bajar_s <= '0';
            end if;  
            
            -- Si presiono subir 1%; arranco el anti rebote y espero a que termine para bajar la signal
            if duty_1_subir_mh_2 = '1' and rebote = 0 then
                 if duty_1 < 9 and duty < 10 then
                    duty_1 <= duty_1 + paso_1_duty;
                 end if;
                duty_1_subir <= '1';
                led_subir_s <= '1';
                rebote <= set_rebote;
            elsif duty_1_subir_mh_2 = '0' and rebote = 0 then
                duty_1_subir <= '0';
            end if;
            
            -- Si presiono bajar 1%; arranco el anti rebote y espero a que termine para bajar la signal
            if duty_1_bajar_mh_2 = '1' and rebote = 0 then
                 if duty_1 > 0 then
                    duty_1 <= duty_1 - paso_1_duty;
                 end if;
                duty_1_bajar <= '1';
                led_bajar_s <= '1';
                rebote <= set_rebote;
            elsif duty_1_bajar_mh_2 = '0' and rebote = 0 then
                duty_1_bajar <= '0';
            end if;
            
            -- Si presiono resetjar; arranco el anti rebote y espero a que termine para bajar la signal
            if duty_reset_mh_2 = '1' and rebote = 0 then
                duty <= to_unsigned(5, 4);
                duty_1 <= to_unsigned(0, 4);
                duty_reset <= '1';
                led_reset_s <= '1';
                rebote <= set_rebote;
            elsif duty_reset_mh_2 = '0' and rebote = 0 then
                duty_reset <= '0';
                led_reset_s <= '0';
            end if;  
            
            -- Control del tiempo de rebote
            if rebote > 0 then
                rebote <= rebote - 1;
            end if;
            
            
        end if;
    end process; -- clk
    -- 

end Behavioral;
