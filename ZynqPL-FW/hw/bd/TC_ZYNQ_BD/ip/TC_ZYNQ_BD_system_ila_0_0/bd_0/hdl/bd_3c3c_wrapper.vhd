--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Command: generate_target bd_3c3c_wrapper.bd
--Design : bd_3c3c_wrapper
--Purpose: IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity bd_3c3c_wrapper is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 31 downto 0 )
  );
end bd_3c3c_wrapper;

architecture STRUCTURE of bd_3c3c_wrapper is
  component bd_3c3c is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component bd_3c3c;
begin
bd_3c3c_i: component bd_3c3c
     port map (
      clk => clk,
      probe0(31 downto 0) => probe0(31 downto 0)
    );
end STRUCTURE;
