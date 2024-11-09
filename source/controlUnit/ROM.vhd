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
        0 => "0011001001000000001", --ld r1, 1
        1 => "0011001010000000010", --ld r2, 2
        2 => "0011001011000000011", --ld r3, 3
        3 => "0011001100000000100", --ld r4, 4
        4 => "0011000011000000010", --addi r3, 2
        5 => "0001000000000000011", -- Jump
        6 => "0000000000000001000",
        7 => "0000000000000001001",
        8 => "0000000000000001010",
        9 => "0000000000000001011",
        10 => "0000000000000001100",
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