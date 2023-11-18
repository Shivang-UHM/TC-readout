LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY counter IS
	GENERIC (
		NBITS : INTEGER := 8
	);
	PORT (
		CLK : IN STD_LOGIC;
		RST : IN STD_LOGIC;
		Q : OUT STD_LOGIC_VECTOR(NBITS - 1 DOWNTO 0)
	);

END counter;

ARCHITECTURE archi OF counter IS

	SIGNAL cnt : STD_LOGIC_VECTOR(NBITS - 1 DOWNTO 0);

BEGIN

	PROCESS (CLK, RST)
	BEGIN
		IF RST = '0' THEN
			cnt <= (OTHERS => '0');
		ELSE
			IF rising_edge(clk) THEN
				cnt <= STD_LOGIC_VECTOR(unsigned(cnt) + 1);
			END IF;
		END IF;
	END PROCESS;

	Q <= cnt;

END archi;