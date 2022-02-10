library ieee;
use ieee.std_logic_1164.all;

entity ALU is
GENERIC (n : integer := 32);
port( sel0: IN std_logic;
      sel1: IN std_logic;
      sel2: IN std_logic;
      sel3: IN std_logic;
      in1 , in2: IN std_logic_vector (n-1 DOWNTO 0);
      Carryout: OUT std_logic;
      Shift: IN std_logic_vector (5 DOWNTO 0);
      output: OUT std_logic_vector (n-1 DOWNTO 0));
end entity ALU;

architecture struct of ALU is

component parta IS
	GENERIC (n : integer := 32);
	PORT ( IN1,IN2:  IN std_logic_vector(n-1 DOWNTO 0);
               CarryOut: OUT std_logic;
                   SEL0:  IN std_logic;
                   SEL1:  IN std_logic; 
		  OUT1:  OUT  std_logic_vector(n-1 DOWNTO 0));
END component;

component partb is 
GENERIC (n : integer := 32);
port( A , B: IN std_logic_vector (n-1 DOWNTO 0);
      S0: IN std_logic;
      S1: IN std_logic;
      CarryOut: OUT std_logic;
      F: OUT std_logic_vector (n-1 DOWNTO 0));
end component;

component partc is
GENERIC (n : integer := 32); 
port( A: IN std_logic_vector (n-1 DOWNTO 0);
      Shift: IN std_logic_vector (5 DOWNTO 0);
      S0: IN std_logic;
      S1: IN std_logic;
      Cout: OUT std_logic;
      F: OUT std_logic_vector (n-1 DOWNTO 0));
end component;


SIGNAL x0,x1,xa: std_logic_vector (n-1 DOWNTO 0);
SIGNAL c0,c1,ca: std_logic;

begin
ua: parta GENERIC MAP (n) port map(in1,in2,ca,sel0,sel1,xa);
u0: partb GENERIC MAP (n) port map(in1,in2,sel0,sel1,c0,x0);
u1: partc GENERIC MAP (n) port map(in1,Shift,sel0,sel1,c1,x1);

output  <=  xa WHEN sel2 = '0' AND sel3 = '0'
       ELSE x0 WHEN sel2 = '1' AND sel3 = '0'
       ELSE x1 WHEN sel2 = '0' AND sel3 = '1';

Carryout <= ca WHEN sel2 = '0' AND sel3 = '0'
       ELSE c0 WHEN sel2 = '1' AND sel3 = '0'
       ELSE c1 WHEN sel2 = '0' AND sel3 = '1';

end struct;
