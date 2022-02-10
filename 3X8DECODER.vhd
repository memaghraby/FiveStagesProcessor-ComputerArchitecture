LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY reg_decoder IS
PORT( enable: IN std_logic;
      input : IN std_logic_vector(2 DOWNTO 0);
      output: OUT std_logic_vector(7 DOWNTO 0));
END reg_decoder;

ARCHITECTURE A_REG_DECODER OF reg_decoder IS
BEGIN

output<="00000000" WHEN enable='0'
        ELSE "00000001" WHEN input(2)='0' and input(1)='0' and input(0)='0'
        ELSE "00000010" WHEN input(2)='0' and input(1)='0' and input(0)='1'
        ELSE "00000100" WHEN input(2)='0' and input(1)='1' and input(0)='0'
	ELSE "00001000" WHEN input(2)='0' and input(1)='1' and input(0)='1'
	ELSE "00010000" WHEN input(2)='1' and input(1)='0' and input(0)='0'
	ELSE "00100000" WHEN input(2)='1' and input(1)='0' and input(0)='1'
        ELSE "01000000" WHEN input(2)='1' and input(1)='1' and input(0)='0'
	ELSE "10000000";

END A_REG_DECODER;
