library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- a entidade tem o mesmo nome do arquivo
entity tb is
end;

architecture a_tb of tb is
   component main 
   port(
        clk, rst: in std_logic;
        opSelect : out unsigned(3 downto 0);
        z, n, v, opException : out std_logic;
        result, PC : out unsigned(15 downto 0)
    );
   end component;
   signal wrData, out_a, pc : unsigned (15 downto 0);
   signal rom : unsigned (18 downto 0);
   signal inOp : unsigned (3 downto 0);
   signal wrAddress : unsigned (2 downto 0);
   signal z, n, v, clk, rst, wrEn, excp : std_logic;

   constant periodTime : time := 50 ns;
   signal finished : std_logic := '0';
begin
   uut: main port map( 
        clk => clk,
        rst => rst,
        opSelect => inOp,
        z => z,
        n => n,
        v => v,
        result => out_a,
        PC => pc,
        opException => excp
    );
    resetGlobal : process
    begin
        rst <= '1';
        wait for periodTime * 2;
        rst <= '0';
        wait;
    end process;

    simTimeProc : process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process simTimeProc;

    clkProc : process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for periodTime / 2;
            clk <= '1';
            wait for periodTime / 2;
        end loop;
        wait;
    end process clkProc;

    process 
    begin
        wait for periodTime * 10;
        wait;
    end process;
end architecture;