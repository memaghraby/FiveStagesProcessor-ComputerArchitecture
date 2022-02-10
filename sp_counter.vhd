LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY sp_counter IS
GENERIC ( n : integer := 20);
PORT( Clk,Rst,PopPush,enable  : IN std_logic;
		q : OUT std_logic_vector(n-1 DOWNTO 0)
		);
END sp_counter;

ARCHITECTURE a_sp_counter OF sp_counter IS

COMPONENT counter_reg IS
GENERIC ( n : integer := 32);
PORT( Clk,Rst,enable1,enable2 : IN std_logic;
		   d1,d2 : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;

COMPONENT fulladder IS
GENERIC (n : integer := 32);
PORT   (a, b : IN std_logic_vector(n-1 DOWNTO 0) ;
             cin : IN std_logic;
             s : OUT std_logic_vector(n-1 DOWNTO 0);
             cout : OUT std_logic);
END COMPONENT;

SIGNAL AdderOut: std_logic_vector(n-1 DOWNTO 0);
SIGNAL SPOut,addedValue: std_logic_vector(n-1 DOWNTO 0);
SIGNAL Cout,InvertedPopPush: std_logic;
BEGIN
--InvertedPopPush <= not PopPush;
addedValue <= "00000000000000000010" when (PopPush = '1') else "11111111111111111110";
SP: counter_reg GENERIC MAP (n) PORT MAP(Clk,Rst,enable,'0',AdderOut,SPOut,SPOut);
FA: fulladder GENERIC MAP (n) PORT MAP(SPOut ,addedValue,'0',AdderOut,Cout);
q <= AdderOut when PopPush = '1' else SPOut;

END a_sp_counter;