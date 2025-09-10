library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- instruction Format:

-- R-type:
--   opCode:                      [15:12]  
--   Rd (Destination Register):   [11:9]  
--   Rn (First Source Register):  [8:6]  
--   Rm (Second Source Register): [5:3]
--   Unused:                      [2:0]

-- D-type:
--   opCode:                           [15:12]  
--   Rt (source/destination register): [11:9]  
--   Rn (base register):               [8:6]  
--   Address:                          [7:0]

-- I-type:
--   opCode:                    [15:12]  
--   Rd (destination register): [11:9]  
--   Rn (source register):      [8:6]  
--   immediate:                 [7:0]

-- B-type (BR):
--   opCode:    [15:12]  
--   immediate: [7:0] 
--   unused:    [11:8]


-- CB-type (BNZ and BZ):
--   opCode:               [15:12]  
--   Rt (source register): [11:9]
--   immediate:            [7:0] 




entity Instruction_Memory is
    Port (
        address    : in  std_logic_vector(8 downto 0);  
        
        instr_out  : out std_logic_vector(15 downto 0)  
    );
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is
    type byte_memory is array(0 to 511) of std_logic_vector(7 downto 0); -- 512 bytes

    signal rom : byte_memory := (
    
        -- inializing the Ri with i (R0 = 0, ... , R7 = 7)

        -- 1: I-type ADDI R0, R0, #0 
        -- opcode=0010, rd=000, rs1=000, imm=00000000
        0  => "00100000", 
        1  => "00000000",
        
        -- 2: I-type ADDI R1, R0, #1 
        -- opcode=0010, rd=001, rs1=000, imm=00000001
        2  => "00100010", 
        3  => "00000001",
        
        -- 3: I-type ADDI R2, R0, #2 
        -- opcode=0010, rd=010, rs1=000, imm=00000010
        4  => "00100100",
        5  => "00000010", 
        
        -- 4: I-type ADDI R3, R0, #3 
        -- opcode=0010, rd=011, rs1=000, imm=00000011
        6  => "00100110",
        7  => "00000011", 
        
        -- 5: I-type ADDI R4, R0, #4 
        -- opcode=0010, rd=100, rs1=000, imm=00000100
        8  => "00101000", 
        9  => "00000100", 
        
        -- 6: I-type ADDI R5, R0, #5 
        -- opcode=0010, rd=101, rs1=000, imm=00000101
        10 => "00101010", 
        11 => "00000101", 
        
        -- 7: I-type ADDI R6, R0, #6 
        -- opcode=0010, rd=110, rs1=000, imm=00000110
        12 => "00101100", 
        13 => "00000110", 
        
        -- 8: I-type ADDI R7, R0, #7 
        -- opcode=0010, rd=111, rs1=000, imm=00000111
        14 => "00101110", 
        15 => "00000111", 



        -- 9: D-type ST R1, R0, #0
        -- opcode=1100, rd=001, rs1=000, imm=00000000
        16  => "11000010", 
        17  => "00000000",


        -- 10: SHR R2, R3 
        -- opcode=1000, rd=010, rs1=011
        18 => "10000100",
        19 => "11000000", 


        -- 11: SHL R3, R4
        -- opcode=0111, rd=111, rs1=100
        20 => "01110111", 
        21 => "00000000",


        -- 12: SHL R5, R3
        -- opcode=0111, rd=101, rs1=011
        22 => "01111010", 
        23 => "11000000",
        

        -- 13: R-type SUB R5, R2, R3   
        -- opcode=0001, rd=101, rs1=010, rs2=001
        24  => "00011010", 
        25  => "10011000", 

        
        -- 14: D-type ST R4, R0, #1
        -- opcode=1100, rd=100, rs1=000, imm=00000001
        28  => "11001000",
        29  => "00000001",


        -- 15: D-type LD R3, R0, #1
        -- opcode=1011, rd=011, rs1=000, imm=00000001
        30  => "10110110", 
        31  => "00000001", 


        -- 16: MOV R7, R1
        -- opcode=0011, rd=111, rs1=001
        32 => "00111110",
        33 => "01000000",

        -- 17: BNZ R0, 3
        -- opCode = 1111, rd=000 imm=00000101
        34 => "11110000",
        35 => "00000101",

        -- 18: MOV R0, R7
        -- opcode=0011, rd=000, rs1=111
        36 => "00110001",
        37 => "11000000", 


        -- 19: BNZ R0 ,-2
        -- opcode=1110, rd=011, rs1=000, imm=11111110 (-2)
        38  => "11110000", 
        39  => "11111110",


        -- 20: INC R7, R0
        -- opcode=1010, rd=111, rs1=000, rs2=000
        44  => "10101110", 
        45  => "00000000",
        





        -- Special HALT instruction for stop simulation:
        -- Format = 1111 XXXX 00000000
        -- (BNZ with zero immediate). Normally meaningless, 
        -- but reserved here to indicate end of program / stop simulation.
        46  => "11110000", 
        47  => "00000000",

    

        -- Fill rest with "00000000_00000000"
        others => (others => '0')
    );
begin

    -- Combine two consecutive bytes into one 16-bit instruction
    instr_out <= rom(to_integer(unsigned(address))) & rom(to_integer(unsigned(address) + 1));

end Behavioral;