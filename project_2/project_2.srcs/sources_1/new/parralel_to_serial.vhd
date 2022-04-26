----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2022 18:45:57
-- Design Name: DA2 CONTROLLER
-- Module Name: parralel_to_serial - Behavioral
-- Project Name: DA2 CONTROLLER - PUF PROJECT
-- Target Devices: ZYBO7000
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

entity parralel_to_serial is
    generic( OUT_BITS : integer := 12);
    Port (
      clk       : in std_logic; -- system clock
      clk_pmod  : in std_logic; -- clock for pmod outputing
      reset     : in std_logic; -- sync reset
      data_in   : in std_logic_vector(OUT_BITS-1 downto 0); -- data in vector
      start     : in std_logic; -- start transmitting data
      
      serial_out: out std_logic; -- pmod serial output
      clk_out   : out std_logic; -- clock out to pmod interface
      done      : out std_logic -- signall indicating that data sending is done
     );
end parralel_to_serial;

architecture Behavioral of parralel_to_serial is
    type state is (idle, shiftOut, report_done);
    signal curr_state   : state;
    signal next_state   : state;
    
    signal data_shift   : std_logic_vector(OUT_BITS-1 downto 0);
    signal proceed_shift: std_logic;
    signal data_counter : integer := 0;
    signal data_load    : std_logic;
    constant max_out_counter : integer := OUT_BITS;
begin

current_state_reset_process:
    process(reset,clk,clk_pmod)
    begin
    if(rising_edge(clk_pmod)) then
        if(reset = '1') then
            curr_state <= idle;
            data_shift <= ( others =>'0' );
        else
            curr_state <= next_state;
        end if;
    end if;
    end process;

output_signals_handler:
process(curr_state, clk_pmod)
begin
    done <= '0';
    if curr_state = idle then
        data_counter <= 0;
        data_load <= '1';
        proceed_shift <= '0';
    elsif curr_state = report_done then
        done <= '1';
        data_load <= '1';
        proceed_shift <= '0';
    else
        if(rising_edge(clk_pmod)) then
            data_counter <= data_counter + 1;
        end if;
        proceed_shift <= '1';
        data_load <= '0';
    end if;
end process;

data_load_process:
process(data_load, clk)
begin
    if(rising_edge(clk)) then
        if(data_load ='1') then
            data_shift <= data_in;
        end if;
    end if;
end process;
next_state_process:
process(curr_state, start, data_counter)
begin
    case (curr_state) is
        when idle =>
            if(start = '1') then
                next_state <= shiftOut;
            end if;
        when shiftOut =>
            if(data_counter = max_out_counter - 1) then
                next_state <= report_done;
            end if;
        when others =>
            next_state <= idle;
    end case;
end process;

serial_data_process:
process(clk_pmod)
begin
    if(rising_edge(clk_pmod)) then
        if(proceed_shift ='1') then
            data_shift <= data_shift(OUT_BITS-2 downto 0)&'0';
        end if;
    end if;
end process;
    serial_out <= data_shift(OUT_BITS-1);
    clk_out <= clk_pmod;

end Behavioral;
