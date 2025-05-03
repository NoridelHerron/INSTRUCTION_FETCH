----------------------------------------------------------------------------------
-- Noridel Herron
-- For testing Instruction Fetch (IF) Stage
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use ieee.math_real.all;

-- Declare the customized package (reusable function)
library work;
use work.reusable_function.all;

entity tb_INST_FETCH is
end tb_INST_FETCH;

architecture behavior of tb_INST_FETCH is

    -- Component declaration
    component INST_FETCH
        Port (
            clk        : in  std_logic;
            rst        : in  std_logic;
            instr_in   : in  std_logic_vector(31 downto 0);
            pc_out     : out std_logic_vector(31 downto 0);
            instr_out  : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signals
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal instr_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal pc_out    : std_logic_vector(31 downto 0);
    signal instr_out : std_logic_vector(31 downto 0);

    -- this is changeble..
    -- increase the value to slow down the simulation, good for debugging
    -- once done debugging, lower the value to speed up the simulation time
    constant CLK_PERIOD : time := 10 ns; 

begin

    -- Instantiate UUT
    uut: INST_FETCH
        port map ( clk, rst, instr_in, pc_out, instr_out);

    -- Clock process
    clk_process : process
    begin
        while now < 400 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc : process
        variable seed1, seed2 : positive := 42;
        variable rand_real    : real;
        variable rand_int     : integer;
        variable expected_pc  : unsigned(31 downto 0) := (others => '0');
    begin
        -- Initial reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        for i in 0 to 20 loop
            -- Randomize instruction input
            uniform(seed1, seed2, rand_real);
            rand_int := integer(rand_real * 2.0**31);  -- stays within 32-bit signed integer
            instr_in <= std_logic_vector(to_unsigned(rand_int, 32));

            -- Occasionally assert reset
            if i = 10 or i = 17 then
                rst <= '1';
            else
                rst <= '0';
            end if;

            wait for CLK_PERIOD;

            -- Expected PC logic
            if rst = '1' then
                expected_pc := (others => '0');
            else
                expected_pc := expected_pc + 4;
            end if;

            -- PC check with hex display
            assert pc_out = std_logic_vector(expected_pc)
            report "PC MISMATCH at cycle " & integer'image(i) &
                   " | Expected: 0x" & to_hexstring(std_logic_vector(expected_pc)) &
                   " | Got: 0x" & to_hexstring(pc_out)
            severity error;

            -- Instruction passthrough check
            assert instr_out = instr_in
            report "INSTR MISMATCH at cycle " & integer'image(i) &
                   " | Expected: 0x" & to_hexstring(instr_in) &
                   " | Got: 0x" & to_hexstring(instr_out)
            severity error;
        end loop;

        assert false report "Randomized testbench completed successfully." severity note;
        wait;
    end process;

end behavior;
