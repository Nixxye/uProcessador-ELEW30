library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlUnit is
    port (
        clk, rst, z, n, v : in std_logic;
        instruction : in unsigned(6 downto 0); -- OPCODE (4 bits) + FUNCTION (3 bits)
        pcWrtEn, pcWrtCnd, ulaSrcA, pcSource, opException, zeroReg, memtoReg, regWrt, irWrt, flagWrtEn: out std_logic;
        ulaOp : out unsigned(3 downto 0); 
        ulaSrcB : out unsigned(2 downto 0);
        lorD : out unsigned(1 downto 0)
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
    signal excp, jmp, jmpBLT, jmpBLE, stRst, instrR, instrJ, instrI, instrB: std_logic;
begin
    sM : stateMachine port map(
        clk => clk,
        rst => stRst,
        state => state
    );
    -- Coloca o registrador ZERO na ULA para ter mais bits para a constante do jump:
    -- Usado também para quando é necessário somar com zero (apenas passar a constante pela ULA):
    zeroReg <= '1' when state = "010" and instrJ = '1' else  -- jump
        '1' when state = "010" and instrI = '1' and func = "001" else -- ld
        '1' when state = "010" and instrR = '1' and func = "010" else -- move
        '0';

    ulaOp <= "0000" when state = "000" else 
        "0000" when state = "001" else
        "0000" when state = "010" and instrJ = '1' else
        "0000" when state = "010" and instrB = '1' else
        "0000" when state = "010" and instrR = '1' and func = "000" else
        "0001" when state = "010" and instrR = '1' and func = "001" else
        "0000" when state = "010" and instrR = '1' and func = "010" else
        "0001" when state = "010" and instrR = '1' and func = "011" else
        "0000" when state = "010" and instrI = '1' and func = "000" else
        "0001" when state = "010" and instrI = '1' and func = "010" else
        (others => '0');

    ulaSrcA <= '0' when state = "000" else
        '0' when state = "001" else
        '1' when state = "010" and instrR = '1' else
        '1' when state = "010" and instrI = '1' else
        '1' when state = "010" and instrJ = '1' else
        '0' when state = "010" and instrB = '1' else
        '0';

    ulaSrcB <= "001" when state = "000" else
        "100" when state = "001" else
        "011" when state = "010" and instrJ = '1' else
        "000" when state = "010" and instrR = '1' else
        "010" when state = "010" and instrI = '1' else
        "010" when state = "010" and instrB = '1' else
        "000";
        
    pcWrtEn <= '1' when state = "000" and excp = '0' else '0';
    pcWrtCnd <= '1' when state = "010" and instrJ = '1' else
        '1' when state = "010" and instrB = '1' and jmp = '1' else
        '0';
    pcSource <= '0' when state = "000" else
        '0' when state = "010" and instrJ = '1' else
        '0' when state = "010" and instrB = '1' else
        '0';
    
    irWrt <= '1' when state = "000" else 
        '0';
    
    memtoReg <= '0' when instrR = '1' and state = "011" else
        '1' when instrI = '1' and func = "001" and state = "011" else --ld sem somar
        '0' when instrI = '1' and func = "000" and state = "011" else --addi
        '0';
    regWrt <= '1' when instrR = '1' and state = "011" and func /= "011" else
        '1' when instrI = '1' and state = "011" and func /= "010" else '0';
    lorD <= "10" when instrJ = '1' and state = "010" else
        "10" when instrB = '1' and state = "010" else
        "00";
    -- DECODE:
    opcode <= instruction (6 downto 3);
    func <= instruction (2 downto 0);
    -- INSTRUÇÕES PERMITIDAS
    excp <= '0' when opcode = "0000" and func = "000" else --nop
        '0' when instrJ = '1' and func = "000" else -- jmp
        '0' when instrR = '1' and func = "000" else -- add
        '0' when instrR = '1' and func = "001" else -- sub
        '0' when instrR = '1' and func = "010" else -- move
        '0' when instrR = '1' and func = "011" else -- cmp
        '0' when instrI = '1' and func = "000" else -- addi
        '0' when instrI = '1' and func = "001" else -- ld
        '0' when instrI = '1' and func = "010" else -- cmpi
        '0' when instrB = '1' and func = "000" else -- ble
        '0' when instrB = '1' and func = "001" else -- blt
        '1';
    -- RESETA A MÁQUINA DE ESTADOS EM DIFERENTES POSIÇÕES DEPENDENDO DO OPCODE
    stRst <= '1' when rst = '1' else
            '1' when instrJ = '1' and state = "010" else
            '1' when instrR = '1' and state = "011" else 
            '1' when instrI = '1' and state = "011" else
            '0';

    instrR <= '1' when opcode = "0010" else '0';
    instrJ <= '1' when opcode = "0001" else '0';
    instrI <= '1' when opcode = "0011" else '0';
    instrB <= '1' when opcode = "0100" else '0';

    opException <= excp;
    -- PULOS:
    jmp <= '1' when instrB = '1' and func = "000" and z = '1' else
        '1' when instrB = '1' and func = "000" and n /= v else 
        '1' when (instrB = '1') and (func = "001" and (n /= v)) else
        '0';

    flagWrtEn <= '0' when state = "000" or state = "011" or instrJ = '1' or instrB = '1' else '1';
end architecture;