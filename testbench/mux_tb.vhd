library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- a entidade tem o mesmo nome do arquivo
entity mux_tb is
end;

architecture a_mux_tb of mux_tb is
   component mux16
    port (
        a, b, c : in unsigned (15 downto 0);
        sel : in unsigned (3 downto 0);
        muxOut : out unsigned (15 downto 0)
    );
   end component;
   signal in_a, in_b, in_c, out_a: unsigned (15 downto 0);
   signal in_op : unsigned (3 downto 0);
   signal a : unsigned (3 downto 0);
   begin
   -- uut significa Unit Under Test
    uut: mux16 port map( 
        a  => in_a,
        b  => in_b,
        c => in_c,
        muxOut => out_a,
        sel => a
    );
	process
   begin
		in_a <= "0000000000001010";
		in_b <= "0000000001000011";
        in_c <= "0000001000000000";
		a <= "0000";
		wait for 50 ns;
        in_op <= "0001";
		wait for 50 ns;
        in_op <= "0010";
        wait for 50 ns;
		wait;
   end process;
end architecture;