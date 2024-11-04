library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- a entidade tem o mesmo nome do arquivo
entity tb is
end;

architecture a_tb of tb is
   component ULA
	port (
      dataInA, dataInB : in unsigned(15 downto 0);
      opSelect : in unsigned(3 downto 0); -- Modificar tamanho
      dataOut : out unsigned(15 downto 0);
      zero, bigger, carry : out std_logic -- Flags
    );
   end component;
   signal in_a,in_b, out_a: unsigned (15 downto 0);
   signal in_op : unsigned (3 downto 0);
   signal a, b, c : std_logic;
   begin
   -- uut significa Unit Under Test
   uut: ULA port map( dataInA  => in_a,
                        dataInB  => in_b,
                        opSelect => in_op,
						dataOut => out_a,
						zero => a,
						bigger => b,
						carry => c);
	process
   begin
		in_a <= "1000000001011000";
		in_b <= "1000111111000000";
		in_op <= "0000";
		wait for 50 ns;
		wait;
   end process;
end architecture;