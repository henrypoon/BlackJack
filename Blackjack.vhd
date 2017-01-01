----------------------------------------------------------------------------------
-- Company: UNSW
-- Engineer: Jorgen Peddersen
-- 
-- Create Date:    16:06:48 09/26/2006 
-- Design Name:    Blackjack Player
-- Module Name:    Blackjack - Structural 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Blackjack is
    Port ( clock_50 :in std_LOGIC;
				--clk : in  STD_LOGIC;     -- on-board clock - fast
			  LEDR : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
			  KEY : in std_LOGIC_VECTOR(2 downto 0);
			  LEDG : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			  SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			  HEX0 : out std_LOGIC_VECTOR(6 downto 0);
			  hex1 : out std_LOGIC_VECTOR(6 downto 0);
			  HEX2 : out std_LOGIC_VECTOR(6 downto 0);
			  hex3 : out std_LOGIC_VECTOR(6 downto 0));
			  
end Blackjack;

architecture Structural of Blackjack is

  component Blackjack_FSM
    port (
      clk                       : in  std_logic;
      rst                       : in  std_logic;
      cardReady                 : in  std_logic;
      newCard                   : out std_logic;
      lost                      : out std_logic;
      finished                  : out std_logic;
      cmp11, cmp16, cmp21       : in  std_logic;
      sel                       : out std_logic;
      enaLoad, enaAdd, enaScore : out std_logic);
  end component;

  component Blackjack_DataPath
    port (
      clk                       : in  std_logic;
      rst                       : in  std_logic;
      cardValue                 : in  std_logic_vector(3 downto 0);
      score                     : out std_logic_vector(4 downto 0);
      sel                       : in  std_logic;
      enaLoad, enaAdd, enaScore : in  std_logic;
      cmp11, cmp16, cmp21       : out std_logic);
  end component;
  
  
  component Blackjack_7Seg is
  
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;
    score : in  std_logic_vector(4 downto 0);
	 enable : in std_logic;
	 hex0 : out std_logic_vector(6 downto 0);
	 hex1 : out std_LOGIC_VECTOR(6 downto 0));
    --data  : out std_logic_vector(0 to 7);
    --addr  : out std_logic_vector(3 downto 0));

end component;
  
  
  
  
 signal  clk :   STD_LOGIC;
	SIGNAL sw_clk : STD_LOGIC;   -- switch controlled clock - slow
	SIGNAL start :   STD_LOGIC;   -- start input (asynchronous reset)
	SIGNAL cardValue :   STD_LOGIC_VECTOR (3 downto 0);
	SIGNAL cardReady :   STD_LOGIC;
	SIGNAL newCard :   STD_LOGIC;
	SIGNAL lost :   STD_LOGIC;
	SIGNAL finished :   STD_LOGIC;
	SIGNAL score :  STD_LOGIC_VECTOR (4 downto 0);
	SIGNAL data7s :   STD_LOGIC_VECTOR (0 to 7);
	SIGNAL addr7s :   STD_LOGIC_VECTOR (3 downto 0);
 
 
 

  signal sel                       : std_logic;
  signal enaLoad, enaAdd, enaScore : std_logic;
  signal cmp11, cmp16, cmp21       : std_logic;

  signal score_sig : std_logic_vector(4 downto 0);
  
  -- The following signals are used to synchronise the inputs to the clock
  signal cardReady_sync, cardReady_prev : std_logic;
  signal cardValue_sync, cardValue_prev : std_logic_vector(3 downto 0);
  signal sync_count : std_logic_vector(19 downto 0);
  
begin


	start <= not KEY(0);
	--clk <= clock_50;
	clk <= key(1);
	cardValue <= sw(3 downto 0);
	cardReady <= sw(4);
	ledg(5) <= newCard;
	ledG(6) <= lost;
	ledg(7) <= finished;
	ledR(4 downto 0) <= score;
	

  -- purpose: This process debounces the input switches and synchronises
  --          to the positive edge of clk.  You may comment this process
  --          out if you want to use sw_clk, but you don't have to.
  -- type   : sequential
  -- inputs : clk, rst, cardReady, cardValue
  -- outputs: cardReady_sync, cardValue_sync
  synchronise: process (clk, start)
  begin  -- process synchronise
    if start = '1' then                   -- asynchronous reset (active high)
      cardReady_sync <= '0';
      cardReady_prev <= '0';
      cardValue_sync <= (others => '0');
      cardValue_prev <= (others => '0');
      sync_count <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      cardReady_prev <= cardReady;
      cardValue_prev <= cardValue;
		
      -- The following counter counts time that the inputs have been steady.
      -- At 50Mhz, the signal must be steady for approx. 10 milliseconds.
      if cardReady /= cardReady_prev or cardValue /= cardValue_prev then
        sync_count <= (others => '0');
      elsif sync_count /= x"FFFFF" then
        sync_count <= sync_count + 1;
      end if;
		
      -- If the full time is reached, update the signals.
      if sync_count = x"FFFFF" then
        cardReady_sync <= cardReady_prev;
        cardValue_sync <= cardValue_prev;
      end if;  

    end if;
  end process synchronise;

  -- The following two instantiations are set up for the normal clock.
  -- To set up for sw_clk, uncomment the commented lines and comment out
  -- the lines above each commented line.
  BJ_FSM: Blackjack_FSM
    port map (
        clk       => clk,
--      clk       => sw_clk,
        rst       => start,
--        cardReady => cardReady_sync,
      cardReady => cardReady,
        newCard   => newCard,
        lost      => lost,
        finished  => finished,
        cmp11     => cmp11,
        cmp16     => cmp16,
        cmp21     => cmp21,
        sel       => sel,
        enaLoad   => enaLoad,
        enaAdd    => enaAdd,
        enaScore  => enaScore);

  BJ_DP: Blackjack_DataPath
    port map (
        clk       => clk,
--     clk       => sw_clk,
        rst       => start,
--        cardValue => cardValue_sync,
      cardValue => cardValue,
        score     => score_sig,
        sel       => sel,
        enaLoad   => enaLoad,
        enaAdd    => enaAdd,
        enaScore  => enaScore,
        cmp11     => cmp11,
        cmp16     => cmp16,
        cmp21     => cmp21);

  -- 7 Segment Display of score is OPTIONAL.  Comment the following
  -- instantiation if you don't want to use it.
   BJ_7seg_s: Blackjack_7Seg
    port map (
        clk   => clk,
        rst   => start,
        score => score_sig,
		  enable => enaScore,
		  hex0 => hex0,
		  hex1 => hex1);
  --      data  => data7s,
   --     addr  => addr7s);
  --
  -- Do not comment the following line.  A signal is needed as score is used as
  -- an input to the 7 Segment Display AND an output of the entity.
  score <= score_sig;
  
     BJ_7seg_v: Blackjack_7Seg
    port map (
        clk   => clk,
        rst   => start,
        score => "0" & cardValue,
		  enable => enaLoad,
		  hex0 => hex2,
		  hex1 => hex3);
  --      data  => data7s,
   --     addr  => addr7s);
  --
  -- Do not comment the following line.  A signal is needed as score is used as
  -- an input to the 7 Segment Display AND an output of the entity.
  score <= score_sig;
  
  
  
end Structural;

