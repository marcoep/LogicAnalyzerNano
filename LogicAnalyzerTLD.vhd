-------------------------------------------------------------------------------
-- Title      : LogicAnalyzer Top Level Design
-- Project    : 
-------------------------------------------------------------------------------
-- File       : LogicAnalyzer.vhd
-- Author     :   <Marco@JUDI>
-- Company    : 
-- Created    : 2014-11-27
-- Last update: 2014-11-28
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


  component LogicAnalyzer is
    port (
      Clk_CI    : in  std_logic;
      Reset_RBI : in  std_logic;
      BusDI_DI  : in  std_logic;
      BusDO_DI  : in  std_logic;
      BusCS_DI  : in  std_logic;
      BusClk_SI : in  std_logic;
      Led_SO    : out std_logic;
      Btn_SI    : in  std_logic);
  end component LogicAnalyzer;
  
begin  -- architecture Behavioral

  LogicAnalyzer_1: entity work.LogicAnalyzer
    port map (
      Clk_CI    => CLOCK_50,
      Reset_RBI => KEY(0),
      BusDI_DI  => GPIO(4),
      BusDO_DI  => GPIO(2),
      BusCS_DI  => GPIO_IN(1),
      BusClk_SI => GPIO_IN(0),
      Led_SO    => LED(0),
      Btn_SI    => not KEY(1));

 
  LED(7 downto 1) <= "0000000";

end architecture Behavioral;
