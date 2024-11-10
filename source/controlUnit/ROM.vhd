library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
    port (
        clk : in std_logic;
        address : in unsigned(15 downto 0);
        data : out unsigned(18 downto 0) -- Instruções de 19 bits
    );
end entity;

architecture a_ROM of ROM is
    type mem is array (0 to 127) of unsigned(18 downto 0);
    constant romContent : mem := (
        0 => B"0011_001_010_000000101",   -- ld r2, 5
        1 => B"0011_001_011_000001000",   -- ld r3, 8
        2 => B"0010_010_100_010_000000",  -- mov r4, r2 
        3 => B"0010_000_100_011_000000",  -- add r4, r3
        4 => B"0011_001_001_000000001",   -- ld r1, 1
        5 => B"0010_001_100_001_000000",  -- sub r4, r1
        6 => B"0001_000_000000010100",    -- jump 20
        7 => B"0011_001_100_000000000",   -- ld r4, 0 (n executada)
        8 => B"0010001001010000000",      -- sub r1, r2
        9 => B"0000000000000001011",
        10 => B"0000000000000001100",
        20 => B"0010_010_010_100_000000", -- mov r2, r4
        21 => B"0001_000_000000000011",   -- jump 3
        22 => B"0011_001_011_000000000",  -- ld r3, 0 (n executada)
        others => (others => '0')
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            data <= romContent(to_integer(unsigned(address)));
        end if;
    end process;
end architecture;