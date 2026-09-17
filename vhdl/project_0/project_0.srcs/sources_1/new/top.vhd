----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.09.2026 20:53:18
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description test basico:
--   led0 se enciende si sw0=1
--   led1 se enciende si sw1=1
-- Description:
--   led0 se enciende solo si sw0=1 y sw1=0
--   led1 se enciende solo si sw1=1 y sw0=0
--   si ambos switches estan en 1, ambos LEDs quedan en 0
-- Supuesto: ON del switch = '1', LED encendido = '1' 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- https://github.com/Digilent/digilent-xdc/blob/master/Arty-Z7-10-Master.xdc
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( sw0 : in STD_LOGIC;
           sw1 : in STD_LOGIC;
           led0 : out STD_LOGIC;
           led1 : out STD_LOGIC);
end top;

architecture Behavioral of top is

begin
    led0 <= sw0;
    led1 <= sw1;

end Behavioral;
