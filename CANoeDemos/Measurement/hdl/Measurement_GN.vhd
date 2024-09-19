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


-- User code VHD file for the VT5838 Multi I/O Module

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
    AvgBlock_ch1 : out std_logic_vector(31 downto 0) := (others => '0');
    AvgBlock_ch2 : out std_logic_vector(31 downto 0) := (others => '0');
    AvgBlock_ch3 : out std_logic_vector(31 downto 0) := (others => '0');
    AvgBlock_ch4 : out std_logic_vector(31 downto 0) := (others => '0');
    AvgBlock_ch5 : out std_logic_vector(31 downto 0) := (others => '0');
    AvgBlock_ch6 : out std_logic_vector(31 downto 0) := (others => '0');
    AvgBlock_ch7 : out std_logic_vector(31 downto 0) := (others => '0');
    AvgBlock_ch8 : out std_logic_vector(31 downto 0) := (others => '0');
    AvgRolling_ch1 : out std_logic_vector(31 downto 0) := (others => '0');
    AvgRolling_ch2 : out std_logic_vector(31 downto 0) := (others => '0');
    AvgRolling_ch3 : out std_logic_vector(31 downto 0) := (others => '0');
    AvgRolling_ch4 : out std_logic_vector(31 downto 0) := (others => '0');
    AvgRolling_ch5 : out std_logic_vector(31 downto 0) := (others => '0');
    AvgRolling_ch6 : out std_logic_vector(31 downto 0) := (others => '0');
    AvgRolling_ch7 : out std_logic_vector(31 downto 0) := (others => '0');
    AvgRolling_ch8 : out std_logic_vector(31 downto 0) := (others => '0');
    ResetMinMax_ch1 : in std_logic_vector(0 downto 0);
    ResetMinMax_ch2 : in std_logic_vector(0 downto 0);
    ResetMinMax_ch3 : in std_logic_vector(0 downto 0);
    ResetMinMax_ch4 : in std_logic_vector(0 downto 0);
    ResetMinMax_ch5 : in std_logic_vector(0 downto 0);
    ResetMinMax_ch6 : in std_logic_vector(0 downto 0);
    ResetMinMax_ch7 : in std_logic_vector(0 downto 0);
    ResetMinMax_ch8 : in std_logic_vector(0 downto 0);
    Minimum_ch1 : out std_logic_vector(31 downto 0) := (others => '0');
    Minimum_ch2 : out std_logic_vector(31 downto 0) := (others => '0');
    Minimum_ch3 : out std_logic_vector(31 downto 0) := (others => '0');
    Minimum_ch4 : out std_logic_vector(31 downto 0) := (others => '0');
    Minimum_ch5 : out std_logic_vector(31 downto 0) := (others => '0');
    Minimum_ch6 : out std_logic_vector(31 downto 0) := (others => '0');
    Minimum_ch7 : out std_logic_vector(31 downto 0) := (others => '0');
    Minimum_ch8 : out std_logic_vector(31 downto 0) := (others => '0');
    Maximum_ch1 : out std_logic_vector(31 downto 0) := (others => '0');
    Maximum_ch2 : out std_logic_vector(31 downto 0) := (others => '0');
    Maximum_ch3 : out std_logic_vector(31 downto 0) := (others => '0');
    Maximum_ch4 : out std_logic_vector(31 downto 0) := (others => '0');
    Maximum_ch5 : out std_logic_vector(31 downto 0) := (others => '0');
    Maximum_ch6 : out std_logic_vector(31 downto 0) := (others => '0');
    Maximum_ch7 : out std_logic_vector(31 downto 0) := (others => '0');
    Maximum_ch8 : out std_logic_vector(31 downto 0) := (others => '0');
    ActiveFreqDC_ch1 : in std_logic_vector(0 downto 0);
    ActiveFreqDC_ch2 : in std_logic_vector(0 downto 0);
    ActiveFreqDC_ch3 : in std_logic_vector(0 downto 0);
    ActiveFreqDC_ch4 : in std_logic_vector(0 downto 0);
    ActiveFreqDC_ch5 : in std_logic_vector(0 downto 0);
    ActiveFreqDC_ch6 : in std_logic_vector(0 downto 0);
    ActiveFreqDC_ch7 : in std_logic_vector(0 downto 0);
    ActiveFreqDC_ch8 : in std_logic_vector(0 downto 0);
    Threshold_ch1 : in std_logic_vector(31 downto 0);
    Threshold_ch2 : in std_logic_vector(31 downto 0);
    Threshold_ch3 : in std_logic_vector(31 downto 0);
    Threshold_ch4 : in std_logic_vector(31 downto 0);
    Threshold_ch5 : in std_logic_vector(31 downto 0);
    Threshold_ch6 : in std_logic_vector(31 downto 0);
    Threshold_ch7 : in std_logic_vector(31 downto 0);
    Threshold_ch8 : in std_logic_vector(31 downto 0);
    Hysteresis_ch1 : in std_logic_vector(31 downto 0);
    Hysteresis_ch2 : in std_logic_vector(31 downto 0);
    Hysteresis_ch3 : in std_logic_vector(31 downto 0);
    Hysteresis_ch4 : in std_logic_vector(31 downto 0);
    Hysteresis_ch5 : in std_logic_vector(31 downto 0);
    Hysteresis_ch6 : in std_logic_vector(31 downto 0);
    Hysteresis_ch7 : in std_logic_vector(31 downto 0);
    Hysteresis_ch8 : in std_logic_vector(31 downto 0);
    Timeout_ch1 : in std_logic_vector(31 downto 0);
    Timeout_ch2 : in std_logic_vector(31 downto 0);
    Timeout_ch3 : in std_logic_vector(31 downto 0);
    Timeout_ch4 : in std_logic_vector(31 downto 0);
    Timeout_ch5 : in std_logic_vector(31 downto 0);
    Timeout_ch6 : in std_logic_vector(31 downto 0);
    Timeout_ch7 : in std_logic_vector(31 downto 0);
    Timeout_ch8 : in std_logic_vector(31 downto 0);
    PeriodCounter_ch1 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch2 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch3 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch4 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch5 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch6 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch7 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch8 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch1 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch2 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch3 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch4 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch5 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch6 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch7 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch8 : out std_logic_vector(31 downto 0) := (others => '0');
    Timeout_ch23 : in std_logic_vector(31 downto 0);
    Timeout_ch24 : in std_logic_vector(31 downto 0);
    Timeout_ch25 : in std_logic_vector(31 downto 0);
    Timeout_ch26 : in std_logic_vector(31 downto 0);
    Timeout_ch27 : in std_logic_vector(31 downto 0);
    Timeout_ch28 : in std_logic_vector(31 downto 0);
    Timeout_ch29 : in std_logic_vector(31 downto 0);
    Timeout_ch30 : in std_logic_vector(31 downto 0);
    Timeout_ch31 : in std_logic_vector(31 downto 0);
    Timeout_ch32 : in std_logic_vector(31 downto 0);
    Timeout_ch33 : in std_logic_vector(31 downto 0);
    Timeout_ch34 : in std_logic_vector(31 downto 0);
    Timeout_ch35 : in std_logic_vector(31 downto 0);
    Timeout_ch36 : in std_logic_vector(31 downto 0);
    Timeout_ch37 : in std_logic_vector(31 downto 0);
    Timeout_ch38 : in std_logic_vector(31 downto 0);
    PeriodCounter_ch23 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch24 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch25 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch26 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch27 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch28 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch29 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch30 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch31 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch32 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch33 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch34 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch35 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch36 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch37 : out std_logic_vector(31 downto 0) := (others => '0');
    PeriodCounter_ch38 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch23 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch24 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch25 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch26 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch27 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch28 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch29 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch30 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch31 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch32 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch33 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch34 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch35 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch36 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch37 : out std_logic_vector(31 downto 0) := (others => '0');
    PulseCounter_ch38 : out std_logic_vector(31 downto 0) := (others => '0');
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
    --
    -- IBC+
    --
    in_ibc_plus_lane_error_1            : IN    std_logic_vector(7 DOWNTO 0)  := (OTHERS => '0');
    in_ibc_plus_lane_error_2            : IN    std_logic_vector(7 DOWNTO 0)  := (OTHERS => '0');
    in_ibc_plus_lane_error_3            : IN    std_logic_vector(7 DOWNTO 0)  := (OTHERS => '0');
    in_ibc_plus_lane_error_4            : IN    std_logic_vector(7 DOWNTO 0)  := (OTHERS => '0');
    in_ibc_plus_lane_block_tx_ready     : IN    std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');
    in_ibc_plus_lane_block_tx_ack       : IN    std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');
    out_ibc_plus_lane_block_tx_valid    : OUT   std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');
    in_ibc_plus_lane_block_rx_valid     : IN    std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');
    -- @CMD=IBCPLUSSTART
    -- @CMD=IBCPLUSEND
    --
    --
    -- General
    --
    clk                                 : IN    std_logic;                                         -- Clock.clk
    areset                              : IN    std_logic;                                         -- .reset
    h_areset                            : IN    std_logic;
    in_invar_update                     : IN    std_logic;                                         -- invar update notification
    in_timestamp                        : IN    std_logic_vector(63 DOWNTO 0);                     -- current module time
    in_hw_revision                      : IN    std_logic_vector(7 DOWNTO 0);
    --
    --
    -- ADC
    --
    in_adc_data_valid                   : IN    std_logic_vector(0 DOWNTO 0);                      -- marks the validity of incoming ADC data
    out_adc_sample                      : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- triggers the analog to digital conversion
    --
    in_adc_1                            : IN    std_logic_vector(31 DOWNTO 0);                     -- AIn channel 1 analog input
    in_adc_2                            : IN    std_logic_vector(31 DOWNTO 0);                     -- AIn channel 2 analog input
    in_adc_3                            : IN    std_logic_vector(31 DOWNTO 0);                     -- AIn channel 3 analog input
    in_adc_4                            : IN    std_logic_vector(31 DOWNTO 0);                     -- AIn channel 4 analog input
    in_adc_5                            : IN    std_logic_vector(31 DOWNTO 0);                     -- AIn channel 5 analog input
    in_adc_6                            : IN    std_logic_vector(31 DOWNTO 0);                     -- AIn channel 6 analog input
    in_adc_7                            : IN    std_logic_vector(31 DOWNTO 0);                     -- AIn channel 7 analog input
    in_adc_8                            : IN    std_logic_vector(31 DOWNTO 0);                     -- AIn channel 8 analog input
    --
    --
    -- DAC
    --
    in_dac_ready                        : IN    std_logic_vector(0 DOWNTO 0);                      -- indicates that the DAC unit is ready
    in_dac_load                         : IN    std_logic_vector(0 DOWNTO 0);                      -- indicates that data loading is complete (cyclic mode only)
    out_dac_conv                        : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- triggers the digital to analog conversion
    --
    out_dac_1                           : OUT   std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- AOut channel 1 analog output
    out_dac_2                           : OUT   std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- AOut channel 2 analog output
    out_dac_3                           : OUT   std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- AOut channel 3 analog output
    out_dac_4                           : OUT   std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- AOut channel 4 analog output
    out_dac_5                           : OUT   std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- AOut channel 5 analog output
    out_dac_6                           : OUT   std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- AOut channel 6 analog output
    out_dac_7                           : OUT   std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- AOut channel 7 analog output
    out_dac_8                           : OUT   std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- AOut channel 8 analog output
    out_dac_9                           : OUT   std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- AOut channel 9 analog output
    out_dac_10                          : OUT   std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- AOut channel 10 analog output
    out_dac_11                          : OUT   std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- AOut channel 11 analog output
    out_dac_12                          : OUT   std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- AOut channel 12 analog output
    out_dac_13                          : OUT   std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- AOut channel 13 analog output
    out_dac_14                          : OUT   std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- AOut channel 14 analog output
    --
    --
    -- RS422
    --
    in_serial_rs422_1                   : IN    std_logic_vector(0 DOWNTO 0);                      -- RS422 serial data in
    out_serial_rs422_enable_1           : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- RS422 enable signal
    out_serial_rs422_1                  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- RS422 serial data out
    --
    in_serial_rs422_2                   : IN    std_logic_vector(0 DOWNTO 0);                      -- RS422 serial data in
    out_serial_rs422_enable_2           : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- RS422 enable signal
    out_serial_rs422_2                  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- RS422 serial data out
    --
    --
    -- LVDS
    --
    in_serial_lvds_1                    : IN    std_logic_vector(0 DOWNTO 0);                      -- LVDS serial data in
    out_serial_lvds_1                   : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- LVDS serial data out
    --
    in_serial_lvds_2                    : IN    std_logic_vector(0 DOWNTO 0);                      -- LVDS serial data in
    out_serial_lvds_2                   : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- LVDS serial data out
    --
    --
    -- DIO
    --
    out_digital_tristate_1              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 1 pin mode (0: pin activly driven, 1: high impedance mode)
    out_digital_tristate_2              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 2 pin mode (0: pin activly driven, 1: high impedance mode)
    out_digital_tristate_3              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 3 pin mode (0: pin activly driven, 1: high impedance mode)
    out_digital_tristate_4              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 4 pin mode (0: pin activly driven, 1: high impedance mode)
    out_digital_tristate_5              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 5 pin mode (0: pin activly driven, 1: high impedance mode)
    out_digital_tristate_6              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 6 pin mode (0: pin activly driven, 1: high impedance mode)
    out_digital_tristate_7              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 7 pin mode (0: pin activly driven, 1: high impedance mode)
    out_digital_tristate_8              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 8 pin mode (0: pin activly driven, 1: high impedance mode)
    out_digital_tristate_9              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 9 pin mode (0: pin activly driven, 1: high impedance mode)
    out_digital_tristate_10             : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 10 pin mode (0: pin activly driven, 1: high impedance mode)
    out_digital_tristate_11             : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 11 pin mode (0: pin activly driven, 1: high impedance mode)
    out_digital_tristate_12             : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 12 pin mode (0: pin activly driven, 1: high impedance mode)
    out_digital_tristate_13             : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 13 pin mode (0: pin activly driven, 1: high impedance mode)
    out_digital_tristate_14             : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 14 pin mode (0: pin activly driven, 1: high impedance mode)
    out_digital_tristate_15             : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 15 pin mode (0: pin activly driven, 1: high impedance mode)
    out_digital_tristate_16             : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 16 pin mode (0: pin activly driven, 1: high impedance mode)
    --
    in_digital_1                        : IN    std_logic_vector(0 DOWNTO 0);                      -- DIO channel 1 digital input
    in_digital_2                        : IN    std_logic_vector(0 DOWNTO 0);                      -- DIO channel 2 digital input
    in_digital_3                        : IN    std_logic_vector(0 DOWNTO 0);                      -- DIO channel 3 digital input
    in_digital_4                        : IN    std_logic_vector(0 DOWNTO 0);                      -- DIO channel 4 digital input
    in_digital_5                        : IN    std_logic_vector(0 DOWNTO 0);                      -- DIO channel 5 digital input
    in_digital_6                        : IN    std_logic_vector(0 DOWNTO 0);                      -- DIO channel 6 digital input
    in_digital_7                        : IN    std_logic_vector(0 DOWNTO 0);                      -- DIO channel 7 digital input
    in_digital_8                        : IN    std_logic_vector(0 DOWNTO 0);                      -- DIO channel 8 digital input
    in_digital_9                        : IN    std_logic_vector(0 DOWNTO 0);                      -- DIO channel 9 digital input
    in_digital_10                       : IN    std_logic_vector(0 DOWNTO 0);                      -- DIO channel 10 digital input
    in_digital_11                       : IN    std_logic_vector(0 DOWNTO 0);                      -- DIO channel 11 digital input
    in_digital_12                       : IN    std_logic_vector(0 DOWNTO 0);                      -- DIO channel 12 digital input
    in_digital_13                       : IN    std_logic_vector(0 DOWNTO 0);                      -- DIO channel 13 digital input
    in_digital_14                       : IN    std_logic_vector(0 DOWNTO 0);                      -- DIO channel 14 digital input
    in_digital_15                       : IN    std_logic_vector(0 DOWNTO 0);                      -- DIO channel 15 digital input
    in_digital_16                       : IN    std_logic_vector(0 DOWNTO 0);                      -- DIO channel 16 digital input
    --
    out_digital_1                       : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 1 digital output
    out_digital_2                       : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 2 digital output
    out_digital_3                       : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 3 digital output
    out_digital_4                       : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 4 digital output
    out_digital_5                       : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 5 digital output
    out_digital_6                       : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 6 digital output
    out_digital_7                       : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 7 digital output
    out_digital_8                       : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 8 digital output
    out_digital_9                       : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 9 digital output
    out_digital_10                      : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 10 digital output
    out_digital_11                      : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 11 digital output
    out_digital_12                      : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 12 digital output
    out_digital_13                      : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 13 digital output
    out_digital_14                      : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 14 digital output
    out_digital_15                      : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 15 digital output
    out_digital_16                      : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- DIO channel 16 digital output
    --
    --
    -- HRAM 0
    --
    -- @CMD=HRAM0START
    --  All Avalon® and burst interfaces in HRAM 0 are currently disabled.
    --  Open the module specific settings in the VT System FPGA Manager to enable the interfaces.
    -- @CMD=HRAM0END
    --
    --
    -- HRAM 1
    --
    -- @CMD=HRAM1START
    --  All Avalon® and burst interfaces in HRAM 1 are currently disabled.
    --  Open the module specific settings in the VT System FPGA Manager to enable the interfaces.
    -- @CMD=HRAM1END
    --
    --
    -- Application Board
    --
    out_application_board_io_control_1  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 1
    out_application_board_io_control_2  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 2
    out_application_board_io_control_3  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 3
    out_application_board_io_control_4  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 4
    out_application_board_io_control_5  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 5
    out_application_board_io_control_6  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 6
    out_application_board_io_control_7  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 7
    out_application_board_io_control_8  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 8
    out_application_board_io_control_9  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 9
    out_application_board_io_control_10 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 10
    out_application_board_io_control_11 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 11
    out_application_board_io_control_12 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 12
    out_application_board_io_control_13 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 13
    out_application_board_io_control_14 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 14
    out_application_board_io_control_15 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 15
    out_application_board_io_control_16 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 16
    out_application_board_io_control_17 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 17
    out_application_board_io_control_18 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 18
    out_application_board_io_control_19 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 19
    out_application_board_io_control_20 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 20
    out_application_board_io_control_21 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 21
    out_application_board_io_control_22 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 22
    out_application_board_io_control_23 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 23
    out_application_board_io_control_24 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 24
    out_application_board_io_control_25 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 25
    out_application_board_io_control_26 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 26
    out_application_board_io_control_27 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 27
    out_application_board_io_control_28 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 28
    out_application_board_io_control_29 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 29
    out_application_board_io_control_30 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 30
    out_application_board_io_control_31 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 31
    out_application_board_io_control_32 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 32
    out_application_board_io_control_33 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 33
    out_application_board_io_control_34 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 34
    out_application_board_io_control_35 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 35
    out_application_board_io_control_36 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 36
    out_application_board_io_control_37 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 37
    out_application_board_io_control_38 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 38
    out_application_board_io_control_39 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 39
    out_application_board_io_control_40 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 40
    out_application_board_io_control_41 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 41
    out_application_board_io_control_42 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 42
    out_application_board_io_control_43 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 43
    out_application_board_io_control_44 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 44
    out_application_board_io_control_45 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 45
    out_application_board_io_control_46 : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board I/O control 46
    --
    in_application_board_io_input_1     : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 1
    in_application_board_io_input_2     : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 2
    in_application_board_io_input_3     : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 3
    in_application_board_io_input_4     : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 4
    in_application_board_io_input_5     : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 5
    in_application_board_io_input_6     : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 6
    in_application_board_io_input_7     : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 7
    in_application_board_io_input_8     : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 8
    in_application_board_io_input_9     : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 9
    in_application_board_io_input_10    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 10
    in_application_board_io_input_11    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 11
    in_application_board_io_input_12    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 12
    in_application_board_io_input_13    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 13
    in_application_board_io_input_14    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 14
    in_application_board_io_input_15    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 15
    in_application_board_io_input_16    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 16
    in_application_board_io_input_17    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 17
    in_application_board_io_input_18    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 18
    in_application_board_io_input_19    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 19
    in_application_board_io_input_20    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 20
    in_application_board_io_input_21    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 21
    in_application_board_io_input_22    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 22
    in_application_board_io_input_23    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 23
    in_application_board_io_input_24    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 24
    in_application_board_io_input_25    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 25
    in_application_board_io_input_26    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 26
    in_application_board_io_input_27    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 27
    in_application_board_io_input_28    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 28
    in_application_board_io_input_29    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 29
    in_application_board_io_input_30    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 30
    in_application_board_io_input_31    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 31
    in_application_board_io_input_32    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 32
    in_application_board_io_input_33    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 33
    in_application_board_io_input_34    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 34
    in_application_board_io_input_35    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 35
    in_application_board_io_input_36    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 36
    in_application_board_io_input_37    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 37
    in_application_board_io_input_38    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 38
    in_application_board_io_input_39    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 39
    in_application_board_io_input_40    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 40
    in_application_board_io_input_41    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 41
    in_application_board_io_input_42    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 42
    in_application_board_io_input_43    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 43
    in_application_board_io_input_44    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 44
    in_application_board_io_input_45    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 45
    in_application_board_io_input_46    : IN    std_logic_vector(0 DOWNTO 0);                      -- application board input 46
    --
    out_application_board_io_output_1   : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 1
    out_application_board_io_output_2   : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 2
    out_application_board_io_output_3   : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 3
    out_application_board_io_output_4   : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 4
    out_application_board_io_output_5   : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 5
    out_application_board_io_output_6   : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 6
    out_application_board_io_output_7   : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 7
    out_application_board_io_output_8   : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 8
    out_application_board_io_output_9   : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 9
    out_application_board_io_output_10  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 10
    out_application_board_io_output_11  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 11
    out_application_board_io_output_12  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 12
    out_application_board_io_output_13  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 13
    out_application_board_io_output_14  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 14
    out_application_board_io_output_15  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 15
    out_application_board_io_output_16  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 16
    out_application_board_io_output_17  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 17
    out_application_board_io_output_18  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 18
    out_application_board_io_output_19  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 19
    out_application_board_io_output_20  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 20
    out_application_board_io_output_21  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 21
    out_application_board_io_output_22  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 22
    out_application_board_io_output_23  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 23
    out_application_board_io_output_24  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 24
    out_application_board_io_output_25  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 25
    out_application_board_io_output_26  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 26
    out_application_board_io_output_27  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 27
    out_application_board_io_output_28  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 28
    out_application_board_io_output_29  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 29
    out_application_board_io_output_30  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 30
    out_application_board_io_output_31  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 31
    out_application_board_io_output_32  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 32
    out_application_board_io_output_33  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 33
    out_application_board_io_output_34  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 34
    out_application_board_io_output_35  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 35
    out_application_board_io_output_36  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 36
    out_application_board_io_output_37  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 37
    out_application_board_io_output_38  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 38
    out_application_board_io_output_39  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 39
    out_application_board_io_output_40  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 40
    out_application_board_io_output_41  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 41
    out_application_board_io_output_42  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 42
    out_application_board_io_output_43  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 43
    out_application_board_io_output_44  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 44
    out_application_board_io_output_45  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 45
    out_application_board_io_output_46  : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- application board output 46
    --
    --
    -- Font Panel LEDs
    --
    frontpanel_LED_green_1              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel green LED 1
    frontpanel_LED_green_2              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel green LED 2
    frontpanel_LED_green_3              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel green LED 3
    frontpanel_LED_green_4              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel green LED 4
    frontpanel_LED_green_5              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel green LED 5
    frontpanel_LED_green_6              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel green LED 6
    frontpanel_LED_green_7              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel green LED 7
    frontpanel_LED_green_8              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel green LED 8
    frontpanel_LED_green_9              : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel green LED 9
    frontpanel_LED_green_10             : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel green LED 10
    frontpanel_LED_green_11             : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel green LED 11
    frontpanel_LED_green_12             : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel green LED 12
    frontpanel_LED_green_13             : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel green LED 13
    frontpanel_LED_green_14             : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel green LED 14
    frontpanel_LED_green_15             : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel green LED 15
    frontpanel_LED_green_16             : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel green LED 16
    --
    frontpanel_LED_red_1                : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel red LED 1
    frontpanel_LED_red_2                : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel red LED 2
    frontpanel_LED_red_3                : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel red LED 3
    frontpanel_LED_red_4                : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel red LED 4
    frontpanel_LED_red_5                : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel red LED 5
    frontpanel_LED_red_6                : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel red LED 6
    frontpanel_LED_red_7                : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel red LED 7
    frontpanel_LED_red_8                : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel red LED 8
    frontpanel_LED_red_9                : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel red LED 9
    frontpanel_LED_red_10               : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel red LED 10
    frontpanel_LED_red_11               : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel red LED 11
    frontpanel_LED_red_12               : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel red LED 12
    frontpanel_LED_red_13               : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel red LED 13
    frontpanel_LED_red_14               : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel red LED 14
    frontpanel_LED_red_15               : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel red LED 15
    frontpanel_LED_red_16               : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- front panel red LED 16
    --
    --
    -- Eth
    --
    out_phy_reset_n                     : OUT   std_logic                     := '0';
    in_phy_int_n                        : IN    std_logic                     := '0';
    out_phy_led                         : OUT   std_logic_vector(2 DOWNTO 0)  := (OTHERS => '0');
    out_phy_mdc                         : OUT   std_logic                     := '0';
    inout_phy_mdio                      : INOUT std_logic                     := 'Z';
    in_mac_address_valid                : IN    std_logic                     := '0';
    in_mac_address_value                : IN    std_logic_vector(47 DOWNTO 0) := (OTHERS => '0');
    in_eth_reset                        : IN    std_logic                     := '0';
    in_phy_led_0                        : IN    std_logic                     := '0';
    in_phy_link_status                  : IN    std_logic                     := '0';
    in_eth_clock                        : IN    std_logic                     := '0';
    in_eth_gmii_rx_clock_en             : IN    std_logic                     := '0';
    in_eth_gmii_rx_en                   : IN    std_logic                     := '0';
    in_eth_gmii_rx_err                  : IN    std_logic                     := '0';
    in_eth_gmii_rx_data                 : IN    std_logic_vector(7 DOWNTO 0)  := (OTHERS => '0');
    in_eth_gmii_tx_clock_en             : IN    std_logic                     := '0';
    out_eth_gmii_tx_en                  : OUT   std_logic                     := '0';
    out_eth_gmii_tx_err                 : OUT   std_logic                     := '0';
    out_eth_gmii_tx_data                : OUT   std_logic_vector(7 DOWNTO 0)  := (OTHERS => '0');
    --
    --
    --Debug LEDs
    --
    debug_LED_1                         : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- debug LED 1
    debug_LED_2                         : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- debug LED 2
    debug_LED_3                         : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- debug LED 3
    debug_LED_4                         : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- debug LED 4
    debug_LED_5                         : OUT   std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0')   -- debug LED 5
    );
