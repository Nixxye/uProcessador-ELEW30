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
      z, n, v : out std_logic -- Flags
    );
   end component;
   signal in_a,in_b, out_a: unsigned (15 downto 0);
   signal in_op : unsigned (3 downto 0);
   signal z, n, v : std_logic;
   begin
   -- uut significa Unit Under Test
   uut: ULA port map( 
      dataInA  => in_a,
      dataInB  => in_b,
      opSelect => in_op,
      dataOut => out_a,
      z => z,
      n => n,
      v => v
   );
	process
   begin
      in_a <= "0100111000100000";
		in_b <= "0000111000100000";
		in_op <= "0000";
		wait for 10 ns;
      in_a <= "0010010101000000";
		in_b <= "0001001110100000";
		in_op <= "0000";
		wait for 10 ns;

      in_a <= "0100111010000000";
		in_b <= "0001001110100000";
		in_op <= "0001";
		wait for 10 ns;
      in_a <= "1111100000100000";
		in_b <= "1111111110000010";
		in_op <= "0001";
		wait for 10 ns;


      in_a <= "0110111000100000"; --overflow pos - neg
		in_b <= "1110111000100000";
		in_op <= "0001";
		wait for 10 ns;
      in_a <= "0111110100000000"; --overflow pos - neg
		in_b <= "1111110011111000";
		in_op <= "0001";
		wait for 10 ns;

      in_a <= "1111111000100000"; --overflow neg - pos
		in_b <= "0111111001111111";
		in_op <= "0001"; 
		wait for 10 ns;
      in_a <= "1000000100000000"; --overflow neg - pos
		in_b <= "0000001111101000";
		in_op <= "0001"; 
		wait for 10 ns;


      in_a <= "0111111000100000"; --overflow sum pos
		in_b <= "0111111001111111";
		in_op <= "0000";
		wait for 10 ns;
      in_a <= "0111010111100000"; --overflow sum pos
		in_b <= "0010011100010000";
		in_op <= "0000";
		wait for 10 ns;

      in_a <= "1011111111111111"; --overflow sum neg
		in_b <= "1011111111111111";
		in_op <= "0000";
		wait for 10 ns;
      in_a <= "1001001101101000"; --overflow sum neg
		in_b <= "1101100011110000";
		in_op <= "0000";
		wait for 10 ns;

		in_a <= "0100111000100000"; --
		in_b <= "0100111000100000";
		in_op <= "0000";
		wait for 10 ns;
      in_a <= "0100111000100000"; --igual
		in_b <= "0100111000100000";
		in_op <= "0001";
      wait for 10 ns;
      in_a <= "1001110000110101"; --igual
		in_b <= "1001110000110101";
		in_op <= "0001";
		wait for 10 ns;

      in_a <= "0100101000100000";
		in_b <= "0100011010100000";
		in_op <= "0010";
		wait for 10 ns;
      in_a <= "0100101000100000";
		in_b <= "0100011010100000";
		in_op <= "0011";
		wait for 10 ns;
      
		wait;
   end process;
end architecture;