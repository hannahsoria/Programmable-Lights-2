-- Hannah Soria
-- CS232 fall 22
-- project 5
-- pldrom file **this is the circuit for the self guided instructions (last circuit)
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
	 "0001100000" when addr = "0000" else -- move 0s into LR
	 "0010100101" when addr = "0001" else -- move 5 into low bit of ACC
	 "0011100000" when addr = "0010" else -- move 0 into high bit of ACC
	 "0100010101" when addr = "0011" else -- add 1 into LR 
	 "0100110001" when addr = "0100" else -- subtract 1 from ACC 
    "1100000111" when addr = "0101" else -- branch if ACC is 0
    "1000000011" when addr = "0110" else -- branch to 0011
	 "0011100101" when addr = "0111" else -- move 0101 into ACC 4 high bit
	 "0010100101" when addr = "1000" else -- move 0101 into ACC 4 low bit
	 "0001000101" when addr = "1001" else -- move ACC into LR
	 "0011100000" when addr = "1010" else -- move 0s into high 4 bit ACC
	 "0010100011" when addr = "1011" else -- move 3 into low 4 bit ACC
	 "0100110001" when addr = "1100" else -- subtract 1 from ACC
	 "0100110101" when addr = "1101" else -- subtract 1 from LR
	 "1100000000" when addr = "1110" else -- branch if ACC 0
    "1000001100" when addr = "1111" else -- branch to 1100
	 "0000000000"; -- garbage
	
end rtl;	
