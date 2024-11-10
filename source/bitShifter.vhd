library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bitShifter is 
    port (
        a : in unsigned (15 downto 0);
        shift : out unsigned (15 downto 0);
        left : in std_logic
    );
end entity;

architecture a_bitShifter of bitShifter is
begin
    shift <= (a(14 downto 0) & "0") when left = '1'
        else (a(15) & a(15 downto 1));  -- Mantém o sinal
end architecture;