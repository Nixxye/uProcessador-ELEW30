library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlUnit is
    port (
        clk, rst : in std_logic;
        PC : out unsigned(15 downto 0);
        jmpEn : out std_logic
    );
end entity;

architecture a_controlUnit of controlUnit is
    component reg16 is
        port(
            clk, rst, wrEn : in std_logic;
            dataIn : in unsigned(15 downto 0);
            dataOut : out unsigned(15 downto 0)
        );
    end component;

    component stateMachine is
        port(
            clk, rst : in std_logic;
            state : out std_logic
        );
    end component;

    signal pcAddress, pcSource : unsigned(15 downto 0);
    signal opcode : unsigned(3 downto 0);
    signal state : std_logic;
begin
    pcComp : reg16 port map(
        clk => clk, 
        rst => rst, 
        wrEn => '1', 
        dataIn => pcSource,
        dataOut => pcAddress
    );

    sM : stateMachine port map(
        clk => clk,
        rst => rst,
        state => state
    );
    PC <= pcAddress;
    -- COLOCAR UM SOMADOR OU APENAS DEIXAR + 1???
    pcSource <= (others => '0') when rst = '1' else 
                pcAddress + 1 when state = '1' else
                pcAddress;
    -- DECODE:
    opcode <= pc
    -- ROM DENTRO DO CONTROL UNIT???
end architecture;