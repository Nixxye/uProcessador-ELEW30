library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port (
        dataInA, dataInB : in std_logic_vector(15 downto 0);
        dataOut : out std_logic_vector(15 downto 0);
        zero, bigger, less : out std_logic; -- Flags
        opSelect : in std_logic_vector(4 downto 0) 0 -- Modificar tamanho
    );
end entity;

architecture a_ULA of ULA is
begin
    
end architecture;