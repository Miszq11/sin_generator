----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.04.2022 00:08:08
-- Design Name: 
-- Module Name: def_sim - Behavioral
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
use IEEE.std_logic_unsigned.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity def_sim is
    generic(
        OUT_BITS : integer range 2 to 16 := 12);
--  Port ( );
end def_sim;

architecture Behavioral of def_sim is
    constant LUT_SIZE :integer := 256;
    constant IN_BITS :integer := 8;
    signal reset, clock, ena: std_logic := '0';
    signal wave : std_logic_vector(OUT_BITS -1 downto 0);
	signal clk_out : std_logic := '0';
	signal pmod_DA_in : std_logic :='0';
	signal ready_out : std_logic :='0';
	signal pmod_clk : std_logic :='0';
	signal work_done: std_logic :='0';
	signal start_shifting: std_logic := '0';
begin
   UUT: entity work.sin_generator 
   generic map(LUT_SIZE,OUT_BITS,IN_BITS)
   port map(clock, reset , ena, wave, ready_out);
   
   UUT2: entity work.parralel_to_serial
   generic map(OUT_BITS)
   port map(
    clk        => clock, -- system clock
    clk_pmod   => pmod_clk, -- clock for pmod outputing
    reset      => reset, -- sync reset
    data_in    => wave, -- data in vector
    start      => start_shifting, -- start transmitting data
    
    serial_out => pmod_DA_in, -- pmod serial output
    clk_out    => clk_out, -- clock out to pmod interface
    done       => work_done  -- signall indicating that data sending is done
   );
   clock_trigger_div : entity work.one_clock_trigger
   port map(            
        trg_clk => clock,
        trigger => work_done,
        reset   => reset,
        out_trigger => ena,
        not_out_trg => start_shifting);
   
reset <= '1','0' after 200ps;
clock    <= '1' after 100 ps when clock ='0' else
            '0' after 100 ps when clock ='1';
pmod_clk <= '1' after 1200 ps when pmod_clk ='0' else
            '0' after 1200 ps when pmod_clk ='1';
ena <= '0';
--ena <=   '1' after 2300 ps when ena ='0' else
--         '0' after 100 ps when ena ='1';

end Behavioral;
