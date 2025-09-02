library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu_tb is
end entity;

architecture sim of alu_tb is

    -- Component declaration
    component ALU
        port (
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
    end component;

    -- Signals to connect to ALU
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal A, B       : signed(7 downto 0) := (others => '0') ;
    signal opCode     : std_logic_vector(3 downto 0) := (others => '0');
    
    signal result     : signed(7 downto 0);
    signal carryFlg   : std_logic;
    signal zeroFlg    : std_logic;
    signal signFlg    : std_logic;

    -- Clock period constant
    constant clk_period : time    := 10 ns;
    signal   stop_sim   : boolean := false;

begin

    -- Instantiate the ALU
    UUT: ALU
        port map (
            clk       => clk,
            rst       => rst,
            A         => A,
            B         => B,
            opCode    => opCode,

            result    => result,
            carryFlg  => carryFlg,
            zeroFlg   => zeroFlg,
            signFlg   => signFlg
        );

    -- Clock generation
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
        rst <= '1';

        wait for 20 ns;

        rst <= '0';

        wait for 20 ns;

        -- ADD (5 + 3 = 8)
        A <= to_signed(-5, 8);
        B <= to_signed(3, 8);
        opCode <= "0000";  -- ADD
        wait until rising_edge(clk);

        -- SUB (10 - 15 = -5)
        A <= to_signed(10, 8);
        B <= to_signed(15, 8);
        opCode <= "0001";  -- SUB
        wait until rising_edge(clk);

        -- MOV (R1 = B)
        A <= to_signed(0, 8);
        B <= to_signed(-20, 8);
        opCode <= "0011";  -- MOV
        wait until rising_edge(clk);

        -- CMP (compare 5 - 5)
        A <= to_signed(5, 8);
        B <= to_signed(5, 8);
        opCode <= "0100";  -- CMP
        wait until rising_edge(clk);

        -- XOR (5 xor 3 = 6)
        A <= to_signed(5, 8);
        B <= to_signed(3, 8);
        opCode <= "0101";  -- XOR
        wait until rising_edge(clk);

        -- AND (5 and 3 = 1)
        A <= to_signed(5, 8);
        B <= to_signed(3, 8);
        opCode <= "0110";  -- AND
        wait until rising_edge(clk);

        -- SHL: Shift Left (opCode = "0111")
        A <= to_signed(0, 8);  -- A irrelevant for SHL in your design
        B <= to_signed(8, 8);  -- ????? ??? 8 (00001000)
        opCode <= "0111";      -- SHL
        wait until rising_edge(clk);

        -- SHR: Shift Right (opCode = "1000")
        A <= to_signed(0, 8);
        B <= to_signed(16, 8); -- ???? 00010000
        opCode <= "1000";      -- SHR
        wait until rising_edge(clk);

        -- INC (4 + 1 = 5)
        A <= to_signed(4, 8);
        B <= to_signed(0, 8);
        opCode <= "1010";  -- INC
        wait until rising_edge(clk);

        -- COM (NOT 00000101 = 11111010 = -6)
        A <= to_signed(5, 8);
        B <= to_signed(0, 8);
        opCode <= "1001";  -- COM
        wait until rising_edge(clk);

        -- BZ (branch if zero, simulate zero flag = 1)
        A <= to_signed(0, 8);  -- irrelevant
        B <= to_signed(0, 8);  -- causes zero condition
        opCode <= "0001";  -- Do SUB to set Zero flag
        wait until rising_edge(clk);

        opCode <= "1110"; -- BZ
        wait until rising_edge(clk);

        -- BNZ (branch if not zero, should be 0 now)
        opCode <= "1111";  -- BNZ
        wait until rising_edge(clk);

        -- BR (unconditional branch)
        opCode <= "1101";  -- BR
        wait until rising_edge(clk);

        -- End simulation
        wait for 10 ns;        
        stop_sim <= true;

        wait;
    end process;

end architecture;
