library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux16 is 
    port (
        a, b, c : in unsigned (15 downto 0);
        sel : in unsigned (3 downto 0);
        muxOut : out unsigned (15 downto 0)
    );
end entity;

architecture a_mux16 of mux16 is
begin
    muxOut <= a when (sel = "0000") else
        b when (sel = "0001") else
        c when (sel = "0010") else
        "0000000000000000"; 
end architecture;