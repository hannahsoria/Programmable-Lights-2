-- Hannah Soria
-- CS232 fall 22
-- project 5
-- pld2 file
-- Quartus II VHDL Template
-- Four-State Moore State Machine

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pld2 is

	port(
		clk		 : in	std_logic;
		reset	 : in	std_logic;
		lightsig : out std_logic_vector(7 downto 0);
		IRView	 : out	std_logic_vector(9 downto 0);
		rled	: out std_logic;
		gled	: out std_logic
	);

end entity;

architecture rtl of pld2 is

	component pldrom
	port 
	(
		addr	   : in std_logic_vector  (3 downto 0);
		data : out std_logic_vector (9 downto 0)
	);
	end component;
	
	

	-- Build an enumerated type for the state machine
	type state_type is (sFetch, sExecute1, sExecute2);

	-- Register to hold the current state
	signal IR   : std_logic_vector(9 downto 0);
	signal PC	: unsigned(3 downto 0);
	signal LR	: unsigned(7 downto 0);
	signal ROMvalue	: std_logic_vector(9 downto 0);
	signal state: state_type;
	signal ACC	: unsigned (7 downto 0);
	signal SRC	: unsigned (7 downto 0);


begin

	pldrom1: pldrom
	port map (addr => std_logic_vector(PC), data => ROMvalue);
		
	-- Logic to advance to the next state
	process (clk, reset)
	begin
		if reset = '0' then
			PC <= "0000";
			IR <= "0000000000";
			LR <= "00000000";
			state <= sFetch;
		elsif (rising_edge(clk)) then
			case state is
				when sFetch =>
					IR <= ROMvalue;
					PC <= PC + 1;
					state <= sExecute1;
				when sExecute1 => -- move instructions
					if IR (9 downto 8) = "00" then
						if IR(5 downto 4) = "00" then -- ACC assigned to SRC
							SRC <= ACC;
						
						elsif IR(5 downto 4) = "01" then -- LR assigned to SRC
							SRC <= LR;
							
						elsif IR(5 downto 4) = "10" then -- IR low 4 bits extended to SRC
							SRC <= unsigned(IR(3) & IR(3) & IR(3) & IR(3) & IR (3 downto 0));
							
						elsif IR(5 downto 4) = "11" then -- all 1s assigned to SRC
							SRC <= "11111111";
						end if;
					end if;
						
					-- binary instructions
					if IR(9 downto 8) = "01" then
						if IR(4 downto 3) = "00" then -- ACC assigned to SRC
						SRC <= ACC;
							
						elsif IR(4 downto 3) = "01" then -- LR assgigned to SRC
						SRC <= LR;
							
						elsif IR(4 downto 3) = "10" then-- IR low 2 bits are 1s
						SRC <= unsigned(IR(1) & IR(1) & IR(1) & IR(1) & IR(1) & IR(1) & IR(1 downto 0));
							
						elsif IR(4 downto 3) = "11" then-- all 1s assigned to SRC
						SRC <= "11111111";
						end if;
					end if;
					
						
					-- unconditional branch instructions
					if IR(9 downto 8) = "10" then
						PC <= unsigned(IR(3 downto 0));
					end if;
						
					-- conditional branch instructions
					if (IR(9 downto 8) = "11") then
							if (IR(7) = '0') then
								if (ACC = 0) then
								PC <= unsigned(IR(3 downto 0));
								end if;
								
							else
								if (LR = 0) then
								PC <= unsigned(IR(3 downto 0));
								end if;
								
							end if;
					end if;
					state <= sExecute2;
					
				when sExecute2 =>
					--move operations
					if IR(9 downto 8) = "00" then
						if IR(7 downto 6) = "00" then --SRC assigned to ACC
						ACC <= SRC;
						
						elsif IR(7 downto 6) = "01" then
						LR <= SRC; -- SRC assigned to LR
								
						elsif IR(7 downto 6) = "10" then -- low 4 bit ACC
						ACC(3 downto 0) <= SRC(3 downto 0);
								
						elsif IR(7 downto 6) = "11" then -- high 4 bits of ACC
						ACC(7 downto 4) <= SRC(3 downto 0);
						end if;
					end if;
						
				--binary instructions
				if IR(9 downto 8) = "01" then
					if IR(2) = '0' then -- result of binary op saved to ACC
						if IR(7 downto 5) = "000" then -- addition
						ACC <= ACC + SRC; 
						
						elsif IR(7 downto 5) = "001" then -- subtraction
						ACC <= ACC - SRC;
						
						elsif IR(7 downto 5) = "010" then -- shift left
						ACC <= shift_left(SRC,1);
						
						elsif IR(7 downto 5) = "011" then -- shift right
						ACC <= shift_right(SRC,1);

						elsif IR(7 downto 5) = "100" then -- xor
						ACC <= ACC XOR SRC;
						
						elsif IR(7 downto 5) = "101" then -- AND
						ACC <= ACC AND SRC;
						
						elsif IR(7 downto 5) = "110" then -- rotate left
						ACC <= rotate_left(SRC,1);
						
						elsif IR(7 downto 5) = "111" then -- rotate right
						ACC <= rotate_right(SRC,1);
						end if;

					
					elsif IR(2) = '1' then  --result of binary op saved to LR
						if IR(7 downto 5) = "000" then -- addition
						LR <= LR + SRC;
						
						elsif IR(7 downto 5) = "001" then -- subtraction
						LR <= LR - SRC;
						
						elsif IR(7 downto 5) = "010" then -- shift left
						LR <= shift_left(SRC,1);
						
						elsif IR(7 downto 5) = "011" then -- shift right
						LR <= shift_right(SRC,1);
						
						elsif IR(7 downto 5) = "100" then -- XOR
						LR <= LR XOR SRC;
						
						elsif IR(7 downto 5) = "101" then --AND
						LR <= LR AND SRC;
						
						elsif IR(7 downto 5) = "110" then -- rotate left
						LR <= rotate_left(SRC,1);
						
						elsif IR(7 downto 5) = "111" then -- rotate right
						LR <= rotate_right(SRC,1);
						end if;
					
					end if;
				end if;
				state <= sFetch;
				
			end case;
		end if;
	end process;

	-- Output depends solely on the current state
	IRview <= IR;
	lightsig <= std_logic_vector(LR);
	
	

end rtl;
