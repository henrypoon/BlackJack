                                                     Black Jack Game
Design and implementation of a datapath and controller for a Blackjack card player. Program in VHDL and implement on FPGA board

The system works via the following steps:

The machine asserts newCard to indicate it wants a new card
The operator (i.e. YOU) asserts cardReady after you have setup cardValue
The machine de-asserts newCard to show it has received the card
The operator de-asserts cardReady to indicate it has seen that the machine has taken the new card
This handshake ensures both the machine and controller will not get out of sync even if they are running at different clock speeds or are asynchronous. 
This is known as a request-ack handshake and is seen in many designs when communication is needed.                                                     

Goal:

Get as close to 21 points as possible without going over.
Rules:

The game uses a standard 52-card deck, or multiple 52-card decks.
The value of a number card (2-10) is equal to its number.
The value of all face cards (Jack, Queen and King) is 10.
The value of an Ace is 11, but it can count for 1 instead.
You can keep asking for cards as long as you like until you stop or go over 21.
The strategy your player must demonstrate is:

Ask for cards while the current total value of cards is 16 or less.
Initially treat all Aces as worth 11 points
If you exceed 21 points and you have previously received an Ace, count it as 1 point instead.
Stop when your score is either between 17 and 21 (inclusive), or your score is above 21 and you don't have an Ace in reserve.
