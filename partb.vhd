library ieee;
use ieee.std_logic_1164.all;

entity partb is
GENERIC (n : integer := 32);
port( A , B: IN std_logic_vector (n-1 DOWNTO 0);
      S0: IN std_logic;
      S1: IN std_logic;
      CarryOut: OUT std_logic;
      F: OUT std_logic_vector (n-1 DOWNTO 0));
end partb;

ARCHITECTURE  archb OF partb IS
COMPONENT fulladder IS
GENERIC (n : integer := 32);
PORT   (a, b : IN std_logic_vector(n-1 DOWNTO 0) ;
             cin : IN std_logic;
             s : OUT std_logic_vector(n-1 DOWNTO 0);
             cout : OUT std_logic);
          END COMPONENT;
     SIGNAL x, y : std_logic_vector(n-1 DOWNTO 0);
     SIGNAL Cout : std_logic;	
BEGIN

     x <= "00000000000000000000000000000001";

     u0: fulladder GENERIC MAP (n) PORT MAP (A,x,'0',y,Cout);

     F <=   A and B  WHEN   S0 = '0' AND S1 = '0'
            ELSE A or B  WHEN   S0 = '1' AND S1 = '0'
            ELSE y  WHEN   S0 = '0' AND S1 = '1'
            ELSE not A  WHEN   S0 = '1' AND S1 = '1';

     CarryOut <=  Cout 	WHEN   S0 = '0' AND S1 = '1' ELSE '0';

END archb;
