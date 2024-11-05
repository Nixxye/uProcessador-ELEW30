library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stateMachine is
    port (
        clk, rst : in std_logic;
        state : out std_logic
    );
end entity;
architecture a_stateMachine of stateMachine is
    signal s : std_logic;
begin
    process(clk)
    begin
        if rst = '1' then
            s <= '0';
        elsif rising_edge(clk) then
            s <= not s;
        end if;
    end process;
    state <= s;
end architecture;