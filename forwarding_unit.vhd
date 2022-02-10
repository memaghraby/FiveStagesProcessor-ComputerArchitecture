LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY forwarding_unit IS
PORT(RegWrite1CUMemory,RegWrite2CUMemory,RegWrite1CUWriteBack,RegWrite2CUWriteBack: IN std_logic; 
     WriteAddr1Memory,WriteAddr2Memory,WriteAddr1WriteBack,WriteAddr2WriteBack,ReadAddr1Execute,ReadAddr2Execute: IN std_logic_vector(2 DOWNTO 0);
     SelMux1,SelMux2: OUT std_logic_vector(2 DOWNTO 0)
);
END forwarding_unit;

ARCHITECTURE a_forwarding_unit OF forwarding_unit IS
BEGIN

SelMux1 <= "001" WHEN (RegWrite1CUMemory = '1' AND (WriteAddr1Memory = ReadAddr1Execute))
	ELSE "010" WHEN (RegWrite2CUMemory = '1' AND (WriteAddr2Memory = ReadAddr1Execute))
	ELSE "011" WHEN (RegWrite1CUWriteBack = '1' AND (WriteAddr1WriteBack = ReadAddr1Execute))
	ELSE "100" WHEN (RegWrite2CUWriteBack = '1' AND (WriteAddr2WriteBack = ReadAddr1Execute))
	ELSE "000";

SelMux2 <= "001" WHEN (RegWrite1CUMemory = '1' AND (WriteAddr1Memory = ReadAddr2Execute))
	ELSE "010" WHEN (RegWrite2CUMemory = '1' AND (WriteAddr2Memory = ReadAddr2Execute))
	ELSE "011" WHEN (RegWrite1CUWriteBack = '1' AND (WriteAddr1WriteBack = ReadAddr2Execute))
	ELSE "100" WHEN (RegWrite2CUWriteBack = '1' AND (WriteAddr2WriteBack = ReadAddr2Execute))
	ELSE "000";

END a_forwarding_unit;