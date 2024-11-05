library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is 
    port(
        clk, rst, wrEn : in std_logic;
        opSelect : in unsigned(3 downto 0);
        r0, r1, wrAddress, wrData : in unsigned(15 downto 0);
        z, n, v : out std_logic;
        result : out unsigned(15 downto 0)
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

    signal r0Ula, r1Ula : unsigned(15 downto 0);
begin
    ulat : ULA port map(
        dataInA => r0Ula,
        dataInB => r1Ula,
        opSelect => opSelect,
        dataOut => result,
        z => z,
        n => n,
        v => v
    );

    regFile : registerFile port map(
        clk => clk,
        rst => rst,
        wrEn => wrEn,
        wrData => wrData,
        wrAddress => wrAddress,
        r0Address => r0,
        r1Address => r1,
        r0Data => r0Ula,
        r1Data => r1Ula
    );
end architecture;