library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is 
    port(
        clk, rst, wrEn : in std_logic;
        opSelect : out unsigned(3 downto 0);
        wrAddress : in unsigned(2 downto 0);
        wrData : in unsigned(15 downto 0);
        z, n, v, opException : out std_logic;
        result, PC : out unsigned(15 downto 0);
        romOut : out unsigned(18 downto 0)
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
            pcWrtEn, ulaSrcA: out std_logic;
            ulaOp : out unsigned(3 downto 0); 
            ulaSrcB : out unsigned(1 downto 0);
            jmpEn, opException : out std_logic
        );
    end component;
    signal ulaA, ulaB, r0Ula, r1Ula, reg, ulaOut, romIn, pcIn, pcOut: unsigned(15 downto 0);
    signal pcWrtEn, sUlaA, jmp, excp : std_logic;
    signal sUlaB : unsigned(1 downto 0);
    signal ulaOp : unsigned(3 downto 0);
    signal instruction : unsigned(18 downto 0);
begin
    ulat : ULA port map(
        dataInA => ulaA,
        dataInB => ulaB,
        opSelect => ulaOp,
        dataOut => ulaOut,
        z => z,
        n => n,
        v => v
    );
    regFile : registerFile port map(
        clk => clk,
        rst => rst,
        wrEn => wrEn,
        wrData => reg,
        wrAddress => wrAddress,
        r0Address => instruction(11 downto 9),
        r1Address => instruction(8 downto 6),
        r0Data => r0Ula,
        r1Data => r1Ula
    );
    romMem : ROM port map(
        clk => clk,
        address => pcOut,
        data => instruction
    );
    -- kk
    cU : controlUnit port map(
        clk => clk,
        rst => rst,
        instruction => instruction(18 downto 12),
        pcWrtEn => pcWrtEn,
        ulaSrcA => sUlaA,
        ulaSrcB => sUlaB,
        ulaOp => ulaOp,
        jmpEn => jmp,
        opException => excp
    );
    pcReg : reg16 port map(
        clk => clk,
        rst => rst,
        wrEn => pcWrtEn,
        dataIn => ulaOut,
        dataOut => pcOut
    );
    -- MUX
    reg <= wrData;
    ulaA <= pcOut when sUlaA = '0' else
            r0Ula when sUlaA = '1' else
            (others => '0');
    -- AQUI VAI A CONSTANTE IMEDIATA
    ulaB <= r1Ula when sUlaB = "00" else
        "0000000000000001" when sUlaB = "01" else
        "000000" & instruction(9 downto 0) when jmp = '1' else
        (others => '0');

    result <= ulaOut;
    PC <= pcOut;
    opSelect <= ulaOp;
    romOut <= instruction;
    opException <= excp;
end architecture;