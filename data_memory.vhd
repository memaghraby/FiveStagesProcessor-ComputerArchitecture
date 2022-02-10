LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
USE IEEE.numeric_std.all;

ENTITY dataMemory IS
	PORT(
		clk : IN std_logic;
		MemWrite,MemPushPop: IN std_logic;
		MemRead: IN std_logic;
		reset: IN std_logic;
		address : IN  std_logic_vector(19 DOWNTO 0);
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0);
		Int : IN std_logic
				);
END ENTITY dataMemory;

ARCHITECTURE syncrama OF dataMemory IS

	TYPE ram_type IS ARRAY(0 TO 2047) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram : ram_type ;
	SIGNAL trimmed_address : std_logic_vector(10 DOWNTO 0);

	
	BEGIN
		trimmed_address <= address(10 DOWNTO 0);
		PROCESS(clk , reset) IS
			BEGIN
				IF reset = '1' THEN
						dataout(15 downto 0) <= ram(0);
						dataout(31 downto 16) <= ram(1); 
				ELSIF rising_edge(clk) THEN
					IF Int = '1' and  MemRead = '1' THEN
						dataout(15 downto 0) <= ram(2);
						dataout(31 downto 16) <= ram(3); 						
					ELSIF MemPushPop = '0' THEN 
						IF MemWrite = '1' THEN
							ram(to_integer(unsigned(trimmed_address))) <= datain(15 downto 0);
							ram(to_integer(unsigned(trimmed_address + 1))) <= datain(31 downto 16);
						ELSIF MemRead = '1' THEN
							dataout(15 downto 0) <= ram(to_integer(unsigned(trimmed_address)));
							dataout(31 downto 16) <= ram(to_integer(unsigned(trimmed_address +1)));
						END IF;
					ELSE 
						IF MemWrite = '1' THEN
							ram(to_integer(unsigned(trimmed_address -1))) <= datain(15 downto 0);
							ram(to_integer(unsigned(trimmed_address))) <= datain(31 downto 16);
						ELSIF MemRead = '1' THEN
							dataout(15 downto 0) <= ram(to_integer(unsigned(trimmed_address -1)));
							dataout(31 downto 16) <= ram(to_integer(unsigned(trimmed_address)));
						END IF;

					END IF;
				END IF;
		END PROCESS;
END syncrama;

