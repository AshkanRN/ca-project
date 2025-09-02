library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Program_Counter_TB is
end entity Program_Counter_TB;

architecture sim of Program_counter_TB is

    component Program_Counter is
        port(
            clk       : in std_logic;
            rst       : in std_logic;
            branchFlg : in std_logic;
            offset    : in SIGNED(7 downto 0);

            PC        : out integer range 0 to 511
        );

    end component Program_Counter;

    signal clk       : std_logic;
    signal rst       : std_logic;
    signal branchFlg : std_logic;
    signal offset    : signed(7 downto 0);

    signal PC        : integer range 0 to 511;

    signal stop_sim : boolean := false;
    constant clk_period : time := 10 ns;

begin

    UUT : Program_Counter
        port map(
            clk       => clk,
            rst       => rst,
            branchFlg => branchFlg,
            offset    => offset,

            PC        => PC
        );

    clock_procces : process
    begin
        while not stop_sim loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        
        wait;
    end process;
    
    
    stim_proc : process 
    begin
        
        -- Test 1: Reset PC
        rst <= '1';  
        branchFlg <= '0';
        offset <= (to_signed(0, 8)); -- binary init

        wait for clk_period;

        rst <= '0';
        
        wait until rising_edge(clk);

        
        -- Test 2: Normal increments
        wait until rising_edge(clk);

        wait until rising_edge(clk);

        wait until rising_edge(clk);
        
        
        -- Test 3: Branch forward (offset = 4 => jump 8 bytes)
        branchFlg <= '1';
        offset <= (to_signed(4, 8));

        wait until rising_edge(clk);

        branchFlg <= '0';
        offset <= (to_signed(0, 8));
        
        
        -- Test 4: UnBranch forward (offset = 2 => jump 4 bytes)
        BranchFlg <= '1';
        offset <= (to_signed(2, 8));

        wait until rising_edge(clk);

        BranchFlg <= '0';
        offset <= (to_signed(0, 8));

        
        -- Test 5: Branch backwards (offset = -3 => jump -6 bytes)
        branchFlg <= '1';
        offset <= (to_signed(-3, 8)); -- -3 in two's complement

        wait until rising_edge(clk);

        branchFlg <= '0';	    
        offset <= (to_signed(0, 8));

        
        -- End simulation
        wait for clk_period;
        stop_sim <= true;

        wait;
    end process;

end architecture;