----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.09.2026 19:54:56
-- Design Name: 
-- Module Name: control_inputs - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_inputs is
    Port ( btn_subir : in STD_LOGIC;
           btn_bajar : in STD_LOGIC;
           btn_reset_duty : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (0 downto 0));
end control_inputs;

architecture Behavioral of control_inputs is

begin


end Behavioral;
