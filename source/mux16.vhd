library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux16 is 
    port (
        op0, op1, op2, op3 : in unsigned (15 downto 0);
        sel : in unsigned (3 downto 0);
        muxOut : out unsigned (15 downto 0)
    );
end entity;

architecture a_mux16 of mux16 is
begin
    muxOut <= op0 when sel = "0000" else
        op1 when sel = "0001" else
        op2 when sel = "0010" else
        op3 when sel = "0011" else
        "0000000000000000"; 
end architecture;