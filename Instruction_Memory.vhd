library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- instruction Format:

-- R-type:
--   opCode: [15:12]  
--   rd:     [11:9]  
--   rs1:    [8:6]  
--   rs2:    [5:3]
--   [2:0] is empty

-- I-type and B-type:
--   opCode: [15:12]  
--   rd:     [11:9]  
--   rs1:    [8:6]  
--   imm:    [7:0]
            

entity Instruction_Memory is
    Port (
        address    : in  std_logic_vector(8 downto 0);  -- Byte-addressed PC
        
        instr_out  : out std_logic_vector(15 downto 0)  -- Full 16-bit instruction
    );
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is
    type byte_memory is array(0 to 511) of std_logic_vector(7 downto 0); -- 512 bytes

    signal rom : byte_memory := (
        
        -- The first 7 instructions initialize the Ri registers with the value i
        -- Example: R2 = #2
        
        -- 0: I-type ADDI R0, R0, #0 (R0 = R0 + 0 = 0, keep R0 as zero)
        -- opcode=0010, rd=000, rs1=000, imm=00000000
        0  => "00100000", -- high byte: 0010 0000 (opcode + rd + rs1)
        1  => "00000000", -- low byte: 0000 0000 (immediate = 0)
        
        -- 1: I-type ADDI R1, R0, #1 (R1 = R0 + 1 = 1)
        -- opcode=0010, rd=001, rs1=000, imm=00000001
        2  => "00100010", -- high byte: 0010 0010 (opcode + rd + rs1)
        3  => "00000001", -- low byte: 0000 0001 (immediate = 1)
        
        -- 2: I-type ADDI R2, R0, #2 (R2 = R0 + 2 = 2)
        -- opcode=0010, rd=010, rs1=000, imm=00000010
        4  => "00100100", -- high byte: 0010 0100 (opcode + rd + rs1)
        5  => "00000010", -- low byte: 0000 0010 (immediate = 2)
        
        -- 3: I-type ADDI R3, R0, #3 (R3 = R0 + 3 = 3)
        -- opcode=0010, rd=011, rs1=000, imm=00000011
        6  => "00100110", -- high byte: 0010 0110 (opcode + rd + rs1)
        7  => "00000011", -- low byte: 0000 0011 (immediate = 3)
        
        -- 4: I-type ADDI R4, R0, #4 (R4 = R0 + 4 = 4)
        -- opcode=0010, rd=100, rs1=000, imm=00000100
        8  => "00101000", -- high byte: 0010 1000 (opcode + rd + rs1)
        9  => "00000100", -- low byte: 0000 0100 (immediate = 4)
        
        -- 5: I-type ADDI R5, R0, #5 (R5 = R0 + 5 = 5)
        -- opcode=0010, rd=101, rs1=000, imm=00000101
        10 => "00101010", -- high byte: 0010 1010 (opcode + rd + rs1)
        11 => "00000101", -- low byte: 0000 0101 (immediate = 5)
        
        -- 6: I-type ADDI R6, R0, #6 (R6 = R0 + 6 = 6)
        -- opcode=0010, rd=110, rs1=000, imm=00000110
        12 => "00101100", -- high byte: 0010 1100 (opcode + rd + rs1)
        13 => "00000110", -- low byte: 0000 0110 (immediate = 6)
        
        -- 7: I-type ADDI R7, R0, #7 (R7 = R0 + 7 = 7)
        -- opcode=0010, rd=111, rs1=000, imm=00000111
        14 => "00101110", -- high byte: 0010 1110 (opcode + rd + rs1)
        15 => "00000111", -- low byte: 0000 0111 (immediate = 7)






        -- 8: I-type ST R1, R0, #0 (Store: MEM[R0 + 0] = R1)
        -- opcode=1100, rd=001, rs1=000, imm=00001100
        -- Format: [15:12]=1100, [11:9]=101, [8:6]=000, [7:0]=imm
        -- Binary: 1100 101 000 00001100
        16  => "11000010", -- high byte: [15:8] = 1100 1010 (opcode + rd + rs1)
        17  => "00000000", -- low byte: [7:0] = 0000 1100 (8-bit immediate)

        -- 9: I-type ST R1, R0, #1 (Store: MEM[R3 + 1] = R5)
        -- opcode=1100, rd=100, rs1=000, imm=00000000
        -- Format: [15:12]=1100, [11:9]=100, [8:6]=000, [7:0]=imm
        -- Binary: 1100 100 000 00000101
        18  => "11000010", -- high byte: [15:8] = 1100 1000 (opcode + rd + rs1)
        19  => "00000001", -- low byte: [7:0] = 0000 1100 (8-bit immediate)


        -- 10: I-type ST R2, R1, #0 (Store: MEM[R1 + 0] = R2)
        -- opcode=1100, rd=010, rs1=000, imm=0000000
        -- Format: [15:12]=1100, [11:9]=100, [8:6]=000, [7:0]=imm
        -- Binary: 1100 100 000 00000101
        20  => "11000100", -- high byte: [15:8] = 1100 1000 (opcode + rd + rs1)
        21  => "01000000", -- low byte: [7:0] = 0000 1100 (8-bit immediate)



        -- 11: I-type ST R3, R2, #0 (Store: MEM[R2 + 0] = R3)
        -- opcode=1100, rd=011, rs1=000, imm=00000000
        -- Format: [15:12]=1100, [11:9]=101, [8:6]=000, [7:0]=imm
        -- Binary: 1100 101 000 00001100
        22  => "11000110", -- high byte: [15:8] = 1100 1010 (opcode + rd + rs1)
        23  => "10000000", -- low byte: [7:0] = 0000 1100 (8-bit immediate)

        -- 12: I-type ST R4, R3, #0 (Store: MEM[R3 + 0] = R4)
        -- opcode=1100, rd=100, rs1=000, imm=00000000
        -- Format: [15:12]=1100, [11:9]=100, [8:6]=000, [7:0]=imm
        -- Binary: 1100 100 000 00000101
        24  => "11001000", -- high byte: [15:8] = 1100 1000 (opcode + rd + rs1)
        25  => "11000000", -- low byte: [7:0] = 0000 1100 (8-bit immediate)


        -- 13: I-type ST R1, R0, #1 (Store: MEM[R3 + 1] = R5)
        -- opcode=1100, rd=100, rs1=000, imm=00000000
        -- Format: [15:12]=1100, [11:9]=100, [8:6]=000, [7:0]=imm
        -- Binary: 1100 100 000 00000101
        26  => "11000010", -- high byte: [15:8] = 1100 1000 (opcode + rd + rs1)
        27  => "00000001", -- low byte: [7:0] = 0000 1100 (8-bit immediate)



        -- -- 14: I-type LD R6, R0, #12 (Store: R6 = MEM[R0 + 12] )
        -- -- opcode=1011, rd=110 , rs1=000, imm=00001100
        -- -- Format: [15:12]=1011, [11:9]=110, [8:6]=000, [7:0]=imm
        -- -- Binary: 1011 110 000 00001100
        -- 28  => "10111100", -- high byte: [15:8] = 1011 1100 (opcode + rd + rs1)
        -- 29  => "00001100", -- low byte: [7:0] = 0000 1100 (8-bit immediate)

        -- -- 15: I-type LD R7, R4, #5 (Store: R7 = MEM[R3 + 5])
        -- -- opcode=1011, rd=111, rs1=100, imm=00000101
        -- -- Format: [15:12]=1011, [11:9]=111, [8:6]=100, [7:0]=imm
        -- -- Binary: 1011 111 000 00000101
        -- 30  => "10111110", -- high byte: [15:8] = 1011 1110 (opcode + rd + rs1)
        -- 31  => "00000101", -- low byte: [7:0] = 0000 0101 (8-bit immediate)

    

        -- Fill rest with NOPs (all zeros)
        others => (others => '0')
    );
begin

    -- Combine two consecutive bytes into one 16-bit instruction
    instr_out <= rom(to_integer(unsigned(address))) & rom(to_integer(unsigned(address) + 1));

end Behavioral;