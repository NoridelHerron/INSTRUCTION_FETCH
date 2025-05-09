----------------------------------------------------------------------------------
-- Noridel Herron
-- Test_bench for IF_STAGE.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

library work;
use work.reusable_function.all; -- Customize function

-- no port needed
entity tb_INST_FETCH is
end tb_INST_FETCH;

architecture behavior of tb_INST_FETCH is

    -- Component under test
    component INST_FETCH
        Port (
            clk        : in  std_logic;   
            rst        : in  std_logic;
            instr_out  : out std_logic_vector(31 downto 0);
            pc_out     : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Clock/reset and output signals
    signal clk, rst       : std_logic := '0';
    signal instr_out      : std_logic_vector(31 downto 0);
    signal pc_out         : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

    -- Define ROM type and initialize it
    type memory_array is array(0 to 63) of std_logic_vector(31 downto 0);
    signal rom : memory_array := (
        0  => x"01498913", 
        1  => x"005A0A13",  
        2  => x"002DAB13",  
        3  => x"009DAB93",  
        4  => x"0009AD83",  
        5  => x"015A4CB3",  
        others => x"00000013"  -- NOP
    );

begin

    -- Instantiate DUT
    uut: INST_FETCH port map ( clk, rst, instr_out, pc_out);

    -- Clock process
    clk_process : process
    begin
        while now < 500 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus and verification process
    stim_proc : process
        variable expected_instr : std_logic_vector(31 downto 0);
        constant NUM_CYCLES : integer := 6; 
        -- keep track pass/fail for debugging purpose
        variable pass_count : integer := 0;
        variable fail_count : integer := 0;
    begin
        -- Apply reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        for i in 0 to NUM_CYCLES - 1 loop
            wait until rising_edge(clk);

            -- Get instruction from ROM using DUT PC output
            expected_instr := rom(to_integer(unsigned(pc_out(31 downto 2)))); -- word address

            if instr_out = expected_instr then
                pass_count := pass_count + 1;            
            else
                fail_count := fail_count + 1;
                report "Cycle " & integer'image(i) & ": FAIL | PC = 0x" & to_hexstring(pc_out) &
                       " | Got 0x" & to_hexstring(instr_out) &
                       ", expected 0x" & to_hexstring(expected_instr)
                       severity error;
            end if;
        end loop;

        -- Test summary
        report "----------------------------------------------------";
        report "Test Summary:";   
        report "Total Passes     : " & integer'image(pass_count);
        report "Total Failures   : " & integer'image(fail_count); 
        report "----------------------------------------------------";
        wait;
    end process;

end behavior;
