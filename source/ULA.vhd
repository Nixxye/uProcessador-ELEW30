library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port (
        dataInA, dataInB : in unsigned(15 downto 0);
        opSelect : in unsigned(3 downto 0); -- Modificar tamanho
        dataOut : out unsigned(15 downto 0);
        z, n, v : out std_logic -- Flags
    );
end entity;

architecture a_ULA of ULA is
    component halfAdder is 
        port (
            a, b : in unsigned (15 downto 0);
            sum : out unsigned (15 downto 0)
        );
    end component;

    component halfSubtractor is 
        port (
            a, b : in unsigned (15 downto 0);
            sub : out unsigned (15 downto 0)
        );
    end component;

    component mux16 is 
        port (
            a, b, c : in unsigned (15 downto 0);
            sel : in unsigned (3 downto 0);
            muxOut : out unsigned (15 downto 0)
        );
    end component;

    component bitShifter is 
        port (
            a : in unsigned (15 downto 0);
            shift : out unsigned (15 downto 0);
            left : in std_logic
        );
    end component;
	
    signal muxOp0, muxOp1, muxOp2: unsigned (15 downto 0);
    signal muxOut: unsigned (15 downto 0);
begin
	-- Colocar nome certo do MUX da ULA
    mux : mux16 port map (
        a => muxOp0,
		b => muxOp1,
		c => muxOp2,
		sel => opSelect,
		muxOut => muxOut
    );
	adder : halfAdder port map (
		a => dataInA,
		b => dataInB,
		sum => muxOp0
    );
	subtractor : halfSubtractor port map (
		a => dataInA,
		b => dataInB,
		sub => muxOp1
	);
    dataOut <= muxOut;
    -- FLAGS
    z <= '1' when muxOut = 0 else '0';
    n <= muxOut(15);
    v <= (dataInA(15) and dataInB(15) and not muxOut(15))
     or (not dataInA(15) and not dataInB(15) and muxOut(15));
end architecture;