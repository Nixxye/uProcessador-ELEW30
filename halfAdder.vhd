--Sem saída de carry out
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity halfAdder is 
    port (
        a, b : in unsigned (7 downto 0);
        sum : out std_logic_vector (7 downto 0);
    );
end entity;

architecture a_halfAdder of halfAdder is
begin
    sum <= a + b;
end architecture;