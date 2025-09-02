library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Data_Memory_TB is
end entity;

architecture sim of Data_Memory_TB is

    -- Component Declaration
    component Data_Memory
        port (
            clk       : in  std_logic;
            MemRead   : in  std_logic;
            MemWrite  : in  std_logic;
            Address   : in  std_logic_vector(8 downto 0);
            writeData : in  std_logic_vector(7 downto 0);
            readData  : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signals
    signal clk       : std_logic := '0';
    signal MemRead   : std_logic := '0';
    signal MemWrite  : std_logic := '0';
    signal Address   : std_logic_vector(8 downto 0) := (others => '0');
    signal writeData : std_logic_vector(7 downto 0) := (others => '0');
    signal readData  : std_logic_vector(7 downto 0);

    constant clk_period : time := 10 ns;
    signal stop_sim : boolean := false;

begin

    -- Instantiate Unit Under Test (UUT)
    uut: Data_Memory
        port map (
            clk       => clk,
            MemRead   => MemRead,
            MemWrite  => MemWrite,
            Address   => Address,
            writeData => writeData,
            readData  => readData
        );
    
        
    clk_process: process
    begin
        while not stop_sim loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Write value 11110000 to address 000000001 (1)
        MemWrite <= '1';
        MemRead  <= '0';
        Address  <= "000000001";
        writeData <= "11110000";
        wait until rising_edge(clk);

        -- Disable writing
        MemWrite <= '0';
        writeData <= (others => '0');
        wait until rising_edge(clk);

        -- Read from address 000000001
        MemRead <= '1';
        Address <= "000000001";
        wait until rising_edge(clk);

        -- Read from an address that hasn't been written to (000000010)
        Address <= "000000010";
        wait until rising_edge(clk);

        -- Overwrite value at address 000000001
        MemRead  <= '0';
        MemWrite <= '1';
        Address  <= "000000001";
        writeData <= "00001111";
        wait until rising_edge(clk);

        -- Disable writing
        MemWrite <= '0';
        writeData <= (others => '0');
        wait until rising_edge(clk);

        -- Read back overwritten value
        MemRead <= '1';
        Address <= "000000001";
        wait until rising_edge(clk);

        -- Write to high address 111111111 (511)
        MemRead  <= '0';
        MemWrite <= '1';
        Address  <= "111111111";
        writeData <= "10101010";
        wait until rising_edge(clk);

        -- Disable writing
        MemWrite <= '0';
        writeData <= (others => '0');
        wait until rising_edge(clk);

        -- Read from high address 111111111
        MemRead <= '1';
        Address <= "111111111";
        wait until rising_edge(clk);

        -- Test when both MemRead and MemWrite are '1' simultaneously (address 000010101)
        MemRead  <= '1';
        MemWrite <= '1';
        Address  <= "000010101";  -- Address 21
        writeData <= "01010101";
        wait until rising_edge(clk);

        -- Disable both
        MemRead  <= '0';
        MemWrite <= '0';
        wait until rising_edge(clk);

        -- Multiple consecutive writes (addresses 000000000 to 000000011)
        for i in 0 to 3 loop
            MemWrite <= '1';
            MemRead  <= '0';
            Address <= std_logic_vector(to_unsigned(i, 9));
            case i is
                when 0 => writeData <= "00000000";
                when 1 => writeData <= "00010000";
                when 2 => writeData <= "00100000";
                when 3 => writeData <= "00110000";
                when others => null;
            end case;
            wait until rising_edge(clk);
        end loop;

        -- Disable writing
        MemWrite <= '0';
        writeData <= (others => '0');
        wait until rising_edge(clk);

        -- Read back the same addresses (000000000 to 000000011)
        for i in 0 to 3 loop
            MemRead <= '1';
            Address <= std_logic_vector(to_unsigned(i, 9));
            wait until rising_edge(clk);
        end loop;

        
        MemRead <= '0';
        
        wait for clk_period;        
        stop_sim <= true;
        
        wait;
    end process;


end architecture;