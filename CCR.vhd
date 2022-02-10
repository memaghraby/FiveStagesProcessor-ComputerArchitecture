LIBRARY IEEE; 
USE IEEE.std_logic_1164.all;

ENTITY CCR IS 
 PORT( Clk,Set_clr_carry,en,dec_en,Rst,ALU_cout : IN std_logic;
       dec_in : in std_logic_Vector(1 downto 0);
       ALU : IN std_logic_Vector(31 downto 0);
       CF,ZF,NF : INOUT std_logic;
       jmp : INOUT std_logic;
       ALU_selection : IN std_logic_Vector(3 DOWNTO 0);
       FlagsIn: IN std_logic_Vector(2 DOWNTO 0)
       );
END CCR;
     
ARCHITECTURE a_CCR OF CCR IS 

COMPONENT my_decoder IS
PORT( enable: IN std_logic;
      input : IN std_logic_vector(1 DOWNTO 0);
      output: OUT std_logic_vector(3 DOWNTO 0));
END COMPONENT;
  
signal dec_out : std_logic_vector(3 downto 0);
    
BEGIN   
  
fx: my_decoder PORT MAP(dec_en, dec_in, dec_out);
      
PROCESS(Clk,Rst) 
BEGIN
IF(rst = '1') THEN
	CF <= '0' ;
	ZF <= '0' ;
	NF <= '0' ;
	jmp <= '0';
ELSIF falling_edge(Clk) THEN

	IF (jmp = '0') THEN
	IF(FlagsIn /= "ZZZ") THEN
		CF <= FlagsIn(2);
   		ZF <= FlagsIn(1);
   		NF <= FlagsIn(0);
	ELSIF(en='1') THEN
		IF(Set_clr_carry='1') THEN
			CF <= '1';
		ELSE
			CF <= '0';
		END IF;
	ELSIF (ALU_selection /= "1111") THEN
		CF <= ALU_cout;

		IF (ALU = x"00000000")THEN
	        	ZF <= '1';
        	ELSE
        		ZF <= '0';
		END IF;

		IF ALU(31) = '1' THEN
                	NF <= '1' ;
		ELSE
			NF<= '0';
		END IF;
	END IF;
	END IF;

	IF (dec_out = "1000") THEN
		jmp <= '1';
	ELSIF (dec_out = "0001" AND ZF = '1') THEN
		jmp <= '1';
		ZF <= '0';
	ELSIF (dec_out = "0010" AND NF = '1') THEN
		jmp <= '1';
		NF <= '0';
	ELSIF (dec_out = "0100" AND CF = '1') THEN
		jmp <= '1';
		CF <= '0';
	ELSE
		jmp <= '0';
	END IF;
END IF;

END PROCESS; 
  
END a_CCR;
