library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Register_files is
    port(
        clk          : in  STD_LOGIC;
        rst          : in  STD_LOGIC;
        writeControl : in  STD_LOGIC;
        readReg1     : in  STD_LOGIC_VECTOR(2 downto 0); 
        readReg2     : in  STD_LOGIC_VECTOR(2 downto 0); 
        writeReg     : in  STD_LOGIC_VECTOR(2 downto 0);
        writeData    : in  STD_LOGIC_VECTOR(7 downto 0);
        
        readData1    : out STD_LOGIC_VECTOR(7 downto 0);
        readData2    : out STD_LOGIC_VECTOR(7 downto 0)
        );
        -- The outputs readData1 and readData2 always show the current contents of the registers selected
        -- by readReg1 and readReg2 immediately and combinationally.
end entity Register_files;    

architecture Behavioural of Register_files is
        type regArray is array (0 to 7) of std_logic_vector(7 downto 0);
        signal registers : regArray := (others => (others => '0'));
        -- signal registers : regArray := (
        --     0 => x"01",  -- R0 = 1
        --     1 => x"02",  -- R1 = 2
        --     2 => x"03",  -- R2 = 3
        --     3 => x"04",  -- R3 = 4
        --     4 => x"05",  -- R4 = 5
        --     5 => x"06",  -- R5 = 6
        --     6 => x"07",  -- R6 = 7
        --     7 => x"08"   -- R7 = 8
        --     );
    begin

        readData1 <= registers(to_integer(unsigned(readReg1)));
        readData2 <= registers(to_integer(unsigned(readReg2)));

        process(clk, rst)
        begin
            if rst = '1' then
                registers <= (others => (others => '0'));
                -- registers <= (
                --     0 => x"01",  -- R0 = 1
                --     1 => x"02",  -- R1 = 2
                --     2 => x"03",  -- R2 = 3
                --     3 => x"04",  -- R3 = 4
                --     4 => x"05",  -- R4 = 5
                --     5 => x"06",  -- R5 = 6
                --     6 => x"07",  -- R6 = 7
                --     7 => x"08"   -- R7 = 8
                --     );
            elsif rising_edge(clk) then
                if writeControl = '1' then
                    registers(to_integer(unsigned(writeReg))) <= writeData;
                end if;
            end if;
        end process;
        
end architecture;    
