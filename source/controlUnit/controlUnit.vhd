library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlUnit is
    port (
        clk, rst : in std_logic;
        PC : out unsigned(15 downto 0)
    );
end entity;

architecture a_controlUnit of controlUnit is
    component reg16 is
        port(
            clk, rst, wrEn : in std_logic;
            dataIn : in unsigned(15 downto 0);
            dataOut : out unsigned(15 downto 0)
        );
    end component;
    signal pcAddress, pcSource : unsigned(15 downto 0);
begin
    pcComp : reg16 port map(
        clk => clk, 
        rst => rst, 
        wrEn => '1', 
        dataIn => pcSource,
        dataOut => pcAddress
    );
    PC <= pcAddress;
    process(clk)
    begin
        if rst = '1' then
            pcSource <= (others => '0');
        elsif rising_edge(clk) then
            pcSource <= pcAddress + 1;
        end if;
    end process;
end architecture;