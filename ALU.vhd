
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
    signal nextZeroFlg  : std_logic := '0';
    signal nextCarryFlg : std_logic := '0';
    signal nextSignFlg  : std_logic := '0';
    -- signal res          : signed(8 downto 0);
    

begin
    -- carryFlg <= '0';
    -- zeroFlg <= '0';
    -- signFlg <= '0';

    -- Flag update process (synchronous)
    flag_update: process(clk, rst)
    begin
        if rst = '1' then
            carryFlg <= '0';
            zeroFlg  <= '0';
            signFlg  <= '0';
            
        elsif rising_edge(clk) then
            -- Update flags only for arithmetic/logical operations that affect flags
            if to_integer(unsigned(opCode)) <= 10 then
                carryFlg <= nextCarryFlg;
                zeroFlg  <= nextZeroFlg;
                signFlg  <= nextSignFlg;
            end if;
        end if;
    end process;

    -- ALU operations (combinational)
    alu_operations: process (A, B, opCode, rst)

        variable tempResult : signed(8 downto 0);
    
    begin
        tempResult   := (others => '0');
        nextCarryFlg <= '0';
        nextZeroFlg  <= '0';
        nextSignFlg  <= '0';
        
        case opCode is
            when "0000" => -- ADD R1, R2, R3 (R1 = R2 + R3)
                tempResult := ('0' & A) + ('0' & B);

                nextCarryFlg <= tempResult(8);
                nextSignFlg <= tempResult(7);

                if tempResult(7 downto 0) = "00000000" then
                    nextZeroFlg <= '1';
                else
                    nextZeroFlg  <= '0';
                end if ;

            when "0001" => -- SUB R1, R2, R3 (R1 = R2 - R3)
                tempResult := ('0' & A) - ('0' & B);

                nextCarryFlg <= tempResult(8);
                nextSignFlg <= tempResult(7);
                
                if tempResult(7 downto 0) = "00000000" then
                    nextZeroFlg <= '1';
                else
                    nextZeroFlg  <= '0';
                end if ;

            when "0010" => -- ADDI R1, xx (R1 = R1 + xx)
                tempResult := ('0' & A) + ('0' & B);

                nextCarryFlg <= tempResult(8);
                nextSignFlg <= tempResult(7);
                
                if tempResult(7 downto 0) = "00000000" then
                    nextZeroFlg <= '1';
                else
                    nextZeroFlg  <= '0';
                end if ; 
                
            when "0011" => -- MOV R1, R2 (R1 = R2)
                tempResult := '0' & A;
                -- MOV doesn't affect flags

            when "0100" => -- CMP R1, R2 (R1-R2, affects flags but doesn't store result)
                tempResult := ('0' & A) - ('0' & B);

                nextCarryFlg <= tempResult(8);
                nextSignFlg <= tempResult(7);
                
                if tempResult(7 downto 0) = "00000000" then
                    nextZeroFlg <= '1';
                else
                    nextZeroFlg  <= '0';
                end if ;

            when "0101" => -- XOR R1, R2, R3
                tempResult := '0' & (A xor B);

                nextSignFlg <= tempResult(7);

                if tempResult(7 downto 0) = "00000000" then
                    nextZeroFlg <= '1';
                else
                    nextZeroFlg <= '0';
                end if ;

            when "0110" => -- AND R1, R2, R3
                tempResult := '0' & (A and B);

                nextSignFlg <= tempResult(7);

                if tempResult(7 downto 0) = "00000000" then
                    nextZeroFlg <= '1';
                else
                    nextZeroFlg <= '0';
                end if ;

            when "0111" => -- SHL R1, R0 (shift left by R0 positions)
                tempResult := '0' & ( A(6 downto 0) & '0' );

                nextCarryFlg <= A(7); -- MSB goes to carry
                nextSignFlg <= tempResult(7);  -- Sign bit

                if tempResult(7 downto 0) = "00000000" then
                    nextZeroFlg <= '1';
                else
                    nextZeroFlg <= '0';
                end if ;

            when "1000" => -- SHR R1, R0 (shift right by R0 positions)
                tempResult := '0' & ('0' & A(7 downto 1));
                       
                nextCarryFlg <= A(0); -- LSB goes to carry
                nextSignFlg <= tempResult(7);  -- Sign bit preserved

                if tempResult(7 downto 0) = "00000000" then
                    nextZeroFlg <= '1';
                else
                    nextZeroFlg <= '0';
                end if ;   
                

            when "1001" => -- COM R1 (R1 = NOT R1)
                tempResult := '0' & (not A);

                nextSignFlg <= not A(7);
                if tempResult(7 downto 0) = "00000000" then
                    nextZeroFlg <= '1';
                else
                    nextZeroFlg <= '0';
                end if ;


            when "1010" => -- INC R1 (R1 = R1 + 1)
                tempResult := ('0' & A) + 1;

                nextCarryFlg <= tempResult(8);
                nextSignFlg <= tempResult(7);
                
                if tempResult(7 downto 0) = "00000000" then
                    nextZeroFlg <= '1';
                else
                    nextZeroFlg  <= '0';
                end if ;




            when "1011" => -- LD R1, [R2, yy] (address calculation)
                -- LD doesn't affect flags, just calculates address
                tempResult := ('0' & A) + ('0' & B);

            when "1100" => -- ST R1, [R2, yy] (address calculation)
                -- ST doesn't affect flags, just calculates address
                tempResult := ('0' & A) + ('0' & B);




            when "1101" => -- BR zz (unconditional branch)
                tempResult := (others => '0');
                
            when "1110" => -- BZ R1, zz (branch if zero)
                if B(7 downto 0) = "00000000" then
                    nextZeroFlg <= '1';
                else
                    nextZeroFlg <= '0';
                end if;
                tempResult := (others => '0');             
    
            when "1111" => -- BNZ R1, zz (branch if not zero)
                if B(7 downto 0) = "00000000"  then
                    nextZeroFlg <= '1';
                else
                    nextZeroFlg <= '0';
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






-- library IEEE;
-- use IEEE.std_logic_1164.all;
-- use IEEE.numeric_std.all;

-- entity ALU is
--     port(
--         clk             : in  std_logic;
--         rst             : in  std_logic;
--         A               : in  signed(7 downto 0);
--         B               : in  signed(7 downto 0);
--         opCode          : in  std_logic_vector(3 downto 0);

--         result          : out signed(7 downto 0);
--         carryFlg        : out std_logic;
--         zeroFlg         : out std_logic;
--         signFlg         : out std_logic
--     );
-- end entity ALU;

-- architecture behavioural of ALU is
--     signal nextZeroFlg  : std_logic := '0';
--     signal nextCarryFlg : std_logic := '0';
--     signal nextSignFlg  : std_logic := '0';
--     signal res          : signed(8 downto 0);
    

-- begin
--     -- carryFlg <= '0';
--     -- zeroFlg <= '0';
--     -- signFlg <= '0';

--     -- Flag update process (synchronous)
--     flag_update: process(clk, rst)
--     begin
--         if rst = '1' then
--             carryFlg <= '0';
--             zeroFlg  <= '0';
--             signFlg  <= '0';
            
--         elsif rising_edge(clk) then
--             -- Update flags only for arithmetic/logical operations that affect flags
--             if to_integer(unsigned(opCode)) <= 10  then

-- 				nextCarryFlg <= res(8);
-- 				nextSignFlg <= res(7);

-- 				if res(7 downto 0) = "00000000" then
-- 					nextZeroFlg <= '1';	   
-- 				else
-- 					nextZeroFlg <= '0';
-- 				end if;

-- 				else 
-- 					nextCarryFlg <= nextCarryFlg;
-- 					nextSignFlg <= nextSignFlg;
-- 					nextZeroFlg <= nextZeroFlg;
-- 			end if;	

--             carryFlg <= nextCarryFlg;
--             zeroFlg  <= nextZeroFlg;
--             signFlg  <= nextSignFlg;

--             end if;
--     end process;

--     -- ALU operations (combinational)
--     alu_operations: process (A, B, opCode, rst)

--         variable tempResult : signed(8 downto 0);
    
--     begin
--         tempResult   := (others => '0');
--         nextCarryFlg <= '0';
--         nextZeroFlg  <= '0';
--         nextSignFlg  <= '0';
        
--         case opCode is
--             when "0000" => -- ADD R1, R2, R3 (R1 = R2 + R3)
--                 tempResult := ('0' & A) + ('0' & B);

--                 -- nextCarryFlg <= tempResult(8);
--                 -- nextSignFlg <= tempResult(7);
                
--                 -- if tempResult(7 downto 0) = "00000000" then
--                 --     nextZeroFlg <= '1';
--                 -- else
--                 --     nextZeroFlg  <= '0';
--                 -- end if ;

--             when "0001" => -- SUB R1, R2, R3 (R1 = R2 - R3)
--                 tempResult := ('0' & A) - ('0' & B);

--                 -- nextCarryFlg <= tempResult(8);
--                 -- nextSignFlg <= tempResult(7);
                
--                 -- if tempResult(7 downto 0) = "00000000" then
--                 --     nextZeroFlg <= '1';
--                 -- else
--                 --     nextZeroFlg  <= '0';
--                 -- end if ;

--             when "0010" => -- ADDI R1, xx (R1 = R1 + xx)
--                 tempResult := ('0' & A) + ('0' & B);

--                 -- nextCarryFlg <= tempResult(8);
--                 -- nextSignFlg <= tempResult(7);
                
--                 -- if tempResult(7 downto 0) = "00000000" then
--                 --     nextZeroFlg <= '1';
--                 -- else
--                 --     nextZeroFlg  <= '0';
--                 -- end if ; 
                
--             when "0011" => -- MOV R1, R2 (R1 = R2)
--                 tempResult := '0' & A;

--                 -- MOV doesn't affect flags

--             when "0100" => -- CMP R1, R2 (R1-R2, affects flags but doesn't store result)
--                 tempResult := ('0' & A) - ('0' & B);

--                 -- nextCarryFlg <= tempResult(8);
--                 -- nextSignFlg <= tempResult(7);
                
--                 -- if tempResult(7 downto 0) = "00000000" then
--                 --     nextZeroFlg <= '1';
--                 -- else
--                 --     nextZeroFlg  <= '0';
--                 -- end if ;

--             when "0101" => -- XOR R1, R2, R3
--                 tempResult := '0' & (A xor B);

--                 -- nextSignFlg <= tempResult(7);

--                 -- if tempResult(7 downto 0) = "00000000" then
--                 --     nextZeroFlg <= '1';
--                 -- else
--                 --     nextZeroFlg <= '0';
--                 -- end if ;

--             when "0110" => -- AND R1, R2, R3
--                 tempResult := '0' & (A and B);

--                 -- nextSignFlg <= tempResult(7);

--                 -- if tempResult(7 downto 0) = "00000000" then
--                 --     nextZeroFlg <= '1';
--                 -- else
--                 --     nextZeroFlg <= '0';
--                 -- end if ;

--             when "0111" => -- SHL R1, R0 (R1 = shift left R0)
--                 tempResult := '0' & ( A(6 downto 0) & '0' );

--                 -- nextCarryFlg <= A(7); -- MSB goes to carry
--                 -- nextSignFlg <= tempResult(7);  -- Sign bit

--                 -- if tempResult(7 downto 0) = "00000000" then
--                 --     nextZeroFlg <= '1';
--                 -- else
--                 --     nextZeroFlg <= '0';
--                 -- end if ;

--             when "1000" => -- SHR R1, R0 (R1 = shift right R0)
--                 tempResult := '0' & ('0' & A(7 downto 1));
                       
--                 -- nextCarryFlg <= A(0); -- LSB goes to carry
--                 -- nextSignFlg <= tempResult(7);  -- Sign bit preserved

--                 -- if tempResult(7 downto 0) = "00000000" then
--                 --     nextZeroFlg <= '1';
--                 -- else
--                 --     nextZeroFlg <= '0';
--                 -- end if ;   
                

--             when "1001" => -- COM R1 (R1 = NOT R1)
--                 tempResult := '0' & (not A);

--                 -- nextSignFlg <= not A(7);
--                 -- if tempResult(7 downto 0) = "00000000" then
--                 --     nextZeroFlg <= '1';
--                 -- else
--                 --     nextZeroFlg <= '0';
--                 -- end if ;


--             when "1010" => -- INC R1 (R1 = R1 + 1)
--                 tempResult := ('0' & A) + 1;

--                 -- nextCarryFlg <= tempResult(8);
--                 -- nextSignFlg <= tempResult(7);
                
--                 -- if tempResult(7 downto 0) = "00000000" then
--                 --     nextZeroFlg <= '1';
--                 -- else
--                 --     nextZeroFlg  <= '0';
--                 -- end if ;




--             when "1011" => -- LD R1, [R2, yy] (address calculation)
--                 -- LD doesn't affect flags, just calculates address
--                 tempResult := ('0' & A) + ('0' & B);

--             when "1100" => -- ST R1, [R2, yy] (address calculation)
--                 -- ST doesn't affect flags, just calculates address
--                 tempResult := ('0' & A) + ('0' & B);




--             when "1101" => -- BR zz (unconditional branch)
--                 tempResult := (others => '0');
                
--             when "1110" => -- BZ R1, zz (branch if zero)
--                 -- if B(7 downto 0) = "00000000" then
--                 --     nextZeroFlg <= '1';
--                 -- else
--                 --     nextZeroFlg <= '0';
--                 -- end if;
--                 tempResult := (others => '0');             
    
--             when "1111" => -- BNZ R1, zz (branch if not zero)
--                 -- if B(7 downto 0) = "00000000"  then
--                 --     nextZeroFlg <= '1';
--                 -- else
--                 --     nextZeroFlg <= '0';
--                 -- end if;
--                 tempResult := (others => '0');  

    

--             when others =>
--                 tempResult := (others => '0');
                
--         end case;
        
--         -- Output assignment
--         if rst = '1' then
--            result <= (others => '0') ; 
--         else
--             if opCode = "0100" then
--                 result <= (others => '0') ;
--             else
--                 result <= tempResult(7 downto 0);   
--             end if ;
--         end if ;
        

--         res <= tempResult;
--     end process;


-- end architecture;