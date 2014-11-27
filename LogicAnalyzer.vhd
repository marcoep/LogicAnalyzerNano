-------------------------------------------------------------------------------
-- Title      : Logic Analyzer, actual module
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
-- Description: Logic Analyzer Top Level design, with right Input Names etc.
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

entity LogicAnalyzer is

  port (
    Clk_CI    : in std_logic;
    Reset_RBI : in std_logic

    );
end entity LogicAnalyzer;


