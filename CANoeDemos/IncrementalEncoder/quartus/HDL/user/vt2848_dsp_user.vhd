--============================================================================
--  This confidential and proprietary software may be used
--  only as authorized by a licensing agreement from
--  Vector Informatik GmbH.
--  In an event of publication, the following notice is applicable:
--
--  (C) COPYRIGHT 2012 VECTOR INFORMATIK GMBH
--  ALL RIGHTS RESERVED
--
--  The entire notice above must be reproduced on all authorized copies.
--
--  $Workfile: vt2848_dsp_user.vhd $
--  $Author: visstz $
--  $Date: 2019-03-27 09:48:32 +0100 (Mi, 27 Mrz 2019) $
--  $Revision: 101875 $
--  Abstract      :
--           FPGA top
--           contains CPU interface and functional top
--============================================================================



--=LIBRARY====================================================================
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

LIBRARY work;
USE work.global_definitions.ALL;
USE work.global_scale.ALL;
--============================================================================



--=ENTITY=====================================================================
ENTITY vt2848_dsp_user IS
  GENERIC (
    g_invar      : natural RANGE 0 TO 256;
    g_outvar     : natural RANGE 0 TO 256;
    --
    g_ibc_invar  : natural RANGE 0 TO 32;
    g_ibc_outvar : natural RANGE 0 TO 32);
  PORT (
    i_reset            : IN  std_logic;
    i_clock            : IN  std_logic;
    --
    i_insignal         : IN  std_logic_vector(47 DOWNTO 0);
    o_outsignal        : OUT std_logic_vector(47 DOWNTO 0)       := (OTHERS => '0');
    --
    i_timestamp        : IN  std_logic_vector(63 DOWNTO 0);
    i_invar            : IN  t_slv32_matrix(0 TO g_invar-1);
    i_invar_update     : IN  std_logic;
    o_outvar           : OUT t_slv32_matrix(0 TO g_outvar-1)     := (OTHERS => (OTHERS => '0'));
    --
    i_ibc_sync         : IN  std_logic;
    i_ibc_ready        : IN  std_logic;
    i_ibc_busy         : IN  std_logic;
    o_ibc_error_clear  : OUT std_logic_vector(7 DOWNTO 0);
    i_ibc_error        : IN  std_logic_vector(7 DOWNTO 0);
    i_ibc_invar_update : IN  std_logic_vector(g_ibc_invar-1 DOWNTO 0);
    i_ibc_invar        : IN  t_slv32_matrix(0 TO g_ibc_invar-1);
    i_ibc_outvar_busy  : IN  std_logic;
    o_ibc_outvar       : OUT t_slv32_matrix(0 TO g_ibc_outvar-1) := (OTHERS => (OTHERS => '0'));
    --
    i_ibc              : IN  std_logic_vector(3 DOWNTO 0);
    o_ibc              : OUT std_logic_vector(3 DOWNTO 0)        := (OTHERS => '0');
    --
    o_debug_led        : OUT std_logic_vector(4 DOWNTO 0)        := (OTHERS => '0'));
END vt2848_dsp_user;


--=ARCHITECTURE===============================================================
ARCHITECTURE rtl OF vt2848_dsp_user IS

  -- @CMD=COMPONENTSTART
