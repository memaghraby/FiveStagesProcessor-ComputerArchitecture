LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY my_decoder IS
PORT( enable: IN std_logic;
      input : IN std_logic_vector(1 DOWNTO 0);
      output: OUT std_logic_vector(3 DOWNTO 0));
END my_decoder;

ARCHITECTURE A_DECODER OF my_decoder IS
BEGIN

output<="0000" WHEN enable='0'
        ELSE "0001" WHEN input(1)='0' and input(0)='0'
        ELSE "0010" WHEN input(1)='0' and input(0)='1'
        ELSE "0100" WHEN input(1)='1' and input(0)='0'
	ELSE "1000";

END A_DECODER;
