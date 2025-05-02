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
    Port (
    clk        : in  std_logic;
    rst        : in  std_logic;
    instr_in   : in  std_logic_vector(31 downto 0);  -- From IMEM
    pc_out     : out std_logic_vector(31 downto 0);  -- To IMEM
    instr_out  : out std_logic_vector(31 downto 0)   -- To ID stage
    );
end INST_FETCH;

architecture behavior of INST_FETCH is

    signal pc : std_logic_vector(31 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                pc <= (others => '0');
            else
                pc <= std_logic_vector(unsigned(pc) + 4);
            end if;
        end if;
    end process;

    pc_out    <= pc;         -- Send PC to memory
    instr_out <= instr_in;   -- Pass fetched instruction to ID stage

end behavior;
