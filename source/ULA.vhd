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
            op0, op1, op2, op3 : in unsigned (15 downto 0);
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
	
    component bitwiseAnd is 
    port (
        a, b : in unsigned (15 downto 0);
        result : out unsigned (15 downto 0)
    );
    end component;

    component bitwiseOr is 
    port (
        a, b : in unsigned (15 downto 0);
        result : out unsigned (15 downto 0)
    );
    end component;

    signal muxOp0, muxOp1, muxOp2, muxOp3, muxOut: unsigned (15 downto 0);
begin
	-- Colocar nome certo do MUX da ULA
    mux : mux16 port map (
        op0 => muxOp0,
		op1 => muxOp1,
		op2 => muxOp2,
        op3 => muxOp3,
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
    andOp : bitwiseAnd port map (
        a => dataInA,
        b => dataInB,
        result => muxOp2
    );
    orOp : bitwiseOr port map (
        a => dataInA,
        b => dataInB,
        result => muxOp3
    );
    dataOut <= muxOut;
    
        -- FLAGS

    -- resultado = 0: BLE vai subtrarir os 2 e ver se da 0 (iguais)
    z <= '1' when muxOut = 0 else
    '0';

    -- resultado negativo
    n <= muxOut(15);
 
    -- overflow
    v <= (dataInA(15) and dataInB(15) and (not muxOut(15))) -- soma de positivos da neg 
     or ((not dataInA(15)) and (not dataInB(15)) and muxOut(15)) -- soma de negativos da pos 
     or 
     ((not dataInA(15)) and dataInB(15) and muxOut(15)) -- neg - pos da pos
     or (dataInA(15) and (not dataInB(15)) and (not muxOut(15))); -- pos - neg da neg
end architecture;