--Sem saída de carry out
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity halfSubtractor is 
    port (
        a, b : in unsigned (15 downto 0);
        sub : out unsigned (15 downto 0)
    );
end entity;

architecture a_halfSubtractor of halfSubtractor is
begin
    sub <= a - b;
end architecture;