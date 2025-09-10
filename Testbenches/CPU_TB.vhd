library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU_TB is
end entity;

architecture sim of CPU_TB is


    component CPU
        port(
        clk             : in std_logic;
        rst             : in std_logic;
        instruction_out : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;


    signal clk : std_logic := '0';  
    signal rst : std_logic := '0';
    signal instruction_out : STD_LOGIC_VECTOR(15 downto 0);

    constant clk_period : time := 10 ns; 
    signal   stop_sim   : boolean := false;

begin

    UUT : CPU
        port map(
            clk => clk,
            rst => rst,
            instruction_out => instruction_out
        );

    
    clock_process : process 
    begin
        while not stop_sim loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;    
	
    -- CPU will run the Instruction in Instruction Memory        
    stim_proc : process
    procedure wait_clocks(signal clk : in std_logic; N : natural) is
    begin
        for i in 1 to N loop
            wait until rising_edge(clk);
        end loop;
    end procedure;

    begin
        rst <= '1';
        wait_clocks(clk, 2);
        rst <= '0';

        

        loop
            wait until rising_edge(clk); 
           if rst = '0' and instruction_out(15 downto 12) = "1111" 
                        and instruction_out(7 downto 0)  = "00000000" then
                stop_sim <= true;
                exit;
            end if; 
        end loop;

        wait;
    end process;

end architecture;
