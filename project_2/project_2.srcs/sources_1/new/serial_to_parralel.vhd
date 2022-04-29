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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.MATH_REAL.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity serial_to_parralel is
  generic(OUTPUT_BITS: integer := 12;
          FRAME_BITS : integer := 16;
          DATA_BITS  : integer := 12 );
          --DATA_VECTOR_BITS : integer := 4);
  Port (
        input, clk, rst, clk_pmod: in std_logic;
        output : out std_logic_vector(OUTPUT_BITS -1 downto 0);
        data_ready : out std_logic  );
end serial_to_parralel;

architecture Behavioral of serial_to_parralel is
    signal data_in : std_logic_vector(OUTPUT_BITS -1 downto 0);
    signal data_counter , data_counter_next : integer :=0;
       -- proces kt�ry b�dzie zasysa� dane z zewn�trz i za ka�dym 
       -- tykni�ciem zegara clk_pmod b�dzie inkrementowa� licznik danych poch�oni�tych
       -- 
       -- je�eli licznik si� nasyci, to zerujesz jego warto�� i latchujesz warto��, kt�ra znajduje si� 
       -- w data_in na wyj�cie output (tak, �eby w czasie pobierania nast�pnych danych szeregowych
       -- z inputa na wyj�ciu by�a wy�wietlana poprzednia odebrana warto��
begin

shifter_process:
process(rst,clk_pmod)
begin
    if(rst ='1') then
            data_counter <= -1;
            data_ready <= '0';
    else
        if(rising_edge(clk_pmod)) then
            
                data_ready <= '0';
                if(data_counter >= FRAME_BITS-1) then
                    data_counter <= 0;
                    output <= data_in;
                    data_ready <= '1';
                else
                    data_in <= data_in(OUTPUT_BITS -2 downto 0) & input;
                    data_counter <= data_counter + 1;
                end if;
            end if;
    end if;
end process;
    
end Behavioral;
