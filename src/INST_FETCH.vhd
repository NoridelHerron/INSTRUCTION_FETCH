----------------------------------------------------------------------------------
-- Noridel Herron
-- Basic Instruction Fetch (IF) Stage
-- No branch, flush, or stall handling
-- PC increments by 4 each cycle
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INST_FETCH is
    Port ( clk        : in  std_logic;                      -- input Clock signal
           rst        : in  std_logic;                      -- input Active-high reset signal
           instr_in   : in  std_logic_vector(31 downto 0);  -- input 32-bits instruction from instruction memory
           pc_out     : out std_logic_vector(31 downto 0);  -- output 32-bits program counter sent to instruction memory
           instr_out  : out std_logic_vector(31 downto 0)); -- output instr_out- 32-bit instruction forwarded to Decode stage
end INST_FETCH;

architecture behavior of INST_FETCH is

    -- Internal signal for program counter (PC)
    signal pc : std_logic_vector(31 downto 0) := (others => '0');

begin
    process(clk)
    begin
        -- PC update process: triggered on rising edge of clock
        if rising_edge(clk) then
            if rst = '1' then
                pc <= (others => '0');
            else
                -- increment PC by 4 (next instruction)
                pc <= std_logic_vector(unsigned(pc) + 4);
            end if;
        end if;
    end process;

    -- Output assignments
    pc_out    <= pc;         -- Send current PC to instruction memory
    instr_out <= instr_in;   -- Pass fetched instruction to ID stage

end behavior;
