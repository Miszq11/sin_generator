----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.04.2022 17:20:51
-- Design Name: 
-- Module Name: sin_lut_table - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sin_lut_table is
generic(OUT_BITS : integer range 2 to 16 := 12;
        IN_BITS : integer := 8 );
Port   (in_vec : in std_logic_vector(IN_BITS-1 downto 0);
        out_vec : out std_logic_vector(OUT_BITS-1 downto 0));
end sin_lut_table;

architecture arch of sin_lut_table is
type my_int_array is array (0 to 255) of integer range 0 to 255;
constant sin_lut_table_inner: my_int_array :=(
    255, 254, 254, 254, 254, 254, 254, 254, 
    254, 254, 254, 253, 253, 253, 253, 252, 
    252, 252, 251, 251, 251, 250, 250, 249, 
    249, 249, 248, 248, 247, 247, 246, 245, 
    245, 244, 244, 243, 242, 242, 241, 240, 
    239, 239, 238, 237, 236, 236, 235, 234, 
    233, 232, 231, 230, 229, 228, 228, 227, 
    226, 225, 224, 223, 221, 220, 219, 218, 
    217, 216, 215, 214, 213, 211, 210, 209, 
    208, 207, 205, 204, 203, 202, 200, 199, 
    198, 197, 195, 194, 193, 191, 190, 188, 
    187, 186, 184, 183, 182, 180, 179, 177, 
    176, 174, 173, 171, 170, 168, 167, 166, 
    164, 163, 161, 159, 158, 156, 155, 153, 
    152, 150, 149, 147, 146, 144, 143, 141, 
    139, 138, 136, 135, 133, 132, 130, 129, 
    127, 125, 124, 122, 121, 119, 118, 116, 
    115, 113, 111, 110, 108, 107, 105, 104, 
    102, 101, 99, 98, 96, 95, 93, 91, 
    90, 88, 87, 86, 84, 83, 81, 80, 
    78, 77, 75, 74, 72, 71, 70, 68, 
    67, 66, 64, 63, 61, 60, 59, 57, 
    56, 55, 54, 52, 51, 50, 49, 47, 
    46, 45, 44, 43, 41, 40, 39, 38, 
    37, 36, 35, 34, 33, 31, 30, 29, 
    28, 27, 26, 26, 25, 24, 23, 22, 
    21, 20, 19, 18, 18, 17, 16, 15, 
    15, 14, 13, 12, 12, 11, 10, 10, 
    9, 9, 8, 7, 7, 6, 6, 5, 
    5, 5, 4, 4, 3, 3, 3, 2, 
    2, 2, 1, 1, 1, 1, 0, 0, 
    0, 0, 0, 0, 0, 0, 0, 0
);
    --signal temp : std_logic_vector()
begin
    out_vec <= std_logic_vector(to_unsigned(sin_lut_table_inner(to_integer(unsigned(in_vec))),OUT_BITS));
end arch;
