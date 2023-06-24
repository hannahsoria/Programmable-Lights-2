-- Hannah Soria
-- CS232 fall 22
-- project 5
-- pldrom file **this is the circuit that was instructed to write
-- Quartus II VHDL Template
-- Unsigned Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pldrom is

	port 
	(
		addr	   : in std_logic_vector  (3 downto 0);
		data : out std_logic_vector (9 downto 0)
	);

end entity;

architecture rtl of pldrom is 
begin

  data <= 
	 "0011100001" when addr = "0000" else -- move 1 into high 4 bit of ACC
	 "0010100000" when addr = "0001" else -- move 0000 into low 4 bit of ACC
	 "0001000000" when addr = "0010" else -- move ACC into LR   
    "0100110101" when addr = "0011" else -- subtract 1 from LR
    "1110000110" when addr = "0100" else -- branch if LR is 0
    "1000000011" when addr = "0101" else -- branch to 011
	 "0011100000" when addr = "0110" else -- move 0s into high 4 bit ACC
    "0010101000" when addr = "0111" else -- move 8 into low 4 bit ACC
	 "0100110001" when addr = "1000" else -- subtract 1 from ACC
    "0001110000" when addr = "1001" else -- move all 1s into LR
    "0001100000" when addr = "1010" else -- move 0s into LR
    "1100000000" when addr = "1011" else -- branch if ACC 0
    "1000001000" when addr = "1100" else -- branch to 1000
	 "0000000000"; -- garbage
	
end rtl;	
