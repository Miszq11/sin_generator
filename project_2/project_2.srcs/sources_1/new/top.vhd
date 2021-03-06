----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2022 18:43:34
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
  generic(
    OUT_BITS : integer range 2 to 16 := 12);
  Port ( clock_reset, clock, reset, ena : in std_logic;
         pmods_clock, pmod_mosi1, pmod_mosi2: out std_logic;
         pmod_miso1, pmod_miso2 : in std_logic;
         test_output : out std_logic_vector(OUT_BITS -1 downto 0));
         -- jeszcze trzeba doda? cs, zostanie to dodane przy implementacji sprz?towej
end top;

architecture Behavioral of top is
    component clk_wiz_0 
    port(
        reset   : in std_logic;
        clk_in1 : in std_logic;
        clk_out1: out std_logic
        );
    end component;
    
    constant LUT_SIZE :integer := 256;
    constant IN_BITS :integer := 8;
    signal this_clock : std_logic;
    signal enable_mock,should_enable_sin_gen : std_logic;
    signal wave : std_logic_vector(OUT_BITS -1 downto 0);
	signal clk_out : std_logic := '0';
	signal ready_out : std_logic :='0';
	signal pmod_clk : std_logic :='0';
	signal work_done: std_logic :='0';
	signal start_shifting: std_logic := '0';
	signal received_sin_wave   : std_logic_vector(OUT_BITS -1 downto 0);
	signal ADC_data_ready      : std_logic; 
	
	signal divided_clock_state : std_logic;
	signal clock_divider_counter : integer := 0;
	constant clock_divided_by : integer := 10;
begin
    
    clock_divider_process:
    process(clock,clock_reset)
    begin
        if(clock_reset = '1') then
            clock_divider_counter <= 0;
            divided_clock_state <= '1';
        elsif(rising_edge(clock)) then
            clock_divider_counter <= clock_divider_counter+1;
            if(clock_divider_counter  >= clock_divided_by -1) then
                divided_clock_state <= not divided_clock_state;
                clock_divider_counter <= 0;
            end if;
        end if;
    end process;
    
    pmod_clk <= divided_clock_state ; 
    
   sin_gen: entity work.sin_generator 
   generic map(LUT_SIZE,OUT_BITS,IN_BITS)
   port map(clock, reset , enable_mock, wave, ready_out);
   
   SPI_MOSI_controller: entity work.parralel_to_serial
   generic map(OUT_BITS)
   port map(
    clk        => clock, -- system clock
    clk_pmod   => pmod_clk, -- clock for pmod outputing
    reset      => reset, -- sync reset
    data_in    => wave, -- data in vector
    start      => start_shifting, -- start transmitting data
    
    serial_out => pmod_mosi1, -- pmod serial output
    clk_out    => clk_out, -- clock out to pmod interface
    done       => work_done  -- signall indicating that data sending is done
   );
   
   SPI_MISO_controller: entity work.serial_to_parralel
   generic map(output_bits => OUT_BITS)
   port map(
        input => pmod_miso1,
        clk => clock, 
        rst => reset, 
        clk_pmod => pmod_clk,
        output => received_sin_wave,
        data_ready => ADC_data_ready);
   
   clock_trigger_div : entity work.one_clock_trigger
   port map(            
        trg_clk => clock,
        trigger => work_done,
        reset   => reset,
        out_trigger => should_enable_sin_gen,
        not_out_trg => start_shifting);
    
    enable_mock <= ena and should_enable_sin_gen;
    --pmods_clock <= pmod_clk;
    pmod_mosi2 <= '0';
    
    dummy_device_clock: clk_wiz_0
    port map(
        reset => clock_reset,
        clk_in1 => clock, 
        clk_out1 => this_clock );
    test_output <= received_sin_wave;
end Behavioral;