END;

ARCHITECTURE rtl OF User IS

  -- analog channels
  CONSTANT c_NumOfAnalogChannels : natural := 8;
  SUBTYPE c_AnalogChannelsRange IS natural RANGE 1 TO c_NumOfAnalogChannels;
  --
  TYPE t_AnalogChannels IS RECORD
    InputSignal   : t_ArrayVector(c_AnalogChannelsRange)(in_adc_1'range);
    AvgBlock      : t_ArrayVector(c_AnalogChannelsRange)(AvgBlock_ch1'range);
    AvgRolling    : t_ArrayVector(c_AnalogChannelsRange)(AvgRolling_ch1'range);
    ResetMinMax   : t_ArrayLogic(c_AnalogChannelsRange);
    Minimum       : t_ArrayVector(c_AnalogChannelsRange)(Minimum_ch1'range);
    Maximum       : t_ArrayVector(c_AnalogChannelsRange)(Maximum_ch1'range);
    ActiveFreqDC  : t_ArrayLogic(c_AnalogChannelsRange);
    Threshold     : t_ArraySigned(c_AnalogChannelsRange)(Threshold_ch1'range);
    Hysteresis    : t_ArraySigned(c_AnalogChannelsRange)(Hysteresis_ch1'range);
    Timeout       : t_ArrayVector(c_AnalogChannelsRange)(Timeout_ch1'range);
    PeriodCounter : t_ArrayVector(c_AnalogChannelsRange)(PeriodCounter_ch1'range);
    PulseCounter  : t_ArrayVector(c_AnalogChannelsRange)(PulseCounter_ch1'range);
    ADC           : t_ArrayLogic(c_AnalogChannelsRange);  -- analog to digital conversion for freq and dc
  END RECORD;
  --
  SIGNAL s_AnalogChannels : t_AnalogChannels := (
    InputSignal   => (OTHERS => (OTHERS => '0')),
    AvgBlock      => (OTHERS => (OTHERS => '0')),
    AvgRolling    => (OTHERS => (OTHERS => '0')),
    ResetMinMax   => (OTHERS => '0'),
    Minimum       => (OTHERS => (OTHERS => '0')),
    Maximum       => (OTHERS => (OTHERS => '0')),
    ActiveFreqDC  => (OTHERS => '0'),
    Threshold     => (OTHERS => (OTHERS => '0')),
    Hysteresis    => (OTHERS => (OTHERS => '0')),
    Timeout       => (OTHERS => fpga_frequency),          -- 1 sec
    PeriodCounter => (OTHERS => (OTHERS => '0')),
    PulseCounter  => (OTHERS => (OTHERS => '0')),
    ADC           => (OTHERS => '0'));
  --
  -- digital channels
  CONSTANT c_NumOfDigitalChannels : natural := 16;
  SUBTYPE c_DigitalChannelsRange IS natural RANGE 23 TO 23 + (c_NumOfDigitalChannels - 1);
  --
  TYPE t_DigitalChannels IS RECORD
    InputSignal   : t_ArrayLogic(c_DigitalChannelsRange);
    Timeout       : t_ArrayVector(c_DigitalChannelsRange)(Timeout_ch23'range);
    PeriodCounter : t_ArrayVector(c_DigitalChannelsRange)(PeriodCounter_ch23'range);
    PulseCounter  : t_ArrayVector(c_DigitalChannelsRange)(PulseCounter_ch23'range);
  END RECORD;
  --
  SIGNAL s_DigitalChannels : t_DigitalChannels := (
    InputSignal   => (OTHERS => '0'),
    Timeout       => (OTHERS => fpga_frequency),
    PeriodCounter => (OTHERS => (OTHERS => '0')),
    PulseCounter  => (OTHERS => (OTHERS => '0')));

BEGIN

  proc_SignalAllocation : PROCESS (ALL)
  BEGIN  -- PROCESS proc_SignalAllocation
    -- analog signals
    s_AnalogChannels.InputSignal(1)   <= in_adc_1;
    s_AnalogChannels.InputSignal(2)   <= in_adc_2;
    s_AnalogChannels.InputSignal(3)   <= in_adc_3;
    s_AnalogChannels.InputSignal(4)   <= in_adc_4;
    s_AnalogChannels.InputSignal(5)   <= in_adc_5;
    s_AnalogChannels.InputSignal(6)   <= in_adc_6;
    s_AnalogChannels.InputSignal(7)   <= in_adc_7;
    s_AnalogChannels.InputSignal(8)   <= in_adc_8;
    --
    AvgBlock_ch1                      <= s_AnalogChannels.AvgBlock(1);
    AvgBlock_ch2                      <= s_AnalogChannels.AvgBlock(2);
    AvgBlock_ch3                      <= s_AnalogChannels.AvgBlock(3);
    AvgBlock_ch4                      <= s_AnalogChannels.AvgBlock(4);
    AvgBlock_ch5                      <= s_AnalogChannels.AvgBlock(5);
    AvgBlock_ch6                      <= s_AnalogChannels.AvgBlock(6);
    AvgBlock_ch7                      <= s_AnalogChannels.AvgBlock(7);
    AvgBlock_ch8                      <= s_AnalogChannels.AvgBlock(8);
    --
    AvgRolling_ch1                    <= s_AnalogChannels.AvgRolling(1);
    AvgRolling_ch2                    <= s_AnalogChannels.AvgRolling(2);
    AvgRolling_ch3                    <= s_AnalogChannels.AvgRolling(3);
    AvgRolling_ch4                    <= s_AnalogChannels.AvgRolling(4);
    AvgRolling_ch5                    <= s_AnalogChannels.AvgRolling(5);
    AvgRolling_ch6                    <= s_AnalogChannels.AvgRolling(6);
    AvgRolling_ch7                    <= s_AnalogChannels.AvgRolling(7);
    AvgRolling_ch8                    <= s_AnalogChannels.AvgRolling(8);
    --
    s_AnalogChannels.ResetMinMax(1)   <= ResetMinMax_ch1(0);
    s_AnalogChannels.ResetMinMax(2)   <= ResetMinMax_ch2(0);
    s_AnalogChannels.ResetMinMax(3)   <= ResetMinMax_ch3(0);
    s_AnalogChannels.ResetMinMax(4)   <= ResetMinMax_ch4(0);
    s_AnalogChannels.ResetMinMax(5)   <= ResetMinMax_ch5(0);
    s_AnalogChannels.ResetMinMax(6)   <= ResetMinMax_ch6(0);
    s_AnalogChannels.ResetMinMax(7)   <= ResetMinMax_ch7(0);
    s_AnalogChannels.ResetMinMax(8)   <= ResetMinMax_ch8(0);
    --
    Minimum_ch1                       <= s_AnalogChannels.Minimum(1);
    Minimum_ch2                       <= s_AnalogChannels.Minimum(2);
    Minimum_ch3                       <= s_AnalogChannels.Minimum(3);
    Minimum_ch4                       <= s_AnalogChannels.Minimum(4);
    Minimum_ch5                       <= s_AnalogChannels.Minimum(5);
    Minimum_ch6                       <= s_AnalogChannels.Minimum(6);
    Minimum_ch7                       <= s_AnalogChannels.Minimum(7);
    Minimum_ch8                       <= s_AnalogChannels.Minimum(8);
    --
    Maximum_ch1                       <= s_AnalogChannels.Maximum(1);
    Maximum_ch2                       <= s_AnalogChannels.Maximum(2);
    Maximum_ch3                       <= s_AnalogChannels.Maximum(3);
    Maximum_ch4                       <= s_AnalogChannels.Maximum(4);
    Maximum_ch5                       <= s_AnalogChannels.Maximum(5);
    Maximum_ch6                       <= s_AnalogChannels.Maximum(6);
    Maximum_ch7                       <= s_AnalogChannels.Maximum(7);
    Maximum_ch8                       <= s_AnalogChannels.Maximum(8);
    --
    s_AnalogChannels.ActiveFreqDC(1)  <= ActiveFreqDC_ch1(0);
    s_AnalogChannels.ActiveFreqDC(2)  <= ActiveFreqDC_ch2(0);
    s_AnalogChannels.ActiveFreqDC(3)  <= ActiveFreqDC_ch3(0);
    s_AnalogChannels.ActiveFreqDC(4)  <= ActiveFreqDC_ch4(0);
    s_AnalogChannels.ActiveFreqDC(5)  <= ActiveFreqDC_ch5(0);
    s_AnalogChannels.ActiveFreqDC(6)  <= ActiveFreqDC_ch6(0);
    s_AnalogChannels.ActiveFreqDC(7)  <= ActiveFreqDC_ch7(0);
    s_AnalogChannels.ActiveFreqDC(8)  <= ActiveFreqDC_ch8(0);
    --
    s_AnalogChannels.Threshold(1)     <= signed(Threshold_ch1);
    s_AnalogChannels.Threshold(2)     <= signed(Threshold_ch2);
    s_AnalogChannels.Threshold(3)     <= signed(Threshold_ch3);
    s_AnalogChannels.Threshold(4)     <= signed(Threshold_ch4);
    s_AnalogChannels.Threshold(5)     <= signed(Threshold_ch5);
    s_AnalogChannels.Threshold(6)     <= signed(Threshold_ch6);
    s_AnalogChannels.Threshold(7)     <= signed(Threshold_ch7);
    s_AnalogChannels.Threshold(8)     <= signed(Threshold_ch8);
    --
    s_AnalogChannels.Hysteresis(1)    <= signed(Hysteresis_ch1);
    s_AnalogChannels.Hysteresis(2)    <= signed(Hysteresis_ch2);
    s_AnalogChannels.Hysteresis(3)    <= signed(Hysteresis_ch3);
    s_AnalogChannels.Hysteresis(4)    <= signed(Hysteresis_ch4);
    s_AnalogChannels.Hysteresis(5)    <= signed(Hysteresis_ch5);
    s_AnalogChannels.Hysteresis(6)    <= signed(Hysteresis_ch6);
    s_AnalogChannels.Hysteresis(7)    <= signed(Hysteresis_ch7);
    s_AnalogChannels.Hysteresis(8)    <= signed(Hysteresis_ch8);
    --
    s_AnalogChannels.Timeout(1)       <= Timeout_ch1;
    s_AnalogChannels.Timeout(2)       <= Timeout_ch2;
    s_AnalogChannels.Timeout(3)       <= Timeout_ch3;
    s_AnalogChannels.Timeout(4)       <= Timeout_ch4;
    s_AnalogChannels.Timeout(5)       <= Timeout_ch5;
    s_AnalogChannels.Timeout(6)       <= Timeout_ch6;
    s_AnalogChannels.Timeout(7)       <= Timeout_ch7;
    s_AnalogChannels.Timeout(8)       <= Timeout_ch8;
    --
    PeriodCounter_ch1                 <= s_AnalogChannels.PeriodCounter(1);
    PeriodCounter_ch2                 <= s_AnalogChannels.PeriodCounter(2);
    PeriodCounter_ch3                 <= s_AnalogChannels.PeriodCounter(3);
    PeriodCounter_ch4                 <= s_AnalogChannels.PeriodCounter(4);
    PeriodCounter_ch5                 <= s_AnalogChannels.PeriodCounter(5);
    PeriodCounter_ch6                 <= s_AnalogChannels.PeriodCounter(6);
    PeriodCounter_ch7                 <= s_AnalogChannels.PeriodCounter(7);
    PeriodCounter_ch8                 <= s_AnalogChannels.PeriodCounter(8);
    --
    PulseCounter_ch1                  <= s_AnalogChannels.PulseCounter(1);
    PulseCounter_ch2                  <= s_AnalogChannels.PulseCounter(2);
    PulseCounter_ch3                  <= s_AnalogChannels.PulseCounter(3);
    PulseCounter_ch4                  <= s_AnalogChannels.PulseCounter(4);
    PulseCounter_ch5                  <= s_AnalogChannels.PulseCounter(5);
    PulseCounter_ch6                  <= s_AnalogChannels.PulseCounter(6);
    PulseCounter_ch7                  <= s_AnalogChannels.PulseCounter(7);
    PulseCounter_ch8                  <= s_AnalogChannels.PulseCounter(8);
    --
    --
    -- digital signals
    out_digital_tristate_1            <= "1";  -- high impedance to set it to input
    out_digital_tristate_2            <= "1";
    out_digital_tristate_3            <= "1";
    out_digital_tristate_4            <= "1";
    out_digital_tristate_5            <= "1";
    out_digital_tristate_6            <= "1";
    out_digital_tristate_7            <= "1";
    out_digital_tristate_8            <= "1";
    out_digital_tristate_9            <= "1";
    out_digital_tristate_10           <= "1";
    out_digital_tristate_11           <= "1";
    out_digital_tristate_12           <= "1";
    out_digital_tristate_13           <= "1";
    out_digital_tristate_14           <= "1";
    out_digital_tristate_15           <= "1";
    out_digital_tristate_16           <= "1";
    --
    s_DigitalChannels.InputSignal(23) <= in_digital_1(0);
    s_DigitalChannels.InputSignal(24) <= in_digital_2(0);
    s_DigitalChannels.InputSignal(25) <= in_digital_3(0);
    s_DigitalChannels.InputSignal(26) <= in_digital_4(0);
    s_DigitalChannels.InputSignal(27) <= in_digital_5(0);
    s_DigitalChannels.InputSignal(28) <= in_digital_6(0);
    s_DigitalChannels.InputSignal(29) <= in_digital_7(0);
    s_DigitalChannels.InputSignal(30) <= in_digital_8(0);
    s_DigitalChannels.InputSignal(31) <= in_digital_9(0);
    s_DigitalChannels.InputSignal(32) <= in_digital_10(0);
    s_DigitalChannels.InputSignal(33) <= in_digital_11(0);
    s_DigitalChannels.InputSignal(34) <= in_digital_12(0);
    s_DigitalChannels.InputSignal(35) <= in_digital_13(0);
    s_DigitalChannels.InputSignal(36) <= in_digital_14(0);
    s_DigitalChannels.InputSignal(37) <= in_digital_15(0);
    s_DigitalChannels.InputSignal(38) <= in_digital_16(0);
    --
    s_DigitalChannels.Timeout(23)     <= Timeout_ch23;
    s_DigitalChannels.Timeout(24)     <= Timeout_ch24;
    s_DigitalChannels.Timeout(25)     <= Timeout_ch25;
    s_DigitalChannels.Timeout(26)     <= Timeout_ch26;
    s_DigitalChannels.Timeout(27)     <= Timeout_ch27;
    s_DigitalChannels.Timeout(28)     <= Timeout_ch28;
    s_DigitalChannels.Timeout(29)     <= Timeout_ch29;
    s_DigitalChannels.Timeout(30)     <= Timeout_ch30;
    s_DigitalChannels.Timeout(31)     <= Timeout_ch31;
    s_DigitalChannels.Timeout(32)     <= Timeout_ch32;
    s_DigitalChannels.Timeout(33)     <= Timeout_ch33;
    s_DigitalChannels.Timeout(34)     <= Timeout_ch34;
    s_DigitalChannels.Timeout(35)     <= Timeout_ch35;
    s_DigitalChannels.Timeout(36)     <= Timeout_ch36;
    s_DigitalChannels.Timeout(37)     <= Timeout_ch37;
    s_DigitalChannels.Timeout(38)     <= Timeout_ch38;
    --
    PeriodCounter_ch23                <= s_DigitalChannels.PeriodCounter(23);
    PeriodCounter_ch24                <= s_DigitalChannels.PeriodCounter(24);
    PeriodCounter_ch25                <= s_DigitalChannels.PeriodCounter(25);
    PeriodCounter_ch26                <= s_DigitalChannels.PeriodCounter(26);
    PeriodCounter_ch27                <= s_DigitalChannels.PeriodCounter(27);
    PeriodCounter_ch28                <= s_DigitalChannels.PeriodCounter(28);
    PeriodCounter_ch29                <= s_DigitalChannels.PeriodCounter(29);
    PeriodCounter_ch30                <= s_DigitalChannels.PeriodCounter(30);
    PeriodCounter_ch31                <= s_DigitalChannels.PeriodCounter(31);
    PeriodCounter_ch32                <= s_DigitalChannels.PeriodCounter(32);
    PeriodCounter_ch33                <= s_DigitalChannels.PeriodCounter(33);
    PeriodCounter_ch34                <= s_DigitalChannels.PeriodCounter(34);
    PeriodCounter_ch35                <= s_DigitalChannels.PeriodCounter(35);
    PeriodCounter_ch36                <= s_DigitalChannels.PeriodCounter(36);
    PeriodCounter_ch37                <= s_DigitalChannels.PeriodCounter(37);
    PeriodCounter_ch38                <= s_DigitalChannels.PeriodCounter(38);
    --
    PulseCounter_ch23                 <= s_DigitalChannels.PulseCounter(23);
    PulseCounter_ch24                 <= s_DigitalChannels.PulseCounter(24);
    PulseCounter_ch25                 <= s_DigitalChannels.PulseCounter(25);
    PulseCounter_ch26                 <= s_DigitalChannels.PulseCounter(26);
    PulseCounter_ch27                 <= s_DigitalChannels.PulseCounter(27);
    PulseCounter_ch28                 <= s_DigitalChannels.PulseCounter(28);
    PulseCounter_ch29                 <= s_DigitalChannels.PulseCounter(29);
    PulseCounter_ch30                 <= s_DigitalChannels.PulseCounter(30);
    PulseCounter_ch31                 <= s_DigitalChannels.PulseCounter(31);
    PulseCounter_ch32                 <= s_DigitalChannels.PulseCounter(32);
    PulseCounter_ch33                 <= s_DigitalChannels.PulseCounter(33);
    PulseCounter_ch34                 <= s_DigitalChannels.PulseCounter(34);
    PulseCounter_ch35                 <= s_DigitalChannels.PulseCounter(35);
    PulseCounter_ch36                 <= s_DigitalChannels.PulseCounter(36);
    PulseCounter_ch37                 <= s_DigitalChannels.PulseCounter(37);
    PulseCounter_ch38                 <= s_DigitalChannels.PulseCounter(38);
  END PROCESS proc_SignalAllocation;

  --
  --
  --

  AnalogChannels : FOR Channel IN c_AnalogChannelsRange GENERATE
    inst_Analog_Avg : ENTITY work.Analog_Avg
      PORT MAP (
        i_clock          => clk,
        i_reset          => areset,
        i_Signal         => s_AnalogChannels.InputSignal(Channel),
        i_NewValue       => in_adc_data_valid(0),
        o_AvgBlock       => s_AnalogChannels.AvgBlock(Channel),
        o_AvgRolling     => s_AnalogChannels.AvgRolling(Channel),
        o_NewDataBlock   => OPEN,
        o_NewDataRolling => OPEN
        );
    --
    inst_Analog_MinMax : ENTITY work.Analog_MinMax
      PORT MAP (
        i_clock       => clk,
        i_reset       => areset,
        i_Signal      => s_AnalogChannels.InputSignal(Channel),
        i_NewValue    => in_adc_data_valid(0),
        i_ResetMinMax => s_AnalogChannels.ResetMinMax(Channel),
        o_NewData     => OPEN,
        o_Min         => s_AnalogChannels.Minimum(Channel),
        o_Max         => s_AnalogChannels.Maximum(Channel)
        );
    --
    --
    --
    proc_AnalogToDigitalConversion : PROCESS (clk, areset)
    BEGIN  -- PROCESS proc_AnalogToDigitalConversion
      IF (areset = c_reset_active) THEN                                                                                                          -- asynchronous reset (active package defined)
        NULL;
      ELSIF (clk'event AND clk = '1') THEN                                                                                                       -- rising clock edge
        IF (signed(s_AnalogChannels.InputSignal(Channel)) >= s_AnalogChannels.Threshold(Channel) + s_AnalogChannels.Hysteresis(Channel)) THEN    -- high
          s_AnalogChannels.ADC(Channel) <= '1';
        ELSIF (signed(s_AnalogChannels.InputSignal(Channel)) < s_AnalogChannels.Threshold(Channel) - s_AnalogChannels.Hysteresis(Channel)) THEN  -- low
          s_AnalogChannels.ADC(Channel) <= '0';
        END IF;
      END IF;
    END PROCESS proc_AnalogToDigitalConversion;
    --
    inst_Digital_FrequencyDutyCycle : ENTITY work.Digital_FrequencyDutyCycle
      PORT MAP (
        i_clock         => clk,
        i_reset         => areset,
        i_Active        => s_AnalogChannels.ActiveFreqDC(Channel),
        i_Signal        => s_AnalogChannels.ADC(Channel),
        i_Timeout       => s_AnalogChannels.Timeout(Channel),
        o_NewData       => OPEN,
        o_PeriodCounter => s_AnalogChannels.PeriodCounter(Channel),
        o_PulseCounter  => s_AnalogChannels.PulseCounter(Channel),
        o_TimeoutHigh   => OPEN,
        o_TimeoutLow    => OPEN
        );
  END GENERATE AnalogChannels;

  --

  DigitalChannels : FOR Channel IN c_DigitalChannelsRange GENERATE
    inst_Digital_FrequencyDutyCycle : ENTITY work.Digital_FrequencyDutyCycle
      PORT MAP (
        i_clock         => clk,
        i_reset         => areset,
        i_Active        => '1',
        i_Signal        => s_DigitalChannels.InputSignal(Channel),
        i_Timeout       => s_DigitalChannels.Timeout(Channel),
        o_NewData       => OPEN,
        o_PeriodCounter => s_DigitalChannels.PeriodCounter(Channel),
        o_PulseCounter  => s_DigitalChannels.PulseCounter(Channel),
        o_TimeoutHigh   => OPEN,
        o_TimeoutLow    => OPEN
        );
  END GENERATE DigitalChannels;

END ARCHITECTURE rtl;  -- of  User
