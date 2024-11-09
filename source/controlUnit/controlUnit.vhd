library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlUnit is
    port (
        clk, rst : in std_logic;
        instruction : in unsigned(6 downto 0); -- OPCODE (4 bits) + FUNCTION (3 bits)
        pcWrtEn, pcWrtCnd, ulaSrcA: out std_logic;
        ulaOp : out unsigned(3 downto 0); 
        ulaSrcB : out unsigned(1 downto 0);
        pcSource, opException : out std_logic
    );
end entity;

architecture a_controlUnit of controlUnit is
    component stateMachine is
        port(
            clk, rst : in std_logic;
            state : out unsigned(2 downto 0)
        );
    end component;

    signal opcode : unsigned(3 downto 0);
    signal func, state : unsigned(2 downto 0);
    signal jmp, excp, stRst : std_logic;
begin
    sM : stateMachine port map(
        clk => clk,
        rst => stRst,
        state => state
    );
    ulaOp <= "0000" when state = "000" else 
        "0000" when state = "001" else
        (others => '0');
    ulaSrcA <= '0' when state = "000" else
        '0' when state = "001" else
        '1' when state = "010" else
        '0';
    -- ARRUMAR CONSTANTE AQUI:
    ulaSrcB <= "01" when state = "000" else
        "10" when state = "001" else
        "10" when state = "010" and jmp = '1' else
        "00";
        
    pcWrtEn <= '1' when state = "000" and excp = '0' else '0';
    pcWrtCnd <= '1' when state = "010" and jmp = '1' else '0';
    pcSource <= '0' when state = "000" else
        '0' when state = "010" and jmp = '1' else -- Olhar para o opcode dps
        '0';
    -- DECODE:
    opcode <= instruction (6 downto 3);
    func <= instruction (2 downto 0);
    -- INSTRUÇÕES PERMITIDAS
    excp <= '0' when opcode = "0000" and func = "000" else --nop
        '0' when opcode = "0001" and func = "000" -- jmp
        else '1';
    -- RESETA A MÁQUINA DE ESTADOS EM DIFERENTES POSIÇÕES DEPENDENDO DO OPCODE
    stRst <= '1' when rst = '1' else
            '1' when opcode = "0001" and state = "010" else
            '0';
    jmp <= '1' when opcode = "0001" and func = "000" else '0';

    opException <= excp;
end architecture;