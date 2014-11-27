-------------------------------------------------------------------------------
-- Title      : LogicAnalyzer Top Level Design
-- Project    : 
-------------------------------------------------------------------------------
-- File       : LogicAnalyzer.vhd
-- Author     :   <Marco@JUDI>
-- Company    : 
-- Created    : 2014-11-27
-- Last update: 2014-11-27
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Top Level Design for a Logic Analyzer in VHDL for the DE0nano
-- Board from Terasic.
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-11-27  1.0      Marco   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LogicAnalyzerTLD is

  port (
    CLOCK_50 : in  std_logic;
    LED      : out std_logic_vector(7 downto 0);
    KEY      : in  std_logic_vector(1 downto 0);
    GPIO     : in  std_logic_vector(33 downto 0);
    GPIO_IN  : in  std_logic_vector(1 downto 0));

end entity LogicAnalyzerTLD;


architecture Behavioral of LogicAnalyzerTLD is


begin  -- architecture Behavioral



end architecture Behavioral;
