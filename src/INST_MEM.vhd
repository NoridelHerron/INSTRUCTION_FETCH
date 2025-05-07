----------------------------------------------------------------------------------
-- Noridel Herron
-- InstructionMemory.vhd
-- Created: [Insert today's date]
--
-- Description:
--   Standalone instruction memory module for my personal 5-stage RISC-V pipeline.
--   Stores up to 256 32-bit instructions in a simple word-addressable ROM.
--   Returns the instruction corresponding to the input PC address (word-aligned).
--
-- Design Notes:
--   - Used for simulation and testbench development.
--   - Instructions are currently hardcoded for quick testing.
--   - Future version may support file loading or external memory access.
--
-- Personal Project:
--   This is part of my custom CPU design and pipeline experiment.
--   Not intended for distribution or production use.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INST_MEM is
    Port ( addr   : in  std_logic_vector(31 downto 0);  -- input: byte address to fetch instruction
           instr  : out std_logic_vector(31 downto 0)); -- output: instruction at the given address
end INST_MEM;

architecture behavior of INST_MEM is

    type memory_array is array (0 to 255) of std_logic_vector(31 downto 0);
    -- list of instructions
    signal rom : memory_array := (
        0  => x"01498933",  -- add, x18, x19, x20
        1  => x"407312B3",  -- sra x5, x6, x7
        2  => x"0149F933",  -- and x18, x19, x20
        3  => x"0149E933",  -- or x18, x19, x20
        4  => x"0009A903",  -- lw x18, 0(x19)
        5  => x"01392023",  -- sw x19, 0(x18)
        6  => x"403151B3",  -- sra x1, x2, x3
        7  => x"0030F113",  -- andi x2, x1, 3
        8  => x"00816193",  -- ori x3, x2, 8
        9  => x"00219213",  -- slli x4, x3, 2
        10 => x"002081B3",  -- add x3, x1, x2
        11 => x"402081B3",  -- sub x3, x1, x2
        12 => x"0020C1B3",  -- xor x3, x1, x2
        13 => x"002091B3",  -- sll x3, x1, x2
        14 => x"00502023",  -- sw x5, 0(x0)
        15 => x"00002483",  -- lw x9, 0(x0)
        16 => x"003100B3",  -- add x1, x2, x3
        17 => x"4062A233",  -- slt x4, x5, x6
        18 => x"009412B3",  -- sll x5, x8, x9
        19 => x"00C5A3B3",  -- slt x7, x11, x12
        20 => x"00F6B4B3",  -- sltu x9, x13, x15
        21 => x"0128C533",  -- xor x10, x17, x18
        22 => x"015A55B3",  -- srl x11, x20, x21
        23 => x"018BC5B3",  -- xor x11, x23, x24
        24 => x"01BCE6B3",  -- or x13, x25, x27
        25 => x"01EEDF33",  -- srl x30, x29, x30
        26 => x"00500093",  -- addi x1, x0, 5
        27 => x"0030A113",  -- slti x2, x1, 3
        28 => x"0041B193",  -- sltiu x3, x3, 4
        29 => x"0071C213",  -- xori x4, x3, 7
        30 => x"00822293",  -- slti x5, x4, 8
        31 => x"00F2B313",  -- sltiu x6, x5, 15
        32 => x"00132313",  -- slti x6, x6, 1
        33 => x"00135413",  -- srli x8, x6, 1
        34 => x"40146493",  -- ori x9, x8, 1025
        35 => x"00002503",  -- lw x10, 0(x0)
        36 => x"00B02223",  -- sw x11, 4(x0)
        37 => x"41498933",  -- sub x18, x19, x20
        38 => x"416AAAB3",  -- sra x20, x21, x22
        39 => x"00500093",  -- addi x1, x0, 5
        40 => x"4013C3B3",  -- sra x7, x7, x1
        41 => x"40331293",  -- srai x5, x6, 3
        42 => x"01498933",  -- add, x18, x19, x20
        43 => x"4055A513",  -- srai x10, x11, 5
        others => x"00000013"  -- NOP (addi x0, x0, 0)
    );

begin
    -- Fetch instruction using word-aligned address (addr / 4)
    instr <= rom(to_integer(unsigned(addr(9 downto 2))));
end behavior;