COMPONENT User IS
  GENERIC (
    -- @CMD=CONSTSSTART
    fpga_frequency : std_logic_vector(31 DOWNTO 0) := 32d"80000000"
   -- @CMD=CONSTSEND
    );
  PORT (
    --
    -- @CMD=SYSVARSTART
    AtrailsB_ch1 : in std_logic_vector(0 downto 0);
    AtrailsB_ch4 : in std_logic_vector(0 downto 0);
    AtrailsB_ch7 : in std_logic_vector(0 downto 0);
    AtrailsB_ch10 : in std_logic_vector(0 downto 0);
    AtrailsB_ch13 : in std_logic_vector(0 downto 0);
    AtrailsB_ch16 : in std_logic_vector(0 downto 0);
    AtrailsB_ch19 : in std_logic_vector(0 downto 0);
    AtrailsB_ch22 : in std_logic_vector(0 downto 0);
    Position_ch1 : out std_logic_vector(31 downto 0) := (others => '0');
    Position_ch4 : out std_logic_vector(31 downto 0) := (others => '0');
    Position_ch7 : out std_logic_vector(31 downto 0) := (others => '0');
    Position_ch10 : out std_logic_vector(31 downto 0) := (others => '0');
    Position_ch13 : out std_logic_vector(31 downto 0) := (others => '0');
    Position_ch16 : out std_logic_vector(31 downto 0) := (others => '0');
    Position_ch19 : out std_logic_vector(31 downto 0) := (others => '0');
    Position_ch22 : out std_logic_vector(31 downto 0) := (others => '0');
    Error_ch1 : out std_logic_vector(0 downto 0) := (others => '0');
    Error_ch4 : out std_logic_vector(0 downto 0) := (others => '0');
    Error_ch7 : out std_logic_vector(0 downto 0) := (others => '0');
    Error_ch10 : out std_logic_vector(0 downto 0) := (others => '0');
    Error_ch13 : out std_logic_vector(0 downto 0) := (others => '0');
    Error_ch16 : out std_logic_vector(0 downto 0) := (others => '0');
    Error_ch19 : out std_logic_vector(0 downto 0) := (others => '0');
    Error_ch22 : out std_logic_vector(0 downto 0) := (others => '0');
    ResetPosition_ch1 : in std_logic_vector(0 downto 0);
    ResetPosition_ch4 : in std_logic_vector(0 downto 0);
    ResetPosition_ch7 : in std_logic_vector(0 downto 0);
    ResetPosition_ch10 : in std_logic_vector(0 downto 0);
    ResetPosition_ch13 : in std_logic_vector(0 downto 0);
    ResetPosition_ch16 : in std_logic_vector(0 downto 0);
    ResetPosition_ch19 : in std_logic_vector(0 downto 0);
    ResetPosition_ch22 : in std_logic_vector(0 downto 0);
    ResetError_ch1 : in std_logic_vector(0 downto 0);
    ResetError_ch4 : in std_logic_vector(0 downto 0);
    ResetError_ch7 : in std_logic_vector(0 downto 0);
    ResetError_ch10 : in std_logic_vector(0 downto 0);
    ResetError_ch13 : in std_logic_vector(0 downto 0);
    ResetError_ch16 : in std_logic_vector(0 downto 0);
    ResetError_ch19 : in std_logic_vector(0 downto 0);
    ResetError_ch22 : in std_logic_vector(0 downto 0);
    AutoMaxPosition_ch1 : in std_logic_vector(0 downto 0);
    AutoMaxPosition_ch4 : in std_logic_vector(0 downto 0);
    AutoMaxPosition_ch7 : in std_logic_vector(0 downto 0);
    AutoMaxPosition_ch10 : in std_logic_vector(0 downto 0);
    AutoMaxPosition_ch13 : in std_logic_vector(0 downto 0);
    AutoMaxPosition_ch16 : in std_logic_vector(0 downto 0);
    AutoMaxPosition_ch19 : in std_logic_vector(0 downto 0);
    AutoMaxPosition_ch22 : in std_logic_vector(0 downto 0);
    MaxPosition_ch1 : in std_logic_vector(31 downto 0);
    MaxPosition_ch4 : in std_logic_vector(31 downto 0);
    MaxPosition_ch7 : in std_logic_vector(31 downto 0);
    MaxPosition_ch10 : in std_logic_vector(31 downto 0);
    MaxPosition_ch13 : in std_logic_vector(31 downto 0);
    MaxPosition_ch16 : in std_logic_vector(31 downto 0);
    MaxPosition_ch19 : in std_logic_vector(31 downto 0);
    MaxPosition_ch22 : in std_logic_vector(31 downto 0);
    NumOfTeeth_ch25 : in std_logic_vector(15 downto 0);
    NumOfTeeth_ch28 : in std_logic_vector(15 downto 0);
    NumOfTeeth_ch31 : in std_logic_vector(15 downto 0);
    NumOfTeeth_ch34 : in std_logic_vector(15 downto 0);
    NumOfTeeth_ch37 : in std_logic_vector(15 downto 0);
    NumOfTeeth_ch40 : in std_logic_vector(15 downto 0);
    NumOfTeeth_ch43 : in std_logic_vector(15 downto 0);
    NumOfTeeth_ch46 : in std_logic_vector(15 downto 0);
    StatesPerTooth_ch25 : in std_logic_vector(15 downto 0);
    StatesPerTooth_ch28 : in std_logic_vector(15 downto 0);
    StatesPerTooth_ch31 : in std_logic_vector(15 downto 0);
    StatesPerTooth_ch34 : in std_logic_vector(15 downto 0);
    StatesPerTooth_ch37 : in std_logic_vector(15 downto 0);
    StatesPerTooth_ch40 : in std_logic_vector(15 downto 0);
    StatesPerTooth_ch43 : in std_logic_vector(15 downto 0);
    StatesPerTooth_ch46 : in std_logic_vector(15 downto 0);
    SignalA_RisingEdgeState_ch25 : in std_logic_vector(15 downto 0);
    SignalA_RisingEdgeState_ch28 : in std_logic_vector(15 downto 0);
    SignalA_RisingEdgeState_ch31 : in std_logic_vector(15 downto 0);
    SignalA_RisingEdgeState_ch34 : in std_logic_vector(15 downto 0);
    SignalA_RisingEdgeState_ch37 : in std_logic_vector(15 downto 0);
    SignalA_RisingEdgeState_ch40 : in std_logic_vector(15 downto 0);
    SignalA_RisingEdgeState_ch43 : in std_logic_vector(15 downto 0);
    SignalA_RisingEdgeState_ch46 : in std_logic_vector(15 downto 0);
    SignalA_FallingEdgeState_ch25 : in std_logic_vector(15 downto 0);
    SignalA_FallingEdgeState_ch28 : in std_logic_vector(15 downto 0);
    SignalA_FallingEdgeState_ch31 : in std_logic_vector(15 downto 0);
    SignalA_FallingEdgeState_ch34 : in std_logic_vector(15 downto 0);
    SignalA_FallingEdgeState_ch37 : in std_logic_vector(15 downto 0);
    SignalA_FallingEdgeState_ch40 : in std_logic_vector(15 downto 0);
    SignalA_FallingEdgeState_ch43 : in std_logic_vector(15 downto 0);
    SignalA_FallingEdgeState_ch46 : in std_logic_vector(15 downto 0);
    SignalB_RisingEdgeState_ch25 : in std_logic_vector(15 downto 0);
    SignalB_RisingEdgeState_ch28 : in std_logic_vector(15 downto 0);
    SignalB_RisingEdgeState_ch31 : in std_logic_vector(15 downto 0);
    SignalB_RisingEdgeState_ch34 : in std_logic_vector(15 downto 0);
    SignalB_RisingEdgeState_ch37 : in std_logic_vector(15 downto 0);
    SignalB_RisingEdgeState_ch40 : in std_logic_vector(15 downto 0);
    SignalB_RisingEdgeState_ch43 : in std_logic_vector(15 downto 0);
    SignalB_RisingEdgeState_ch46 : in std_logic_vector(15 downto 0);
    SignalB_FallingEdgeState_ch25 : in std_logic_vector(15 downto 0);
    SignalB_FallingEdgeState_ch28 : in std_logic_vector(15 downto 0);
    SignalB_FallingEdgeState_ch31 : in std_logic_vector(15 downto 0);
    SignalB_FallingEdgeState_ch34 : in std_logic_vector(15 downto 0);
    SignalB_FallingEdgeState_ch37 : in std_logic_vector(15 downto 0);
    SignalB_FallingEdgeState_ch40 : in std_logic_vector(15 downto 0);
    SignalB_FallingEdgeState_ch43 : in std_logic_vector(15 downto 0);
    SignalB_FallingEdgeState_ch46 : in std_logic_vector(15 downto 0);
    SignalIndex_RisingEdgeTooth_ch25 : in std_logic_vector(15 downto 0);
    SignalIndex_RisingEdgeTooth_ch28 : in std_logic_vector(15 downto 0);
    SignalIndex_RisingEdgeTooth_ch31 : in std_logic_vector(15 downto 0);
    SignalIndex_RisingEdgeTooth_ch34 : in std_logic_vector(15 downto 0);
    SignalIndex_RisingEdgeTooth_ch37 : in std_logic_vector(15 downto 0);
    SignalIndex_RisingEdgeTooth_ch40 : in std_logic_vector(15 downto 0);
    SignalIndex_RisingEdgeTooth_ch43 : in std_logic_vector(15 downto 0);
    SignalIndex_RisingEdgeTooth_ch46 : in std_logic_vector(15 downto 0);
    SignalIndex_RisingEdgeState_ch25 : in std_logic_vector(15 downto 0);
    SignalIndex_RisingEdgeState_ch28 : in std_logic_vector(15 downto 0);
    SignalIndex_RisingEdgeState_ch31 : in std_logic_vector(15 downto 0);
    SignalIndex_RisingEdgeState_ch34 : in std_logic_vector(15 downto 0);
    SignalIndex_RisingEdgeState_ch37 : in std_logic_vector(15 downto 0);
    SignalIndex_RisingEdgeState_ch40 : in std_logic_vector(15 downto 0);
    SignalIndex_RisingEdgeState_ch43 : in std_logic_vector(15 downto 0);
    SignalIndex_RisingEdgeState_ch46 : in std_logic_vector(15 downto 0);
    SignalIndex_FallingEdgeTooth_ch25 : in std_logic_vector(15 downto 0);
    SignalIndex_FallingEdgeTooth_ch28 : in std_logic_vector(15 downto 0);
    SignalIndex_FallingEdgeTooth_ch31 : in std_logic_vector(15 downto 0);
    SignalIndex_FallingEdgeTooth_ch34 : in std_logic_vector(15 downto 0);
    SignalIndex_FallingEdgeTooth_ch37 : in std_logic_vector(15 downto 0);
    SignalIndex_FallingEdgeTooth_ch40 : in std_logic_vector(15 downto 0);
    SignalIndex_FallingEdgeTooth_ch43 : in std_logic_vector(15 downto 0);
    SignalIndex_FallingEdgeTooth_ch46 : in std_logic_vector(15 downto 0);
    SignalIndex_FallingEdgeState_ch25 : in std_logic_vector(15 downto 0);
    SignalIndex_FallingEdgeState_ch28 : in std_logic_vector(15 downto 0);
    SignalIndex_FallingEdgeState_ch31 : in std_logic_vector(15 downto 0);
    SignalIndex_FallingEdgeState_ch34 : in std_logic_vector(15 downto 0);
    SignalIndex_FallingEdgeState_ch37 : in std_logic_vector(15 downto 0);
    SignalIndex_FallingEdgeState_ch40 : in std_logic_vector(15 downto 0);
    SignalIndex_FallingEdgeState_ch43 : in std_logic_vector(15 downto 0);
    SignalIndex_FallingEdgeState_ch46 : in std_logic_vector(15 downto 0);
    ResetPosition_ch25 : in std_logic_vector(0 downto 0);
    ResetPosition_ch28 : in std_logic_vector(0 downto 0);
    ResetPosition_ch31 : in std_logic_vector(0 downto 0);
    ResetPosition_ch34 : in std_logic_vector(0 downto 0);
    ResetPosition_ch37 : in std_logic_vector(0 downto 0);
    ResetPosition_ch40 : in std_logic_vector(0 downto 0);
    ResetPosition_ch43 : in std_logic_vector(0 downto 0);
    ResetPosition_ch46 : in std_logic_vector(0 downto 0);
    Frequency_ch25 : in std_logic_vector(31 downto 0);
    Frequency_ch28 : in std_logic_vector(31 downto 0);
    Frequency_ch31 : in std_logic_vector(31 downto 0);
    Frequency_ch34 : in std_logic_vector(31 downto 0);
    Frequency_ch37 : in std_logic_vector(31 downto 0);
    Frequency_ch40 : in std_logic_vector(31 downto 0);
    Frequency_ch43 : in std_logic_vector(31 downto 0);
    Frequency_ch46 : in std_logic_vector(31 downto 0);
    PhaseDifference_ch1 : out std_logic_vector(31 downto 0) := (others => '0');
    PhaseDifference_ch4 : out std_logic_vector(31 downto 0) := (others => '0');
    PhaseDifference_ch7 : out std_logic_vector(31 downto 0) := (others => '0');
    PhaseDifference_ch10 : out std_logic_vector(31 downto 0) := (others => '0');
    PhaseDifference_ch13 : out std_logic_vector(31 downto 0) := (others => '0');
    PhaseDifference_ch16 : out std_logic_vector(31 downto 0) := (others => '0');
    PhaseDifference_ch19 : out std_logic_vector(31 downto 0) := (others => '0');
    PhaseDifference_ch22 : out std_logic_vector(31 downto 0) := (others => '0');
    -- @CMD=SYSVAREND
    --
    -- @CMD=TIMESTAMPSTART
    -- @CMD=TIMESTAMPEND
    --
    -- @CMD=IBCSTART
    in_ibc_1   : IN std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- in_ibc_1.wire
    in_ibc_2   : IN std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- in_ibc_2.wire
    in_ibc_3   : IN std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- in_ibc_3.wire
    in_ibc_4   : IN std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- in_ibc_4.wire

    out_ibc_1   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- out_ibc_1.wire
    out_ibc_2   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- out_ibc_2.wire
    out_ibc_3   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- out_ibc_3.wire
    out_ibc_4   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- out_ibc_4.wire
    -- @CMD=IBCEND
    --
    clk             : IN  std_logic;                                        -- Clock.clk
    areset          : IN  std_logic;                                        -- .reset
    h_areset        : IN  std_logic;
    --
    in_signal_1     : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 1 digital input
    in_signal_2     : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 2 digital input
    in_signal_3     : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 3 digital input
    in_signal_4     : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 4 digital input
    in_signal_5     : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 5 digital input
    in_signal_6     : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 6 digital input
    in_signal_7     : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 7 digital input
    in_signal_8     : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 8 digital input
    in_signal_9     : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 9 digital input
    in_signal_10    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 10 digital input
    in_signal_11    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 11 digital input
    in_signal_12    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 12 digital input
    in_signal_13    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 13 digital input
    in_signal_14    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 14 digital input
    in_signal_15    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 15 digital input
    in_signal_16    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 16 digital input
    in_signal_17    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 17 digital input
    in_signal_18    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 18 digital input
    in_signal_19    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 19 digital input
    in_signal_20    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 20 digital input
    in_signal_21    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 21 digital input
    in_signal_22    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 22 digital input
    in_signal_23    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 23 digital input
    in_signal_24    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 24 digital input
    in_signal_25    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 25 digital input
    in_signal_26    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 26 digital input
    in_signal_27    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 27 digital input
    in_signal_28    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 28 digital input
    in_signal_29    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 29 digital input
    in_signal_30    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 30 digital input
    in_signal_31    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 31 digital input
    in_signal_32    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 32 digital input
    in_signal_33    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 33 digital input
    in_signal_34    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 34 digital input
    in_signal_35    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 35 digital input
    in_signal_36    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 36 digital input
    in_signal_37    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 37 digital input
    in_signal_38    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 38 digital input
    in_signal_39    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 39 digital input
    in_signal_40    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 40 digital input
    in_signal_41    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 41 digital input
    in_signal_42    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 42 digital input
    in_signal_43    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 43 digital input
    in_signal_44    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 44 digital input
    in_signal_45    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 45 digital input
    in_signal_46    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 46 digital input
    in_signal_47    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 47 digital input
    in_signal_48    : IN  std_logic_vector(0 DOWNTO 0);                     -- channel 48 digital input
    --
    out_signal_1    : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 1 digital output
    out_signal_2    : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 2 digital output
    out_signal_3    : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 3 digital output
    out_signal_4    : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 4 digital output
    out_signal_5    : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 5 digital output
    out_signal_6    : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 6 digital output
    out_signal_7    : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 7 digital output
    out_signal_8    : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 8 digital output
    out_signal_9    : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 9 digital output
    out_signal_10   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 10 digital output
    out_signal_11   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 11 digital output
    out_signal_12   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 12 digital output
    out_signal_13   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 13 digital output
    out_signal_14   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 14 digital output
    out_signal_15   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 15 digital output
    out_signal_16   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 16 digital output
    out_signal_17   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 17 digital output
    out_signal_18   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 18 digital output
    out_signal_19   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 19 digital output
    out_signal_20   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 20 digital output
    out_signal_21   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 21 digital output
    out_signal_22   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 22 digital output
    out_signal_23   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 23 digital output
    out_signal_24   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 24 digital output
    out_signal_25   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 25 digital output
    out_signal_26   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 26 digital output
    out_signal_27   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 27 digital output
    out_signal_28   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 28 digital output
    out_signal_29   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 29 digital output
    out_signal_30   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 30 digital output
    out_signal_31   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 31 digital output
    out_signal_32   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 32 digital output
    out_signal_33   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 33 digital output
    out_signal_34   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 34 digital output
    out_signal_35   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 35 digital output
    out_signal_36   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 36 digital output
    out_signal_37   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 37 digital output
    out_signal_38   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 38 digital output
    out_signal_39   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 39 digital output
    out_signal_40   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 40 digital output
    out_signal_41   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 41 digital output
    out_signal_42   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 42 digital output
    out_signal_43   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 43 digital output
    out_signal_44   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 44 digital output
    out_signal_45   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 45 digital output
    out_signal_46   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 46 digital output
    out_signal_47   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 47 digital output
    out_signal_48   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- channel 48 digital output
    --
    in_invar_update : IN  std_logic;                                        -- invar update notification
    in_timestamp    : IN  std_logic_vector(63 DOWNTO 0);                    -- current module time
    --
    debug_LED_1     : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- debug LED 1
    debug_LED_2     : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- debug LED 2
    debug_LED_3     : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- debug LED 3
    debug_LED_4     : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- debug LED 4
    debug_LED_5     : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0')   -- debug LED 5
    );
