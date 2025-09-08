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

-- I-type and B-type and D-type:
--   opCode: [15:12]  
--   rd:     [11:9]  
--   rs1:    [8:6]  
--   imm:    [7:0]
            

entity Instruction_Memory is
    Port (
        address    : in  std_logic_vector(8 downto 0);  
        
        instr_out  : out std_logic_vector(15 downto 0)  
    );
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is
    type byte_memory is array(0 to 511) of std_logic_vector(7 downto 0); -- 512 bytes

    signal rom : byte_memory := (
    

        -- 0: I-type ADDI R0, R0, #0 
        -- opcode=0010, rd=000, rs1=000, imm=00000000
        0  => "00100000", 
        1  => "00000000",
        
        -- 1: I-type ADDI R1, R0, #1 
        -- opcode=0010, rd=001, rs1=000, imm=00000001
        2  => "00100010", 
        3  => "00000001",
        
        -- 2: I-type ADDI R2, R0, #2 
        -- opcode=0010, rd=010, rs1=000, imm=00000010
        4  => "00100100",
        5  => "00000010", 
        
        -- 3: I-type ADDI R3, R0, #3 
        -- opcode=0010, rd=011, rs1=000, imm=00000011
        6  => "00100110",
        7  => "00000011", 
        
        -- 4: I-type ADDI R4, R0, #4 
        -- opcode=0010, rd=100, rs1=000, imm=00000100
        8  => "00101000", 
        9  => "00000100", 
        
        -- 5: I-type ADDI R5, R0, #5 
        -- opcode=0010, rd=101, rs1=000, imm=00000101
        10 => "00101010", 
        11 => "00000101", 
        
        -- 6: I-type ADDI R6, R0, #6 
        -- opcode=0010, rd=110, rs1=000, imm=00000110
        12 => "00101100", 
        13 => "00000110", 
        
        -- 7: I-type ADDI R7, R0, #7 
        -- opcode=0010, rd=111, rs1=000, imm=00000111
        14 => "00101110", 
        15 => "00000111", 


        -- 8: I-type ST R1, R0, #0
        -- opcode=1100, rd=001, rs1=000, imm=00000000
        16  => "11000010", 
        17  => "00000000",


        -- 9: I-type SHR R2, R3 
        -- opcode=1000, rd=010, rs1=011
        18 => "10000100",
        19 => "11000000", 


        -- 10: I-type SHL R3, R4
        -- opcode=0111, rd=111, rs1=100
        20 => "01110111", 
        21 => "00000000",


        -- 11: I-type SHL R5, R3
        -- opcode=0111, rd=101, rs1=011
        22 => "01111010", 
        23 => "11000000",
        

        -- -- 12: B-type BNZ R4, #4
        -- -- opcode=1111, rd=100, rs1=000, imm=00000100
        -- 24  => "11111000", 
        -- 25  => "00000100",


        -- 13: B-type SUB R5, R2, R3   
        -- opcode=0001, rd=101, rs1=010, rs2=001
        26  => "00011010", 
        27  => "10011000", 

        -- 14: MOV R6, R3
        -- opcode=0011, rd=110, rs1=011
        28 => "00111100",
        29 => "11000000", 

        -- 15: BZ R0, 5
        -- opCode = 1110, rd=000 imm=00000101
        30 => "11100000",
        31 => "00000101",


        -- -- 16: INC R7, R0
        -- -- opcode=1010, rd=111, rs1=000, rs2=000
        -- 32  => "10101110", 
        -- 33  => "00000000",
        

        -- -- 17: D-type LD R4, R0, #0 (Store: R4 = MEM[R0 + 0] )
        -- -- opcode=1011, rd=100, rs1=000, imm=00000000
        -- 34  => "10111000", 
        -- 35  => "00000000", 


        -- -- 18: B-type BZ, R0, #10 
        -- -- opcode=1110, rd=000, rs1=000, imm=00001010
        -- 36  => "11100000", 
        -- 37  => "00000100", 


        -- -- 19: B-type BR #10 
        -- -- opcode=1101, rd=000, rs1=000, imm=00001010
        -- 38  => "11010000", 
        -- 39  => "00001010",


        -- -- 20: CMP R5, R4
        -- -- opcode=0100, rd=101, rs1=100, rs2=000
        -- 40  => "01001011",
        -- 41  => "00000000",

        -- -- 21: I-type ST R1, R0, #1
        -- -- opcode=1100, rd=001, rs1=000, imm=00000001
        -- 42  => "11000010",
        -- 43  => "00000001",

         
        -- -- 22: I-type LD R2, R0, #1 
        -- -- opcode=1011, rd=010 , rs1=000, imm=00000001
        -- 44  => "10110100",
        -- 45  => "00000001",







        
        -- -- 10: I-type ST R2, R1, #0 (Store: MEM[R1 + 0] = R2)
        -- -- opcode=1100, rd=010, rs1=000, imm=0000000
        -- 20  => "11000100", 
        -- 21  => "01000000",



        -- -- 11: I-type ST R3, R2, #0 (Store: MEM[R2 + 0] = R3)
        -- -- opcode=1100, rd=011, rs1=000, imm=00000000
        -- 22  => "11000110", 
        -- 23  => "10000000", 

        -- -- 12: I-type ST R4, R3, #0 (Store: MEM[R3 + 0] = R4)
        -- -- opcode=1100, rd=100, rs1=000, imm=00000000
        -- 24  => "11001000", 
        -- 25  => "11000000",


        -- -- 13: I-type ST R1, R0, #1 (Store: MEM[R3 + 1] = R5)
        -- -- opcode=1100, rd=100, rs1=000, imm=00000000
        -- 26  => "11000010",
        -- 27  => "00000001",



        -- -- 14: I-type LD R6, R0, #12 (Store: R6 = MEM[R0 + 12] )
        -- -- opcode=1011, rd=110 , rs1=000, imm=00001100
        -- 28  => "10111100",
        -- 29  => "00001100", 

        -- -- 15: I-type LD R7, R4, #5 (Store: R7 = MEM[R3 + 5])
        -- -- opcode=1011, rd=111, rs1=100, imm=00000101
        -- 30  => "10111110",
        -- 31  => "00000101", 

    

        -- Fill rest with NOPs (all zeros)
        others => (others => '0')
    );
begin

    -- Combine two consecutive bytes into one 16-bit instruction
    instr_out <= rom(to_integer(unsigned(address))) & rom(to_integer(unsigned(address) + 1));

end Behavioral;