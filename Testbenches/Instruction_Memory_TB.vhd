library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instruction_Memory_TB is
end entity Instruction_Memory_TB;

architecture sim of Instruction_Memory_TB is

    component Instruction_Memory is
    Port (
        address    : in  std_logic_vector(8 downto 0);  -- Byte-addressed PC
        instr_out  : out std_logic_vector(15 downto 0)  -- Full 16-bit instruction
    );
    end component Instruction_Memory;

    signal address    : std_logic_vector(8 downto 0);  -- Byte-addressed PC
    signal instr_out  : std_logic_vector(15 downto 0);    

begin

    UUT : Instruction_Memory
        port map(
            address   => address,
            instr_out => instr_out
        );

    stim_proc : process
    begin
        
        -- Instructions shown here are based on current contents of Instruction_Memory.vhd
        -- If that file changes, comments may not match anymore
        
        -- Addr 0-1: I-type ADDI R0, R0, #0
        address <= "000000000";
        wait for 10 ns;

        -- Addr 2-3: I-type ADDI R1, R0, #1
        address <= "000000010";
        wait for 10 ns;

        -- Addr 4-5: I-type ADDI R2, R0, #2
        address <= "000000100";  -- 4
        wait for 10 ns;

        -- Addr 6-7: I-type ADDI R3, R0, #3
        address <= "000000110";  -- 6
        wait for 10 ns;

        -- Addr 8-9: I-type ADDI R4, R0, #4
        address <= "000001000";  -- 8
        wait for 10 ns;

        -- Addr 10-11: I-type ADDI R5, R0, #5
        address <= "000001010";  -- 10
        wait for 10 ns;

        -- Addr 12-13: I-type ADDI R6, R0, #6
        address <= "000001100";  -- 12
        wait for 10 ns;

        -- Addr 14-15: I-type ADDI R7, R0, #7
        address <= "000001110";  -- 14
        wait for 10 ns;

        -- Addr 16-17: I-type ST R1, R0, #0
        address <= "000010000";  -- 16
        wait for 10 ns;

        -- Addr 18-19: I-type ST R1, R0, #1
        address <= "000010010";  -- 18
        wait for 10 ns;

        -- Addr 20-21: I-type ST R2, R1, #0
        address <= "000010100";  -- 20
        wait for 10 ns;

        -- Addr 22-23: I-type ST R3, R2, #0
        address <= "000010110";  -- 22
        wait for 10 ns;

        -- Addr 24-25: I-type ST R4, R3, #0
        address <= "000011000";  -- 24
        wait for 10 ns;

        -- Addr 26-27: I-type ST R1, R0, #1 (duplicate from ROM definition)
        address <= "000011010";  -- 26
        wait for 10 ns;
        
        wait;
    end process;    

end architecture;