-------------------------------------------------------------------------------
-- Title      : Logic Analyzer, actual module
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
    Reset_RBI : in std_logic;

    BusDI_DI  : in std_logic;
    BusDO_DI  : in std_logic;
    BusCS_DI  : in std_logic;
    BusClk_SI : in std_logic;

    Led_SO : out std_logic;
    Btn_SI : in  std_logic
    );
end entity LogicAnalyzer;


architecture Behavioral of LogicAnalyzer is


  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component StorageRAM is
    port (
      aclr    : in  std_logic := '0';
      address : in  std_logic_vector (12 downto 0);
      clock   : in  std_logic := '1';
      data    : in  std_logic_vector (2 downto 0);
      wren    : in  std_logic;
      q       : out std_logic_vector (2 downto 0));
  end component StorageRAM;


  -----------------------------------------------------------------------------
  -- Type Declarations
  -----------------------------------------------------------------------------

  type FsmState_t is (INIT, WAITCLK, SAVE, WAITCLKRESET, RAMFULL);

  -----------------------------------------------------------------------------
  -- Signal Declarations
  -----------------------------------------------------------------------------

  -- Data in Bus and its FFed signals
  signal Bus_D, BusF_D, BusFF_D : std_logic_vector(2 downto 0);

  -- Bus Clock signal
  signal BusClkF_S, BusClkFF_S : std_logic;

  -- Counter Data Signals
  signal AddrCnt_DP, AddrCnt_DN : unsigned(12 downto 0);

  -- Control Signals
  signal CntrEna_S, CntrEnded_S, BusClkOne_S, BusClkZero_S, RamWE_S : std_logic;
  signal State_SP, State_SN                                         : FsmState_t;


-----------------------------------------------------------------------------
--
--
--  Actual Implementation
--
--
-----------------------------------------------------------------------------
begin  -- architecture Behavioral


  BusClkZero_S <= not(BusClk_SI or BusClkF_S or BusClkFF_S);
  BusClkOne_S  <= (BusClk_SI and BusClkF_S and BusClkFF_S);


  Bus_D <= (BusDI_DI & BusDO_DI & BusCS_DI);


  StorageRAM_1 : entity work.StorageRAM
    port map (
      aclr    => Reset_RBI,
      address => std_logic_vector(AddrCnt_DP),
      clock   => Clk_CI,
      data    => BusFF_D,
      wren    => RamWE_S,
      q       => open);


  AddrCnt_DN <= AddrCnt_DP +1;
  AddressCounter : process (Clk_CI, Reset_RBI) is
  begin  -- process AddressCounter
    if Reset_RBI = '0' then             -- asynchronous reset (active low)
      AddrCnt_DP <= (others => '0');
    elsif Clk_CI'event and Clk_CI = '1' then  -- rising clock edge
      if CntrEna_S = '1' then
        AddrCnt_DP <= AddrCnt_DN;
      end if;
    end if;
  end process AddressCounter;


  BusAndClockFF : process (Clk_CI, Reset_RBI) is
  begin  -- process Bus and Clock Flipflops
    if Reset_RBI = '0' then             -- asynchronous reset (active low)
      BusF_D     <= (others => '0');
      BusFF_D    <= (others => '0');
      BusClkF_S  <= '0';
      BusClkFF_S <= '0';
    elsif Clk_CI'event and Clk_CI = '1' then  -- rising clock edge
      BusF_D     <= Bus_D;
      BusFF_D    <= BusF_D;
      BusClkF_S  <= BusClk_SI;
      BusClkFF_S <= BusClkF_S;
    end if;
  end process BusAndClockFF;



-----------------------------------------------------------------------------
-- FSM
-----------------------------------------------------------------------------


  FSMNextState : process (AddrCnt_DP, Btn_SI, BusClkOne_S, BusClkZero_S,
                          BusFF_D(0), State_SP) is
  begin  -- process FSMNextState

    RamWE_S   <= '0';
    CntrEna_S <= '0';
    Led_SO    <= '0';
    State_SN  <= State_SP;

    case State_SP is
      -------------------------------------------------------------------------
      when INIT =>
        if BusFF_D(0) = '1' then
          State_SN <= WAITCLK;
        end if;
      -----------------------------------------------------------------------
      when WAITCLK =>
        if BusClkOne_S = '1' then
          State_SN <= SAVE;
        end if;
        if AddrCnt_DP = "1111111111111" or Btn_SI = '1' then
          State_SN <= RAMFULL;
        end if;
      -------------------------------------------------------------------------
      when RAMFULL =>
        Led_SO <= '1';
      -------------------------------------------------------------------------
      when SAVE =>
        RamWE_S   <= '1';
        CntrEna_S <= '1';
        State_SN  <= WAITCLKRESET;
      -------------------------------------------------------------------------
      when WAITCLKRESET =>
        if BusClkZero_S = '1' then
          State_SN <= WAITCLK;
    end if;
    -------------------------------------------------------------------------
    when others =>
    State_SN <= INIT;
  end case;
end process FSMNextState;


FSMProgress : process (Clk_CI, Reset_RBI) is
begin  -- process FSMProgress
  if Reset_RBI = '0' then                   -- asynchronous reset (active low)
    State_SP <= INIT;
  elsif Clk_CI'event and Clk_CI = '1' then  -- rising clock edge
    State_SP <= State_SN;
  end if;
end process FSMProgress;

end architecture Behavioral;
