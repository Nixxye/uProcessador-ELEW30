--Sem saída de carry out
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity halfAdder is 
    port (
        a, b : in unsigned (15 downto 0);
        sum : out unsigned (15 downto 0);
        carry : out std_logic
    );
end entity;

architecture a_halfAdder of halfAdder is
    signal s, a1, b1 : unsigned (16 downto 0);
begin
    a1 <= a & "0";
    b1 <= b & "0";
    s <= a1 + b1;
    sum <= s(15 downto 0);
    carry <= s(16);
end architecture;