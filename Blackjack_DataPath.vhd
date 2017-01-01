----------------------------------------------------------------------------------
-- Company: UNSW
-- Engineer: Jorgen Peddersen
-- 
-- Create Date:    16:06:48 09/26/2006 
-- Design Name:    Blackjack Player
-- Module Name:    Blackjack Datapath - Structural 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Blackjack_DataPath is
  
  port (
    clk                       : in  std_logic;
    rst                       : in  std_logic;
	 minus10							: out  std_logic;
    cardValue                 : in  std_logic_vector(3 downto 0);
    score               : buffer std_logic_vector(4 downto 0);
    sel                       : in  std_logic;
    enaLoad, enaAdd, enaScore : in  std_logic;
	 A, B : buffer std_LOGIC_vector(5 downto 0);
    cmp11, cmp16, cmp21       : out std_logic);

end Blackjack_DataPath;

architecture Structural of Blackjack_DataPath is

component regn is 
	port(R : in std_logic_vector(4 downto 0);
			CLK, RIN : in std_logic;
			Q : buffer std_logic_vector(4 downto 0));
end component;

--register
--signal A, B : std_logic_vector(5 downto 0);
signal myCard : std_LOGIC_vector(5 DOWnto 0);

BEGIN

--score <= bout;

--input control
myCard <= "00" & cardValue;


--datapath
process(clk, A)
	begin

	
	if (rst = '1') then
		cmp11 <= '0';
		score <= "00000";
		B <= "000000";
		A <= "000000";

	elsif (clk'event and clk = '1' )then
		
		if enaLoad = '1' then
		A <= mycard;
			if A = 11 then
				cmp11 <= '1';
			end if;
			
			if sel = '1' then
				A <= "110110";
			end if;
			B <= B + A;
		end if;
		
		--if enaAdd = '1' then
			
		--end if;
		
		if enaScore = '1' then
			score <= B(4 downto 0);
		end if;
		
	end if;
	
end process;
		
			
--cmp 
process(rst)
	begin

	if rst = '1' then
		cmp16 <= '0';
		cmp21 <= '0';
	else
		if B > 16 then
			cmp16 <= '1';
		else 
			cmp16 <= '0';
		end if;
		
		if B > 21 then
			cmp21 <= '1';
		else
			cmp21 <= '0';
		end if;
	end if;
	
end process;


			
end Structural;





