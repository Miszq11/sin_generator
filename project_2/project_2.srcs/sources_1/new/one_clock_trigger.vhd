----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2022 17:39:35
-- Design Name: 
-- Module Name: one_clock_trigger - Behavioral
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

entity one_clock_trigger is
    Port (
            trg_clk : in std_logic;
            trigger : in std_logic;
            reset   : in std_logic;
        out_trigger : out std_logic;
        not_out_trg : out std_logic);
end one_clock_trigger;
architecture Behavioral of one_clock_trigger is
    type state is (idle, triggered, waiting_for_trigger_fall);
    signal current_state, next_state : state;
    signal out_bit  : std_logic;
begin
state_process:
process(trg_clk, reset)
begin
    if(rising_edge(trg_clk)) then
        if(reset = '1') then
            --out_trigger     <= '0';
            current_state   <= idle;
            --out_bit         <= '0';
        else
            current_state <= next_state;
        end if;
    end if;
end process;

next_state_process:
process(trg_clk,trigger )
begin
    out_bit <= '0';
    if(current_state = idle) then
        if(trigger = '1')then
            out_bit <= '1';
            next_state <= triggered;
        end if;
    elsif (current_state = triggered) then
        out_bit <= '0';
        next_state <= waiting_for_trigger_fall;
    else
        if(trigger='0') then
            next_state <= idle;
        end if;
    end if;
end process;

out_trigger <= out_bit;
not_out_trg <= not out_bit;

end Behavioral;
