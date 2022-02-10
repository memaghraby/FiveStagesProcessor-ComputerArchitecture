LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY instruction_divider IS
GENERIC ( n : integer := 32);
PORT(Clk: IN std_logic; 
     Sel: IN std_logic_vector(1 DOWNTO 0);
     Input: IN std_logic_vector((n/2)-1 DOWNTO 0);
     Finish: OUT std_logic;
     Output: OUT std_logic_vector(n-1 DOWNTO 0));
END instruction_divider;

ARCHITECTURE a_instruction_divider OF instruction_divider IS
BEGIN

PROCESS(Clk)
BEGIN
IF rising_edge(Clk)THEN
IF(Sel = "01") THEN
	Output((n/2)-1 DOWNTO 0)<= Input;
	Finish<= '1';
ELSE
	Output(n-1 DOWNTO n/2)<= Input;
	Output((n/2)-1 DOWNTO 0)<= (OTHERS=>'0');
	Finish<= '0';
END IF;
END IF;
END PROCESS;
--Output(n-1 DOWNTO n/2)<= Input when Sel(1) = '1' OR Sel(0) = '0' OR Sel="XX" OR Sel="UU";
--Output((n/2)-1 DOWNTO 0)<= Input when Sel = "01"
--		       ELSE (OTHERS=>'0');
--Finish<= '1' when Sel = "01"
--	 ELSE '0';
END a_instruction_divider;