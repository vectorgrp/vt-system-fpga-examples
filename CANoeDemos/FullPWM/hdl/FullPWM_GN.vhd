-- Copyright (c) 2024 Vector Informatik GmbH  

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
    MeasurementDuration_ch17 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch18 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch19 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch20 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch21 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch22 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch23 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch24 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch25 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch26 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch27 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch28 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch29 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch30 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch31 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch32 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch33 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch34 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch35 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch36 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch37 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch38 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch39 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch40 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch41 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch42 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch43 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch44 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch45 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch46 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch47 : in std_logic_vector(31 downto 0);
    MeasurementDuration_ch48 : in std_logic_vector(31 downto 0);
    Frequency_ch17 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch18 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch19 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch20 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch21 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch22 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch23 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch24 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch25 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch26 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch27 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch28 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch29 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch30 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch31 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch32 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch33 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch34 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch35 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch36 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch37 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch38 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch39 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch40 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch41 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch42 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch43 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch44 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch45 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch46 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch47 : out std_logic_vector(31 downto 0) := (others => '0');
    Frequency_ch48 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch17 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch18 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch19 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch20 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch21 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch22 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch23 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch24 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch25 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch26 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch27 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch28 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch29 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch30 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch31 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch32 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch33 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch34 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch35 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch36 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch37 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch38 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch39 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch40 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch41 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch42 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch43 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch44 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch45 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch46 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch47 : out std_logic_vector(31 downto 0) := (others => '0');
    DutyCycle_ch48 : out std_logic_vector(31 downto 0) := (others => '0');
    OutputActive_ch1 : in std_logic_vector(0 downto 0);
    OutputActive_ch2 : in std_logic_vector(0 downto 0);
    OutputActive_ch3 : in std_logic_vector(0 downto 0);
    OutputActive_ch4 : in std_logic_vector(0 downto 0);
    OutputActive_ch5 : in std_logic_vector(0 downto 0);
    OutputActive_ch6 : in std_logic_vector(0 downto 0);
    OutputActive_ch7 : in std_logic_vector(0 downto 0);
    OutputActive_ch8 : in std_logic_vector(0 downto 0);
    OutputActive_ch9 : in std_logic_vector(0 downto 0);
    OutputActive_ch10 : in std_logic_vector(0 downto 0);
    OutputActive_ch11 : in std_logic_vector(0 downto 0);
    OutputActive_ch12 : in std_logic_vector(0 downto 0);
    OutputActive_ch13 : in std_logic_vector(0 downto 0);
    OutputActive_ch14 : in std_logic_vector(0 downto 0);
    OutputActive_ch15 : in std_logic_vector(0 downto 0);
    OutputActive_ch16 : in std_logic_vector(0 downto 0);
    OutputActive_ch17 : in std_logic_vector(0 downto 0);
    OutputActive_ch18 : in std_logic_vector(0 downto 0);
    OutputActive_ch19 : in std_logic_vector(0 downto 0);
    OutputActive_ch20 : in std_logic_vector(0 downto 0);
    OutputActive_ch21 : in std_logic_vector(0 downto 0);
    OutputActive_ch22 : in std_logic_vector(0 downto 0);
    OutputActive_ch23 : in std_logic_vector(0 downto 0);
    OutputActive_ch24 : in std_logic_vector(0 downto 0);
    OutputActive_ch25 : in std_logic_vector(0 downto 0);
    OutputActive_ch26 : in std_logic_vector(0 downto 0);
    OutputActive_ch27 : in std_logic_vector(0 downto 0);
    OutputActive_ch28 : in std_logic_vector(0 downto 0);
    OutputActive_ch29 : in std_logic_vector(0 downto 0);
    OutputActive_ch30 : in std_logic_vector(0 downto 0);
    OutputActive_ch31 : in std_logic_vector(0 downto 0);
    OutputActive_ch32 : in std_logic_vector(0 downto 0);
    OutputFrequency_ch1 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch2 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch3 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch4 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch5 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch6 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch7 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch8 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch9 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch10 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch11 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch12 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch13 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch14 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch15 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch16 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch17 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch18 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch19 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch20 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch21 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch22 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch23 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch24 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch25 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch26 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch27 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch28 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch29 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch30 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch31 : in std_logic_vector(31 downto 0);
    OutputFrequency_ch32 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch1 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch2 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch3 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch4 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch5 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch6 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch7 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch8 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch9 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch10 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch11 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch12 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch13 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch14 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch15 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch16 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch17 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch18 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch19 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch20 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch21 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch22 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch23 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch24 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch25 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch26 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch27 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch28 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch29 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch30 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch31 : in std_logic_vector(31 downto 0);
    OutputDutyCycle_ch32 : in std_logic_vector(31 downto 0);
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

  SUBTYPE t_MeasurementChannelsRange IS natural RANGE 17 TO 48;
  SUBTYPE t_OutputChannelsRange IS natural RANGE 1 TO 32;                                                    -- channel 33-48 in base functionality of the module
  --
  CONSTANT c_MeasurementCounterSize           : natural                       := 32;
  CONSTANT c_MeasurementDutyCycleFactor       : unsigned(10 DOWNTO 0)         := 11d"1024";                  -- used to factorize the Numer value to prevent a result <1
  --
  CONSTANT c_PhaseAccumulatorWidth            : natural                       := 32;
  CONSTANT c_PhaseAccumulatorResolutionFactor : std_logic_vector(31 DOWNTO 0) := 32d"1";
  --
  --
  --
  TYPE t_MeasurementChannels IS RECORD
    Input               : t_ArrayLogic(t_MeasurementChannelsRange);
    NewData             : t_ArrayLogic(t_MeasurementChannelsRange);
    TimeoutHigh         : t_ArrayLogic(t_MeasurementChannelsRange);
    TimeoutLow          : t_ArrayLogic(t_MeasurementChannelsRange);
    PeriodCounter       : t_ArrayVector(t_MeasurementChannelsRange)(c_MeasurementCounterSize - 1 DOWNTO 0);
    PulseCounter        : t_ArrayVector(t_MeasurementChannelsRange)(c_MeasurementCounterSize - 1 DOWNTO 0);
    MeasurementDuration : t_ArrayVector(t_MeasurementChannelsRange)(MeasurementDuration_ch17'range);
    FrequencyNumer      : t_ArrayVector(t_MeasurementChannelsRange)(c_MeasurementCounterSize - 1 DOWNTO 0);  -- used to check for division by 0 and timeouts
    FrequencyDenom      : t_ArrayVector(t_MeasurementChannelsRange)(c_MeasurementCounterSize - 1 DOWNTO 0);  -- used to check for division by 0 and timeouts
    DutyCycleNumer      : t_ArrayVector(t_MeasurementChannelsRange)(c_MeasurementCounterSize - 1 DOWNTO 0);  -- used to check for division by 0 and timeouts
    DutyCycleDenom      : t_ArrayVector(t_MeasurementChannelsRange)(c_MeasurementCounterSize - 1 DOWNTO 0);  -- used to check for division by 0 and timeouts
    Frequency           : t_ArrayVector(t_MeasurementChannelsRange)(Frequency_ch17'range);
    DutyCycle           : t_ArrayVector(t_MeasurementChannelsRange)(DutyCycle_ch17'range);
  END RECORD;
  --
  SIGNAL s_MeasurementChannels : t_MeasurementChannels := (
    Input               => (OTHERS => '0'),
    NewData             => (OTHERS => '0'),
    TimeoutHigh         => (OTHERS => '0'),
    TimeoutLow          => (OTHERS => '0'),
    PeriodCounter       => (OTHERS => (OTHERS => '0')),
    PulseCounter        => (OTHERS => (OTHERS => '0')),
    MeasurementDuration => (OTHERS => fpga_frequency),                                                       -- 1 sec
    FrequencyNumer      => (OTHERS => (OTHERS => '0')),
    FrequencyDenom      => (OTHERS => (OTHERS => '0')),
    DutyCycleNumer      => (OTHERS => (OTHERS => '0')),
    DutyCycleDenom      => (OTHERS => (OTHERS => '0')),
    Frequency           => (OTHERS => (OTHERS => '0')),
    DutyCycle           => (OTHERS => (OTHERS => '0')));
  --
  --
  --
  TYPE t_Divide IS RECORD
    Numer    : std_logic_vector(31 DOWNTO 0);
    Denom    : std_logic_vector(31 DOWNTO 0);
    Quotient : std_logic_vector(31 DOWNTO 0);
  END RECORD;
  --
  SIGNAL s_DivideFrequency : t_Divide := (
    Numer    => 32d"0",
    Denom    => 32d"1",
    Quotient => 32d"0");
  --
  SIGNAL s_DivideDutyCycle : t_Divide := (
    Numer    => 32d"0",
    Denom    => 32d"1",
    Quotient => 32d"0");
  --
  --
  --
  TYPE t_OutputChannels IS RECORD
    Active    : t_ArrayLogic(t_OutputChannelsRange);
    Frequency : t_ArrayVector(t_OutputChannelsRange)(OutputFrequency_ch1'range);
    DutyCycle : t_ArrayVector(t_OutputChannelsRange)(OutputDutyCycle_ch1'range);
    Counter   : t_ArrayVector(t_OutputChannelsRange)(c_PhaseAccumulatorWidth - 1 DOWNTO 0);
    Overflow  : t_ArrayLogic(t_OutputChannelsRange);
    Output    : t_ArrayLogic(t_OutputChannelsRange);
  END RECORD;
  --
  SIGNAL s_OutputChannels : t_OutputChannels := (
    Active    => (OTHERS => '0'),
    Frequency => (OTHERS => (OTHERS => '0')),
    DutyCycle => (OTHERS => (OTHERS => '0')),
    Counter   => (OTHERS => (OTHERS => '0')),
    Overflow  => (OTHERS => '0'),
    Output    => (OTHERS => '0'));

BEGIN

  --
  -- PWM measurement
  --

  s_MeasurementChannels.Input(17)               <= in_signal_17(0);
  s_MeasurementChannels.Input(18)               <= in_signal_18(0);
  s_MeasurementChannels.Input(19)               <= in_signal_19(0);
  s_MeasurementChannels.Input(20)               <= in_signal_20(0);
  s_MeasurementChannels.Input(21)               <= in_signal_21(0);
  s_MeasurementChannels.Input(22)               <= in_signal_22(0);
  s_MeasurementChannels.Input(23)               <= in_signal_23(0);
  s_MeasurementChannels.Input(24)               <= in_signal_24(0);
  s_MeasurementChannels.Input(25)               <= in_signal_25(0);
  s_MeasurementChannels.Input(26)               <= in_signal_26(0);
  s_MeasurementChannels.Input(27)               <= in_signal_27(0);
  s_MeasurementChannels.Input(28)               <= in_signal_28(0);
  s_MeasurementChannels.Input(29)               <= in_signal_29(0);
  s_MeasurementChannels.Input(30)               <= in_signal_30(0);
  s_MeasurementChannels.Input(31)               <= in_signal_31(0);
  s_MeasurementChannels.Input(32)               <= in_signal_32(0);
  s_MeasurementChannels.Input(33)               <= in_signal_33(0);
  s_MeasurementChannels.Input(34)               <= in_signal_34(0);
  s_MeasurementChannels.Input(35)               <= in_signal_35(0);
  s_MeasurementChannels.Input(36)               <= in_signal_36(0);
  s_MeasurementChannels.Input(37)               <= in_signal_37(0);
  s_MeasurementChannels.Input(38)               <= in_signal_38(0);
  s_MeasurementChannels.Input(39)               <= in_signal_39(0);
  s_MeasurementChannels.Input(40)               <= in_signal_40(0);
  s_MeasurementChannels.Input(41)               <= in_signal_41(0);
  s_MeasurementChannels.Input(42)               <= in_signal_42(0);
  s_MeasurementChannels.Input(43)               <= in_signal_43(0);
  s_MeasurementChannels.Input(44)               <= in_signal_44(0);
  s_MeasurementChannels.Input(45)               <= in_signal_45(0);
  s_MeasurementChannels.Input(46)               <= in_signal_46(0);
  s_MeasurementChannels.Input(47)               <= in_signal_47(0);
  s_MeasurementChannels.Input(48)               <= in_signal_48(0);
  --
  s_MeasurementChannels.MeasurementDuration(17) <= MeasurementDuration_ch17;
  s_MeasurementChannels.MeasurementDuration(18) <= MeasurementDuration_ch18;
  s_MeasurementChannels.MeasurementDuration(19) <= MeasurementDuration_ch19;
  s_MeasurementChannels.MeasurementDuration(20) <= MeasurementDuration_ch20;
  s_MeasurementChannels.MeasurementDuration(21) <= MeasurementDuration_ch21;
  s_MeasurementChannels.MeasurementDuration(22) <= MeasurementDuration_ch22;
  s_MeasurementChannels.MeasurementDuration(23) <= MeasurementDuration_ch23;
  s_MeasurementChannels.MeasurementDuration(24) <= MeasurementDuration_ch24;
  s_MeasurementChannels.MeasurementDuration(25) <= MeasurementDuration_ch25;
  s_MeasurementChannels.MeasurementDuration(26) <= MeasurementDuration_ch26;
  s_MeasurementChannels.MeasurementDuration(27) <= MeasurementDuration_ch27;
  s_MeasurementChannels.MeasurementDuration(28) <= MeasurementDuration_ch28;
  s_MeasurementChannels.MeasurementDuration(29) <= MeasurementDuration_ch29;
  s_MeasurementChannels.MeasurementDuration(30) <= MeasurementDuration_ch30;
  s_MeasurementChannels.MeasurementDuration(31) <= MeasurementDuration_ch31;
  s_MeasurementChannels.MeasurementDuration(32) <= MeasurementDuration_ch32;
  s_MeasurementChannels.MeasurementDuration(33) <= MeasurementDuration_ch33;
  s_MeasurementChannels.MeasurementDuration(34) <= MeasurementDuration_ch34;
  s_MeasurementChannels.MeasurementDuration(35) <= MeasurementDuration_ch35;
  s_MeasurementChannels.MeasurementDuration(36) <= MeasurementDuration_ch36;
  s_MeasurementChannels.MeasurementDuration(37) <= MeasurementDuration_ch37;
  s_MeasurementChannels.MeasurementDuration(38) <= MeasurementDuration_ch38;
  s_MeasurementChannels.MeasurementDuration(39) <= MeasurementDuration_ch39;
  s_MeasurementChannels.MeasurementDuration(40) <= MeasurementDuration_ch40;
  s_MeasurementChannels.MeasurementDuration(41) <= MeasurementDuration_ch41;
  s_MeasurementChannels.MeasurementDuration(42) <= MeasurementDuration_ch42;
  s_MeasurementChannels.MeasurementDuration(43) <= MeasurementDuration_ch43;
  s_MeasurementChannels.MeasurementDuration(44) <= MeasurementDuration_ch44;
  s_MeasurementChannels.MeasurementDuration(45) <= MeasurementDuration_ch45;
  s_MeasurementChannels.MeasurementDuration(46) <= MeasurementDuration_ch46;
  s_MeasurementChannels.MeasurementDuration(47) <= MeasurementDuration_ch47;
  s_MeasurementChannels.MeasurementDuration(48) <= MeasurementDuration_ch48;
  --
  Frequency_ch17                                <= s_MeasurementChannels.Frequency(17);
  Frequency_ch18                                <= s_MeasurementChannels.Frequency(18);
  Frequency_ch19                                <= s_MeasurementChannels.Frequency(19);
  Frequency_ch20                                <= s_MeasurementChannels.Frequency(20);
  Frequency_ch21                                <= s_MeasurementChannels.Frequency(21);
  Frequency_ch22                                <= s_MeasurementChannels.Frequency(22);
  Frequency_ch23                                <= s_MeasurementChannels.Frequency(23);
  Frequency_ch24                                <= s_MeasurementChannels.Frequency(24);
  Frequency_ch25                                <= s_MeasurementChannels.Frequency(25);
  Frequency_ch26                                <= s_MeasurementChannels.Frequency(26);
  Frequency_ch27                                <= s_MeasurementChannels.Frequency(27);
  Frequency_ch28                                <= s_MeasurementChannels.Frequency(28);
  Frequency_ch29                                <= s_MeasurementChannels.Frequency(29);
  Frequency_ch30                                <= s_MeasurementChannels.Frequency(30);
  Frequency_ch31                                <= s_MeasurementChannels.Frequency(31);
  Frequency_ch32                                <= s_MeasurementChannels.Frequency(32);
  Frequency_ch33                                <= s_MeasurementChannels.Frequency(33);
  Frequency_ch34                                <= s_MeasurementChannels.Frequency(34);
  Frequency_ch35                                <= s_MeasurementChannels.Frequency(35);
  Frequency_ch36                                <= s_MeasurementChannels.Frequency(36);
  Frequency_ch37                                <= s_MeasurementChannels.Frequency(37);
  Frequency_ch38                                <= s_MeasurementChannels.Frequency(38);
  Frequency_ch39                                <= s_MeasurementChannels.Frequency(39);
  Frequency_ch40                                <= s_MeasurementChannels.Frequency(40);
  Frequency_ch41                                <= s_MeasurementChannels.Frequency(41);
  Frequency_ch42                                <= s_MeasurementChannels.Frequency(42);
  Frequency_ch43                                <= s_MeasurementChannels.Frequency(43);
  Frequency_ch44                                <= s_MeasurementChannels.Frequency(44);
  Frequency_ch45                                <= s_MeasurementChannels.Frequency(45);
  Frequency_ch46                                <= s_MeasurementChannels.Frequency(46);
  Frequency_ch47                                <= s_MeasurementChannels.Frequency(47);
  Frequency_ch48                                <= s_MeasurementChannels.Frequency(48);
  --
  DutyCycle_ch17                                <= s_MeasurementChannels.DutyCycle(17);
  DutyCycle_ch18                                <= s_MeasurementChannels.DutyCycle(18);
  DutyCycle_ch19                                <= s_MeasurementChannels.DutyCycle(19);
  DutyCycle_ch20                                <= s_MeasurementChannels.DutyCycle(20);
  DutyCycle_ch21                                <= s_MeasurementChannels.DutyCycle(21);
  DutyCycle_ch22                                <= s_MeasurementChannels.DutyCycle(22);
  DutyCycle_ch23                                <= s_MeasurementChannels.DutyCycle(23);
  DutyCycle_ch24                                <= s_MeasurementChannels.DutyCycle(24);
  DutyCycle_ch25                                <= s_MeasurementChannels.DutyCycle(25);
  DutyCycle_ch26                                <= s_MeasurementChannels.DutyCycle(26);
  DutyCycle_ch27                                <= s_MeasurementChannels.DutyCycle(27);
  DutyCycle_ch28                                <= s_MeasurementChannels.DutyCycle(28);
  DutyCycle_ch29                                <= s_MeasurementChannels.DutyCycle(29);
  DutyCycle_ch30                                <= s_MeasurementChannels.DutyCycle(30);
  DutyCycle_ch31                                <= s_MeasurementChannels.DutyCycle(31);
  DutyCycle_ch32                                <= s_MeasurementChannels.DutyCycle(32);
  DutyCycle_ch33                                <= s_MeasurementChannels.DutyCycle(33);
  DutyCycle_ch34                                <= s_MeasurementChannels.DutyCycle(34);
  DutyCycle_ch35                                <= s_MeasurementChannels.DutyCycle(35);
  DutyCycle_ch36                                <= s_MeasurementChannels.DutyCycle(36);
  DutyCycle_ch37                                <= s_MeasurementChannels.DutyCycle(37);
  DutyCycle_ch38                                <= s_MeasurementChannels.DutyCycle(38);
  DutyCycle_ch39                                <= s_MeasurementChannels.DutyCycle(39);
  DutyCycle_ch40                                <= s_MeasurementChannels.DutyCycle(40);
  DutyCycle_ch41                                <= s_MeasurementChannels.DutyCycle(41);
  DutyCycle_ch42                                <= s_MeasurementChannels.DutyCycle(42);
  DutyCycle_ch43                                <= s_MeasurementChannels.DutyCycle(43);
  DutyCycle_ch44                                <= s_MeasurementChannels.DutyCycle(44);
  DutyCycle_ch45                                <= s_MeasurementChannels.DutyCycle(45);
  DutyCycle_ch46                                <= s_MeasurementChannels.DutyCycle(46);
  DutyCycle_ch47                                <= s_MeasurementChannels.DutyCycle(47);
  DutyCycle_ch48                                <= s_MeasurementChannels.DutyCycle(48);

  --

  MeasurementChannels : FOR Channel IN t_MeasurementChannelsRange GENERATE
    inst_Digital_FrequencyDutyCycle : ENTITY work.Digital_FrequencyDutyCycle
      GENERIC MAP (
        g_CounterSize => c_MeasurementCounterSize
        )
      PORT MAP (
        i_clock         => clk,
        i_reset         => areset,
        i_Active        => '1',
        i_Signal        => s_MeasurementChannels.Input(Channel),
        i_Timeout       => s_MeasurementChannels.MeasurementDuration(Channel),
        o_NewData       => s_MeasurementChannels.NewData(Channel),
        o_PeriodCounter => s_MeasurementChannels.PeriodCounter(Channel),
        o_PulseCounter  => s_MeasurementChannels.PulseCounter(Channel),
        o_TimeoutHigh   => s_MeasurementChannels.TimeoutHigh(Channel),
        o_TimeoutLow    => s_MeasurementChannels.TimeoutLow(Channel)
        );
    --
    -- check for timeouts and possible divions by 0
    proc_CounterCheck : PROCESS (clk, areset)
    BEGIN  -- PROCESS proc_CounterCheck
      IF (areset = c_reset_active) THEN                                                                                      -- asynchronous reset (active package defined)
        NULL;
      ELSIF (clk'event AND clk = '1') THEN                                                                                   -- rising clock edge
        IF (s_MeasurementChannels.PeriodCounter(Channel) = std_logic_vector(to_unsigned(0, c_MeasurementCounterSize))) THEN  -- division by 0
          -- frequency division
          s_MeasurementChannels.FrequencyNumer(Channel) <= (OTHERS => '0');
          s_MeasurementChannels.FrequencyDenom(Channel) <= std_logic_vector(to_unsigned(1, c_MeasurementCounterSize));
          -- duty cycle division
          s_MeasurementChannels.DutyCycleNumer(Channel) <= (OTHERS => '0');
          s_MeasurementChannels.DutyCycleDenom(Channel) <= std_logic_vector(to_unsigned(1, c_MeasurementCounterSize));
        --
        ELSIF (s_MeasurementChannels.NewData(Channel)) THEN                                                                  -- check for new data
          IF (s_MeasurementChannels.TimeoutHigh(Channel)) THEN                                                               -- timeout high
            -- frequency division
            s_MeasurementChannels.FrequencyNumer(Channel) <= (OTHERS => '0');
            s_MeasurementChannels.FrequencyDenom(Channel) <= std_logic_vector(to_unsigned(1, c_MeasurementCounterSize));
            -- duty cycle division
            s_MeasurementChannels.DutyCycleNumer(Channel) <= std_logic_vector(resize(c_MeasurementDutyCycleFactor, s_MeasurementChannels.DutyCycleNumer(Channel)'length));
            s_MeasurementChannels.DutyCycleDenom(Channel) <= std_logic_vector(to_unsigned(1, c_MeasurementCounterSize));
          --
          ELSIF (s_MeasurementChannels.TimeoutLow(Channel)) THEN                                                             -- timeout low
            -- frequency division
            s_MeasurementChannels.FrequencyNumer(Channel) <= (OTHERS => '0');
            s_MeasurementChannels.FrequencyDenom(Channel) <= std_logic_vector(to_unsigned(1, c_MeasurementCounterSize));
            -- duty cycle division
            s_MeasurementChannels.DutyCycleNumer(Channel) <= (OTHERS => '0');
            s_MeasurementChannels.DutyCycleDenom(Channel) <= std_logic_vector(to_unsigned(1, c_MeasurementCounterSize));
          --
          ELSE                                                                                                               -- no error
            -- frequency division
            s_MeasurementChannels.FrequencyNumer(Channel) <= fpga_frequency;                                                 -- generic; set in the FPGA manager
            s_MeasurementChannels.FrequencyDenom(Channel) <= std_logic_vector(unsigned(s_MeasurementChannels.PeriodCounter(Channel)));
            -- duty cycle division
            s_MeasurementChannels.DutyCycleNumer(Channel) <= std_logic_vector(resize(unsigned(s_MeasurementChannels.PulseCounter(Channel)) * c_MeasurementDutyCycleFactor, s_DivideDutyCycle.Numer'length));
            s_MeasurementChannels.DutyCycleDenom(Channel) <= std_logic_vector(unsigned(s_MeasurementChannels.PeriodCounter(Channel)));
          END IF;
        END IF;
      END IF;
    END PROCESS proc_CounterCheck;
  END GENERATE MeasurementChannels;
  --
  proc_DivideMultiplexing : PROCESS (clk, areset)
    VARIABLE v_Channel : natural := t_MeasurementChannelsRange'low;
  BEGIN  -- PROCESS proc_DivideMultiplexing
    IF (areset = c_reset_active) THEN                                                                                        -- asynchronous reset (active package defined)
      NULL;
    ELSIF (clk'event AND clk = '1') THEN                                                                                     -- rising clock edge
      IF (v_Channel = t_MeasurementChannelsRange'high) THEN                                                                  -- cycle through the channels
        v_Channel := t_MeasurementChannelsRange'low;
      ELSE
        v_Channel := v_Channel + 1;
      END IF;
      --
      -- frequency
      s_DivideFrequency.Numer                    <= s_MeasurementChannels.FrequencyNumer(v_Channel);
      s_DivideFrequency.Denom                    <= s_MeasurementChannels.FrequencyDenom(v_Channel);
      s_MeasurementChannels.Frequency(v_Channel) <= s_DivideFrequency.Quotient;
      -- duty cycle
      s_DivideDutyCycle.Numer                    <= s_MeasurementChannels.DutyCycleNumer(v_Channel);
      s_DivideDutyCycle.Denom                    <= s_MeasurementChannels.DutyCycleDenom(v_Channel);
      s_MeasurementChannels.DutyCycle(v_Channel) <= s_DivideDutyCycle.Quotient;
    END IF;
  END PROCESS proc_DivideMultiplexing;
  --
  inst_Divide_32Bit_Frequency : ENTITY work.Divide_32Bit
    PORT MAP (
      clock    => clk,
      denom    => s_DivideFrequency.Denom,
      numer    => s_DivideFrequency.Numer,
      quotient => s_DivideFrequency.Quotient,
      remain   => OPEN
      );
  --
  inst_Divide_32Bit_DutyCycle : ENTITY work.Divide_32Bit
    PORT MAP (
      clock    => clk,
      denom    => s_DivideDutyCycle.Denom,
      numer    => s_DivideDutyCycle.Numer,
      quotient => s_DivideDutyCycle.Quotient,
      remain   => OPEN
      );

  --
  -- PWM output
  --

  s_OutputChannels.Active(1)     <= OutputActive_ch1(0);
  s_OutputChannels.Active(2)     <= OutputActive_ch2(0);
  s_OutputChannels.Active(3)     <= OutputActive_ch3(0);
  s_OutputChannels.Active(4)     <= OutputActive_ch4(0);
  s_OutputChannels.Active(5)     <= OutputActive_ch5(0);
  s_OutputChannels.Active(6)     <= OutputActive_ch6(0);
  s_OutputChannels.Active(7)     <= OutputActive_ch7(0);
  s_OutputChannels.Active(8)     <= OutputActive_ch8(0);
  s_OutputChannels.Active(9)     <= OutputActive_ch9(0);
  s_OutputChannels.Active(10)    <= OutputActive_ch10(0);
  s_OutputChannels.Active(11)    <= OutputActive_ch11(0);
  s_OutputChannels.Active(12)    <= OutputActive_ch12(0);
  s_OutputChannels.Active(13)    <= OutputActive_ch13(0);
  s_OutputChannels.Active(14)    <= OutputActive_ch14(0);
  s_OutputChannels.Active(15)    <= OutputActive_ch15(0);
  s_OutputChannels.Active(16)    <= OutputActive_ch16(0);
  s_OutputChannels.Active(17)    <= OutputActive_ch17(0);
  s_OutputChannels.Active(18)    <= OutputActive_ch18(0);
  s_OutputChannels.Active(19)    <= OutputActive_ch19(0);
  s_OutputChannels.Active(20)    <= OutputActive_ch20(0);
  s_OutputChannels.Active(21)    <= OutputActive_ch21(0);
  s_OutputChannels.Active(22)    <= OutputActive_ch22(0);
  s_OutputChannels.Active(23)    <= OutputActive_ch23(0);
  s_OutputChannels.Active(24)    <= OutputActive_ch24(0);
  s_OutputChannels.Active(25)    <= OutputActive_ch25(0);
  s_OutputChannels.Active(26)    <= OutputActive_ch26(0);
  s_OutputChannels.Active(27)    <= OutputActive_ch27(0);
  s_OutputChannels.Active(28)    <= OutputActive_ch28(0);
  s_OutputChannels.Active(29)    <= OutputActive_ch29(0);
  s_OutputChannels.Active(30)    <= OutputActive_ch30(0);
  s_OutputChannels.Active(31)    <= OutputActive_ch31(0);
  s_OutputChannels.Active(32)    <= OutputActive_ch32(0);
  --
  s_OutputChannels.Frequency(1)  <= OutputFrequency_ch1;
  s_OutputChannels.Frequency(2)  <= OutputFrequency_ch2;
  s_OutputChannels.Frequency(3)  <= OutputFrequency_ch3;
  s_OutputChannels.Frequency(4)  <= OutputFrequency_ch4;
  s_OutputChannels.Frequency(5)  <= OutputFrequency_ch5;
  s_OutputChannels.Frequency(6)  <= OutputFrequency_ch6;
  s_OutputChannels.Frequency(7)  <= OutputFrequency_ch7;
  s_OutputChannels.Frequency(8)  <= OutputFrequency_ch8;
  s_OutputChannels.Frequency(9)  <= OutputFrequency_ch9;
  s_OutputChannels.Frequency(10) <= OutputFrequency_ch10;
  s_OutputChannels.Frequency(11) <= OutputFrequency_ch11;
  s_OutputChannels.Frequency(12) <= OutputFrequency_ch12;
  s_OutputChannels.Frequency(13) <= OutputFrequency_ch13;
  s_OutputChannels.Frequency(14) <= OutputFrequency_ch14;
  s_OutputChannels.Frequency(15) <= OutputFrequency_ch15;
  s_OutputChannels.Frequency(16) <= OutputFrequency_ch16;
  s_OutputChannels.Frequency(17) <= OutputFrequency_ch17;
  s_OutputChannels.Frequency(18) <= OutputFrequency_ch18;
  s_OutputChannels.Frequency(19) <= OutputFrequency_ch19;
  s_OutputChannels.Frequency(20) <= OutputFrequency_ch20;
  s_OutputChannels.Frequency(21) <= OutputFrequency_ch21;
  s_OutputChannels.Frequency(22) <= OutputFrequency_ch22;
  s_OutputChannels.Frequency(23) <= OutputFrequency_ch23;
  s_OutputChannels.Frequency(24) <= OutputFrequency_ch24;
  s_OutputChannels.Frequency(25) <= OutputFrequency_ch25;
  s_OutputChannels.Frequency(26) <= OutputFrequency_ch26;
  s_OutputChannels.Frequency(27) <= OutputFrequency_ch27;
  s_OutputChannels.Frequency(28) <= OutputFrequency_ch28;
  s_OutputChannels.Frequency(29) <= OutputFrequency_ch29;
  s_OutputChannels.Frequency(30) <= OutputFrequency_ch30;
  s_OutputChannels.Frequency(31) <= OutputFrequency_ch31;
  s_OutputChannels.Frequency(32) <= OutputFrequency_ch32;
  --
  s_OutputChannels.DutyCycle(1)  <= OutputDutyCycle_ch1;
  s_OutputChannels.DutyCycle(2)  <= OutputDutyCycle_ch2;
  s_OutputChannels.DutyCycle(3)  <= OutputDutyCycle_ch3;
  s_OutputChannels.DutyCycle(4)  <= OutputDutyCycle_ch4;
  s_OutputChannels.DutyCycle(5)  <= OutputDutyCycle_ch5;
  s_OutputChannels.DutyCycle(6)  <= OutputDutyCycle_ch6;
  s_OutputChannels.DutyCycle(7)  <= OutputDutyCycle_ch7;
  s_OutputChannels.DutyCycle(8)  <= OutputDutyCycle_ch8;
  s_OutputChannels.DutyCycle(9)  <= OutputDutyCycle_ch9;
  s_OutputChannels.DutyCycle(10) <= OutputDutyCycle_ch10;
  s_OutputChannels.DutyCycle(11) <= OutputDutyCycle_ch11;
  s_OutputChannels.DutyCycle(12) <= OutputDutyCycle_ch12;
  s_OutputChannels.DutyCycle(13) <= OutputDutyCycle_ch13;
  s_OutputChannels.DutyCycle(14) <= OutputDutyCycle_ch14;
  s_OutputChannels.DutyCycle(15) <= OutputDutyCycle_ch15;
  s_OutputChannels.DutyCycle(16) <= OutputDutyCycle_ch16;
  s_OutputChannels.DutyCycle(17) <= OutputDutyCycle_ch17;
  s_OutputChannels.DutyCycle(18) <= OutputDutyCycle_ch18;
  s_OutputChannels.DutyCycle(19) <= OutputDutyCycle_ch19;
  s_OutputChannels.DutyCycle(20) <= OutputDutyCycle_ch20;
  s_OutputChannels.DutyCycle(21) <= OutputDutyCycle_ch21;
  s_OutputChannels.DutyCycle(22) <= OutputDutyCycle_ch22;
  s_OutputChannels.DutyCycle(23) <= OutputDutyCycle_ch23;
  s_OutputChannels.DutyCycle(24) <= OutputDutyCycle_ch24;
  s_OutputChannels.DutyCycle(25) <= OutputDutyCycle_ch25;
  s_OutputChannels.DutyCycle(26) <= OutputDutyCycle_ch26;
  s_OutputChannels.DutyCycle(27) <= OutputDutyCycle_ch27;
  s_OutputChannels.DutyCycle(28) <= OutputDutyCycle_ch28;
  s_OutputChannels.DutyCycle(29) <= OutputDutyCycle_ch29;
  s_OutputChannels.DutyCycle(30) <= OutputDutyCycle_ch30;
  s_OutputChannels.DutyCycle(31) <= OutputDutyCycle_ch31;
  s_OutputChannels.DutyCycle(32) <= OutputDutyCycle_ch32;
  --
  out_signal_1(0)                <= s_OutputChannels.Output(1);
  out_signal_2(0)                <= s_OutputChannels.Output(2);
  out_signal_3(0)                <= s_OutputChannels.Output(3);
  out_signal_4(0)                <= s_OutputChannels.Output(4);
  out_signal_5(0)                <= s_OutputChannels.Output(5);
  out_signal_6(0)                <= s_OutputChannels.Output(6);
  out_signal_7(0)                <= s_OutputChannels.Output(7);
  out_signal_8(0)                <= s_OutputChannels.Output(8);
  out_signal_9(0)                <= s_OutputChannels.Output(9);
  out_signal_10(0)               <= s_OutputChannels.Output(10);
  out_signal_11(0)               <= s_OutputChannels.Output(11);
  out_signal_12(0)               <= s_OutputChannels.Output(12);
  out_signal_13(0)               <= s_OutputChannels.Output(13);
  out_signal_14(0)               <= s_OutputChannels.Output(14);
  out_signal_15(0)               <= s_OutputChannels.Output(15);
  out_signal_16(0)               <= s_OutputChannels.Output(16);
  out_signal_17(0)               <= s_OutputChannels.Output(17);
  out_signal_18(0)               <= s_OutputChannels.Output(18);
  out_signal_19(0)               <= s_OutputChannels.Output(19);
  out_signal_20(0)               <= s_OutputChannels.Output(10);
  out_signal_21(0)               <= s_OutputChannels.Output(21);
  out_signal_22(0)               <= s_OutputChannels.Output(22);
  out_signal_23(0)               <= s_OutputChannels.Output(23);
  out_signal_24(0)               <= s_OutputChannels.Output(24);
  out_signal_25(0)               <= s_OutputChannels.Output(25);
  out_signal_26(0)               <= s_OutputChannels.Output(26);
  out_signal_27(0)               <= s_OutputChannels.Output(27);
  out_signal_28(0)               <= s_OutputChannels.Output(28);
  out_signal_29(0)               <= s_OutputChannels.Output(29);
  out_signal_30(0)               <= s_OutputChannels.Output(30);
  out_signal_31(0)               <= s_OutputChannels.Output(31);
  out_signal_32(0)               <= s_OutputChannels.Output(32);

  --

  OutputChannels : FOR Channel IN t_OutputChannelsRange GENERATE
    inst_PhaseAccumulator : ENTITY work.PhaseAccumulator
      GENERIC MAP (
        fpga_frequency     => fpga_frequency,
        g_Width            => c_PhaseAccumulatorWidth,
        g_ResolutionFactor => c_PhaseAccumulatorResolutionFactor
        )
      PORT MAP (
        i_clock                => clk,
        i_reset                => areset,
        i_Active               => s_OutputChannels.Active(Channel),
        i_StartValue           => (OTHERS => '0'),
        i_SetStartValue        => '0',
        i_FrequencyControlWord => s_OutputChannels.Frequency(Channel),
        o_CounterValue         => s_OutputChannels.Counter(Channel),
        o_Overflow             => s_OutputChannels.Overflow(Channel)
        );
    --
    -- signal begins with a rising edge (signaled via an overflow); duty cycle threshold signals the falling edge of the signal
    proc_PWMOutput : PROCESS (clk, areset)
    BEGIN  -- PROCESS proc_PWMOutput
      IF (areset = c_reset_active) THEN                  -- asynchronous reset (active package defined)
        NULL;
      ELSIF (clk'event AND clk = '1') THEN               -- rising clock edge
        IF (unsigned(s_OutputChannels.Counter(Channel)) >= unsigned(s_OutputChannels.DutyCycle(Channel))) THEN
          s_OutputChannels.Output(Channel) <= '0';
        ELSIF (s_OutputChannels.Overflow(Channel)) THEN  -- new period
          s_OutputChannels.Output(Channel) <= '1';
        END IF;
      END IF;
    END PROCESS proc_PWMOutput;
  END GENERATE OutputChannels;

END ARCHITECTURE rtl;  -- of  User
