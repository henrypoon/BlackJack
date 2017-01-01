----------------------------------------------------------------------------------
-- Company: UNSW
-- Engineer: Jorgen Peddersen
-- 
-- Create Date:    16:06:48 09/26/2006 
-- Design Name:    Blackjack Player
-- Module Name:    Blackjack 7 Segment Display - Behavioural 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Blackjack_7Seg is
  
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;
    score : in  std_logic_vector(4 downto 0);
	 enable : in std_logic;
	 hex0 : out std_logic_vector(6 downto 0);
	 hex1 : out std_LOGIC_VECTOR(6 downto 0));
    --data  : out std_logic_vector(0 to 7);
    --addr  : out std_logic_vector(3 downto 0));

end Blackjack_7Seg;

architecture Behavioural of Blackjack_7Seg is

component number IS
	PORT( S,U,V,W : IN STD_LOGIC;
		   num : OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END component;

component char_7seg IS
	PORT( number: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
	HEXN : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END component;

component BCD IS
	PORT(input: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			secondDigit:OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			firstDigit:OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END component;

signal temp : std_LOGIC_VECTOR(4 downto 0);
signal first : std_LOGIC_VECTOR(3 downto 0);
signal second : std_LOGIC_VECTOR(3 downto 0);
signal number0 : std_LOGIC_VECTOR(9 downto 0);
signal number1 : std_LOGIC_VECTOR(9 downto 0);


begin  -- Behavioural

process(rst,clk)
begin
if rst = '1' then
	temp <= "00000";
elsif clk'event and clk = '1' then
	if enable = '1' then
		temp <= score;
  end if;
 end if;
end process;

B0 : BCD port map(score,second, first);
D0 : number port map(first(3), first(2), first(1), first(0), number0);
D1 : number port map(second(3), second(2), second(1), second(0), number1);
H0 : char_7seg port map (number0, hex0);
H1 : char_7seg port map (number1, hex1);

end Behavioural;




--char_7seg

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY char_7seg IS
	PORT( number: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
	HEXN : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END char_7seg;

ARCHITECTURE Behaviour of char_7seg IS

BEGIN

HEXN(0) <= number(1) OR number(4);
HEXN(1) <= number(5) OR number (6);
HEXN(2) <= number(2);
HEXN(3) <= number(1) OR number(4) OR number(7);
HEXN(4) <= number(1) OR number(3) OR number(4) OR number(5) OR number(7) OR number(9);
HEXN(5) <= number(1) OR number(2) OR number(3);
HEXN(6) <= number(0) OR number(1) OR number(7);
	
END Behaviour;


--number

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY number IS
	PORT( S,U,V,W : IN STD_LOGIC;
		   num : OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END number;

ARCHITECTURE Behaviour of number IS

BEGIN
	num(0) <= NOT S AND NOT W AND NOT U AND NOT V;
	num(1) <= NOT S AND NOT U AND NOT V AND W;
	num(2) <= NOT S AND NOT U AND V AND NOT W;
	num(3) <= NOT S AND NOT U AND V AND W;
	num(4) <= NOT S AND U AND NOT V AND NOT W;
	num(5) <= NOT S AND U AND NOT V AND W;
	num(6) <= NOT S AND U AND V AND NOT W;
	num(7) <= NOT S AND U AND V AND W;
	num(8) <= S AND NOT U AND NOT V AND NOT W;
	num(9) <= S AND NOT U AND NOT V AND W;
	
END Behaviour;




LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY BCD IS
	PORT(input: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			secondDigit:OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			firstDigit:OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END BCD;

ARCHITECTURE Behaviour OF BCD IS
SIGNAL total : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL tens : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL digits : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL result : STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN
total <= input;
PROCESS(total,tens,digits)
BEGIN

	IF (total >= 20) THEN
		tens <= "10100";
		digits <= "0010";
	ELSIF (total >= 10) THEN
		tens <= "01010";
		digits <= "0001";
	ELSE
		tens <= "00000";
		digits <= "0000";
	END IF;
END PROCESS;

result <= total - tens;
firstDigit <= result(3 DOWNTO 0);
secondDigit <= digits;

END Behaviour;

