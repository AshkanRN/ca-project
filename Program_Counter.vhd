library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Program_Counter is
    port(
        clk       : in std_logic;
        rst       : in std_logic;
        branchFlg : in std_logic;
        offset    : in SIGNED(7 downto 0);

        PC        : out integer range 0 to 511
    );

end entity Program_Counter;

architecture Behavioural of Program_Counter is
    signal PC_next : integer range 0 to 511 := 0;
begin
    process(clk, rst)
    
    begin
        if rst = '1' then
           PC_next <= 0;
           
        elsif rising_edge(clk) then
            if branchFlg = '1' then
                PC_next <= PC_next + (2 * to_integer((offset)));
            else
                PC_next <= PC_next + 2;   
            end if;        
        end if; 

     end process;
     
     PC <= PC_next;           
                
end architecture;           