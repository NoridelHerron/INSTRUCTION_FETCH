
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
library work;
use work.Noridel_function.all;

entity tb_INST_FETCH is
end tb_INST_FETCH;

architecture behavior of tb_INST_FETCH is

    -- Component under test
    component INST_FETCH
        Port ( clk, rst  : in  std_logic;   
               instr_out : out std_logic_vector(31 downto 0)); -- output instr_out- 32-bit instruction forwarded to Decode stage
    end component;

    -- Clock/reset and output signals
    signal clk, rst        : std_logic := '0';
    signal instr_out  : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

    -- Define ROM type and initialize it
    type memory_array is array(0 to 63) of std_logic_vector(31 downto 0);
    signal rom : memory_array := (
        0  => x"01498933", 1  => x"407312B3", 2  => x"0149F933", 3  => x"0149E933",
        4  => x"0009A903", 5  => x"01392023", 6  => x"403151B3", 7  => x"0030F113",
        8  => x"00816193", 9  => x"00219213", 10 => x"002081B3", 11 => x"402081B3",
        12 => x"0020C1B3", 13 => x"002091B3", 14 => x"00502023", 15 => x"00002483",
        16 => x"003100B3", 17 => x"4062A233", 18 => x"009412B3", 19 => x"00C5A3B3",
        20 => x"00F6B4B3", 21 => x"0128C533", 22 => x"015A55B3", 23 => x"018BC5B3",
        24 => x"01BCE6B3", 25 => x"01EEDF33", 26 => x"00500093", 27 => x"0030A113",
        28 => x"0041B193", 29 => x"0071C213", 30 => x"00822293", 31 => x"00F2B313",
        32 => x"00132313", 33 => x"00135413", 34 => x"40146493", 35 => x"00002503",
        36 => x"00B02223", 37 => x"41498933", 38 => x"416AAAB3", 39 => x"00500093",
        40 => x"4013C3B3", 41 => x"40331293", 42 => x"01498933", 43 => x"4055A513",
        others => x"00000013"
    );

begin

    -- Instantiate DUT
    uut: INST_FETCH port map (  clk, rst, instr_out);

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
        constant NUM_CYCLES : integer := 44;  -- Adjust based on ROM size
        -- Pass/fail counters
        variable pass_count : integer := 0;
        variable fail_count : integer := 0;
        -- Internal PC tracker (in bytes)
        variable pc : unsigned(31 downto 0) := (others => '0');
    begin
        -- Apply reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        for i in 0 to NUM_CYCLES - 1 loop
            wait until rising_edge(clk);

            -- Check expected instruction
            expected_instr := rom(to_integer(pc(31 downto 2))); -- pc/4 for word index

            if instr_out = expected_instr then
                pass_count := pass_count + 1;            
            else
                fail_count := fail_count + 1;
                report "Cycle " & integer'image(i) & ": FAIL | Got 0x" & to_hexstring(instr_out) &
                       ", expected 0x" & to_hexstring(expected_instr)
                       severity error;
            end if;

            -- Increment PC
            if rst = '1' then
                pc := (others => '0');
            else
                pc := pc + 4;
            end if;
        end loop;

        report "----------------------------------------------------";
        report "Test Summary:";   
        report "Total Passes     : " & integer'image(pass_count);
        report "Total Failures   : " & integer'image(fail_count); 
        report "----------------------------------------------------";
        wait;
    end process;

end behavior;
