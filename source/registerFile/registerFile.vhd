library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerFile is 
    port(
        clk, rst, wrEn : in std_logic;
        wrData, wrAddress, r0Address, r1Address: in unsigned(15 downto 0);
        r0Data, r1Data : out unsigned(15 downto 0)
    );
end entity;

architecture a_registerFile of registerFile is
    component reg16 is
        port(
            clk, rst, wrEn : in std_logic;
            dataIn : in unsigned(15 downto 0);
            dataOut : out unsigned(15 downto 0)
        );
    end component;
    signal rs0, rs1, rs2, rs3, rs4, rs5, rs6, rs7 : unsigned(15 downto 0);
    signal wrEn1, wrEn2, wrEn3, wrEn4, wrEn5, wrEn6, wrEn7 : std_logic;
begin
    -- Resetar no início ou colocar um valor default apenas para o r0?
    r0 : reg16 port map(
        clk => clk, 
        rst => rst, 
        wrEn => '0', 
        dataIn => wrData,
        dataOut => rs0
    );
    r1 : reg16 port map(
        clk => clk, 
        rst => rst, 
        wrEn => wrEn1, 
        dataIn => wrData,
        dataOut => rs1
    );
    r2 : reg16 port map(
        clk => clk, 
        rst => rst, 
        wrEn => wrEn2, 
        dataIn => wrData,
        dataOut => rs2
    );
    r3 : reg16 port map(
        clk => clk, 
        rst => rst, 
        wrEn => wrEn3, 
        dataIn => wrData,
        dataOut => rs3
    );
    r4 : reg16 port map(
        clk => clk, 
        rst => rst, 
        wrEn => wrEn4, 
        dataIn => wrData,
        dataOut => rs4
    );
    r5 : reg16 port map(
        clk => clk, 
        rst => rst, 
        wrEn => wrEn5, 
        dataIn => wrData,
        dataOut => rs5
    );
    r6 : reg16 port map(
        clk => clk, 
        rst => rst, 
        wrEn => wrEn6, 
        dataIn => wrData,
        dataOut => rs6
    );
    r7 : reg16 port map(
        clk => clk, 
        rst => rst, 
        wrEn => wrEn7, 
        dataIn => wrData,
        dataOut => rs7
    );
    r0Data <= rs0 when r0Address = "000" else
            rs1 when r0Address = "001" else
            rs2 when r0Address = "010" else
            rs3 when r0Address = "011" else
            rs4 when r0Address = "100" else
            rs5 when r0Address = "101" else
            rs6 when r0Address = "110" else
            rs7 when r0Address = "111" else
            (others => '0');

    r1Data <= rs0 when r1Address = "000" else
            rs1 when r1Address = "001" else
            rs2 when r1Address = "010" else
            rs3 when r1Address = "011" else
            rs4 when r1Address = "100" else
            rs5 when r1Address = "101" else
            rs6 when r1Address = "110" else
            rs7 when r1Address = "111" else
            (others => '0');

    wrEn1 <= wrEn when wrAddress = "001" else '0';
    wrEn2 <= wrEn when wrAddress = "010" else '0';
    wrEn3 <= wrEn when wrAddress = "011" else '0';
    wrEn4 <= wrEn when wrAddress = "100" else '0';
    wrEn5 <= wrEn when wrAddress = "101" else '0';
    wrEn6 <= wrEn when wrAddress = "110" else '0';
    wrEn7 <= wrEn when wrAddress = "111" else '0';
end architecture;
