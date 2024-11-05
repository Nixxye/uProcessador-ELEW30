--Sem saída de carry out
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bitwiseAnd is 
    port (
        a, b : in unsigned (15 downto 0);
        result : out unsigned (15 downto 0)
    );
end entity;

architecture a_bitwiseAnd of bitwiseAnd is
begin
    result <= a and b;
end architecture;