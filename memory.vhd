LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY memory IS
	PORT(
		address : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY memory;

ARCHITECTURE syncrama OF memory IS

	TYPE ram_type IS ARRAY(0 TO 1023) OF std_logic_vector(15 DOWNTO 0); 
	SIGNAL memory : ram_type ;
	
	BEGIN
		dataout <= memory(to_integer(unsigned(address)));
END ARCHITECTURE syncrama;

