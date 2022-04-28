----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2022 18:45:21
-- Design Name: 
-- Module Name: serial_to_parralel - Behavioral
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

entity serial_to_parralel is
  generic(output_bits: integer := 12;
          frame_bits : integer := 16);
  Port (
        input, clk, rst, clk_pmod: std_logic;
        output : std_logic_vector(output_bits -1 downto 0);
        data_ready : std_logic;  );
end serial_to_parralel;

architecture Behavioral of serial_to_parralel is
    signal data_in : std_logic_vector(output_bits -1 downto 0);
       -- proces kt�ry b�dzie zasysa� dane z zewn�trz i za ka�dym 
       -- tykni�ciem zegara clk_pmod b�dzie inkrementowa� licznik danych poch�oni�tych
       -- 
       -- je�eli licznik si� nasyci, to zerujesz jego warto�� i latchujesz warto��, kt�ra znajduje si� 
       -- w data_in na wyj�cie output (tak, �eby w czasie pobierania nast�pnych danych szeregowych
       -- z inputa na wyj�ciu by�a wy�wietlana poprzednia odebrana warto��
begin


end Behavioral;
