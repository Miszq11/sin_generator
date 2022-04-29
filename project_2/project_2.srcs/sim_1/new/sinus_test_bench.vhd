----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2022 22:03:30
-- Design Name: 
-- Module Name: sinus_test_bench - Behavioral
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

entity sinus_test_bench is
end sinus_test_bench;

architecture Behavioral of sinus_test_bench is
    signal clock_reset, clock, reset, ena : std_logic := '0';
    signal pmods_clock, pmod_mosi1, pmod_mosi2: std_logic := '0';
    signal pmod_miso1, pmod_miso2 : std_logic := '0';
    signal test_output : std_logic_vector(12 -1 downto 0) := (others => '0');
    constant clock_time : time := 10 ns;
begin
    UUT: entity work.top
    generic map(OUT_BITS => 12)
    port map(
        clock_reset => clock_reset,
        clock => clock, 
        reset => reset,
        ena => ena,
        pmods_clock => pmods_clock,
        pmod_mosi1 => pmod_mosi1, 
        pmod_mosi2 => pmod_mosi2,
        pmod_miso1 => pmod_miso1,
        pmod_miso2 => pmod_miso2,
        test_output => test_output);
    
   clock_reset <= '1','0' after 3*clock_time;
   clock    <= '1' after clock_time when clock ='0' else
            '0' after clock_time when clock ='1';
   reset <= '1','0' after 420*clock_time, '1' after 1000*clock_time, '0' after 1420*clock_time;
   pmod_miso1 <= pmod_mosi1;
   ena <= '0','1' after 5*clock_time;
   
end Behavioral;
