library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Control_Unit is
    port(
        opCode           : in  std_logic_vector(3 downto 0);
        
        RegWrite         : out std_logic;
        MemRead          : out std_logic;
        MemWrite         : out std_logic;
        AluSrc           : out std_logic;
        Reg2Loc          : out std_logic;
        MemToReg         : out std_logic; 
        zeroBranchFlg    : out std_logic;
        notZeroBranchFlg : out std_logic;
        uncondBranchFlg  : out std_logic;
        AluOp            : out STD_LOGIC_VECTOR(3 downto 0)
    );
end entity Control_Unit;    


architecture Behavioral of Control_Unit is
begin
    process (OpCode)
    begin
        -- init
        RegWrite         <= '0';
        MemRead          <= '0';
        MemWrite         <= '0';
        AluSrc           <= '0';
        zeroBranchFlg    <= '0'; 
        uncondBranchFlg  <= '0'; 
        notZeroBranchFlg <= '0'; 
		Reg2Loc          <= '0';
		MemToReg         <= '0';
        AluOp            <= "0000";
			
        case OpCode is
            when "0000" => -- ADD
                RegWrite <= '1';
                AluSrc   <= '0';
                AluOp    <= "0000";

            when "0001" => -- SUB
                RegWrite <= '1';
                AluSrc   <= '0';                
                AluOp    <= "0001";

            when "0010" => -- ADDI
                RegWrite <= '1';
                AluSrc   <= '1';
                AluOp    <= "0010";

            when "0011" => -- MOV
                RegWrite <= '1';
                AluOp    <= "0011";
    
            when "0100" => -- CMP
                RegWrite <= '0';
				Reg2Loc  <= '0';
                AluOp    <= "0100";  

            when "0101" => -- XOR
				RegWrite <= '1';
                AluOp    <= "0101";
                
            when "0110" => -- AND
                RegWrite <= '1';
                AluOp    <= "0110";

            when "0111" => -- SHL
                -- Reg2Loc  <= '1';
                RegWrite <= '1';
                AluOp    <= "0111";

            when "1000" => -- SHR
                -- Reg2Loc  <= '1';
				RegWrite <= '1';
                AluOp    <= "1000";

            when "1001" => -- COM"
                RegWrite <= '0';
                Reg2Loc  <= '0';
                ALUOp    <= "1001";

            when "1010" => -- INC
                RegWrite <= '1';
                ALUOp    <= "1010";



            when "1011" => -- LD
                RegWrite <= '1';
                MemRead  <= '1';
                AluSrc   <= '1'; 	 
				MemToReg <= '1';
				AluOp    <= "1011";

            when "1100" => -- ST
                MemWrite <= '1';
                AluSrc   <= '1';	
				Reg2Loc  <= '1';
				AluOp    <= "1100";



            when "1101" => -- BR
                uncondBranchFlg <= '1';                    
                AluOp           <= "1101";

            when "1110" => -- BZ
				Reg2Loc       <= '1';
                zeroBranchFlg <= '1';
				AluOp         <= "1110";

            when "1111" => -- BNZ 
				Reg2Loc          <= '1';	
                notZeroBranchFlg <= '1';
				AluOp            <= "1111";
                    

            when others =>
                null;
        end case;

    end process;

end Behavioral;