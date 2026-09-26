----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.09.2026 20:10:45
-- Design Name: 
-- Module Name: control_pwm - Behavioral
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

entity control_pwm is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           duty : in unsigned (6 downto 0);
           --duty_subir : in STD_LOGIC;
           --duty_bajar : in STD_LOGIC;
           sel_frec : in STD_LOGIC_VECTOR (1 downto 0);
           
           -- Salida 
           pwm_out : out STD_LOGIC);
end control_pwm;

architecture Behavioral of control_pwm is
    signal count_periodo            : unsigned(18 downto 0);
    signal count_paso               : unsigned(18 downto 0);
    -- El count de on, al multiplicar dos vectores; tengo que hacerlo el doble de bits que la suma de los tamaño    
    signal count_mult_on            : unsigned(37 downto 0)     := to_unsigned(0, 38);
    signal count_on                 : unsigned(18 downto 0)     := to_unsigned(0, 19);
    signal contador_aux             : unsigned(18 downto 0)     := to_unsigned(0, 19);
    -- constantes para el maximo de periodo
    constant count_periodo_1_k_Hz   : unsigned(18 downto 0) := to_unsigned(10000, 19);
    constant count_periodo_10_k_Hz  : unsigned(18 downto 0) := to_unsigned(1000, 19);
    constant count_periodo_100_k_Hz : unsigned(18 downto 0) := to_unsigned(100, 19);
    constant count_periodo_1_M_Hz   : unsigned(18 downto 0) := to_unsigned(10, 19);
    -- constantes para el calculo de duty on
    constant count_paso_1_k_Hz      : unsigned(18 downto 0) := to_unsigned(1000, 19);
    constant count_paso_10_k_Hz     : unsigned(18 downto 0) := to_unsigned(100, 19);
    constant count_paso_100_k_Hz    : unsigned(18 downto 0) := to_unsigned(10, 19);
    constant count_paso_1_M_Hz      : unsigned(18 downto 0) := to_unsigned(1, 19);  

begin

    process(sel_frec)   -- process para control de frecuencia
    begin
        case sel_frec is
            when "11"   =>
                count_periodo <= count_periodo_1_M_Hz;
                count_paso <= count_paso_1_M_Hz;  
            when "10"   =>
                count_periodo <= count_periodo_100_k_Hz;
                count_paso <= count_paso_100_k_Hz;   
            when "01"   =>
                count_periodo <= count_periodo_10_k_Hz;
                count_paso <= count_paso_10_k_Hz;   
            when others =>
                count_periodo <= count_periodo_1_k_Hz;
                count_paso <= count_paso_1_k_Hz;   
        end case;
            
    end process;
    
    process(duty)   -- process para control de duty on
    begin
        count_mult_on <= count_paso * duty;           
        count_on <=  count_mult_on(18 downto 0);
    end process;
    
    process(clk)    -- process con el clock de 10 MHz
    begin
        if rising_edge(clk) then
            if reset = '1' then
                contador_aux <= to_unsigned(0, 19);
                pwm_out <= '0';
            else
                -- Control de periodo
                if contador_aux < (count_periodo - 1) then
                    contador_aux <= contador_aux + 1;
                else
                    contador_aux <= to_unsigned(0, 19);
                end if;
                
                -- Control de periodo
                if contador_aux < count_on then
                    pwm_out <= '1';
                else
                    pwm_out <= '0';
                end if;   
              
            end if;
            
            
        
        end if;
    end process;
    

end Behavioral;

