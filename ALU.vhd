library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    port(
        clk             : in  std_logic;
        rst             : in  std_logic;
        A               : in  signed(7 downto 0);
        B               : in  signed(7 downto 0);
        opCode          : in  std_logic_vector(3 downto 0);

        result          : out signed(7 downto 0);
        carryFlg        : out std_logic;
        zeroFlg         : out std_logic;
        signFlg         : out std_logic
    );
end entity ALU;

architecture behavioural of ALU is
    

begin
    alu_operations: process (A, B, opCode, rst)

        variable tempResult : signed(8 downto 0);
    
    begin
        tempResult   := (others => '0');
        CarryFlg <= '0';
        ZeroFlg  <= '0';
        SignFlg  <= '0';
        
        case opCode is
            when "0000" => -- ADD R1, R2, R3 (R1 = R2 + R3)
                tempResult := resize(A, 9) + resize(B, 9);

                CarryFlg <= tempResult(8);
                SignFlg <= tempResult(7);

                if tempResult(7 downto 0) = "00000000" then
                    ZeroFlg <= '1';
                else
                    ZeroFlg  <= '0';
                end if ;

            when "0001" => -- SUB R1, R2, R3 (R1 = R2 - R3)
                tempResult := resize(A, 9) - resize(B, 9);

                CarryFlg <= tempResult(8);
                SignFlg <= tempResult(7);
                
                if tempResult(7 downto 0) = "00000000" then
                    ZeroFlg <= '1';
                else
                    ZeroFlg  <= '0';
                end if ;

            when "0010" => -- ADDI R1, xx (R1 = R1 + xx)
                tempResult := resize(A, 9) + resize(B, 9);

                CarryFlg <= tempResult(8);
                SignFlg <= tempResult(7);
                
                if tempResult(7 downto 0) = "00000000" then
                    ZeroFlg <= '1';
                else
                    ZeroFlg  <= '0';
                end if ; 
                
            when "0011" => -- MOV R1, R2 (R1 = R2)
                tempResult := '0' & A;
                

            when "0100" => -- CMP R1, R2 (R1-R2)
                tempResult := resize(A, 9) - resize(B, 9);

                CarryFlg <= tempResult(8);
                SignFlg <= tempResult(7);
                
                
                if tempResult(7 downto 0) = "00000000" then
                    ZeroFlg <= '1';
                else
                    ZeroFlg  <= '0';
                end if ;

            when "0101" => -- XOR R1, R2, R3
                tempResult := '0' & (A xor B);

                SignFlg <= tempResult(7);

                if tempResult(7 downto 0) = "00000000" then
                    ZeroFlg <= '1';
                else
                    ZeroFlg <= '0';
                end if ;

            when "0110" => -- AND R1, R2, R3
                tempResult := '0' & (A and B);

                SignFlg <= tempResult(7);

                if tempResult(7 downto 0) = "00000000" then
                    ZeroFlg <= '1';
                else
                    ZeroFlg <= '0';
                end if ;

            when "0111" => -- SHL R1, R0 (R1 = Shift R0 left 1 bit)
                tempResult := '0' & ( A(6 downto 0) & '0' );

                CarryFlg <= A(7); -- MSB goes to carry
                SignFlg <= tempResult(7);  -- Sign bit

                if tempResult(7 downto 0) = "00000000" then
                    ZeroFlg <= '1';
                else
                    ZeroFlg <= '0';
                end if ;

            when "1000" => -- SHR R1, R0 (R1 = Shift R0 right 1 bit )
                tempResult := '0' & ('0' & A(7 downto 1));
                       
                CarryFlg <= A(0); -- LSB goes to carry
                SignFlg <= tempResult(7);  -- Sign bit

                if tempResult(7 downto 0) = "00000000" then
                    ZeroFlg <= '1';
                else
                    ZeroFlg <= '0';
                end if ;   
                

            when "1001" => -- COM R1 (R1 = NOT R1)
                tempResult := resize(not A, 0);

                SignFlg <= not A(7);
                if tempResult(7 downto 0) = "00000000" then
                    ZeroFlg <= '1';
                else
                    ZeroFlg <= '0';
                end if ;


            when "1010" => -- INC R1 (R1 = R1 + 1)
                tempResult := resize(A, 9) + 1;

                CarryFlg <= tempResult(8);
                SignFlg <= tempResult(7);
                
                if tempResult(7 downto 0) = "00000000" then
                    ZeroFlg <= '1';
                else
                    ZeroFlg  <= '0';
                end if ;




            when "1011" => -- LD R1, [R2, yy]
                tempResult := resize(A, 9) + resize(B, 9);


            when "1100" => -- ST R1, [R2, yy]
                tempResult := resize(A, 9) + resize(B, 9);




            when "1101" => -- BR zz (unconditional branch)
                tempResult := (others => '0');
                
            when "1110" => -- BZ R1, zz (branch if zero)
                if B(7 downto 0) = "00000000" then
                    ZeroFlg <= '1';
                else
                    ZeroFlg <= '0';
                end if;
                tempResult := (others => '0');             
    
            when "1111" => -- BNZ R1, zz (branch if not zero)
                if B(7 downto 0) = "00000000"  then
                    ZeroFlg <= '1';
                else
                    ZeroFlg <= '0';
                end if;
                tempResult := (others => '0');  

    

            when others =>
                tempResult := (others => '0');
                
        end case;
        
        -- Output assignment
        if rst = '1' then
           result <= (others => '0') ; 
        else
            if opCode = "0100" then
                result <= (others => '0') ;
            else
                result <= tempResult(7 downto 0);   
            end if ;
        end if ;
        

        -- res <= tempResult;
    end process;


end architecture;




