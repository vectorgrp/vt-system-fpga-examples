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
    WriteEnable_a_ch9 : in std_logic_vector(0 downto 0);
    WriteEnable_b_ch9 : in std_logic_vector(0 downto 0);
    DataIn_a_ch9 : in std_logic_vector(31 downto 0);
    DataIn_b_ch9 : in std_logic_vector(31 downto 0);
    Address_a_ch9 : in std_logic_vector(31 downto 0);
    Address_b_ch9 : in std_logic_vector(31 downto 0);
    DataOut_a_ch9 : out std_logic_vector(31 downto 0) := (others => '0');
    DataOut_b_ch9 : out std_logic_vector(31 downto 0) := (others => '0');
    WriteEnable_a_ch10 : in std_logic_vector(0 downto 0);
    WriteEnable_b_ch10 : in std_logic_vector(0 downto 0);
    DataIn_a_ch10 : in std_logic_vector(31 downto 0);
    DataIn_b_ch10 : in std_logic_vector(31 downto 0);
    Address_a_ch10 : in std_logic_vector(31 downto 0);
    Address_b_ch10 : in std_logic_vector(31 downto 0);
    DataOut_a_ch10 : out std_logic_vector(31 downto 0) := (others => '0');
    DataOut_b_ch10 : out std_logic_vector(31 downto 0) := (others => '0');
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

  -- generics
  CONSTANT c_NumOfChannels : natural                                                       := 2;
  CONSTANT c_AddressWidth  : natural                                                       := 13;
  CONSTANT c_DataWidth     : natural                                                       := 32;
  CONSTANT c_MemInitFile   : t_ArrayString(1 TO c_NumOfChannels)(1 TO 16)                  := ("    RAM_Sine.mif", "RAM_Sawtooth.mif");
  -- signals
  SIGNAL s_WriteEnable_a   : t_ArrayLogic(1 TO c_NumOfChannels)                            := (OTHERS => '0');
  SIGNAL s_WriteEnable_b   : t_ArrayLogic(1 TO c_NumOfChannels)                            := (OTHERS => '0');
  SIGNAL s_DataIn_a        : t_ArrayVector(1 TO c_NumOfChannels)(c_DataWidth - 1 DOWNTO 0) := (OTHERS => (OTHERS => '0'));
  SIGNAL s_DataIn_b        : t_ArrayVector(1 TO c_NumOfChannels)(c_DataWidth - 1 DOWNTO 0) := (OTHERS => (OTHERS => '0'));
  SIGNAL s_Address_a       : t_ArrayNatural(1 TO c_NumOfChannels)                          := (0, 0);
  SIGNAL s_Address_b       : t_ArrayNatural(1 TO c_NumOfChannels)                          := (0, 0);
  SIGNAL s_DataOut_a       : t_ArrayVector(1 TO c_NumOfChannels)(c_DataWidth - 1 DOWNTO 0) := (OTHERS => (OTHERS => '0'));
  SIGNAL s_DataOut_b       : t_ArrayVector(1 TO c_NumOfChannels)(c_DataWidth - 1 DOWNTO 0) := (OTHERS => (OTHERS => '0'));

BEGIN

  proc_SignalAllocation : PROCESS (ALL)
  BEGIN  -- PROCESS proc_SignalAllocation
    -- channel 1
    -- from CANoe
    s_WriteEnable_a(1)                       <= WriteEnable_a_ch9(0);
    s_WriteEnable_b(1)                       <= WriteEnable_a_ch9(0);
    s_DataIn_a(1)                            <= DataIn_a_ch9(c_DataWidth - 1 DOWNTO 0);
    s_DataIn_b(1)                            <= DataIn_b_ch9(c_DataWidth - 1 DOWNTO 0);
    s_Address_a(1)                           <= natural(to_integer(unsigned(Address_a_ch9(c_AddressWidth - 1 DOWNTO 0))));
    s_Address_b(1)                           <= natural(to_integer(unsigned(Address_b_ch9(c_AddressWidth - 1 DOWNTO 0))));
    -- to CANoe 
    DataOut_a_ch9(c_DataWidth - 1 DOWNTO 0)  <= s_DataOut_a(1);
    DataOut_b_ch9(c_DataWidth - 1 DOWNTO 0)  <= s_DataOut_b(1);
    -- Phoenix
    out_dac_1                                <= s_DataOut_a(1);
    --
    --
    -- channel 2
    -- from CANoe
    s_WriteEnable_a(2)                       <= WriteEnable_a_ch10(0);
    s_WriteEnable_b(2)                       <= WriteEnable_a_ch10(0);
    s_DataIn_a(2)                            <= DataIn_a_ch10(c_DataWidth - 1 DOWNTO 0);
    s_DataIn_b(2)                            <= DataIn_b_ch10(c_DataWidth - 1 DOWNTO 0);
    s_Address_a(2)                           <= natural(to_integer(unsigned(Address_a_ch10(c_AddressWidth - 1 DOWNTO 0))));
    s_Address_b(2)                           <= natural(to_integer(unsigned(Address_b_ch10(c_AddressWidth - 1 DOWNTO 0))));
    -- to CANoe
    DataOut_a_ch10(c_DataWidth - 1 DOWNTO 0) <= s_DataOut_a(2);
    DataOut_b_ch10(c_DataWidth - 1 DOWNTO 0) <= s_DataOut_b(2);
    -- Phoenix
    out_dac_2                                <= s_DataOut_a(2);
  END PROCESS proc_SignalAllocation;

  --
  --
  --

  Channels : FOR channel IN 1 TO c_NumOfChannels GENERATE
    inst_RAMTwoPort : ENTITY work.RAMTwoPort
      GENERIC MAP (
        g_AddressWidth => c_AddressWidth,
        g_DataWidth    => c_DataWidth,
        g_MemInitFile  => c_MemInitFile(channel)
        )
      PORT MAP (
        i_clock         => clk,
        i_reset         => areset,
        i_WriteEnable_a => s_WriteEnable_a(channel),
        i_WriteEnable_b => s_WriteEnable_b(channel),
        i_Data_a        => s_DataIn_a(channel),
        i_Data_b        => s_DataIn_b(channel),
        i_Address_a     => s_Address_a(channel),
        i_Address_b     => s_Address_b(channel),
        o_Data_a        => s_DataOut_a(channel),
        o_Data_b        => s_DataOut_b(channel)
        );
  END GENERATE Channels;

END ARCHITECTURE rtl;  -- of  User
