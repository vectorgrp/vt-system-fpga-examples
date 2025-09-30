-- Copyright (c) 2025 Vector Informatik GmbH

-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:

-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
-- LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
-- OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


-- User code VHD file

-- The VT2848 The VT2848 General-Purpose Digital I/O Module has 48 channels,
-- each of which can be used as input or output. Each channel is connected using
-- one line (single-ended). The signals are referenced to the ECU ground, which is
-- connected to the VT2848 separately. A maximum voltage of 60 V is permissible
-- between the signal line and the ECU ground. Voltages are applied via two connections,
-- Vbatt (ECU power supply) and Vext (external power supply), which can be switched to
-- the module's outputs as needed.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

LIBRARY work;
USE work.LibraryBase.ALL;


ENTITY User IS
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
END;

ARCHITECTURE rtl OF User IS

  -- encoder
  CONSTANT c_EncoderChannels          : natural := 8;
  SUBTYPE c_EncoderChannelsRange IS natural RANGE 1 TO c_EncoderChannels;
  -- decoder
  CONSTANT c_DecoderChannels          : natural := 8;
  SUBTYPE c_DecoderChannelsRange IS natural RANGE 1 TO c_DecoderChannels;
  -- phase measurement
  CONSTANT c_PhaseMeasurementChannels : natural := 8;
  SUBTYPE c_PhaseMeasurementChannelsRange IS natural RANGE 1 TO c_PhaseMeasurementChannels;
  --
  TYPE t_PhaseAccumulatorChannels IS RECORD
    Active               : t_ArrayLogic(c_EncoderChannelsRange);
    StartValue           : t_ArrayVector(c_EncoderChannelsRange)(Frequency_ch25'range);
    SetStartValue        : t_ArrayLogic(c_EncoderChannelsRange);
    FrequencyControlWord : t_ArrayVector(c_EncoderChannelsRange)(Frequency_ch25'range);
    CounterValue         : t_ArrayVector(c_EncoderChannelsRange)(Frequency_ch25'range);
    Overflow             : t_ArrayLogic(c_EncoderChannelsRange);
  END RECORD;
  --
  TYPE t_EncoderChannels IS RECORD
    NumOfTeeth                   : t_ArrayVector(c_EncoderChannelsRange)(NumOfTeeth_ch25'range);
    StatesPerTooth               : t_ArrayVector(c_EncoderChannelsRange)(StatesPerTooth_ch25'range);
    SignalA_RisingEdgeState      : t_ArrayVector(c_EncoderChannelsRange)(SignalA_RisingEdgeState_ch25'range);
    SignalA_FallingEdgeState     : t_ArrayVector(c_EncoderChannelsRange)(SignalA_FallingEdgeState_ch25'range);
    SignalB_RisingEdgeState      : t_ArrayVector(c_EncoderChannelsRange)(SignalB_RisingEdgeState_ch25'range);
    SignalB_FallingEdgeState     : t_ArrayVector(c_EncoderChannelsRange)(SignalB_FallingEdgeState_ch25'range);
    SignalIndex_RisingEdgeTooth  : t_ArrayVector(c_EncoderChannelsRange)(SignalIndex_RisingEdgeTooth_ch25'range);
    SignalIndex_RisingEdgeState  : t_ArrayVector(c_EncoderChannelsRange)(SignalIndex_RisingEdgeState_ch25'range);
    SignalIndex_FallingEdgeTooth : t_ArrayVector(c_EncoderChannelsRange)(SignalIndex_FallingEdgeTooth_ch25'range);
    SignalIndex_FallingEdgeState : t_ArrayVector(c_EncoderChannelsRange)(SignalIndex_FallingEdgeState_ch25'range);
    NextState                    : t_ArrayLogic(c_EncoderChannelsRange);
    PreviousState                : t_ArrayLogic(c_EncoderChannelsRange);
    ResetPosition                : t_ArrayLogic(c_EncoderChannelsRange);
    SignalA                      : t_ArrayLogic(c_EncoderChannelsRange);
    SignalB                      : t_ArrayLogic(c_EncoderChannelsRange);
    SignalIndex                  : t_ArrayLogic(c_EncoderChannelsRange);
  END RECORD;
  --
  TYPE t_DecoderChannels IS RECORD
    AtrailsB        : t_ArrayLogic(c_DecoderChannelsRange);
    SignalA         : t_ArrayLogic(c_DecoderChannelsRange);
    SignalB         : t_ArrayLogic(c_DecoderChannelsRange);
    SignalIndex     : t_ArrayLogic(c_DecoderChannelsRange);
    ResetPosition   : t_ArrayLogic(c_DecoderChannelsRange);
    ResetError      : t_ArrayLogic(c_DecoderChannelsRange);
    AutoMaxPosition : t_ArrayLogic(c_DecoderChannelsRange);
    MaxPosition     : t_ArrayVector(c_DecoderChannelsRange)(MaxPosition_ch1'range);
    Position        : t_ArrayVector(c_DecoderChannelsRange)(Position_ch1'range);
    ErrorFlag       : t_ArrayLogic(c_DecoderChannelsRange);
  END RECORD;
  --
  TYPE t_PhaseMeasurementChannels IS RECORD
    PhaseCounter    : t_ArrayVector(c_PhaseMeasurementChannelsRange)(PhaseDifference_ch1'range);
    PeriodCounter   : t_ArrayVector(c_PhaseMeasurementChannelsRange)(PhaseDifference_ch1'range);
    PhaseDifference : t_ArrayVector(c_PhaseMeasurementChannelsRange)(PhaseDifference_ch1'range);
    Numer           : std_logic_vector(31 DOWNTO 0);
    Denom           : std_logic_vector(31 DOWNTO 0);
    Quotient        : std_logic_vector(31 DOWNTO 0);
    Remain          : std_logic_vector(31 DOWNTO 0);
  END RECORD;
  --
  SIGNAL s_PhaseAccumulatorChannels : t_PhaseAccumulatorChannels := (
    Active               => (OTHERS => '1'),  -- always active
    StartValue           => (OTHERS => (OTHERS => '0')),
    SetStartValue        => (OTHERS => '0'),
    FrequencyControlWord => (OTHERS => (OTHERS => '0')),
    CounterValue         => (OTHERS => (OTHERS => '0')),
    Overflow             => (OTHERS => '0'));
  --
  SIGNAL s_EncoderChannels : t_EncoderChannels := (
    NumOfTeeth                   => (OTHERS => (OTHERS => '0')),
    StatesPerTooth               => (OTHERS => (OTHERS => '0')),
    SignalA_RisingEdgeState      => (OTHERS => (OTHERS => '0')),
    SignalA_FallingEdgeState     => (OTHERS => (OTHERS => '0')),
    SignalB_RisingEdgeState      => (OTHERS => (OTHERS => '0')),
    SignalB_FallingEdgeState     => (OTHERS => (OTHERS => '0')),
    SignalIndex_RisingEdgeTooth  => (OTHERS => (OTHERS => '0')),
    SignalIndex_RisingEdgeState  => (OTHERS => (OTHERS => '0')),
    SignalIndex_FallingEdgeTooth => (OTHERS => (OTHERS => '0')),
    SignalIndex_FallingEdgeState => (OTHERS => (OTHERS => '0')),
    NextState                    => (OTHERS => '0'),
    PreviousState                => (OTHERS => '0'),
    ResetPosition                => (OTHERS => '0'),
    SignalA                      => (OTHERS => '0'),
    SignalB                      => (OTHERS => '0'),
    SignalIndex                  => (OTHERS => '0'));
  --
  SIGNAL s_DecoderChannels : t_DecoderChannels := (
    AtrailsB        => (OTHERS => '0'),
    SignalA         => (OTHERS => '0'),
    SignalB         => (OTHERS => '0'),
    SignalIndex     => (OTHERS => '0'),
    ResetPosition   => (OTHERS => '0'),
    ResetError      => (OTHERS => '0'),
    AutoMaxPosition => (OTHERS => '0'),
    MaxPosition     => (OTHERS => (OTHERS => '0')),
    Position        => (OTHERS => (OTHERS => '0')),
    ErrorFlag       => (OTHERS => '0'));
  --
  SIGNAL s_PhaseMeasurementChannels : t_PhaseMeasurementChannels := (
    PhaseCounter    => (OTHERS => (OTHERS => '0')),
    PeriodCounter   => (OTHERS => (OTHERS => '0')),
    PhaseDifference => (OTHERS => (OTHERS => '0')),
    Numer           => (OTHERS => '1'),
    Denom           => (OTHERS => '1'),
    Quotient        => (OTHERS => '1'),
    Remain          => (OTHERS => '0'));

BEGIN

  proc_SignalAllocationPhaseAccumulator : PROCESS (ALL)
  BEGIN  -- PROCESS proc_SignalAllocationPhaseAccumulator
    s_PhaseAccumulatorChannels.FrequencyControlWord(1) <= Frequency_ch25;
    s_PhaseAccumulatorChannels.FrequencyControlWord(2) <= Frequency_ch28;
    s_PhaseAccumulatorChannels.FrequencyControlWord(3) <= Frequency_ch31;
    s_PhaseAccumulatorChannels.FrequencyControlWord(4) <= Frequency_ch34;
    s_PhaseAccumulatorChannels.FrequencyControlWord(5) <= Frequency_ch37;
    s_PhaseAccumulatorChannels.FrequencyControlWord(6) <= Frequency_ch40;
    s_PhaseAccumulatorChannels.FrequencyControlWord(7) <= Frequency_ch43;
    s_PhaseAccumulatorChannels.FrequencyControlWord(8) <= Frequency_ch46;
  END PROCESS proc_SignalAllocationPhaseAccumulator;

  --

  proc_SignalAllocationEncoder : PROCESS (ALL)
  BEGIN  -- PROCESS proc_SignalAllocationEncoder
    s_EncoderChannels.NumOfTeeth(1)                   <= NumOfTeeth_ch25;
    s_EncoderChannels.NumOfTeeth(2)                   <= NumOfTeeth_ch28;
    s_EncoderChannels.NumOfTeeth(3)                   <= NumOfTeeth_ch31;
    s_EncoderChannels.NumOfTeeth(4)                   <= NumOfTeeth_ch34;
    s_EncoderChannels.NumOfTeeth(5)                   <= NumOfTeeth_ch37;
    s_EncoderChannels.NumOfTeeth(6)                   <= NumOfTeeth_ch40;
    s_EncoderChannels.NumOfTeeth(7)                   <= NumOfTeeth_ch43;
    s_EncoderChannels.NumOfTeeth(8)                   <= NumOfTeeth_ch46;
    --
    s_EncoderChannels.StatesPerTooth(1)               <= StatesPerTooth_ch25;
    s_EncoderChannels.StatesPerTooth(2)               <= StatesPerTooth_ch28;
    s_EncoderChannels.StatesPerTooth(3)               <= StatesPerTooth_ch31;
    s_EncoderChannels.StatesPerTooth(4)               <= StatesPerTooth_ch34;
    s_EncoderChannels.StatesPerTooth(5)               <= StatesPerTooth_ch37;
    s_EncoderChannels.StatesPerTooth(6)               <= StatesPerTooth_ch40;
    s_EncoderChannels.StatesPerTooth(7)               <= StatesPerTooth_ch43;
    s_EncoderChannels.StatesPerTooth(8)               <= StatesPerTooth_ch46;
    --
    s_EncoderChannels.SignalA_RisingEdgeState(1)      <= SignalA_RisingEdgeState_ch25;
    s_EncoderChannels.SignalA_RisingEdgeState(2)      <= SignalA_RisingEdgeState_ch28;
    s_EncoderChannels.SignalA_RisingEdgeState(3)      <= SignalA_RisingEdgeState_ch31;
    s_EncoderChannels.SignalA_RisingEdgeState(4)      <= SignalA_RisingEdgeState_ch34;
    s_EncoderChannels.SignalA_RisingEdgeState(5)      <= SignalA_RisingEdgeState_ch37;
    s_EncoderChannels.SignalA_RisingEdgeState(6)      <= SignalA_RisingEdgeState_ch40;
    s_EncoderChannels.SignalA_RisingEdgeState(7)      <= SignalA_RisingEdgeState_ch43;
    s_EncoderChannels.SignalA_RisingEdgeState(8)      <= SignalA_RisingEdgeState_ch46;
    --
    s_EncoderChannels.SignalA_FallingEdgeState(1)     <= SignalA_FallingEdgeState_ch25;
    s_EncoderChannels.SignalA_FallingEdgeState(2)     <= SignalA_FallingEdgeState_ch28;
    s_EncoderChannels.SignalA_FallingEdgeState(3)     <= SignalA_FallingEdgeState_ch31;
    s_EncoderChannels.SignalA_FallingEdgeState(4)     <= SignalA_FallingEdgeState_ch34;
    s_EncoderChannels.SignalA_FallingEdgeState(5)     <= SignalA_FallingEdgeState_ch37;
    s_EncoderChannels.SignalA_FallingEdgeState(6)     <= SignalA_FallingEdgeState_ch40;
    s_EncoderChannels.SignalA_FallingEdgeState(7)     <= SignalA_FallingEdgeState_ch43;
    s_EncoderChannels.SignalA_FallingEdgeState(8)     <= SignalA_FallingEdgeState_ch46;
    --
    s_EncoderChannels.SignalB_RisingEdgeState(1)      <= SignalB_RisingEdgeState_ch25;
    s_EncoderChannels.SignalB_RisingEdgeState(2)      <= SignalB_RisingEdgeState_ch28;
    s_EncoderChannels.SignalB_RisingEdgeState(3)      <= SignalB_RisingEdgeState_ch31;
    s_EncoderChannels.SignalB_RisingEdgeState(4)      <= SignalB_RisingEdgeState_ch34;
    s_EncoderChannels.SignalB_RisingEdgeState(5)      <= SignalB_RisingEdgeState_ch37;
    s_EncoderChannels.SignalB_RisingEdgeState(6)      <= SignalB_RisingEdgeState_ch40;
    s_EncoderChannels.SignalB_RisingEdgeState(7)      <= SignalB_RisingEdgeState_ch43;
    s_EncoderChannels.SignalB_RisingEdgeState(8)      <= SignalB_RisingEdgeState_ch46;
    --
    s_EncoderChannels.SignalB_FallingEdgeState(1)     <= SignalB_FallingEdgeState_ch25;
    s_EncoderChannels.SignalB_FallingEdgeState(2)     <= SignalB_FallingEdgeState_ch28;
    s_EncoderChannels.SignalB_FallingEdgeState(3)     <= SignalB_FallingEdgeState_ch31;
    s_EncoderChannels.SignalB_FallingEdgeState(4)     <= SignalB_FallingEdgeState_ch34;
    s_EncoderChannels.SignalB_FallingEdgeState(5)     <= SignalB_FallingEdgeState_ch37;
    s_EncoderChannels.SignalB_FallingEdgeState(6)     <= SignalB_FallingEdgeState_ch40;
    s_EncoderChannels.SignalB_FallingEdgeState(7)     <= SignalB_FallingEdgeState_ch43;
    s_EncoderChannels.SignalB_FallingEdgeState(8)     <= SignalB_FallingEdgeState_ch46;
    --
    s_EncoderChannels.SignalIndex_RisingEdgeTooth(1)  <= SignalIndex_RisingEdgeTooth_ch25;
    s_EncoderChannels.SignalIndex_RisingEdgeTooth(2)  <= SignalIndex_RisingEdgeTooth_ch28;
    s_EncoderChannels.SignalIndex_RisingEdgeTooth(3)  <= SignalIndex_RisingEdgeTooth_ch31;
    s_EncoderChannels.SignalIndex_RisingEdgeTooth(4)  <= SignalIndex_RisingEdgeTooth_ch34;
    s_EncoderChannels.SignalIndex_RisingEdgeTooth(5)  <= SignalIndex_RisingEdgeTooth_ch37;
    s_EncoderChannels.SignalIndex_RisingEdgeTooth(6)  <= SignalIndex_RisingEdgeTooth_ch40;
    s_EncoderChannels.SignalIndex_RisingEdgeTooth(7)  <= SignalIndex_RisingEdgeTooth_ch43;
    s_EncoderChannels.SignalIndex_RisingEdgeTooth(8)  <= SignalIndex_RisingEdgeTooth_ch46;
    --
    s_EncoderChannels.SignalIndex_RisingEdgeState(1)  <= SignalIndex_RisingEdgeState_ch25;
    s_EncoderChannels.SignalIndex_RisingEdgeState(2)  <= SignalIndex_RisingEdgeState_ch28;
    s_EncoderChannels.SignalIndex_RisingEdgeState(3)  <= SignalIndex_RisingEdgeState_ch31;
    s_EncoderChannels.SignalIndex_RisingEdgeState(4)  <= SignalIndex_RisingEdgeState_ch34;
    s_EncoderChannels.SignalIndex_RisingEdgeState(5)  <= SignalIndex_RisingEdgeState_ch37;
    s_EncoderChannels.SignalIndex_RisingEdgeState(6)  <= SignalIndex_RisingEdgeState_ch40;
    s_EncoderChannels.SignalIndex_RisingEdgeState(7)  <= SignalIndex_RisingEdgeState_ch43;
    s_EncoderChannels.SignalIndex_RisingEdgeState(8)  <= SignalIndex_RisingEdgeState_ch46;
    --
    s_EncoderChannels.SignalIndex_FallingEdgeTooth(1) <= SignalIndex_FallingEdgeTooth_ch25;
    s_EncoderChannels.SignalIndex_FallingEdgeTooth(2) <= SignalIndex_FallingEdgeTooth_ch28;
    s_EncoderChannels.SignalIndex_FallingEdgeTooth(3) <= SignalIndex_FallingEdgeTooth_ch31;
    s_EncoderChannels.SignalIndex_FallingEdgeTooth(4) <= SignalIndex_FallingEdgeTooth_ch34;
    s_EncoderChannels.SignalIndex_FallingEdgeTooth(5) <= SignalIndex_FallingEdgeTooth_ch37;
    s_EncoderChannels.SignalIndex_FallingEdgeTooth(6) <= SignalIndex_FallingEdgeTooth_ch40;
    s_EncoderChannels.SignalIndex_FallingEdgeTooth(7) <= SignalIndex_FallingEdgeTooth_ch43;
    s_EncoderChannels.SignalIndex_FallingEdgeTooth(8) <= SignalIndex_FallingEdgeTooth_ch46;
    --
    s_EncoderChannels.SignalIndex_FallingEdgeState(1) <= SignalIndex_FallingEdgeState_ch25;
    s_EncoderChannels.SignalIndex_FallingEdgeState(2) <= SignalIndex_FallingEdgeState_ch28;
    s_EncoderChannels.SignalIndex_FallingEdgeState(3) <= SignalIndex_FallingEdgeState_ch31;
    s_EncoderChannels.SignalIndex_FallingEdgeState(4) <= SignalIndex_FallingEdgeState_ch34;
    s_EncoderChannels.SignalIndex_FallingEdgeState(5) <= SignalIndex_FallingEdgeState_ch37;
    s_EncoderChannels.SignalIndex_FallingEdgeState(6) <= SignalIndex_FallingEdgeState_ch40;
    s_EncoderChannels.SignalIndex_FallingEdgeState(7) <= SignalIndex_FallingEdgeState_ch43;
    s_EncoderChannels.SignalIndex_FallingEdgeState(8) <= SignalIndex_FallingEdgeState_ch46;
    --
    s_EncoderChannels.ResetPosition(1)                <= ResetPosition_ch25(0);
    s_EncoderChannels.ResetPosition(2)                <= ResetPosition_ch28(0);
    s_EncoderChannels.ResetPosition(3)                <= ResetPosition_ch31(0);
    s_EncoderChannels.ResetPosition(4)                <= ResetPosition_ch34(0);
    s_EncoderChannels.ResetPosition(5)                <= ResetPosition_ch37(0);
    s_EncoderChannels.ResetPosition(6)                <= ResetPosition_ch40(0);
    s_EncoderChannels.ResetPosition(7)                <= ResetPosition_ch43(0);
    s_EncoderChannels.ResetPosition(8)                <= ResetPosition_ch46(0);
    --
    out_signal_25(0)                                  <= s_EncoderChannels.SignalA(1);
    out_signal_28(0)                                  <= s_EncoderChannels.SignalA(2);
    out_signal_31(0)                                  <= s_EncoderChannels.SignalA(3);
    out_signal_34(0)                                  <= s_EncoderChannels.SignalA(4);
    out_signal_37(0)                                  <= s_EncoderChannels.SignalA(5);
    out_signal_40(0)                                  <= s_EncoderChannels.SignalA(6);
    out_signal_43(0)                                  <= s_EncoderChannels.SignalA(7);
    out_signal_46(0)                                  <= s_EncoderChannels.SignalA(8);
    --
    out_signal_26(0)                                  <= s_EncoderChannels.SignalB(1);
    out_signal_29(0)                                  <= s_EncoderChannels.SignalB(2);
    out_signal_32(0)                                  <= s_EncoderChannels.SignalB(3);
    out_signal_35(0)                                  <= s_EncoderChannels.SignalB(4);
    out_signal_38(0)                                  <= s_EncoderChannels.SignalB(5);
    out_signal_41(0)                                  <= s_EncoderChannels.SignalB(6);
    out_signal_44(0)                                  <= s_EncoderChannels.SignalB(7);
    out_signal_47(0)                                  <= s_EncoderChannels.SignalB(8);
    --
    out_signal_27(0)                                  <= s_EncoderChannels.SignalIndex(1);
    out_signal_30(0)                                  <= s_EncoderChannels.SignalIndex(2);
    out_signal_33(0)                                  <= s_EncoderChannels.SignalIndex(3);
    out_signal_36(0)                                  <= s_EncoderChannels.SignalIndex(4);
    out_signal_39(0)                                  <= s_EncoderChannels.SignalIndex(5);
    out_signal_42(0)                                  <= s_EncoderChannels.SignalIndex(6);
    out_signal_45(0)                                  <= s_EncoderChannels.SignalIndex(7);
    out_signal_48(0)                                  <= s_EncoderChannels.SignalIndex(8);
  END PROCESS proc_SignalAllocationEncoder;

  --

  proc_SignalAllocationDecoder : PROCESS (ALL)
  BEGIN  -- PROCESS proc_SignalAllocationDecoder
    s_DecoderChannels.SignalA(1)         <= in_signal_1(0);
    s_DecoderChannels.SignalA(2)         <= in_signal_4(0);
    s_DecoderChannels.SignalA(3)         <= in_signal_7(0);
    s_DecoderChannels.SignalA(4)         <= in_signal_10(0);
    s_DecoderChannels.SignalA(5)         <= in_signal_13(0);
    s_DecoderChannels.SignalA(6)         <= in_signal_16(0);
    s_DecoderChannels.SignalA(7)         <= in_signal_19(0);
    s_DecoderChannels.SignalA(8)         <= in_signal_22(0);
    --
    s_DecoderChannels.SignalB(1)         <= in_signal_2(0);
    s_DecoderChannels.SignalB(2)         <= in_signal_5(0);
    s_DecoderChannels.SignalB(3)         <= in_signal_8(0);
    s_DecoderChannels.SignalB(4)         <= in_signal_11(0);
    s_DecoderChannels.SignalB(5)         <= in_signal_14(0);
    s_DecoderChannels.SignalB(6)         <= in_signal_17(0);
    s_DecoderChannels.SignalB(7)         <= in_signal_20(0);
    s_DecoderChannels.SignalB(8)         <= in_signal_23(0);
    --
    s_DecoderChannels.SignalIndex(1)     <= in_signal_3(0);
    s_DecoderChannels.SignalIndex(2)     <= in_signal_6(0);
    s_DecoderChannels.SignalIndex(3)     <= in_signal_9(0);
    s_DecoderChannels.SignalIndex(4)     <= in_signal_12(0);
    s_DecoderChannels.SignalIndex(5)     <= in_signal_15(0);
    s_DecoderChannels.SignalIndex(6)     <= in_signal_18(0);
    s_DecoderChannels.SignalIndex(7)     <= in_signal_21(0);
    s_DecoderChannels.SignalIndex(8)     <= in_signal_24(0);
    --
    s_DecoderChannels.AtrailsB(1)        <= AtrailsB_ch1(0);
    s_DecoderChannels.AtrailsB(2)        <= AtrailsB_ch4(0);
    s_DecoderChannels.AtrailsB(3)        <= AtrailsB_ch7(0);
    s_DecoderChannels.AtrailsB(4)        <= AtrailsB_ch10(0);
    s_DecoderChannels.AtrailsB(5)        <= AtrailsB_ch13(0);
    s_DecoderChannels.AtrailsB(6)        <= AtrailsB_ch16(0);
    s_DecoderChannels.AtrailsB(7)        <= AtrailsB_ch19(0);
    s_DecoderChannels.AtrailsB(8)        <= AtrailsB_ch22(0);
    --
    s_DecoderChannels.ResetPosition(1)   <= ResetPosition_ch1(0);
    s_DecoderChannels.ResetPosition(2)   <= ResetPosition_ch4(0);
    s_DecoderChannels.ResetPosition(3)   <= ResetPosition_ch7(0);
    s_DecoderChannels.ResetPosition(4)   <= ResetPosition_ch10(0);
    s_DecoderChannels.ResetPosition(5)   <= ResetPosition_ch13(0);
    s_DecoderChannels.ResetPosition(6)   <= ResetPosition_ch16(0);
    s_DecoderChannels.ResetPosition(7)   <= ResetPosition_ch19(0);
    s_DecoderChannels.ResetPosition(8)   <= ResetPosition_ch22(0);
    --
    s_DecoderChannels.ResetError(1)      <= ResetError_ch1(0);
    s_DecoderChannels.ResetError(2)      <= ResetError_ch4(0);
    s_DecoderChannels.ResetError(3)      <= ResetError_ch7(0);
    s_DecoderChannels.ResetError(4)      <= ResetError_ch10(0);
    s_DecoderChannels.ResetError(5)      <= ResetError_ch13(0);
    s_DecoderChannels.ResetError(6)      <= ResetError_ch16(0);
    s_DecoderChannels.ResetError(7)      <= ResetError_ch19(0);
    s_DecoderChannels.ResetError(8)      <= ResetError_ch22(0);
    --
    s_DecoderChannels.AutoMaxPosition(1) <= AutoMaxPosition_ch1(0);
    s_DecoderChannels.AutoMaxPosition(2) <= AutoMaxPosition_ch4(0);
    s_DecoderChannels.AutoMaxPosition(3) <= AutoMaxPosition_ch7(0);
    s_DecoderChannels.AutoMaxPosition(4) <= AutoMaxPosition_ch10(0);
    s_DecoderChannels.AutoMaxPosition(5) <= AutoMaxPosition_ch13(0);
    s_DecoderChannels.AutoMaxPosition(6) <= AutoMaxPosition_ch16(0);
    s_DecoderChannels.AutoMaxPosition(7) <= AutoMaxPosition_ch19(0);
    s_DecoderChannels.AutoMaxPosition(8) <= AutoMaxPosition_ch22(0);
    --
    s_DecoderChannels.MaxPosition(1)     <= MaxPosition_ch1;
    s_DecoderChannels.MaxPosition(2)     <= MaxPosition_ch4;
    s_DecoderChannels.MaxPosition(3)     <= MaxPosition_ch7;
    s_DecoderChannels.MaxPosition(4)     <= MaxPosition_ch10;
    s_DecoderChannels.MaxPosition(5)     <= MaxPosition_ch13;
    s_DecoderChannels.MaxPosition(6)     <= MaxPosition_ch16;
    s_DecoderChannels.MaxPosition(7)     <= MaxPosition_ch19;
    s_DecoderChannels.MaxPosition(8)     <= MaxPosition_ch22;
    --
    Position_ch1                         <= s_DecoderChannels.Position(1);
    Position_ch4                         <= s_DecoderChannels.Position(2);
    Position_ch7                         <= s_DecoderChannels.Position(3);
    Position_ch10                        <= s_DecoderChannels.Position(4);
    Position_ch13                        <= s_DecoderChannels.Position(5);
    Position_ch16                        <= s_DecoderChannels.Position(6);
    Position_ch19                        <= s_DecoderChannels.Position(7);
    Position_ch22                        <= s_DecoderChannels.Position(8);
    --
    Error_ch1(0)                         <= s_DecoderChannels.ErrorFlag(1);
    Error_ch4(0)                         <= s_DecoderChannels.ErrorFlag(2);
    Error_ch7(0)                         <= s_DecoderChannels.ErrorFlag(3);
    Error_ch10(0)                        <= s_DecoderChannels.ErrorFlag(4);
    Error_ch13(0)                        <= s_DecoderChannels.ErrorFlag(5);
    Error_ch16(0)                        <= s_DecoderChannels.ErrorFlag(6);
    Error_ch19(0)                        <= s_DecoderChannels.ErrorFlag(7);
    Error_ch22(0)                        <= s_DecoderChannels.ErrorFlag(8);
  END PROCESS proc_SignalAllocationDecoder;

  --

  proc_SignalAllocationPhaseMeasurement : PROCESS (ALL)
  BEGIN  -- PROCESS proc_SignalAllocationPhaseMeasurement
    PhaseDifference_ch1  <= s_PhaseMeasurementChannels.PhaseDifference(1);
    PhaseDifference_ch4  <= s_PhaseMeasurementChannels.PhaseDifference(2);
    PhaseDifference_ch7  <= s_PhaseMeasurementChannels.PhaseDifference(3);
    PhaseDifference_ch10 <= s_PhaseMeasurementChannels.PhaseDifference(4);
    PhaseDifference_ch13 <= s_PhaseMeasurementChannels.PhaseDifference(5);
    PhaseDifference_ch16 <= s_PhaseMeasurementChannels.PhaseDifference(6);
    PhaseDifference_ch19 <= s_PhaseMeasurementChannels.PhaseDifference(7);
    PhaseDifference_ch22 <= s_PhaseMeasurementChannels.PhaseDifference(8);
  END PROCESS proc_SignalAllocationPhaseMeasurement;

  --
  --
  --

  EncoderChannels : FOR Channel IN c_EncoderChannelsRange GENERATE
    inst_PhaseAccumulator : ENTITY work.PhaseAccumulator
      GENERIC MAP (
        fpga_frequency     => fpga_frequency,
        g_Width            => 32,
        g_ResolutionFactor => 32d"1"
        )
      PORT MAP (
        i_clock                => clk,
        i_reset                => areset,
        i_Active               => s_PhaseAccumulatorChannels.Active(Channel),
        i_StartValue           => s_PhaseAccumulatorChannels.StartValue(Channel),
        i_SetStartValue        => s_PhaseAccumulatorChannels.SetStartValue(Channel),
        i_FrequencyControlWord => s_PhaseAccumulatorChannels.FrequencyControlWord(Channel),
        o_CounterValue         => s_PhaseAccumulatorChannels.CounterValue(Channel),
        o_Overflow             => s_PhaseAccumulatorChannels.Overflow(Channel)
        );

    --

    -- used to determine if the rotation is in positive or negative direction and set the next/previous state signals accordingly
    proc_EncoderState : PROCESS (clk, areset)
    BEGIN  -- PROCESS proc_EncoderState
      IF (areset = c_reset_active) THEN                                                                      -- asynchronous reset (active package defined)
        NULL;
      ELSIF (clk'event AND clk = '1') THEN                                                                   -- rising clock edge
        s_EncoderChannels.NextState(Channel)     <= '0';
        s_EncoderChannels.PreviousState(Channel) <= '0';
        --
        IF (s_PhaseAccumulatorChannels.Overflow(Channel)) THEN
          IF (NOT s_PhaseAccumulatorChannels.FrequencyControlWord(Channel)(Frequency_ch25'length - 1)) THEN  -- positive direction
            s_EncoderChannels.NextState(Channel) <= '1';
          ELSE
            s_EncoderChannels.PreviousState(Channel) <= '1';
          END IF;
        END IF;
      END IF;
    END PROCESS proc_EncoderState;

    --

    inst_QuadratureEncoder : ENTITY work.QuadratureEncoder
      GENERIC MAP (
        g_CounterWidth => 16
        )
      PORT MAP (
        i_clock                        => clk,
        i_reset                        => areset,
        i_NumOfTeeth                   => s_EncoderChannels.NumOfTeeth(Channel),
        i_StatesPerTooth               => s_EncoderChannels.StatesPerTooth(Channel),
        i_SignalA_RisingEdgeState      => s_EncoderChannels.SignalA_RisingEdgeState(Channel),
        i_SignalA_FallingEdgeState     => s_EncoderChannels.SignalA_FallingEdgeState(Channel),
        i_SignalB_RisingEdgeState      => s_EncoderChannels.SignalB_RisingEdgeState(Channel),
        i_SignalB_FallingEdgeState     => s_EncoderChannels.SignalB_FallingEdgeState(Channel),
        i_SignalIndex_RisingEdgeTooth  => s_EncoderChannels.SignalIndex_RisingEdgeTooth(Channel),
        i_SignalIndex_RisingEdgeState  => s_EncoderChannels.SignalIndex_RisingEdgeState(Channel),
        i_SignalIndex_FallingEdgeTooth => s_EncoderChannels.SignalIndex_FallingEdgeTooth(Channel),
        i_SignalIndex_FallingEdgeState => s_EncoderChannels.SignalIndex_FallingEdgeState(Channel),
        i_NextState                    => s_EncoderChannels.NextState(Channel),
        i_PreviousState                => s_EncoderChannels.PreviousState(Channel),
        i_ResetPosition                => s_EncoderChannels.ResetPosition(Channel),
        o_SignalA                      => s_EncoderChannels.SignalA(Channel),
        o_SignalB                      => s_EncoderChannels.SignalB(Channel),
        o_SignalIndex                  => s_EncoderChannels.SignalIndex(Channel)
        );
  END GENERATE EncoderChannels;

  --
  --
  --

  DecoderChannels : FOR Channel IN c_DecoderChannelsRange GENERATE
    inst_QuadratureDecoder : ENTITY work.QuadratureDecoder
      GENERIC MAP (
        g_PositionWidth => 32,
        g_FilterWidth   => 5
        )
      PORT MAP (
        i_clock           => clk,
        i_reset           => areset,
        i_AtrailsB        => s_DecoderChannels.AtrailsB(Channel),
        i_SignalA         => s_DecoderChannels.SignalA(Channel),
        i_SignalB         => s_DecoderChannels.SignalB(Channel),
        i_SignalIndex     => s_DecoderChannels.SignalIndex(Channel),
        i_ResetPosition   => s_DecoderChannels.ResetPosition(Channel),
        i_ResetError      => s_DecoderChannels.ResetError(Channel),
        i_AutoMaxPosition => s_DecoderChannels.AutoMaxPosition(Channel),
        i_MaxPosition     => s_DecoderChannels.MaxPosition(Channel),
        o_Position        => s_DecoderChannels.Position(Channel),
        o_Error           => s_DecoderChannels.ErrorFlag(Channel)
        );
  END GENERATE DecoderChannels;

  --
  --
  --

  PhaseMeasurementChannels : FOR Channel IN c_PhaseMeasurementChannelsRange GENERATE
    inst_PhaseMeasurement : ENTITY work.PhaseMeasurement
      GENERIC MAP (
        g_CounterWidth      => 32,
        g_PhaseCounterState => "10"
        )
      PORT MAP (
        i_clock         => clk,
        i_reset         => areset,
        i_SignalA       => s_DecoderChannels.SignalA(Channel),
        i_SignalB       => s_DecoderChannels.SignalB(Channel),
        o_PhaseCounter  => s_PhaseMeasurementChannels.PhaseCounter(Channel),
        o_PeriodCounter => s_PhaseMeasurementChannels.PeriodCounter(Channel)
        );
  END GENERATE PhaseMeasurementChannels;

  --

  proc_DividerSignalAllocation : PROCESS (ALL)
    VARIABLE v_Channel : natural := 1;
  BEGIN  -- PROCESS proc_DividerSignalAllocation
    IF (areset = c_reset_active) THEN     -- asynchronous reset (active package defined)
      NULL;
    ELSIF (clk'event AND clk = '1') THEN  -- rising clock edge
      s_PhaseMeasurementChannels.Numer                      <= std_logic_vector(resize(1024 * unsigned(s_PhaseMeasurementChannels.PhaseCounter(v_Channel)), 32));
      s_PhaseMeasurementChannels.Denom                      <= s_PhaseMeasurementChannels.PeriodCounter(v_Channel);
      --
      s_PhaseMeasurementChannels.PhaseDifference(v_Channel) <= s_PhaseMeasurementChannels.Quotient;
      --
      --
      --
      IF (v_Channel = c_PhaseMeasurementChannels) THEN
        v_Channel := 1;
      ELSE
        v_Channel := v_Channel + 1;
      END IF;
    END IF;
  END PROCESS proc_DividerSignalAllocation;

  --

  inst_LPM_Divider_32Bit_unsigned : ENTITY work.LPM_Divider_32Bit_unsigned
    PORT MAP (
      clock    => clk,
      denom    => s_PhaseMeasurementChannels.Denom,
      numer    => s_PhaseMeasurementChannels.Numer,
      quotient => s_PhaseMeasurementChannels.Quotient,
      remain   => s_PhaseMeasurementChannels.Remain
      );

END ARCHITECTURE rtl;  -- of  User
