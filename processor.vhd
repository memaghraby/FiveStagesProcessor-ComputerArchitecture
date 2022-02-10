LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE IEEE.numeric_std.all;

ENTITY processor IS
GENERIC ( n : integer := 32);
PORT( Clk,Rst,Int: IN std_logic;
	InPort: IN std_logic_vector(n-1 DOWNTO 0);
	OutPort: OUT std_logic_vector(n-1 DOWNTO 0)
);
END processor;

ARCHITECTURE a_processor OF processor IS

COMPONENT PC_reg IS
GENERIC ( n : integer := 32);
PORT( Clk,Rst,enable1,enable2 : IN std_logic;
		   d1,d2 : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;

COMPONENT memory IS
	PORT(
		address : IN  std_logic_vector(6 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;

COMPONENT fulladder IS
GENERIC (n : integer := 32);
PORT   (a, b : IN std_logic_vector(n-1 DOWNTO 0) ;
             cin : IN std_logic;
             s : OUT std_logic_vector(n-1 DOWNTO 0);
             cout : OUT std_logic);
END COMPONENT;

COMPONENT instruction_divider IS
GENERIC ( n : integer := 16);
PORT(Clk: IN std_logic; 
     Sel: IN std_logic_vector(1 DOWNTO 0);
     Input: IN std_logic_vector(n-1 DOWNTO 0);
     Finish: OUT std_logic;
     Output: OUT std_logic_vector(2*n-1 DOWNTO 0));
END COMPONENT;

COMPONENT register_file IS
GENERIC ( n : integer := 32);
PORT(Clk,Rst: IN std_logic; 
     RegRead,RegWrite1,RegWrite2: IN std_logic;
     ReadAddr1,ReadAddr2: IN std_logic_vector(2 DOWNTO 0);
     WriteAddr1: IN std_logic_vector(2 DOWNTO 0);
     WriteData1: IN std_logic_vector(n-1 DOWNTO 0);
     WriteAddr2 : IN std_logic_vector(2 DOWNTO 0);
     WriteData2: IN std_logic_vector(n-1 DOWNTO 0);
     ReadData1,ReadData2: OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;

COMPONENT control_unit IS
GENERIC ( n : integer := 32);
PORT( Clk,Rst,IntDecodeCU,IntExecuteCU,IntMemoryCU,Finish,RtiIn: IN std_logic;
	OpCode: IN std_logic_vector(4 DOWNTO 0);
	q: OUT std_logic_vector(26 DOWNTO 0)
);
END COMPONENT;

COMPONENT hazard_detection_unit IS
PORT(Clk,Rst,MemReadExecute: IN std_logic;
     ReadAddr1Decode,ReadAddr2Decode,WriteAddr1Execute: IN std_logic_vector(2 DOWNTO 0);
     LoadUseHazard: OUT std_logic
);
END COMPONENT;

COMPONENT CCR IS 
 PORT( Clk,Set_clr_carry,en,dec_en,Rst,ALU_cout : IN std_logic;
       dec_in : in std_logic_Vector(1 downto 0);
       ALU : IN std_logic_Vector(31 downto 0);
       CF,ZF,NF : INOUT std_logic;
       jmp : INOUT std_logic;
       ALU_selection : IN std_logic_Vector(3 DOWNTO 0);
       FlagsIn: IN std_logic_Vector(2 DOWNTO 0)
       );
END COMPONENT;

COMPONENT ALU is
GENERIC (n : integer := 32);
port( sel0: IN std_logic;
      sel1: IN std_logic;
      sel2: IN std_logic;
      sel3: IN std_logic;
      in1 , in2: IN std_logic_vector (n-1 DOWNTO 0);
      Carryout: OUT std_logic;
      Shift: IN std_logic_vector (5 DOWNTO 0);
      output: OUT std_logic_vector (n-1 DOWNTO 0));
END COMPONENT;

COMPONENT forwarding_unit IS
PORT(RegWrite1CUMemory,RegWrite2CUMemory,RegWrite1CUWriteBack,RegWrite2CUWriteBack: IN std_logic; 
     WriteAddr1Memory,WriteAddr2Memory,WriteAddr1WriteBack,WriteAddr2WriteBack,ReadAddr1Execute,ReadAddr2Execute: IN std_logic_vector(2 DOWNTO 0);
     SelMux1,SelMux2: OUT std_logic_vector(2 DOWNTO 0)
);
END COMPONENT;

COMPONENT sp_counter IS
GENERIC ( n : integer := 20);
PORT( Clk,Rst,PopPush,enable  : IN std_logic;
		q : OUT std_logic_vector(n-1 DOWNTO 0)
		);
END COMPONENT;

COMPONENT dataMemory IS
	PORT(
		clk : IN std_logic;
		MemWrite,MemPushPop: IN std_logic;
		MemRead: IN std_logic;
		reset: IN std_logic;
		address : IN  std_logic_vector(19 DOWNTO 0);
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0);
		Int : IN std_logic);
END COMPONENT;

-----------------------------------------------------------------			
SIGNAL PCAdderCOut,IDFinish,enable1,IntDecode,IntExecute,IDFinishExecute,enable2,CarryOutALU,IntMemory,enable3,IntWriteBack,enable4,CFExecute,ZFExecute,NFExecute,jmpExecute,IntWriteBack2,LoadUseHazard,LoadUseHazardForPC,jmpMemory: std_logic;
SIGNAL IDSel: std_logic_vector(1 DOWNTO 0);
SIGNAL WriteAddr1Execute,WriteAddr2Execute,WriteAddr1Decode,WriteAddr2Decode,WriteAddr1Memory,WriteAddr2Memory,WriteAddr1WriteBack,WriteAddr2WriteBack,FlagsRestore,ReadAddr1Execute,ReadAddr2Execute,SelALUMux1,SelALUMux2: std_logic_vector(2 DOWNTO 0);
SIGNAL FinishOut: std_logic_vector(3 DOWNTO 0);
SIGNAL ShiftAmountExecute,OpCodeExecute: std_logic_vector(4 DOWNTO 0);
SIGNAL temp_shift: std_logic_vector(5 DOWNTO 0);
SIGNAL FetchedInstruction,FetchedInstructionDecode: std_logic_vector(15 DOWNTO 0);
SIGNAL SPOut,DataMemAddr: std_logic_vector(19 DOWNTO 0);
SIGNAL ControlUnitOut,ControlUnitExecute, ControlUnitMemory,ControlUnitWriteBack: std_logic_vector(26 DOWNTO 0);
SIGNAL SignExtendDecode,SignExtendExecute,ALUIn1,ALUIn2,InPortMemory,ALUOutMemory,SignExtendMemory,PCMemory,MemReadData,MemWriteData,InPortWriteBack,MemReadDataWriteBack,ALUOutWriteBack,SignExtendWriteBack,ReadData2WriteBack,ReadData2Memory,WriteBackMux,PCMux,Flags,PCAdderMux,AfterALUMux,ReadData1Memory,JmpMux: std_logic_vector(31 DOWNTO 0);
SIGNAL PCOut,PCAdderOut,Instruction,ReadD1,ReadD2,InPortDecode,PCDecode,InPortExecute,ReadData1Execute,ReadData2Execute,PCExecute,ALUOutput: std_logic_vector(n-1 DOWNTO 0);
-----------------------------------------------------------------
BEGIN
--------------------fetch stage------------------------
-------------------------------------------------------
PCMux <= WriteBackMux WHEN (jmpExecute='0' AND ControlUnitWriteBack(26)='1')
	 ELSE ReadData1Memory WHEN (jmpExecute='1')
	 ELSE PCAdderOut;
PC: PC_reg GENERIC MAP (n) PORT MAP(Clk,Rst,'1','0',PCMux,MemReadData,PCOut);
PCAdderMux <= "00000000000000000000000000000000" WHEN LoadUseHazardForPC  = '1'
		ELSE "00000000000000000000000000000001";
PCAdder: fulladder GENERIC MAP (n) PORT MAP(PCOut,PCAdderMux,'0',PCAdderOut,PCAdderCOut);
IM: memory PORT MAP(PCOut,FetchedInstruction);
------------------------------
enable1 <= NOT LoadUseHazard;  --enable of the first buffer'fetch/decode'
------------------------------
--------------------decode stage------------------------
-------------------------------------------------------
IDSel <=IDFinishExecute&ControlUnitExecute(25);
ID: instruction_divider GENERIC MAP (n) PORT MAP(Clk,IDSel,FetchedInstructionDecode,IDFinish,Instruction);
CU: control_unit GENERIC MAP (n) PORT MAP(Clk,Rst,IntDecode,IntExecute,IntMemory,IDFinish,ControlUnitExecute(2),Instruction(31 DOWNTO 27),ControlUnitOut);
HU: hazard_detection_unit PORT MAP(Clk,Rst,ControlUnitExecute(4),Instruction(26 DOWNTO 24),Instruction(23 DOWNTO 21),WriteAddr1Execute,LoadUseHazard);
RF: register_file GENERIC MAP (n) PORT MAP(Clk,Rst,ControlUnitOut(24),ControlUnitWriteBack(23),ControlUnitWriteBack(22),Instruction(26 DOWNTO 24),Instruction(23 DOWNTO 21),WriteAddr1WriteBack,WriteBackMux,WriteAddr2WriteBack,ReadData2WriteBack,ReadD1,ReadD2);
--Write back mux--
WriteAddr1Decode <= Instruction(26 DOWNTO 24) when (ControlUnitOut(22) = '0' and ControlUnitOut(20) = '0') else
					Instruction(20 DOWNTO 18) when (ControlUnitOut(22) = '0' and ControlUnitOut(20) = '1') else
					Instruction(23 DOWNTO 21) when (ControlUnitOut(22) = '1');
--sign extend mux--
SignExtendDecode <= "000000000000"&Instruction(19 DOWNTO 0) when (ControlUnitOut(21) = '1') else
					("0000000000000000" & Instruction(15 DOWNTO 0));
------------------------------
enable2 <= '1';  --enable of the second buffer'decode/execute'
------------------------------
--------------------execute stage----------------------
-------------------------------------------------------
--ALU mux 1---
ALUIn1 <= ALUOutMemory WHEN SelALUMux1 = "001"
	ELSE ReadData2Memory WHEN SelALUMux1 = "010"
	ELSE WriteBackMux WHEN SelALUMux1 = "011"
	ELSE ReadData2WriteBack WHEN SelALUMux1 = "100"
	ELSE ReadData1Execute;
--ALU mux 2---
ALUIn2 <= ALUOutMemory WHEN SelALUMux2 = "001"
	ELSE ReadData2Memory WHEN SelALUMux2 = "010"
	ELSE WriteBackMux WHEN SelALUMux2 = "011"
	ELSE ReadData2WriteBack WHEN SelALUMux2 = "100"
	ELSE SignExtendExecute WHEN ControlUnitExecute(15) = '0'
	ELSE ReadData2Execute;
OutPort <= ALUIn1 when (ControlUnitExecute(16) = '1' ) else
 		(others =>'Z') when (Rst = '1');   --latch for out port 
temp_shift <= '0'&ShiftAmountExecute;
ALUx: ALU PORT MAP(ControlUnitExecute(11),
				ControlUnitExecute(12),
				ControlUnitExecute(13),
				ControlUnitExecute(14),
				ALUIn1,
				ALUIn2,
				CarryOutALU,
				temp_shift,
				ALUOutput
);

CCRx: CCR PORT MAP(Clk,ControlUnitExecute(9),ControlUnitExecute(10),ControlUnitExecute(19),Rst,CarryOutALU,ControlUnitExecute(18 DOWNTO 17),ALUOutput,CFExecute,ZFExecute,NFExecute,jmpExecute , ControlUnitExecute(14 DOWNTO 11),FlagsRestore);
AfterALUMux <= SignExtendExecute WHEN (ControlUnitExecute(1 DOWNTO 0) = "11")	--TO FIX PROBLEM OF LDM FORWARDING
	ELSE InPortExecute WHEN (OpCodeExecute(4 DOWNTO 0) = "00111")
	ELSE ALUOutput;
JmpMux <= ALUOutMemory WHEN SelALUMux1 = "001"
	ELSE ReadData2Memory WHEN SelALUMux1 = "010"
	ELSE WriteBackMux WHEN SelALUMux1 = "011"
	ELSE ReadData2WriteBack WHEN SelALUMux1 = "100"
	ELSE ReadData1Execute;
------------------------------
enable3 <= '1';
------------------------------
FU: forwarding_unit PORT MAP(ControlUnitMemory(23),ControlUnitMemory(22),ControlUnitWriteBack(23),ControlUnitWriteBack(22),
			     WriteAddr1Memory,WriteAddr2Memory,WriteAddr1WriteBack,WriteAddr2WriteBack,ReadAddr1Execute,ReadAddr2Execute,
			     SelALUMux1,SelALUMux2);
--------------------Memory stage----------------------
------------------------------------------------------
SP: sp_counter GENERIC MAP (20) PORT MAP(Clk,Rst,ControlUnitMemory(8),ControlUnitMemory(7),SPOut);
DataMemAddr <=  SPOut WHEN ControlUnitMemory(7)='1'
		ELSE SignExtendMemory(19 DOWNTO 0);
Flags <= "00000000000000000000000000000" & CFExecute & ZFExecute & NFExecute;
MemWriteData <= ALUOutMemory WHEN (IntMemory = '0' and ControlUnitMemory(6)='0' and IntWriteBack2 = '0')
		ELSE PCExecute WHEN (IntMemory = '0' and ControlUnitMemory(6)='1')
		ELSE Flags WHEN (IntWriteBack2 = '1' and ControlUnitMemory(6)='0')
		ELSE PCMemory;
DM: dataMemory PORT MAP(Clk,ControlUnitMemory(5),ControlUnitMemory(7),ControlUnitMemory(4),Rst,DataMemAddr,MemWriteData,MemReadData,IntWriteBack);
FlagsRestore <= MemReadData(2 DOWNTO 0) WHEN ControlUnitMemory(2)='1' 
		ELSE (others =>'Z');
----------------------------
enable4 <= '1';
----------------------------
--------------------Write back stage----------------------
------------------------------------------------------
WriteBackMux <= InPortWriteBack WHEN (ControlUnitWriteBack(1)='0' AND ControlUnitWriteBack(0)='0')
		ELSE MemReadDataWriteBack WHEN (ControlUnitWriteBack(1)='0' AND ControlUnitWriteBack(0)='1')
		ELSE ALUOutWriteBack WHEN (ControlUnitWriteBack(1)='1' AND ControlUnitWriteBack(0)='0')
		ELSE SignExtendWriteBack WHEN (ControlUnitWriteBack(1)='1' AND ControlUnitWriteBack(0)='1');
----------------------------
PROCESS (Clk , Rst)
BEGIN
	IF(Rst = '1') THEN
		IntDecode <= '0';
		InPortDecode <= (others =>'0');
		FetchedInstructionDecode <= "0001000000000000";
		PCDecode <= (others =>'0');
		LoadUseHazardForPC <= '0';
-----------------------------------
		ControlUnitExecute <= "000000000001111100000000000";
		IntExecute <= '0';
		InPortExecute <= (others =>'0');
		ReadData1Execute <= (others =>'0');
		ReadData2Execute <= (others =>'0');
		WriteAddr1Execute <= (others =>'0');
		WriteAddr2Execute <= (others =>'0');
		ReadAddr1Execute <= (others =>'0');
		ReadAddr2Execute <= (others =>'0');
		ShiftAmountExecute <= (others =>'0');
		SignExtendExecute <= (others =>'0');
		OpCodeExecute <= (others =>'0');
		PCExecute <= (others =>'0');
		IDFinishExecute <='0';
--------------------------------------
		ControlUnitMemory <= "000000000001111100000000000";
		IntMemory <= '0';
		InPortMemory <= (others =>'0');
		ALUOutMemory <= (others =>'0');
		WriteAddr1Memory <=(others =>'0');
		WriteAddr2Memory <=(others =>'0');
		SignExtendMemory <=(others =>'0');
		PCMemory <=(others =>'0');
		jmpMemory <= '0';
		ReadData1Memory <= (others =>'0');
		ReadData2Memory <= (others =>'0');
---------------------------------------
		ControlUnitWriteBack <= "000000000001111100000000000";
		IntWriteBack <= '0';
		InPortWriteBack <= (others =>'0');
		MemReadDataWriteBack <= (others =>'0');
		ALUOutWriteBack <=(others =>'0');
		SignExtendWriteBack <= (others =>'0');
		WriteAddr1WriteBack <= (others =>'0');
		WriteAddr2WriteBack <= (others =>'0');
		ReadData2WriteBack <= (others =>'0');
		IntWriteBack2 <= '0';
---------------------------------------
	ELSIF falling_edge(Clk) THEN
		
		IF  (enable1 = '1' AND(ControlUnitOut(26) = '1' OR ControlUnitExecute(26) = '1' OR  ControlUnitMemory(26) = '1' OR IntWriteBack = '1' OR ControlUnitOut(2) = '1')) THEN
			FetchedInstructionDecode <="0001000000000000";  --INSERTING BUBBLE IN CASE OF CALL & RET & INT & RTI & JMP
			IF (Int /= '1') THEN 
                		IntDecode <= '0';
            		ELSE
                		IntDecode <= Int;
            		END IF;
			PCDecode <= PCOut;
			LoadUseHazardForPC <= '0';
		ELSIF enable1 = '1' THEN
			IF (Int /= '1') THEN 
                		IntDecode <= '0';
            		ELSE
                		IntDecode <= Int;
            		END IF;
			InPortDecode <= InPort;
			FetchedInstructionDecode <= FetchedInstruction;
			PCDecode <= PCOut;	
			LoadUseHazardForPC <= '0';
		ELSE 
			LoadUseHazardForPC <= LoadUseHazard;
		END IF;
		------------------------------
		IF (jmpExecute = '1' OR (LoadUseHazard = '1' AND ControlUnitExecute(2) = '0')) THEN
			ControlUnitExecute <= "000000000001111100000000000";  --INSERTING BUBBLE IN CASE OF JMP
			IntExecute <= IntDecode;
			PCExecute <= PCDecode;
		ELSIF enable2 = '1' THEN
			ControlUnitExecute <= ControlUnitOut;
			IntExecute <= IntDecode;
			InPortExecute <= InPortDecode;
			ReadData1Execute <= ReadD1;
			ReadData2Execute <= ReadD2;
			WriteAddr1Execute <= WriteAddr1Decode;
			WriteAddr2Execute <= Instruction(26 DOWNTO 24);
			ReadAddr1Execute <= Instruction(26 DOWNTO 24);
			ReadAddr2Execute <= Instruction(23 DOWNTO 21);
			ShiftAmountExecute <= Instruction(23 DOWNTO 19);
			SignExtendExecute <= SignExtendDecode;
			PCExecute <= PCDecode;
			IDFinishExecute <= IDFinish;
			OpCodeExecute <= Instruction(31 DOWNTO 27);
		END IF;
		------------------------------
		IF (jmpExecute = '1') THEN
			ControlUnitMemory <= "000000000001111100000000000";  --INSERTING BUBBLE IN CASE OF JMP
			IntMemory <= IntExecute;
			PCMemory <= PCExecute;	
		ELSIF enable3 = '1' THEN
			ControlUnitMemory <= ControlUnitExecute;
			IntMemory <= IntExecute;
			InPortMemory <= InPortExecute;
			ALUOutMemory <= AfterALUMux;
			WriteAddr1Memory <=WriteAddr1Execute;
			WriteAddr2Memory <=WriteAddr2Execute;
			SignExtendMemory <= SignExtendExecute;
			PCMemory <= PCExecute;	
			jmpMemory <= jmpExecute;
			ReadData1Memory <= JmpMux;
			ReadData2Memory <= ALUIn2;
		END IF;
		------------------------------
		IF enable4 = '1' THEN
			ControlUnitWriteBack <= ControlUnitMemory;
			IntWriteBack <= IntMemory;
			InPortWriteBack <= InPortMemory;
			MemReadDataWriteBack <= MemReadData;
			ALUOutWriteBack <= ALUOutMemory;
			SignExtendWriteBack <= SignExtendMemory;
			WriteAddr1WriteBack <= WriteAddr1Memory;
			WriteAddr2WriteBack <= WriteAddr2Memory;
			ReadData2WriteBack <= ReadData2Memory;
			IntWriteBack2 <= IntWriteBack;
		END IF;
		------------------------------
	END IF;
END PROCESS;
END a_processor;