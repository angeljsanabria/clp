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
            btn_duty_subir : in STD_LOGIC;
            btn_duty_bajar : in STD_LOGIC;
            btn_duty_reset : in STD_LOGIC;
            sw_sel_frec     : in STD_LOGIC_VECTOR (1 downto 0);
            -- Salidas fisicas
            leds_rgb        : out STD_LOGIC_VECTOR (2 downto 0);
            -- Salidas logicas
            sel_frec        : out STD_LOGIC_VECTOR (1 downto 0);
            duty_subir      : out STD_LOGIC := '0';
            duty_bajar      : out STD_LOGIC := '0';
            duty_reset      : out STD_LOGIC := '0';
            duty_pwm        : out unsigned(7 downto 0)
    );
end secure_inputs;

architecture Behavioral of secure_inputs is
    -- Solo constantes de color
    constant color_azul     : STD_LOGIC_VECTOR (2 downto 0) := "001";
    constant color_verde    : STD_LOGIC_VECTOR (2 downto 0) := "010";
    constant color_amarillo : STD_LOGIC_VECTOR (2 downto 0) := "110";
    constant color_rojo     : STD_LOGIC_VECTOR (2 downto 0) := "100";
    signal sel_color        : STD_LOGIC_VECTOR (1 downto 0) := "00";
    -- Signals para aplicar meta harden
    signal sel_frec_mh      : STD_LOGIC_VECTOR (1 downto 0);
    signal duty_subir_mh    : STD_LOGIC := '0';
    signal duty_bajar_mh    : STD_LOGIC := '0';
    signal duty_reset_mh    : STD_LOGIC := '0';
    signal duty_subir_mh_2  : STD_LOGIC := '0';
    signal duty_bajar_mh_2  : STD_LOGIC := '0';
    signal duty_reset_mh_2  : STD_LOGIC := '0';
    -- contador para rebote en funcion de los 10 MHz de clock -> 30 ms es 300000 ticks de clock
    signal rebote       : unsigned(18 downto 0) := to_unsigned(0, 19);  -- Conversion function/type casting
    constant set_rebote : unsigned(18 downto 0) := to_unsigned(300000, 19);
    -- control de duty
    constant paso_duty  : unsigned(7 downto 0) := to_unsigned(10, 8);
    signal duty         : unsigned(7 downto 0) := to_unsigned(50, 8);
    
   
begin
    
    -- Leds RGB dependiendo de switchs
    leds_rgb <= color_rojo      when (sel_color ="11") else 
                color_amarillo  when (sel_color ="10") else
                color_verde     when (sel_color ="01") else
                color_azul;    
    -- Fin Leds RGB
    
    process(clk)    -- process con el clock de 10 MHz
    begin
        if rising_edge(clk) then
            -- etapas de meta harden para sincronismo
            duty_subir_mh <= btn_duty_subir;
            duty_subir_mh_2 <= duty_subir_mh;
            
            duty_bajar_mh <= btn_duty_bajar;
            duty_bajar_mh_2 <= duty_bajar_mh;
            
            duty_reset_mh <= btn_duty_reset;
            duty_reset_mh_2 <= duty_reset_mh;
            
            sel_frec_mh <= sw_sel_frec;
            sel_frec <= sel_frec_mh;
            sel_color <= sel_frec_mh;
            -- fin etapas mh
            
            
            duty_pwm <= duty;
            -- Si presiono subir; arranco el anti rebote y espero a que termine para bajar la signal
            if duty_subir_mh_2 = '1' and rebote = 0 then
                 if duty < 100 then
                    duty <= duty + paso_duty;
                  end if;
                duty_subir <= '1';
                rebote <= set_rebote;
            elsif duty_subir_mh_2 = '0' and rebote = 0 then
                duty_subir <= '0';
            end if;
            
            -- Si presiono bajar; arranco el anti rebote y espero a que termine para bajar la signal
            if duty_bajar_mh_2 = '1' and rebote = 0 then
                 if duty > 0 then
                    duty <= duty - paso_duty;
                 end if;
                duty_bajar <= '1';
                rebote <= set_rebote;
            elsif duty_bajar_mh_2 = '0' and rebote = 0 then
                duty_bajar <= '0';
            end if;  
            
            -- Si presiono resetjar; arranco el anti rebote y espero a que termine para bajar la signal
            if duty_reset_mh_2 = '1' and rebote = 0 then
                duty <= to_unsigned(50, 8);
                duty_reset <= '1';
                rebote <= set_rebote;
            elsif duty_reset_mh_2 = '0' and rebote = 0 then
                duty_reset <= '0';
            end if;  
            
            -- Control del tiempo de rebote
            if rebote > 0 then
                rebote <= rebote - 1;
            end if;
            
            
        end if;
    end process; -- clk
    -- 

end Behavioral;
