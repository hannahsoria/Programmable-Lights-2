-- Bruce A. Maxwell
-- Spring 2013
-- CS 232
-- Edited by Hannah Soria
-- test program for the lights circuit
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pldbench is
end entity;

architecture test of pldbench is
  constant num_cycles : integer := 400;

  -- this circuit just needs a clock and a reset
  signal clk : std_logic := '1';
  signal reset : std_logic;
  --signal rled: std_logic;
  signal gled: std_logic;

  -- lights component
  component pld2
    port( clk, reset : in std_logic;
          lightsig     : out std_logic_vector(7 downto 0);
          IRView     : out std_logic_vector(9 downto 0);
			 rled	: out std_logic;
			 gled	: out std_logic );
			 
  end component;

  -- output signals
  signal lightsig : std_logic_vector(7 downto 0);
  signal irview : std_logic_vector(9 downto 0);
  signal rled: std_logic;
  signal led: std_logic;

begin

  -- start off with a short reset
  reset <= '0', '1' after 5 ns;

  -- create a clock
  process begin
    for i in 1 to num_cycles loop
      clk <= not clk;
      wait for 5 ns;
      clk <= not clk;
      wait for 5 ns;
    end loop;
    wait;
  end process;

  -- port map the circuit
  L0: pld2 port map( clk, reset, lightsig, irview ,rled, gled);

end test;
