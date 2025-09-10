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
        -- If Instruction_Memory.vhd file changes,these comments MAY NO LONGER MATCH
        
        -- Addr 0-1: I-type ADDI R0, R0, #0
        address <= "000000000"; wait for 10 ns;

        -- Addr 2-3: I-type ADDI R1, R0, #1
        address <= "000000010"; wait for 10 ns;

        -- Addr 4-5: I-type ADDI R2, R0, #2
        address <= "000000100"; wait for 10 ns;

        -- Addr 6-7: I-type ADDI R3, R0, #3
        address <= "000000110"; wait for 10 ns;

        -- Addr 8-9: I-type ADDI R4, R0, #4
        address <= "000001000"; wait for 10 ns;

        -- Addr 10-11: I-type ADDI R5, R0, #5
        address <= "000001010"; wait for 10 ns;

        -- Addr 12-13: I-type ADDI R6, R0, #6
        address <= "000001100"; wait for 10 ns;

        -- Addr 14-15: I-type ADDI R7, R0, #7
        address <= "000001110"; wait for 10 ns;

        -- Addr 16-17: D-type ST R1, R0, #0
        address <= "000010000"; wait for 10 ns;

        -- Addr 18-19: SHR R2, R3 (R2 = R3 >> 1)
        address <= "000010010"; wait for 10 ns;

        -- Addr 20-21: SHL R3, R4 (R3 = R4 << 1)
        address <= "000010100"; wait for 10 ns;

        -- Addr 22-23: SHL R5, R3 (R5 = R3 << 1)
        address <= "000010110"; wait for 10 ns;

        -- Addr 24-25: R-type SUB R5, R2, R3
        address <= "000011000"; wait for 10 ns;

        -- Addr 28-29: D-type ST R4, R0, #1
        address <= "000011100"; wait for 10 ns;

        -- Addr 30-31: D-type LD R3, R0, #1
        address <= "000011110"; wait for 10 ns;

        -- Addr 32-33: MOV R7, R1 (R7 = R1)
        address <= "000100000"; wait for 10 ns;

        -- Addr 34-35: BNZ R0, 3
        address <= "000100010"; wait for 10 ns;

        -- Addr 36-37: MOV R0, R7 (R0 = R7)
        address <= "000100100"; wait for 10 ns;

        -- Addr 38-39: BNZ R0, -2
        address <= "000100110"; wait for 10 ns;

        -- Addr 44-45: INC R7, R0 (R7 = R7 + 1)
        address <= "000101100"; wait for 10 ns;

        -- Addr 46-47: Special HALT instruction
        address <= "000101110"; wait for 10 ns;
        
        wait;
    end process;    

end architecture;