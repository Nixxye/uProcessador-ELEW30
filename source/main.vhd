library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is 
    port(
        clk, rst : in std_logic;
        opSelect : out unsigned(3 downto 0);
        wrData : in unsigned(15 downto 0);
        z, n, v, opException : out std_logic;
        result, PC : out unsigned(15 downto 0)
    );
end entity;

architecture a_main of main is
    component ULA is
        port (
            dataInA, dataInB : in unsigned(15 downto 0);
            opSelect : in unsigned(3 downto 0);
            dataOut : out unsigned(15 downto 0);
            z, n, v : out std_logic
        );
    end component;

    component registerFile is 
        port(
            clk, rst, wrEn : in std_logic;
            wrAddress, r0Address, r1Address : in unsigned(2 downto 0);
            wrData: in unsigned(15 downto 0);
            r0Data, r1Data : out unsigned(15 downto 0)
        );
    end component;

    component reg16 is
        port(
            clk, rst, wrEn : in std_logic;
            dataIn : in unsigned(15 downto 0);
            dataOut : out unsigned(15 downto 0)
        );
    end component;

    component reg19 is
        port(
            clk, rst, wrEn : in std_logic;
            dataIn : in unsigned(18 downto 0);
            dataOut : out unsigned(18 downto 0)
        );
    end component;

    component ROM is
    port (
        clk : in std_logic;
        address : in unsigned(15 downto 0);
        data : out unsigned(18 downto 0) -- Instruções de 19 bits
    );
    end component;

    component controlUnit is
        port (
            clk, rst : in std_logic;
            instruction : in unsigned(6 downto 0); -- OPCODE (4 bits) + FUNCTION (3 bits)
            pcWrtEn, pcWrtCnd, ulaSrcA, pcSource, opException, zeroReg, memtoReg, regWrt, irWrt : out std_logic;
            ulaOp : out unsigned(3 downto 0); 
            ulaSrcB, lorD : out unsigned(1 downto 0)
        );
    end component;
    signal ulaA, ulaB, r0Ula, r1Ula, wrtData, ulaOut, ulaResult, romIn, pcIn, pcOut, romAddr: unsigned(15 downto 0);
    signal pcWrtEn, pcWrtCnd, pcWrt, sUlaA, jmp, excp, pcSource, zeroReg, memtoReg, regWrt, rstPc, irWrt : std_logic;
    signal sUlaB, lorD : unsigned(1 downto 0);
    signal ulaOp : unsigned(3 downto 0);
    signal r0Address, wrAddress : unsigned(2 downto 0);
    signal instruction, romOut : unsigned(18 downto 0);
begin
    ulat : ULA port map(
        dataInA => ulaA,
        dataInB => ulaB,
        opSelect => ulaOp,
        dataOut => ulaResult,
        z => z,
        n => n,
        v => v
    );
    regFile : registerFile port map(
        clk => clk,
        rst => rst,
        wrEn => regWrt,
        wrData => wrtData,
        wrAddress => wrAddress,
        r0Address => instruction(11 downto 9),
        r1Address => instruction(8 downto 6),
        r0Data => r0Ula,
        r1Data => r1Ula
    );
    romMem : ROM port map(
        clk => clk,
        address => romAddr,
        data => romOut
    );
    -- kk
    cU : controlUnit port map(
        clk => clk,
        rst => rst,
        instruction => instruction(18 downto 12),
        pcWrtEn => pcWrtEn,
        pcWrtCnd => pcWrtCnd,
        pcSource => pcSource,
        ulaSrcA => sUlaA,
        ulaSrcB => sUlaB,
        ulaOp => ulaOp,
        opException => excp,
        zeroReg => zeroReg,
        memtoReg => memtoReg,
        regWrt => regWrt,
        irWrt => irWrt,
        lorD => lorD
    );
    pcReg : reg16 port map(
        clk => clk,
        rst => rst,
        wrEn => pcWrt,
        dataIn => pcIn,
        dataOut => pcOut
    );
    Ula_Out : reg16 port map(
        clk => clk,
        rst => rst,
        wrEn => '1',
        dataIn => ulaResult,
        dataOut => ulaOut
    );
    instrReg : reg19 port map(
        clk => clk,
        rst => rst,
        wrEn => irWrt,
        dataIn => romOut,
        dataOut => instruction
    );
    -- registrador a ser escrito no banco (TALVEZ VIRE UM MUX):
    wrAddress <= instruction(11 downto 9);
    -- MUX
    romAddr <= pcOut when lorD = "00" else 
        ulaOut when lorD = "01" else
        ulaResult when lorD = "10" else
        (others => '0'); -- JUMP
    ulaA <= pcOut when sUlaA = '0' else
            r0Ula when sUlaA = '1' else
            (others => '0');
    ulaB <= r1Ula when sUlaB = "00" else
        "0000000000000001" when sUlaB = "01" else
        "0000000" & instruction(8 downto 0) when sUlaB = "10" else
        "0000" & instruction(11 downto 0) when sUlaB = "11" else -- Apenas para Jump
        (others => '0');
    pcIn <= ulaResult when pcSource = '0' else
            ulaOut when pcSource = '1' else
            (others => '0');
    r0Address <= "000" when zeroReg = '1' else
            instruction(11 downto 9);

    wrtData <= ulaOut when memtoReg = '0' else
        "0000000" & instruction(8 downto 0) when memtoReg = '1' else -- IMMEDIATE
        (others => '0');
    -- ATUALIZAR qnd add BEQ
    pcWrt <= pcWrtEn or pcWrtCnd;
    result <= ulaOut;
    PC <= pcOut;
    opSelect <= ulaOp;
    -- instruction <= romOut;
    opException <= excp;
end architecture;