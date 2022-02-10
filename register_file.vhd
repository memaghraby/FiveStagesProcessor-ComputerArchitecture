LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY register_file IS
GENERIC ( n : integer := 32);
PORT(Clk,Rst: IN std_logic; 
     RegRead,RegWrite1,RegWrite2: IN std_logic;
     ReadAddr1,ReadAddr2: IN std_logic_vector(2 DOWNTO 0);
     WriteAddr1: IN std_logic_vector(2 DOWNTO 0);
     WriteData1: IN std_logic_vector(n-1 DOWNTO 0);
     WriteAddr2 : IN std_logic_vector(2 DOWNTO 0);
     WriteData2: IN std_logic_vector(n-1 DOWNTO 0);
     ReadData1,ReadData2: OUT std_logic_vector(n-1 DOWNTO 0));
END register_file;

ARCHITECTURE a_register_file OF register_file IS

COMPONENT my_nDFF IS
GENERIC ( n : integer := 32);
PORT( Clk,Rst,enable1,enable2 : IN std_logic;
		   d1,d2 : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;

COMPONENT reg_decoder IS
PORT( enable: IN std_logic;
      input : IN std_logic_vector(2 DOWNTO 0);
      output: OUT std_logic_vector(7 DOWNTO 0));
END COMPONENT;

SIGNAL S1,S2,D1,D2:std_logic_vector(7 DOWNTO 0);
SIGNAL Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7:std_logic_vector(n-1 DOWNTO 0);

BEGIN
Dec0: reg_decoder PORT MAP(RegRead,ReadAddr1,S1);
Dec1: reg_decoder PORT MAP(RegRead,ReadAddr2,S2);
Dec2: reg_decoder PORT MAP(RegWrite1,WriteAddr1,D1);
Dec3: reg_decoder PORT MAP(RegWrite2,WriteAddr2,D2);
R0: my_nDFF GENERIC MAP (n) PORT MAP(Clk,Rst,D1(0),D2(0),WriteData1,WriteData2,Q0);
R1: my_nDFF GENERIC MAP (n) PORT MAP(Clk,Rst,D1(1),D2(1),WriteData1,WriteData2,Q1);
R2: my_nDFF GENERIC MAP (n) PORT MAP(Clk,Rst,D1(2),D2(2),WriteData1,WriteData2,Q2);
R3: my_nDFF GENERIC MAP (n) PORT MAP(Clk,Rst,D1(3),D2(3),WriteData1,WriteData2,Q3);
R4: my_nDFF GENERIC MAP (n) PORT MAP(Clk,Rst,D1(4),D2(4),WriteData1,WriteData2,Q4);
R5: my_nDFF GENERIC MAP (n) PORT MAP(Clk,Rst,D1(5),D2(5),WriteData1,WriteData2,Q5);
R6: my_nDFF GENERIC MAP (n) PORT MAP(Clk,Rst,D1(6),D2(6),WriteData1,WriteData2,Q6);
R7: my_nDFF GENERIC MAP (n) PORT MAP(Clk,Rst,D1(7),D2(7),WriteData1,WriteData2,Q7);

ReadData1<=Q0 WHEN S1(0)='1' ELSE (OTHERS=>'Z');
ReadData1<=Q1 WHEN S1(1)='1' ELSE (OTHERS=>'Z');
ReadData1<=Q2 WHEN S1(2)='1' ELSE (OTHERS=>'Z');
ReadData1<=Q3 WHEN S1(3)='1' ELSE (OTHERS=>'Z');
ReadData1<=Q4 WHEN S1(4)='1' ELSE (OTHERS=>'Z');
ReadData1<=Q5 WHEN S1(5)='1' ELSE (OTHERS=>'Z');
ReadData1<=Q6 WHEN S1(6)='1' ELSE (OTHERS=>'Z');
ReadData1<=Q7 WHEN S1(7)='1' ELSE (OTHERS=>'Z');

ReadData2<=Q0 WHEN S2(0)='1' ELSE (OTHERS=>'Z');
ReadData2<=Q1 WHEN S2(1)='1' ELSE (OTHERS=>'Z');
ReadData2<=Q2 WHEN S2(2)='1' ELSE (OTHERS=>'Z');
ReadData2<=Q3 WHEN S2(3)='1' ELSE (OTHERS=>'Z');
ReadData2<=Q4 WHEN S2(4)='1' ELSE (OTHERS=>'Z');
ReadData2<=Q5 WHEN S2(5)='1' ELSE (OTHERS=>'Z');
ReadData2<=Q6 WHEN S2(6)='1' ELSE (OTHERS=>'Z');
ReadData2<=Q7 WHEN S2(7)='1' ELSE (OTHERS=>'Z');

END a_register_file;
