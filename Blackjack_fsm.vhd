----------------------------------------------------------------------------------
-- Company: UNSW
-- Engineer: Jorgen Peddersen
-- 
-- Create Date:    16:06:48 09/26/2006 
-- Design Name:    Blackjack Player
-- Module Name:    Blackjack FSM - Behavioural 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Blackjack_FSM is
  
  port (
    clk                       : in  std_logic;
    rst                       : in  std_logic;
    cardReady                 : in  std_logic;
	 newCard                   : buffer std_logic;
    lost                      : buffer std_logic;
    finished                  : buffer std_logic;
    cmp11, cmp16, cmp21       : in  std_logic;
    sel                       : out std_logic;
    enaLoad, enaAdd, enaScore : out std_logic);

end Blackjack_FSM;


architecture Behaviour of Blackjack_FSM is

	signal counter : std_logic_vector(3 downto 0);
	TYPE STATE_TYPE IS (START, LOAD, ADDSTATE, SCORESTATE, MINUSTEN);
	SIGNAL Y: STATE_TYPE;
	
	
	
begin  -- Structural
--intialise



statetable:
PROCESS(RST, CLK)
begin

	if rst = '1' then
		lost <= '0';
		finished <= '0';
		counter <= "0000";
		y <= START;
	elsif (clk'event and clk = '1') then
		case y is
			when START => 
				finished <= '0';
				y <= start;
				if cardReady = '1' then			
					y <= LOAD;
				else
					y <= START;
				end if;
			when LOAD => 
				--finished <= '0';
				if cmp11 = '1' then
					counter <= counter + 1;
				end if;
				--finished <= '0';
				y <= ADDSTATE;
			when ADDSTATE =>
				if cmp16 = '1' and cmp21 = '1' then
					if counter = 0 then
							lost <= '1';
						y <= SCORESTATE;
					else
						counter <= counter - 1;
						y <= MINUSTEN;
					end if;
				end if;
				
				if cmp16 = '0' and cmp21 = '0' then
					--lost <= '1';
					y <= START;
				end if;
				
				if cmp16 = '1' and cmp21 = '0' then
					finished <= '1';
					y <= SCORESTATE;
				end if;
			when MINUSTEN =>
				y <= LOAD;
			when SCORESTATE =>
				if finished = '1' then
					finished <= '1';
				end if;
		end case;
	end if;
end process;


SIGNALCONTROL:
process(y)
begin


	case y is
		when START =>
			newCard <= '1';
			enaLoad <= '0';
			sel <= '0';
			enaAdd <= '0';
			enaScore <= '0';			
		when LOAD =>
			newCard <= '0';
			enaLoad <= '1';
			enaScore <= '0';
			enaAdd <= '0';
		when ADDSTATE =>
			newCard <= '0';
			enaLoad <= '0';		
			enaAdd <= '1';
		when SCORESTATE =>
			newCard <= '0';
			enaAdd <= '0';
			enaLoad <= '0';
			enaScore <= '1';
		when MINUSTEN =>
			newCard <= '0';
			sel <= '1';
			enaAdd <= '0';
			enaLoad <= '0';
			enaScore <= '0';
	end case;
end process;


 
end Behaviour;
