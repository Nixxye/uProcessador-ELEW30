--Sem saída de carry out
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bitwiseOr is 
    port (
        a, b : in unsigned (15 downto 0);
        result : out unsigned (15 downto 0)
    );
end entity;

architecture a_bitwiseOr of bitwiseOr is
begin
    result <= a or b;
end architecture;