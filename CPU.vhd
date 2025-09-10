library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU is
    port(
        clk             : in std_logic;
        rst             : in std_logic;
        instruction_out : out STD_LOGIC_VECTOR(15 downto 0)
    );
end entity CPU;

architecture Behavioural of CPU is

    -- Instruction
    signal instruction  : STD_LOGIC_VECTOR(15 downto 0);

    signal rd, rs1, rs2 : STD_LOGIC_VECTOR(2 downto 0);
    signal immediate    : STD_LOGIC_VECTOR(7 downto 0);
    signal opCode       : std_logic_vector(3 downto 0);      

    -- Contorl Unit
    signal RegWrite          : std_logic;
    signal MemRead, MemWrite : std_logic;
    signal AluSrc            : std_logic;
    signal Reg2Loc           : std_logic;
    signal MemToReg          : std_logic;  
    signal uncondBranchFlg   : STD_LOGIC;
    signal zeroBranchFlg     : std_logic;
    signal notZeroBranchFlg  : STD_LOGIC;
    signal AluOp             : std_logic_vector(3 downto 0);
    
    -- PC
    signal PC       : integer range 0 to 511;
    signal branchPC : std_logic;

    -- ALU
    signal AluResult                  : SIGNED(7 downto 0);
    signal AluResult_9bit             : SIGNED(8 downto 0);
    signal carryFlg, zeroFlg, signFlg : std_logic;

    -- Register Bank
    signal readReg2          : STD_LOGIC_VECTOR(2 downto 0); -- second reg input
    signal readData1         : STD_LOGIC_VECTOR(7 downto 0); -- first reg output
    signal readData2         : STD_LOGIC_VECTOR(7 downto 0); -- second reg output
    signal writeDataRegister : std_logic_vector(7 downto 0); -- write data input
    
    signal memoryDataOut : std_logic_vector(7 downto 0);

    signal aluInput2 : STD_LOGIC_VECTOR(7 downto 0);

    signal PC_vector : std_logic_vector(8 downto 0);


begin


    process (PC)
    begin
       PC_vector <= std_logic_vector(to_unsigned(PC, 9)); 
    end process;
    
    process (AluResult)
    begin
        AluResult_9bit <= '0' & AluResult;
    end process;

    process (instruction)
    begin
        opCode    <= instruction(15 downto 12);
        rd        <= instruction(11 downto 9);
        rs1       <= instruction(8 downto 6); 
        rs2       <= instruction(5 downto 3);
        immediate <= instruction(7 downto 0); 
    end process;


    process (rd, rs2, Reg2Loc)
    begin
        if Reg2Loc = '1' then
            readReg2 <= rd;  
        else
            readReg2 <= rs2;
        end if;    
    end process;


    process (MemToReg, writeDataRegister, AluResult)
    begin
        if MemToReg = '1' then
            writeDataRegister <= memoryDataOut;
        else
            writeDataRegister <= STD_LOGIC_VECTOR(AluResult);
        end if;        
    end process;
    

    process (AluSrc, readData2, immediate)
    begin
        if AluSrc = '1' then
            AluInput2 <= std_logic_vector(resize(signed(immediate), 8));
        else
            AluInput2 <= readData2;
        end if;        
    end process;
        
    process (zeroBranchFlg, notZeroBranchFlg, uncondBranchFlg, zeroFlg)
    begin
        branchPC <= (zeroBranchFlg and zeroFlg)
                or (notZeroBranchFlg and (not zeroFlg))
                or uncondBranchFlg;
    end process;



    Control_Unit : entity work.Control_Unit
        port map(
            opCode           => opCode,

            RegWrite         => RegWrite,
            MemRead          => MemRead,
            MemWrite         => MemWrite,
            AluSrc           => AluSrc,
            Reg2Loc          => Reg2Loc,
            AluOp            => AluOp,
            MemToReg         => MemToReg,
            zeroBranchFlg    => zeroBranchFlg,
            notZeroBranchFlg => notZeroBranchFlg,
            uncondBranchFlg  => uncondBranchFlg
        );

    Register_Files : entity work.Register_files
        port map(
            clk => clk,
            rst => rst,
            writeControl => RegWrite,
            readReg1 => rs1,
            readReg2 => readReg2,
            writeReg => rd,
            writeData => writeDataRegister,

            readData1 => readData1,
            readData2 => readData2        
        );
        
    ALU : entity work.ALU
        port map(
           clk      => clk,
           rst      => rst,
           A        => signed(readData1),
           B        => signed(AluInput2),
           opCode   => AluOp,
            
           result   => AluResult,
           carryFlg => carryFlg,
           zeroFlg  => zeroFlg,
           signFlg  => signFlg
        );

    Data_Memory : entity work.Data_Memory
        port map(
            clk => clk,
            memRead => MemRead,
            memWrite => MemWrite,
            address => STD_LOGIC_VECTOR(AluResult_9bit),
            writeData => readData2,

            readData => memoryDataOut
        );
        
    Instruction_Memory : entity work.Instruction_Memory
        port map(
            address => PC_vector,

            instr_out => instruction
        );
    
    Program_Counter : entity work.Program_Counter
        port map(
            clk => clk,
            rst => rst,
            branchFlg => branchPC,
            offset => SIGNED(immediate),

            PC => PC
        );

    instruction_out <= instruction;    

            

end architecture;