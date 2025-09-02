library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Data_Memory is
    port(
        clk :       in  std_logic;
        memRead :   in  std_logic;
        memWrite :  in  std_logic;
        address :   in  STD_LOGIC_VECTOR(8 downto 0);
        writeData : in  STD_LOGIC_VECTOR(7 downto 0);
        
        readData :  out STD_LOGIC_VECTOR(7 downto 0)  
    );
end entity Data_Memory;    


architecture Behavioural of Data_Memory is
    type mem is array (511 downto 0) of std_logic_vector(7 downto 0);
    signal memory : mem := (others => (others => '0'));
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if memWrite = '1' then
                memory(to_integer(unsigned(address))) <= writeData;
            end if;                
        end if;
    end process;

    readData <= memory(to_integer(unsigned(address))) when memRead = '1' else ((others => '0'));
    
end architecture;            