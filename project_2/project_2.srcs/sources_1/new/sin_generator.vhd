----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.04.2022 16:47:37
-- Design Name: 
-- Module Name: sin_generator - Behavioral
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
use IEEE.math_real.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sin_generator is
generic(
        LUT_SIZE    : integer range 2 to 1024 := 256;
        OUT_BITS    : integer range 2 to 16 := 12;
        IN_BITS     : integer := 8 );
Port   (
        clock,reset,enable : in STD_LOGIC;
        wave        : out std_logic_vector(OUT_BITS-1 downto 0);
        ready       : out std_logic );
end sin_generator;

architecture Arch of sin_generator is

component sin_lut_table
    port(in_vec     : in std_logic_vector(IN_BITS-1 downto 0);
         out_vec    : out std_logic_vector(OUT_BITS-1 downto 0));
end component;

    type sin_gen_state is (counting_up, counting_down);
    signal lut_in       : std_logic_vector(IN_BITS-1 downto 0);
    signal lut_out      : std_logic_vector(OUT_BITS-1 downto 0);
    signal curr_state,next_state : sin_gen_state;
    signal sin_index    : integer := 0;
    signal ready_out    : std_logic;
begin

reset_nex_state_process:
process(clock,reset)
begin
    if reset = '1' then
        curr_state <= counting_up;
    elsif rising_edge(clock) then
        if enable = '1' then
            curr_state <= next_state;
        end if;
    end if;    
end process;

state_change_process:
process(curr_state, sin_index)
begin
    next_state <= curr_state;   -- zeroing next_state
    case curr_state is
    when counting_up =>
        if sin_index = (LUT_SIZE - 2) then
            next_state <= counting_down;
        end if;
    when counting_down =>
        if sin_index = 1 then
            next_state <= counting_up;
        end if;
    end case;
end process;

inner_counter_process:
process(clock, reset)
begin
if reset = '1' then
    sin_index <= 0;
    ready_out <= '0';
elsif rising_edge(clock) then
    ready_out <= '0';
    if enable = '1' then
        case curr_state is 
        when counting_down =>
            sin_index <= sin_index - 1;
            ready_out <= '1';
        when counting_up =>
            sin_index <= sin_index + 1;
            ready_out <= '1';
        when others => --nothing to do
        end case;
    end if;
end if;
end process;

wave_out_process:
process(sin_index)
begin
    lut_in <= std_logic_vector(to_unsigned(sin_index,IN_BITS));
end process;
-- output and input assignments

sin_lut : sin_lut_table
port map(in_vec => lut_in , out_vec => lut_out); 
wave <= lut_out;
ready <= ready_out;

end Arch;
