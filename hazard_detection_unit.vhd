LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY hazard_detection_unit IS
PORT(Clk,Rst,MemReadExecute: IN std_logic;
     ReadAddr1Decode,ReadAddr2Decode,WriteAddr1Execute: IN std_logic_vector(2 DOWNTO 0);
     LoadUseHazard: OUT std_logic
);
END hazard_detection_unit;

ARCHITECTURE a_hazard_detection_unit OF hazard_detection_unit IS

SIGNAL MemReadExecute_Sig: std_logic; 

BEGIN

PROCESS(Clk,Rst)
BEGIN
	IF(Rst = '1') THEN
		MemReadExecute_Sig <= '0';
	ELSIF rising_edge(Clk) THEN
		MemReadExecute_Sig <= MemReadExecute;
	END IF;
END PROCESS;

LoadUseHazard <= '1' WHEN (MemReadExecute_Sig = '1' AND ((ReadAddr1Decode = WriteAddr1Execute) OR (ReadAddr2Decode = WriteAddr1Execute)))
		ELSE '0';

END a_hazard_detection_unit;