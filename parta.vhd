LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY parta IS
	GENERIC (n : integer := 32);
	PORT ( IN1,IN2:  IN std_logic_vector(n-1 DOWNTO 0);
               CarryOut: OUT std_logic;
                   SEL0:  IN std_logic;
                   SEL1:  IN std_logic; 
		  OUT1:  OUT  std_logic_vector(n-1 DOWNTO 0));
END ENTITY parta;


ARCHITECTURE myparta of parta IS
COMPONENT fulladder IS
GENERIC (n : integer := 32);
PORT   (a, b : IN std_logic_vector(n-1 DOWNTO 0) ;
             cin : IN std_logic;
             s : OUT std_logic_vector(n-1 DOWNTO 0);
             cout : OUT std_logic);
          END COMPONENT;
         SIGNAL x,y : std_logic_vector(n-1 DOWNTO 0);
         SIGNAL CarryIn : std_logic;
BEGIN
u0: fulladder GENERIC MAP (n) PORT MAP (IN1,x,CarryIn,y,CarryOut);

x <=   (others=>'0') WHEN SEL0='0' AND SEL1='0'
  ELSE  IN2 WHEN SEL0='1' AND SEL1='0'
  ELSE NOT IN2 WHEN SEL0='0' AND SEL1='1'     
  ELSE  (others=>'1');

OUT1 <= (others=>'0') WHEN SEL0='1' AND SEL1='1' AND CarryIn ='1'
  ELSE y ;

CarryIn <= '1' WHEN SEL0='0' AND SEL1='1'
  ELSE '0' ;

END myparta;
