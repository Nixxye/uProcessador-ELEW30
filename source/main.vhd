library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is 
    port(
        clk, rst, wrEn : in std_logic;
        opSelect : in unsigned(3 downto 0);
        r0, r1, wrAddress, wrData : in unsigned(15 downto 0);
        z, n, v : out std_logic;
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
            wrData, wrAddress, r0Address, r1Address: in unsigned(15 downto 0);
            r0Data, r1Data : out unsigned(15 downto 0)
        );
    end component;
    -- MT FEIO DEIXAR O MESMO MUX???
    component mux16 is 
    port (
        op0, op1, op2, op3 : in unsigned (15 downto 0);
        sel : in unsigned (3 downto 0);
        muxOut : out unsigned (15 downto 0)
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
            PC : out unsigned(15 downto 0)
        );
    end component;
    signal r0Ula, r1Ula, reg, ulaOut, romIn: unsigned(15 downto 0);
begin
    ulat : ULA port map(
        dataInA => r0Ula,
        dataInB => r1Ula,
        opSelect => opSelect,
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
        r0Address => r0,
        r1Address => r1,
        r0Data => r0Ula,
        r1Data => r1Ula
    );

    regIn : mux16 port map(
        op0 => ulaOut,
        op1 => wrData,
        op2 => "0000000000000000",
        op3 => "0000000000000000",
        sel => "0001",
        muxOut => reg
    );

    romMem : ROM port map(
        clk => clk,
        address => romIn,
        data => romOut
    );
    -- kk
    cU : controlUnit port map(
        clk => clk,
        rst => rst,
        PC => romIn
    );
    result <= ulaOut;
    PC <= romIn;
end architecture;