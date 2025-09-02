library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register_Files_TB is
end entity Register_Files_TB;

architecture sim of Register_Files_TB is

    component Register_files is
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
    end component Register_files;

    signal clk          : STD_LOGIC;
    signal rst          : STD_LOGIC;
    signal writeControl : STD_LOGIC;
    signal readReg1     : STD_LOGIC_VECTOR(2 downto 0); 
    signal readReg2     : STD_LOGIC_VECTOR(2 downto 0); 
    signal writeReg     : STD_LOGIC_VECTOR(2 downto 0);
    signal writeData    : STD_LOGIC_VECTOR(7 downto 0);
    signal readData1    : STD_LOGIC_VECTOR(7 downto 0);
    signal readData2    : STD_LOGIC_VECTOR(7 downto 0);

    constant clk_period : time := 10 ns;
    signal stop_sim : boolean := false;

begin

    UUT : Register_Files
        port map(
            clk           => clk,     
            rst           => rst,
            writeControl  => writeControl,   
            readReg1      => readReg1,  
            readReg2      => readReg2,   
            writeReg      => writeReg,  
            writeData     => writeData, 
            readData1     => readData1, 
            readData2     => readData2 
        );

    clk_process : process
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
        -- 1. Apply reset
        rst <= '1';
        writeControl <= '0';
        readReg1 <= "000";
        readReg2 <= "001";
        wait for clk_period * 2;
        rst <= '0';
        wait until rising_edge(clk);

        -- 2. Write to register 2
        writeReg <= "010";         -- R2
        writeData <= "10101010";  
        writeControl <= '1';
        wait until rising_edge(clk);    
        writeControl <= '0';
        wait until rising_edge(clk);

        -- Read back from R2
        readReg1 <= "010";
        wait until rising_edge(clk);

        -- 3. Write to R3
        writeReg <= "011";
        writeData <= "01010101";   
        writeControl <= '1';
        wait until rising_edge(clk);
        writeControl <= '0';

        
        readReg1 <= "010"; -- R2
        readReg2 <= "011"; -- R3
        wait until rising_edge(clk);

        -- 4. Write with disable writeControl
        writeReg <= "010";
        writeData <= "11111111"; 
        -- writeControl <= '0';      
        wait until rising_edge(clk);
        readReg1 <= "010";         -- Should still show 10101010
        wait until rising_edge(clk);

        -- 5. Overwrite test
        writeReg <= "010";
        writeData <= "00001111";   
        writeControl <= '1';

        wait until rising_edge(clk);
        
        writeControl <= '0';
        readReg1 <= "010";         -- Should now show 00001111

        wait until rising_edge(clk);

        -- End simulation
        stop_sim <= true;
        wait;
        
    end process;


end architecture;
