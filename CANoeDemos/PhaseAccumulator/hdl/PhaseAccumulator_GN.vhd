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
    Frequency_ch9 : in std_logic_vector(31 downto 0);
    Frequency_ch10 : in std_logic_vector(31 downto 0);
    Frequency_ch11 : in std_logic_vector(31 downto 0);
    Frequency_ch12 : in std_logic_vector(31 downto 0);
    Frequency_ch13 : in std_logic_vector(31 downto 0);
    Frequency_ch14 : in std_logic_vector(31 downto 0);
    Frequency_ch15 : in std_logic_vector(31 downto 0);
    Frequency_ch16 : in std_logic_vector(31 downto 0);
    Frequency_ch17 : in std_logic_vector(31 downto 0);
    Frequency_ch18 : in std_logic_vector(31 downto 0);
    Frequency_ch19 : in std_logic_vector(31 downto 0);
    Frequency_ch20 : in std_logic_vector(31 downto 0);
    Frequency_ch21 : in std_logic_vector(31 downto 0);
    Frequency_ch22 : in std_logic_vector(31 downto 0);
    Frequency_ch23 : in std_logic_vector(31 downto 0);
    Frequency_ch24 : in std_logic_vector(31 downto 0);
    Frequency_ch25 : in std_logic_vector(31 downto 0);
    Frequency_ch26 : in std_logic_vector(31 downto 0);
    Frequency_ch27 : in std_logic_vector(31 downto 0);
    Frequency_ch28 : in std_logic_vector(31 downto 0);
    Frequency_ch29 : in std_logic_vector(31 downto 0);
    Frequency_ch30 : in std_logic_vector(31 downto 0);
    Frequency_ch31 : in std_logic_vector(31 downto 0);
    Frequency_ch32 : in std_logic_vector(31 downto 0);
    Frequency_ch33 : in std_logic_vector(31 downto 0);
    Frequency_ch34 : in std_logic_vector(31 downto 0);
    Frequency_ch35 : in std_logic_vector(31 downto 0);
    Frequency_ch36 : in std_logic_vector(31 downto 0);
    Frequency_ch37 : in std_logic_vector(31 downto 0);
    Frequency_ch38 : in std_logic_vector(31 downto 0);
    DutyCycle_ch23 : in std_logic_vector(31 downto 0);
    DutyCycle_ch24 : in std_logic_vector(31 downto 0);
    DutyCycle_ch25 : in std_logic_vector(31 downto 0);
    DutyCycle_ch26 : in std_logic_vector(31 downto 0);
    DutyCycle_ch27 : in std_logic_vector(31 downto 0);
    DutyCycle_ch28 : in std_logic_vector(31 downto 0);
    DutyCycle_ch29 : in std_logic_vector(31 downto 0);
    DutyCycle_ch30 : in std_logic_vector(31 downto 0);
    DutyCycle_ch31 : in std_logic_vector(31 downto 0);
    DutyCycle_ch32 : in std_logic_vector(31 downto 0);
    DutyCycle_ch33 : in std_logic_vector(31 downto 0);
    DutyCycle_ch34 : in std_logic_vector(31 downto 0);
    DutyCycle_ch35 : in std_logic_vector(31 downto 0);
    DutyCycle_ch36 : in std_logic_vector(31 downto 0);
    DutyCycle_ch37 : in std_logic_vector(31 downto 0);
    DutyCycle_ch38 : in std_logic_vector(31 downto 0);
    OutputSignal_ch9 : out std_logic_vector(31 downto 0) := (others => '0');
    OutputSignal_ch10 : out std_logic_vector(31 downto 0) := (others => '0');
    OutputSignal_ch11 : out std_logic_vector(31 downto 0) := (others => '0');
    OutputSignal_ch12 : out std_logic_vector(31 downto 0) := (others => '0');
    OutputSignal_ch13 : out std_logic_vector(31 downto 0) := (others => '0');
    OutputSignal_ch14 : out std_logic_vector(31 downto 0) := (others => '0');
    OutputSignal_ch15 : out std_logic_vector(31 downto 0) := (others => '0');
    OutputSignal_ch16 : out std_logic_vector(31 downto 0) := (others => '0');
    OutputSignal_ch17 : out std_logic_vector(31 downto 0) := (others => '0');
    OutputSignal_ch18 : out std_logic_vector(31 downto 0) := (others => '0');
    OutputSignal_ch19 : out std_logic_vector(31 downto 0) := (others => '0');
    OutputSignal_ch20 : out std_logic_vector(31 downto 0) := (others => '0');
    OutputSignal_ch21 : out std_logic_vector(31 downto 0) := (others => '0');
    OutputSignal_ch22 : out std_logic_vector(31 downto 0) := (others => '0');
    OutputSignal_ch23 : out std_logic_vector(0 downto 0) := (others => '0');
    OutputSignal_ch24 : out std_logic_vector(0 downto 0) := (others => '0');
    OutputSignal_ch25 : out std_logic_vector(0 downto 0) := (others => '0');
    OutputSignal_ch26 : out std_logic_vector(0 downto 0) := (others => '0');
    OutputSignal_ch27 : out std_logic_vector(0 downto 0) := (others => '0');
    OutputSignal_ch28 : out std_logic_vector(0 downto 0) := (others => '0');
    OutputSignal_ch29 : out std_logic_vector(0 downto 0) := (others => '0');
    OutputSignal_ch30 : out std_logic_vector(0 downto 0) := (others => '0');
    OutputSignal_ch31 : out std_logic_vector(0 downto 0) := (others => '0');
    OutputSignal_ch32 : out std_logic_vector(0 downto 0) := (others => '0');
    OutputSignal_ch33 : out std_logic_vector(0 downto 0) := (others => '0');
    OutputSignal_ch34 : out std_logic_vector(0 downto 0) := (others => '0');
    OutputSignal_ch35 : out std_logic_vector(0 downto 0) := (others => '0');
    OutputSignal_ch36 : out std_logic_vector(0 downto 0) := (others => '0');
    OutputSignal_ch37 : out std_logic_vector(0 downto 0) := (others => '0');
    OutputSignal_ch38 : out std_logic_vector(0 downto 0) := (others => '0');
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

  CONSTANT c_PhaseAccumulatorWidth            : natural                                                                                := 32;
  CONSTANT c_PhaseAccumulatorResolutionFactor : std_logic_vector(31 DOWNTO 0)                                                          := 32d"1";
  CONSTANT c_NumOfAnalogOutputChannels        : natural                                                                                := 14;
  CONSTANT c_AddressWidth                     : natural                                                                                := 8;
  CONSTANT c_DataWidth                        : natural                                                                                := 32;
  CONSTANT c_MemInitFile                      : t_ArrayString(1 TO c_NumOfAnalogOutputChannels)(1 TO 12)                               := (1 TO 14 => "RAM_Sine.mif");
  --
  SIGNAL s_AnalogOutFrequency                 : t_ArrayVector(1 TO c_NumOfAnalogOutputChannels)(c_PhaseAccumulatorWidth - 1 DOWNTO 0)  := (OTHERS  => (OTHERS => '0'));
  SIGNAL s_AnalogOutCounter                   : t_ArrayVector(1 TO c_NumOfAnalogOutputChannels)(c_PhaseAccumulatorWidth - 1 DOWNTO 0)  := (OTHERS  => (OTHERS => '0'));
  SIGNAL s_AnalogOutOverflow                  : t_ArrayLogic(1 TO c_NumOfAnalogOutputChannels)                                         := (OTHERS  => '0');
  SIGNAL s_AnalogOutRAMData                   : t_ArrayVector(1 TO c_NumOfAnalogOutputChannels)(c_DataWidth - 1 DOWNTO 0)              := (OTHERS  => (OTHERS => '0'));
  SIGNAL s_AnalogOutRAMEnable                 : t_ArrayLogic(1 TO c_NumOfAnalogOutputChannels)                                         := (OTHERS  => '0');
  SIGNAL s_AnalogOutRAMAddress                : t_ArrayNatural(1 TO c_NumOfAnalogOutputChannels)                                       := (OTHERS  => 0);
  SIGNAL s_AnalogOutSignal                    : t_ArrayVector(1 TO c_NumOfAnalogOutputChannels)(c_DataWidth -1 DOWNTO 0)               := (OTHERS  => (OTHERS => '0'));
  --
  CONSTANT c_NumOfDigitalOutputChannels       : natural                                                                                := 16;
  SIGNAL s_DigitalOutFrequency                : t_ArrayVector(1 TO c_NumOfDigitalOutputChannels)(31 DOWNTO 0)                          := (OTHERS  => (OTHERS => '0'));
  SIGNAL s_DigitalOutDutyCycle                : t_ArrayVector(1 TO c_NumOfDigitalOutputChannels)(31 DOWNTO 0)                          := (OTHERS  => (OTHERS => '0'));
  SIGNAL s_DigitalOutCounter                  : t_ArrayVector(1 TO c_NumOfDigitalOutputChannels)(c_PhaseAccumulatorWidth - 1 DOWNTO 0) := (OTHERS  => (OTHERS => '0'));
  SIGNAL s_DigitalOutOverflow                 : t_ArrayLogic(1 TO c_NumOfDigitalOutputChannels)                                        := (OTHERS  => '0');
  SIGNAL s_DigitalOutSignal                   : t_ArrayLogic(1 TO c_NumOfDigitalOutputChannels)                                        := (OTHERS  => '0');