END COMPONENT;
  -- @CMD=COMPONENTEND

BEGIN

  -- @CMD=PORTMAPSTART
inst_name : User
port map(
areset => i_reset,
clk => i_clock,
debug_LED_1(0) => o_debug_led(0),
debug_LED_2(0) => o_debug_led(1),
debug_LED_3(0) => o_debug_led(2),
debug_LED_4(0) => o_debug_led(3),
debug_LED_5(0) => o_debug_led(4),
h_areset => i_reset,
in_ibc_1(0) => i_ibc(0),
in_ibc_2(0) => i_ibc(1),
in_ibc_3(0) => i_ibc(2),
in_ibc_4(0) => i_ibc(3),
in_invar_update => i_invar_update,
in_signal_1(0) => i_insignal(0),
in_signal_10(0) => i_insignal(9),
in_signal_11(0) => i_insignal(10),
in_signal_12(0) => i_insignal(11),
in_signal_13(0) => i_insignal(12),
in_signal_14(0) => i_insignal(13),
in_signal_15(0) => i_insignal(14),
in_signal_16(0) => i_insignal(15),
in_signal_17(0) => i_insignal(16),
in_signal_18(0) => i_insignal(17),
in_signal_19(0) => i_insignal(18),
in_signal_2(0) => i_insignal(1),
in_signal_20(0) => i_insignal(19),
in_signal_21(0) => i_insignal(20),
in_signal_22(0) => i_insignal(21),
in_signal_23(0) => i_insignal(22),
in_signal_24(0) => i_insignal(23),
in_signal_25(0) => i_insignal(24),
in_signal_26(0) => i_insignal(25),
in_signal_27(0) => i_insignal(26),
in_signal_28(0) => i_insignal(27),
in_signal_29(0) => i_insignal(28),
in_signal_3(0) => i_insignal(2),
in_signal_30(0) => i_insignal(29),
in_signal_31(0) => i_insignal(30),
in_signal_32(0) => i_insignal(31),
in_signal_33(0) => i_insignal(32),
in_signal_34(0) => i_insignal(33),
in_signal_35(0) => i_insignal(34),
in_signal_36(0) => i_insignal(35),
in_signal_37(0) => i_insignal(36),
in_signal_38(0) => i_insignal(37),
in_signal_39(0) => i_insignal(38),
in_signal_4(0) => i_insignal(3),
in_signal_40(0) => i_insignal(39),
in_signal_41(0) => i_insignal(40),
in_signal_42(0) => i_insignal(41),
in_signal_43(0) => i_insignal(42),
in_signal_44(0) => i_insignal(43),
in_signal_45(0) => i_insignal(44),
in_signal_46(0) => i_insignal(45),
in_signal_47(0) => i_insignal(46),
in_signal_48(0) => i_insignal(47),
in_signal_5(0) => i_insignal(4),
in_signal_6(0) => i_insignal(5),
in_signal_7(0) => i_insignal(6),
in_signal_8(0) => i_insignal(7),
in_signal_9(0) => i_insignal(8),
in_timestamp => i_timestamp,
out_ibc_1(0) => o_ibc(0),
out_ibc_2(0) => o_ibc(1),
out_ibc_3(0) => o_ibc(2),
out_ibc_4(0) => o_ibc(3),
out_signal_1(0) => o_outsignal(0),
out_signal_10(0) => o_outsignal(9),
out_signal_11(0) => o_outsignal(10),
out_signal_12(0) => o_outsignal(11),
out_signal_13(0) => o_outsignal(12),
out_signal_14(0) => o_outsignal(13),
out_signal_15(0) => o_outsignal(14),
out_signal_16(0) => o_outsignal(15),
out_signal_17(0) => o_outsignal(16),
out_signal_18(0) => o_outsignal(17),
out_signal_19(0) => o_outsignal(18),
out_signal_2(0) => o_outsignal(1),
out_signal_20(0) => o_outsignal(19),
out_signal_21(0) => o_outsignal(20),
out_signal_22(0) => o_outsignal(21),
out_signal_23(0) => o_outsignal(22),
out_signal_24(0) => o_outsignal(23),
out_signal_25(0) => o_outsignal(24),
out_signal_26(0) => o_outsignal(25),
out_signal_27(0) => o_outsignal(26),
out_signal_28(0) => o_outsignal(27),
out_signal_29(0) => o_outsignal(28),
out_signal_3(0) => o_outsignal(2),
out_signal_30(0) => o_outsignal(29),
out_signal_31(0) => o_outsignal(30),
out_signal_32(0) => o_outsignal(31),
out_signal_33(0) => o_outsignal(32),
out_signal_34(0) => o_outsignal(33),
out_signal_35(0) => o_outsignal(34),
out_signal_36(0) => o_outsignal(35),
out_signal_37(0) => o_outsignal(36),
out_signal_38(0) => o_outsignal(37),
out_signal_39(0) => o_outsignal(38),
out_signal_4(0) => o_outsignal(3),
out_signal_40(0) => o_outsignal(39),
out_signal_41(0) => o_outsignal(40),
out_signal_42(0) => o_outsignal(41),
out_signal_43(0) => o_outsignal(42),
out_signal_44(0) => o_outsignal(43),
out_signal_45(0) => o_outsignal(44),
out_signal_46(0) => o_outsignal(45),
out_signal_47(0) => o_outsignal(46),
out_signal_48(0) => o_outsignal(47),
out_signal_5(0) => o_outsignal(4),
out_signal_6(0) => o_outsignal(5),
out_signal_7(0) => o_outsignal(6),
out_signal_8(0) => o_outsignal(7),
out_signal_9(0) => o_outsignal(8),
AtrailsB_ch1(0)   => i_invar(0)(0),
AtrailsB_ch10(0)   => i_invar(0)(1),
AtrailsB_ch13(0)   => i_invar(0)(2),
AtrailsB_ch16(0)   => i_invar(0)(3),
AtrailsB_ch19(0)   => i_invar(0)(4),
AtrailsB_ch22(0)   => i_invar(0)(5),
AtrailsB_ch4(0)   => i_invar(0)(6),
AtrailsB_ch7(0)   => i_invar(0)(7),
AutoMaxPosition_ch1(0)   => i_invar(0)(8),
AutoMaxPosition_ch10(0)   => i_invar(0)(9),
AutoMaxPosition_ch13(0)   => i_invar(0)(10),
AutoMaxPosition_ch16(0)   => i_invar(0)(11),
AutoMaxPosition_ch19(0)   => i_invar(0)(12),
AutoMaxPosition_ch22(0)   => i_invar(0)(13),
AutoMaxPosition_ch4(0)   => i_invar(0)(14),
AutoMaxPosition_ch7(0)   => i_invar(0)(15),
ResetError_ch1(0)   => i_invar(0)(16),
ResetError_ch10(0)   => i_invar(0)(17),
ResetError_ch13(0)   => i_invar(0)(18),
ResetError_ch16(0)   => i_invar(0)(19),
ResetError_ch19(0)   => i_invar(0)(20),
ResetError_ch22(0)   => i_invar(0)(21),
ResetError_ch4(0)   => i_invar(0)(22),
ResetError_ch7(0)   => i_invar(0)(23),
ResetPosition_ch1(0)   => i_invar(0)(24),
ResetPosition_ch10(0)   => i_invar(0)(25),
ResetPosition_ch13(0)   => i_invar(0)(26),
ResetPosition_ch16(0)   => i_invar(0)(27),
ResetPosition_ch19(0)   => i_invar(0)(28),
ResetPosition_ch22(0)   => i_invar(0)(29),
ResetPosition_ch25(0)   => i_invar(0)(30),
ResetPosition_ch28(0)   => i_invar(0)(31),
ResetPosition_ch31(0)   => i_invar(1)(0),
ResetPosition_ch34(0)   => i_invar(1)(1),
ResetPosition_ch37(0)   => i_invar(1)(2),
ResetPosition_ch4(0)   => i_invar(1)(3),
ResetPosition_ch40(0)   => i_invar(1)(4),
ResetPosition_ch43(0)   => i_invar(1)(5),
ResetPosition_ch46(0)   => i_invar(1)(6),
ResetPosition_ch7(0)   => i_invar(1)(7),
NumOfTeeth_ch25   => i_invar(1)(31 downto 16),
NumOfTeeth_ch28   => i_invar(2)(15 downto 0),
NumOfTeeth_ch31   => i_invar(2)(31 downto 16),
NumOfTeeth_ch34   => i_invar(3)(15 downto 0),
NumOfTeeth_ch37   => i_invar(3)(31 downto 16),
NumOfTeeth_ch40   => i_invar(4)(15 downto 0),
NumOfTeeth_ch43   => i_invar(4)(31 downto 16),
NumOfTeeth_ch46   => i_invar(5)(15 downto 0),
SignalA_FallingEdgeState_ch25   => i_invar(5)(31 downto 16),
SignalA_FallingEdgeState_ch28   => i_invar(6)(15 downto 0),
SignalA_FallingEdgeState_ch31   => i_invar(6)(31 downto 16),
SignalA_FallingEdgeState_ch34   => i_invar(7)(15 downto 0),
SignalA_FallingEdgeState_ch37   => i_invar(7)(31 downto 16),
SignalA_FallingEdgeState_ch40   => i_invar(8)(15 downto 0),
SignalA_FallingEdgeState_ch43   => i_invar(8)(31 downto 16),
SignalA_FallingEdgeState_ch46   => i_invar(9)(15 downto 0),
SignalA_RisingEdgeState_ch25   => i_invar(9)(31 downto 16),
SignalA_RisingEdgeState_ch28   => i_invar(10)(15 downto 0),
SignalA_RisingEdgeState_ch31   => i_invar(10)(31 downto 16),
SignalA_RisingEdgeState_ch34   => i_invar(11)(15 downto 0),
SignalA_RisingEdgeState_ch37   => i_invar(11)(31 downto 16),
SignalA_RisingEdgeState_ch40   => i_invar(12)(15 downto 0),
SignalA_RisingEdgeState_ch43   => i_invar(12)(31 downto 16),
SignalA_RisingEdgeState_ch46   => i_invar(13)(15 downto 0),
SignalB_FallingEdgeState_ch25   => i_invar(13)(31 downto 16),
SignalB_FallingEdgeState_ch28   => i_invar(14)(15 downto 0),
SignalB_FallingEdgeState_ch31   => i_invar(14)(31 downto 16),
SignalB_FallingEdgeState_ch34   => i_invar(15)(15 downto 0),
SignalB_FallingEdgeState_ch37   => i_invar(15)(31 downto 16),
SignalB_FallingEdgeState_ch40   => i_invar(16)(15 downto 0),
SignalB_FallingEdgeState_ch43   => i_invar(16)(31 downto 16),
SignalB_FallingEdgeState_ch46   => i_invar(17)(15 downto 0),
SignalB_RisingEdgeState_ch25   => i_invar(17)(31 downto 16),
SignalB_RisingEdgeState_ch28   => i_invar(18)(15 downto 0),
SignalB_RisingEdgeState_ch31   => i_invar(18)(31 downto 16),
SignalB_RisingEdgeState_ch34   => i_invar(19)(15 downto 0),
SignalB_RisingEdgeState_ch37   => i_invar(19)(31 downto 16),
SignalB_RisingEdgeState_ch40   => i_invar(20)(15 downto 0),
SignalB_RisingEdgeState_ch43   => i_invar(20)(31 downto 16),
SignalB_RisingEdgeState_ch46   => i_invar(21)(15 downto 0),
SignalIndex_FallingEdgeState_ch25   => i_invar(21)(31 downto 16),
SignalIndex_FallingEdgeState_ch28   => i_invar(22)(15 downto 0),
SignalIndex_FallingEdgeState_ch31   => i_invar(22)(31 downto 16),
SignalIndex_FallingEdgeState_ch34   => i_invar(23)(15 downto 0),
SignalIndex_FallingEdgeState_ch37   => i_invar(23)(31 downto 16),
SignalIndex_FallingEdgeState_ch40   => i_invar(24)(15 downto 0),
SignalIndex_FallingEdgeState_ch43   => i_invar(24)(31 downto 16),
SignalIndex_FallingEdgeState_ch46   => i_invar(25)(15 downto 0),
SignalIndex_FallingEdgeTooth_ch25   => i_invar(25)(31 downto 16),
SignalIndex_FallingEdgeTooth_ch28   => i_invar(26)(15 downto 0),
SignalIndex_FallingEdgeTooth_ch31   => i_invar(26)(31 downto 16),
SignalIndex_FallingEdgeTooth_ch34   => i_invar(27)(15 downto 0),
SignalIndex_FallingEdgeTooth_ch37   => i_invar(27)(31 downto 16),
SignalIndex_FallingEdgeTooth_ch40   => i_invar(28)(15 downto 0),
SignalIndex_FallingEdgeTooth_ch43   => i_invar(28)(31 downto 16),
SignalIndex_FallingEdgeTooth_ch46   => i_invar(29)(15 downto 0),
SignalIndex_RisingEdgeState_ch25   => i_invar(29)(31 downto 16),
SignalIndex_RisingEdgeState_ch28   => i_invar(30)(15 downto 0),
SignalIndex_RisingEdgeState_ch31   => i_invar(30)(31 downto 16),
SignalIndex_RisingEdgeState_ch34   => i_invar(31)(15 downto 0),
SignalIndex_RisingEdgeState_ch37   => i_invar(31)(31 downto 16),
SignalIndex_RisingEdgeState_ch40   => i_invar(32)(15 downto 0),
SignalIndex_RisingEdgeState_ch43   => i_invar(32)(31 downto 16),
SignalIndex_RisingEdgeState_ch46   => i_invar(33)(15 downto 0),
SignalIndex_RisingEdgeTooth_ch25   => i_invar(33)(31 downto 16),
SignalIndex_RisingEdgeTooth_ch28   => i_invar(34)(15 downto 0),
SignalIndex_RisingEdgeTooth_ch31   => i_invar(34)(31 downto 16),
SignalIndex_RisingEdgeTooth_ch34   => i_invar(35)(15 downto 0),
SignalIndex_RisingEdgeTooth_ch37   => i_invar(35)(31 downto 16),
SignalIndex_RisingEdgeTooth_ch40   => i_invar(36)(15 downto 0),
SignalIndex_RisingEdgeTooth_ch43   => i_invar(36)(31 downto 16),
SignalIndex_RisingEdgeTooth_ch46   => i_invar(37)(15 downto 0),
StatesPerTooth_ch25   => i_invar(37)(31 downto 16),
StatesPerTooth_ch28   => i_invar(38)(15 downto 0),
StatesPerTooth_ch31   => i_invar(38)(31 downto 16),
StatesPerTooth_ch34   => i_invar(39)(15 downto 0),
StatesPerTooth_ch37   => i_invar(39)(31 downto 16),
StatesPerTooth_ch40   => i_invar(40)(15 downto 0),
StatesPerTooth_ch43   => i_invar(40)(31 downto 16),
StatesPerTooth_ch46   => i_invar(41)(15 downto 0),
Frequency_ch25   => i_invar(42)(31 downto 0),
Frequency_ch28   => i_invar(43)(31 downto 0),
Frequency_ch31   => i_invar(44)(31 downto 0),
Frequency_ch34   => i_invar(45)(31 downto 0),
Frequency_ch37   => i_invar(46)(31 downto 0),
Frequency_ch40   => i_invar(47)(31 downto 0),
Frequency_ch43   => i_invar(48)(31 downto 0),
Frequency_ch46   => i_invar(49)(31 downto 0),
MaxPosition_ch1   => i_invar(50)(31 downto 0),
MaxPosition_ch10   => i_invar(51)(31 downto 0),
MaxPosition_ch13   => i_invar(52)(31 downto 0),
MaxPosition_ch16   => i_invar(53)(31 downto 0),
MaxPosition_ch19   => i_invar(54)(31 downto 0),
MaxPosition_ch22   => i_invar(55)(31 downto 0),
MaxPosition_ch4   => i_invar(56)(31 downto 0),
MaxPosition_ch7   => i_invar(57)(31 downto 0),
Error_ch1(0)   => o_outvar(0)(0),
Error_ch10(0)   => o_outvar(0)(1),
Error_ch13(0)   => o_outvar(0)(2),
Error_ch16(0)   => o_outvar(0)(3),
Error_ch19(0)   => o_outvar(0)(4),
Error_ch22(0)   => o_outvar(0)(5),
Error_ch4(0)   => o_outvar(0)(6),
Error_ch7(0)   => o_outvar(0)(7),
PhaseDifference_ch1   => o_outvar(1)(31 downto 0),
PhaseDifference_ch10   => o_outvar(2)(31 downto 0),
PhaseDifference_ch13   => o_outvar(3)(31 downto 0),
PhaseDifference_ch16   => o_outvar(4)(31 downto 0),
PhaseDifference_ch19   => o_outvar(5)(31 downto 0),
PhaseDifference_ch22   => o_outvar(6)(31 downto 0),
PhaseDifference_ch4   => o_outvar(7)(31 downto 0),
PhaseDifference_ch7   => o_outvar(8)(31 downto 0),
Position_ch1   => o_outvar(9)(31 downto 0),
Position_ch10   => o_outvar(10)(31 downto 0),
Position_ch13   => o_outvar(11)(31 downto 0),
Position_ch16   => o_outvar(12)(31 downto 0),
Position_ch19   => o_outvar(13)(31 downto 0),
Position_ch22   => o_outvar(14)(31 downto 0),
Position_ch4   => o_outvar(15)(31 downto 0),
Position_ch7   => o_outvar(16)(31 downto 0)
);
  -- @CMD=PORTMAPEND

END rtl;
