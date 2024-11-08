library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlUnit is
    port (
        clk, rst : in std_logic;
        instruction : in unsigned(6 downto 0); -- OPCODE (4 bits) + FUNCTION (3 bits)
        pcWrtEn, ulaSrcA: out std_logic;
        ulaOp : out unsigned(3 downto 0); 
        ulaSrcB : out unsigned(1 downto 0);
        jmpEn : out std_logic
    );
end entity;

architecture a_controlUnit of controlUnit is
    component stateMachine is
        port(
            clk, rst : in std_logic;
            state : out std_logic
        );
    end component;

    signal opcode : unsigned(3 downto 0);
    signal func : unsigned(2 downto 0);
    signal state, jmp : std_logic;
begin
    sM : stateMachine port map(
        clk => clk,
        rst => rst,
        state => state
    );
    ulaOp <= "0000" when state = '1' or jmp = '1' else 
        (others => '0');
    ulaSrcA <= '1' when state = '0' or jmp = '1' else
        '0' when state = '1' else
        '0';
    -- ARRUMAR CONSTANTE AQUI:
    ulaSrcB <= "10" when jmp = '1' else
        "01" when state = '1' else
        "00" when state = '0' else
        "01";
        
    pcWrtEn <= '1' when state = '1' else '0';

    -- DECODE:
    opcode <= instruction (6 downto 3);
    func <= instruction (2 downto 0);

    jmp <= '1' when opcode = "0001" and func = "000" else '0';
    jmpEn <= jmp;
end architecture;