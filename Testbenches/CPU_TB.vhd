library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU_TB is
end entity;

architecture sim of CPU_TB is


    component CPU
        port(
            clk : in std_logic;
            rst : in std_logic
        );
    end component;

    ----------------------------------------------------------------------
    -- Signals for CPU inputs/outputs
    ----------------------------------------------------------------------
    signal clk : std_logic := '0';  
    signal rst : std_logic := '0';

    constant clk_period : time := 10 ns; 
    signal   stop_sim   : boolean := false;

begin

    UUT : CPU
        port map(
            clk => clk,
            rst => rst
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
	

    stim_proc : process
    begin
        ------------------------------------------------------------------
        -- 1) Apply reset
        -- Keep reset high for 2 cycles to initialize CPU and registers
        ------------------------------------------------------------------
        rst <= '1';
        wait until rising_edge(clk);
        rst <= '0';

        ------------------------------------------------------------------
        -- 2) Let CPU run through instructions
        -- Adjust this delay based on how many instructions you have
        ------------------------------------------------------------------
        wait for 500 ns;

        ------------------------------------------------------------------
        -- 3) Stop simulation
        ------------------------------------------------------------------
        stop_sim <= true;

        wait;
    end process;

end architecture;