BEGIN

  proc_SignalAllocation : PROCESS (clk, areset)
  BEGIN  -- PROCESS proc_SignalAllocation
    IF (areset = c_reset_active) THEN     -- asynchronous reset (active package defined)
      NULL;
    ELSIF (clk'event AND clk = '1') THEN  -- rising clock edge
      -- analog output
      s_AnalogOutFrequency(1)   <= Frequency_ch9;
      s_AnalogOutFrequency(2)   <= Frequency_ch10;
      s_AnalogOutFrequency(3)   <= Frequency_ch11;
      s_AnalogOutFrequency(4)   <= Frequency_ch12;
      s_AnalogOutFrequency(5)   <= Frequency_ch13;
      s_AnalogOutFrequency(6)   <= Frequency_ch14;
      s_AnalogOutFrequency(7)   <= Frequency_ch15;
      s_AnalogOutFrequency(8)   <= Frequency_ch16;
      s_AnalogOutFrequency(9)   <= Frequency_ch17;
      s_AnalogOutFrequency(10)  <= Frequency_ch18;
      s_AnalogOutFrequency(11)  <= Frequency_ch19;
      s_AnalogOutFrequency(12)  <= Frequency_ch20;
      s_AnalogOutFrequency(13)  <= Frequency_ch21;
      s_AnalogOutFrequency(14)  <= Frequency_ch22;
      --
      out_dac_1                 <= s_AnalogOutSignal(1);
      out_dac_2                 <= s_AnalogOutSignal(2);
      out_dac_3                 <= s_AnalogOutSignal(3);
      out_dac_4                 <= s_AnalogOutSignal(4);
      out_dac_5                 <= s_AnalogOutSignal(5);
      out_dac_6                 <= s_AnalogOutSignal(6);
      out_dac_7                 <= s_AnalogOutSignal(7);
      out_dac_8                 <= s_AnalogOutSignal(8);
      out_dac_9                 <= s_AnalogOutSignal(9);
      out_dac_10                <= s_AnalogOutSignal(10);
      out_dac_11                <= s_AnalogOutSignal(11);
      out_dac_12                <= s_AnalogOutSignal(12);
      out_dac_13                <= s_AnalogOutSignal(13);
      out_dac_14                <= s_AnalogOutSignal(14);
      --
      OutputSignal_ch9          <= s_AnalogOutSignal(1);
      OutputSignal_ch10         <= s_AnalogOutSignal(2);
      OutputSignal_ch11         <= s_AnalogOutSignal(3);
      OutputSignal_ch12         <= s_AnalogOutSignal(4);
      OutputSignal_ch13         <= s_AnalogOutSignal(5);
      OutputSignal_ch14         <= s_AnalogOutSignal(6);
      OutputSignal_ch15         <= s_AnalogOutSignal(7);
      OutputSignal_ch16         <= s_AnalogOutSignal(8);
      OutputSignal_ch17         <= s_AnalogOutSignal(9);
      OutputSignal_ch18         <= s_AnalogOutSignal(10);
      OutputSignal_ch19         <= s_AnalogOutSignal(11);
      OutputSignal_ch20         <= s_AnalogOutSignal(12);
      OutputSignal_ch21         <= s_AnalogOutSignal(13);
      OutputSignal_ch22         <= s_AnalogOutSignal(14);
      --
      --
      -- digital output
      s_DigitalOutFrequency(1)  <= Frequency_ch23;
      s_DigitalOutFrequency(2)  <= Frequency_ch24;
      s_DigitalOutFrequency(3)  <= Frequency_ch25;
      s_DigitalOutFrequency(4)  <= Frequency_ch26;
      s_DigitalOutFrequency(5)  <= Frequency_ch27;
      s_DigitalOutFrequency(6)  <= Frequency_ch28;
      s_DigitalOutFrequency(7)  <= Frequency_ch29;
      s_DigitalOutFrequency(8)  <= Frequency_ch30;
      s_DigitalOutFrequency(9)  <= Frequency_ch31;
      s_DigitalOutFrequency(10) <= Frequency_ch32;
      s_DigitalOutFrequency(11) <= Frequency_ch33;
      s_DigitalOutFrequency(12) <= Frequency_ch34;
      s_DigitalOutFrequency(13) <= Frequency_ch35;
      s_DigitalOutFrequency(14) <= Frequency_ch36;
      s_DigitalOutFrequency(15) <= Frequency_ch37;
      s_DigitalOutFrequency(16) <= Frequency_ch38;
      --
      s_DigitalOutDutyCycle(1)  <= DutyCycle_ch23;
      s_DigitalOutDutyCycle(2)  <= DutyCycle_ch24;
      s_DigitalOutDutyCycle(3)  <= DutyCycle_ch25;
      s_DigitalOutDutyCycle(4)  <= DutyCycle_ch26;
      s_DigitalOutDutyCycle(5)  <= DutyCycle_ch27;
      s_DigitalOutDutyCycle(6)  <= DutyCycle_ch28;
      s_DigitalOutDutyCycle(7)  <= DutyCycle_ch29;
      s_DigitalOutDutyCycle(8)  <= DutyCycle_ch30;
      s_DigitalOutDutyCycle(9)  <= DutyCycle_ch31;
      s_DigitalOutDutyCycle(10) <= DutyCycle_ch32;
      s_DigitalOutDutyCycle(11) <= DutyCycle_ch33;
      s_DigitalOutDutyCycle(12) <= DutyCycle_ch34;
      s_DigitalOutDutyCycle(13) <= DutyCycle_ch35;
      s_DigitalOutDutyCycle(14) <= DutyCycle_ch36;
      s_DigitalOutDutyCycle(15) <= DutyCycle_ch37;
      s_DigitalOutDutyCycle(16) <= DutyCycle_ch38;
      --
      out_digital_1(0)          <= s_DigitalOutSignal(1);
      out_digital_2(0)          <= s_DigitalOutSignal(2);
      out_digital_3(0)          <= s_DigitalOutSignal(3);
      out_digital_4(0)          <= s_DigitalOutSignal(4);
      out_digital_5(0)          <= s_DigitalOutSignal(5);
      out_digital_6(0)          <= s_DigitalOutSignal(6);
      out_digital_7(0)          <= s_DigitalOutSignal(7);
      out_digital_8(0)          <= s_DigitalOutSignal(8);
      out_digital_9(0)          <= s_DigitalOutSignal(9);
      out_digital_10(0)         <= s_DigitalOutSignal(10);
      out_digital_11(0)         <= s_DigitalOutSignal(11);
      out_digital_12(0)         <= s_DigitalOutSignal(12);
      out_digital_13(0)         <= s_DigitalOutSignal(13);
      out_digital_14(0)         <= s_DigitalOutSignal(14);
      out_digital_15(0)         <= s_DigitalOutSignal(15);
      out_digital_16(0)         <= s_DigitalOutSignal(16);
      --
      OutputSignal_ch23(0)      <= s_DigitalOutSignal(1);
      OutputSignal_ch24(0)      <= s_DigitalOutSignal(2);
      OutputSignal_ch25(0)      <= s_DigitalOutSignal(3);
      OutputSignal_ch26(0)      <= s_DigitalOutSignal(4);
      OutputSignal_ch27(0)      <= s_DigitalOutSignal(5);
      OutputSignal_ch28(0)      <= s_DigitalOutSignal(6);
      OutputSignal_ch29(0)      <= s_DigitalOutSignal(7);
      OutputSignal_ch30(0)      <= s_DigitalOutSignal(8);
      OutputSignal_ch31(0)      <= s_DigitalOutSignal(9);
      OutputSignal_ch32(0)      <= s_DigitalOutSignal(10);
      OutputSignal_ch33(0)      <= s_DigitalOutSignal(11);
      OutputSignal_ch34(0)      <= s_DigitalOutSignal(12);
      OutputSignal_ch35(0)      <= s_DigitalOutSignal(13);
      OutputSignal_ch36(0)      <= s_DigitalOutSignal(14);
      OutputSignal_ch37(0)      <= s_DigitalOutSignal(15);
      OutputSignal_ch38(0)      <= s_DigitalOutSignal(16);
    END IF;
  END PROCESS proc_SignalAllocation;

  --
  --
  --

  -- uses the frequency value to calculate a RAM address
  AnalogOutput : FOR Channel IN 1 TO c_NumOfAnalogOutputChannels GENERATE
    -- uses the frequency to calculate the RAM address for the next value
    proc_AnalogOutputAddress : PROCESS (clk, areset)
    BEGIN  -- PROCESS proc_AnalogOutputAddress
      IF (areset = c_reset_active) THEN                                                          -- asynchronous reset (active package defined)
        NULL;
      ELSIF (clk'event AND clk = '1') THEN                                                       -- rising clock edge
        IF (s_AnalogOutOverflow(Channel)) THEN
          IF (NOT s_AnalogOutFrequency(Channel)(s_AnalogOutFrequency(Channel)'length - 1)) THEN  -- positive frequency; MSB = sign
            IF (s_AnalogOutRAMAddress(Channel) >= 2 ** c_AddressWidth - 1) THEN
              s_AnalogOutRAMAddress(Channel) <= 0;
            ELSE
              s_AnalogOutRAMAddress(Channel) <= s_AnalogOutRAMAddress(Channel) + 1;
            END IF;
          ELSE                                                                                   -- negative frequency
            IF (s_AnalogOutRAMAddress(Channel) = 0) THEN
              s_AnalogOutRAMAddress(Channel) <= 2 ** c_AddressWidth - 1;
            ELSE
              s_AnalogOutRAMAddress(Channel) <= s_AnalogOutRAMAddress(Channel) - 1;
            END IF;
          END IF;
        END IF;
      END IF;
    END PROCESS proc_AnalogOutputAddress;
    --
    --
    --
    inst_PhaseAccumulator : ENTITY work.PhaseAccumulator
      GENERIC MAP (
        fpga_frequency     => fpga_frequency,
        g_Width            => c_PhaseAccumulatorWidth,
        g_ResolutionFactor => c_PhaseAccumulatorResolutionFactor
        )
      PORT MAP (
        i_clock                => clk,
        i_reset                => areset,
        i_Active               => '1',
        i_StartValue           => (OTHERS => '0'),
        i_SetStartValue        => '0',
        i_FrequencyControlWord => s_AnalogOutFrequency(Channel),
        o_CounterValue         => s_AnalogOutCounter(Channel),
        o_Overflow             => s_AnalogOutOverflow(Channel)
        );
    -- because of the default value used, a single channel ROM instead of a RAM will be created by the compiler
    inst_RAMTwoPort : ENTITY work.RAMTwoPort
      GENERIC MAP (
        g_AddressWidth => c_AddressWidth,
        g_DataWidth    => c_DataWidth,
        g_MemInitFile  => c_MemInitFile(Channel)
        )
      PORT MAP (
        i_clock         => clk,
        i_reset         => areset,
        i_WriteEnable_a => '0',
        i_WriteEnable_b => '0',
        i_Data_a        => (OTHERS => '0'),
        i_Data_b        => (OTHERS => '0'),
        i_Address_a     => s_AnalogOutRAMAddress(Channel),
        i_Address_b     => 0,
        o_Data_a        => s_AnalogOutSignal(Channel),
        o_Data_b        => OPEN
        );
  END GENERATE AnalogOutput;

  --    
  --
  --

  -- uses the frequency and duty cycle value to create a PWM signal
  -- when an overflow occurs it outputs a '1'
  -- when the counter value exceeds the duty cycle value it outputs '0'
  DigitalOutput : FOR Channel IN 1 TO c_NumOfDigitalOutputChannels GENERATE
    proc_DigitalOutputPWM : PROCESS (clk, areset)
    BEGIN  -- PROCESS proc_DigitalOutputPWM
      IF (areset = c_reset_active) THEN     -- asynchronous reset (active package defined)
        NULL;
      ELSIF (clk'event AND clk = '1') THEN  -- rising clock edge
        IF (unsigned(s_DigitalOutCounter(Channel)) >= unsigned(s_DigitalOutDutyCycle(Channel)) AND s_DigitalOutSignal(Channel) = '1') THEN
          s_DigitalOutSignal(Channel) <= '0';
        ELSIF (s_DigitalOutOverflow(Channel)) THEN
          s_DigitalOutSignal(Channel) <= '1';
        END IF;
      END IF;
    END PROCESS proc_DigitalOutputPWM;
    --
    --
    --
    inst_PhaseAccumulator : ENTITY work.PhaseAccumulator
      GENERIC MAP (
        fpga_frequency     => fpga_frequency,
        g_Width            => c_PhaseAccumulatorWidth,
        g_ResolutionFactor => c_PhaseAccumulatorResolutionFactor
        )
      PORT MAP (
        i_clock                => clk,
        i_reset                => areset,
        i_Active               => '1',
        i_StartValue           => (OTHERS => '0'),
        i_SetStartValue        => '0',
        i_FrequencyControlWord => s_DigitalOutFrequency(Channel),
        o_CounterValue         => s_DigitalOutCounter(Channel),
        o_Overflow             => s_DigitalOutOverflow(Channel)
        );
  END GENERATE DigitalOutput;

END ARCHITECTURE rtl;  -- of  User
