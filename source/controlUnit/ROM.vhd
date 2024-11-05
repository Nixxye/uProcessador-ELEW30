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
        0 => "0000000000000000010",
        1 => "0000000000000000011",
        2 => "0000000000000000100",
        3 => "0000000000000000101",
        4 => "0000000000000000110",
        5 => "0000000000000000111",
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