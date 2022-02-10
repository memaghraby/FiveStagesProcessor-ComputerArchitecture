LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY my_nDFF IS
GENERIC ( n : integer := 32);
PORT( Clk,Rst,enable1,enable2 : IN std_logic;
		   d1,d2 : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END my_nDFF;

ARCHITECTURE a_my_nDFF OF my_nDFF IS
BEGIN
PROCESS (Clk,Rst,enable1,enable2)
BEGIN		
IF Rst = '1' THEN
		q <= (OTHERS=>'0');
ELSIF rising_edge(Clk) THEN
IF enable1 = '1' THEN
		q <= d1;
ELSIF enable2 = '1' THEN
		q <= d2;
END IF;
END IF;
END PROCESS;
END a_my_nDFF;

