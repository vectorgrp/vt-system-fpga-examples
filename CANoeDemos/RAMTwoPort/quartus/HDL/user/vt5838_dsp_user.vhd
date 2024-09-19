--============================================================================
-- This confidential and proprietary software may be used
-- only as authorized by a licensing agreement from
-- Vector Informatik GmbH.
-- In an event of publication, the following notice is applicable:
--
--                                                 __
--         __     _______ ____ _____ ___  ____     \ \
--         \ \   / / ____/ ___|_   _/ _ \|  _ \     \ \
--          \ \ / /|  _|| |     | || | | | |_) |     \ \
--           \ V / | |__| |___  | || |_| |  _ <      / /
--            \_/  |_____\____| |_| \___/|_| \_\    / /
--                                                 /_/
--
-- (C) COPYRIGHT 2023 Vector Informatik GmbH
-- ALL RIGHTS RESERVED
--
-- The entire notice above must be reproduced on all authorized copies.
--============================================================================

LIBRARY ieee;
  USE ieee.std_logic_1164.all;

LIBRARY work;
  USE work.global_definitions.all;
  USE work.ethernet_definitions.all;
  USE work.global_scale.all;
  USE work.dsp_user_scale.all;

ENTITY vt5838_dsp_user IS
  PORT (
    i_reset                        : IN    std_logic                                                          := '0';
    i_clock                        : IN    std_logic                                                          := '0';
    --
    i_timestamp                    : IN    std_logic_vector(63 DOWNTO 0)                                      := (OTHERS => '0');
    i_invar_update                 : IN    std_logic                                                          := '0';
    i_invar                        : IN    t_slv32_matrix(0 TO p_invar - 1)                                   := (OTHERS => (OTHERS => '0'));
    o_outvar                       : OUT   t_slv32_matrix(0 TO p_outvar - 1)                                  := (OTHERS => (OTHERS => '0'));
    --
    i_ibc_sync                     : IN    std_logic                                                          := '0';
    i_ibc_ready                    : IN    std_logic                                                          := '0';
    i_ibc_busy                     : IN    std_logic                                                          := '0';
    o_ibc_error_clear              : OUT   std_logic_vector(7 DOWNTO 0)                                       := (OTHERS => '0');
    i_ibc_error                    : IN    std_logic_vector(7 DOWNTO 0)                                       := (OTHERS => '0');
    i_ibc_invar_update             : IN    std_logic_vector(p_ibc_invar - 1 DOWNTO 0)                         := (OTHERS => '0');
    i_ibc_invar                    : IN    t_slv32_matrix(0 TO p_ibc_invar - 1)                               := (OTHERS => (OTHERS => '0'));
    i_ibc_outvar_busy              : IN    std_logic                                                          := '0';
    o_ibc_outvar                   : OUT   t_slv32_matrix(0 TO p_ibc_outvar - 1)                              := (OTHERS => (OTHERS => '0'));
    --
    i_ibc                          : IN    std_logic_vector(3 DOWNTO 0)                                       := (OTHERS => '0');
    o_ibc                          : OUT   std_logic_vector(3 DOWNTO 0)                                       := (OTHERS => '0');
    --
    o_ibc_plus_interface_version   : OUT   std_logic_vector(3 DOWNTO 0)                                       := p_ibc_plus_interface_version;
    o_ibc_plus_system_id           : OUT   std_logic_vector(27 DOWNTO 0)                                      := p_ibc_plus_system_id;
    -- Errors: Lane i = 0..3
    --    Bit 0 : Lane i link error
    --    Bit 1 : Lane i interface version mismatch
    --    Bit 3 : Lane i system id mismatch
    i_ibc_plus_lane_error          : IN    t_slv8_matrix(0 TO 3)                                              := (OTHERS => (OTHERS => '0'));
    i_ibc_plus_lane_block_tx_ready : IN    std_logic_vector(3 DOWNTO 0)                                       := (OTHERS => '0');
    i_ibc_plus_lane_block_tx_ack   : IN    std_logic_vector(3 DOWNTO 0)                                       := (OTHERS => '0');
    o_ibc_plus_lane_block_tx_valid : OUT   std_logic_vector(3 DOWNTO 0)                                       := (OTHERS => '0');
    o_ibc_plus_lane_block_tx_data  : OUT   t_ibc_plus_block_data_array(0 TO 3)                                := (OTHERS => (OTHERS => (OTHERS => '0')));
    i_ibc_plus_lane_block_rx_valid : IN    std_logic_vector(3 DOWNTO 0)                                       := (OTHERS => '0');
    i_ibc_plus_lane_block_rx_data  : IN    t_ibc_plus_block_data_array(0 TO 3)                                := (OTHERS => (OTHERS => (OTHERS => '0')));
    --
    i_serial_rs422                 : IN    std_logic_vector(1 DOWNTO 0)                                       := (OTHERS => '0');
    o_serial_rs422_enable          : OUT   std_logic_vector(1 DOWNTO 0)                                       := (OTHERS => '0');
    o_serial_rs422                 : OUT   std_logic_vector(1 DOWNTO 0)                                       := (OTHERS => '0');
    i_serial_lvds                  : IN    std_logic_vector(1 DOWNTO 0)                                       := (OTHERS => '0');
    o_serial_lvds                  : OUT   std_logic_vector(1 DOWNTO 0)                                       := (OTHERS => '0');
    --
    o_digital_tristate             : OUT   std_logic_vector(15 DOWNTO 0)                                      := (OTHERS => '1');
    o_digital_data                 : OUT   std_logic_vector(15 DOWNTO 0)                                      := (OTHERS => '0');
    i_digital                      : IN    std_logic_vector(15 DOWNTO 0)                                      := (OTHERS => '0');
    --
    o_hram0_avalon_select          : OUT   std_logic_vector(p_hram0_number_of_avalon_interfaces - 1 DOWNTO 0) := (OTHERS => '0');
    i_hram0_avalon_waitrequest     : IN    std_logic_vector(p_hram0_number_of_avalon_interfaces - 1 DOWNTO 0) := (OTHERS => '0');
    o_hram0_avalon_address         : OUT   t_slv24_matrix(0 TO p_hram0_number_of_avalon_interfaces - 1)       := (OTHERS => (OTHERS => '0'));
    o_hram0_avalon_be              : OUT   t_slv4_matrix(0 TO p_hram0_number_of_avalon_interfaces - 1)        := (OTHERS => (OTHERS => '1'));
    o_hram0_avalon_write           : OUT   std_logic_vector(p_hram0_number_of_avalon_interfaces - 1 DOWNTO 0) := (OTHERS => '0');
    o_hram0_avalon_writedata       : OUT   t_slv32_matrix(0 TO p_hram0_number_of_avalon_interfaces - 1)       := (OTHERS => (OTHERS => '0'));
    o_hram0_avalon_read            : OUT   std_logic_vector(p_hram0_number_of_avalon_interfaces - 1 DOWNTO 0) := (OTHERS => '0');
    i_hram0_avalon_readdata        : IN    t_slv32_matrix(0 TO p_hram0_number_of_avalon_interfaces - 1)       := (OTHERS => (OTHERS => '0'));
    --
    i_hram0_burst_busy             : IN    std_logic_vector(p_hram0_number_of_burst_interfaces - 1 DOWNTO 0)  := (OTHERS => '0');
    i_hram0_burst_grant            : IN    std_logic_vector(p_hram0_number_of_burst_interfaces - 1 DOWNTO 0)  := (OTHERS => '0');
    o_hram0_burst_address          : OUT   t_slv24_matrix(0 TO p_hram0_number_of_burst_interfaces - 1)        := (OTHERS => (OTHERS => '0'));
    o_hram0_burst_count            : OUT   t_slv10_matrix(0 TO p_hram0_number_of_burst_interfaces - 1)        := (OTHERS => (OTHERS => '0'));
    o_hram0_burst_be               : OUT   t_slv4_matrix(0 TO p_hram0_number_of_burst_interfaces - 1)         := (OTHERS => (OTHERS => '1'));
    o_hram0_burst_write            : OUT   std_logic_vector(p_hram0_number_of_burst_interfaces - 1 DOWNTO 0)  := (OTHERS => '0');
    o_hram0_burst_writedata        : OUT   t_slv32_matrix(0 TO p_hram0_number_of_burst_interfaces - 1)        := (OTHERS => (OTHERS => '0'));
    o_hram0_burst_read             : OUT   std_logic_vector(p_hram0_number_of_burst_interfaces - 1 DOWNTO 0)  := (OTHERS => '0');
    i_hram0_burst_readdata_valid   : IN    std_logic_vector(p_hram0_number_of_burst_interfaces - 1 DOWNTO 0)  := (OTHERS => '0');
    i_hram0_burst_readdata         : IN    t_slv32_matrix(0 TO p_hram0_number_of_burst_interfaces - 1)        := (OTHERS => (OTHERS => '0'));
    --
    o_hram1_avalon_select          : OUT   std_logic_vector(p_hram1_number_of_avalon_interfaces - 1 DOWNTO 0) := (OTHERS => '0');
    i_hram1_avalon_waitrequest     : IN    std_logic_vector(p_hram1_number_of_avalon_interfaces - 1 DOWNTO 0) := (OTHERS => '0');
    o_hram1_avalon_address         : OUT   t_slv24_matrix(0 TO p_hram1_number_of_avalon_interfaces - 1)       := (OTHERS => (OTHERS => '0'));
    o_hram1_avalon_be              : OUT   t_slv4_matrix(0 TO p_hram1_number_of_avalon_interfaces - 1)        := (OTHERS => (OTHERS => '1'));
    o_hram1_avalon_write           : OUT   std_logic_vector(p_hram1_number_of_avalon_interfaces - 1 DOWNTO 0) := (OTHERS => '0');
    o_hram1_avalon_writedata       : OUT   t_slv32_matrix(0 TO p_hram1_number_of_avalon_interfaces - 1)       := (OTHERS => (OTHERS => '0'));
    o_hram1_avalon_read            : OUT   std_logic_vector(p_hram1_number_of_avalon_interfaces - 1 DOWNTO 0) := (OTHERS => '0');
    i_hram1_avalon_readdata        : IN    t_slv32_matrix(0 TO p_hram1_number_of_avalon_interfaces - 1)       := (OTHERS => (OTHERS => '0'));
    --
    i_hram1_burst_busy             : IN    std_logic_vector(p_hram1_number_of_burst_interfaces - 1 DOWNTO 0)  := (OTHERS => '0');
    i_hram1_burst_grant            : IN    std_logic_vector(p_hram1_number_of_burst_interfaces - 1 DOWNTO 0)  := (OTHERS => '0');
    o_hram1_burst_address          : OUT   t_slv24_matrix(0 TO p_hram1_number_of_burst_interfaces - 1)        := (OTHERS => (OTHERS => '0'));
    o_hram1_burst_count            : OUT   t_slv10_matrix(0 TO p_hram1_number_of_burst_interfaces - 1)        := (OTHERS => (OTHERS => '0'));
    o_hram1_burst_be               : OUT   t_slv4_matrix(0 TO p_hram1_number_of_burst_interfaces - 1)         := (OTHERS => (OTHERS => '1'));
    o_hram1_burst_write            : OUT   std_logic_vector(p_hram1_number_of_burst_interfaces - 1 DOWNTO 0)  := (OTHERS => '0');
    o_hram1_burst_writedata        : OUT   t_slv32_matrix(0 TO p_hram1_number_of_burst_interfaces - 1)        := (OTHERS => (OTHERS => '0'));
    o_hram1_burst_read             : OUT   std_logic_vector(p_hram1_number_of_burst_interfaces - 1 DOWNTO 0)  := (OTHERS => '0');
    i_hram1_burst_readdata_valid   : IN    std_logic_vector(p_hram1_number_of_burst_interfaces - 1 DOWNTO 0)  := (OTHERS => '0');
    i_hram1_burst_readdata         : IN    t_slv32_matrix(0 TO p_hram1_number_of_burst_interfaces - 1)        := (OTHERS => (OTHERS => '0'));
    --
    o_adc_sample                   : OUT   std_logic_vector(0 DOWNTO 0)                                       := (OTHERS => '0');
    i_adc_valid                    : IN    std_logic_vector(0 DOWNTO 0)                                       := (OTHERS => '0');
    i_adc_data                     : IN    t_slv32_matrix(0 TO 7)                                             := (OTHERS => (OTHERS => '0'));
    --
    i_dac_ready                    : IN    std_logic_vector(0 DOWNTO 0)                                       := (OTHERS => '0');
    o_dac_conv                     : OUT   std_logic_vector(0 DOWNTO 0)                                       := (OTHERS => '0');
    i_dac_load                     : IN    std_logic_vector(0 DOWNTO 0)                                       := (OTHERS => '0');
    o_dac_data                     : OUT   t_slv32_matrix(0 TO 13)                                            := (OTHERS => (OTHERS => '0'));
    --
    o_frontpanel_led_green         : OUT   std_logic_vector(15 DOWNTO 0)                                      := (OTHERS => '0');
    o_frontpanel_led_red           : OUT   std_logic_vector(15 DOWNTO 0)                                      := (OTHERS => '0');
    --
    o_application_board_io_control : OUT   std_logic_vector(45 DOWNTO 0)                                      := (OTHERS => '0');
    o_application_board_io_output  : OUT   std_logic_vector(45 DOWNTO 0)                                      := (OTHERS => '0');
    i_application_board_io_input   : IN    std_logic_vector(45 DOWNTO 0)                                      := (OTHERS => '0');
    --
    o_phy_reset_n                  : OUT   std_logic                                                          := '0';
    i_phy_int_n                    : IN    std_logic                                                          := '0';
    o_phy_led                      : OUT   std_logic_vector(2 DOWNTO 0)                                       := (OTHERS => '0');
    o_phy_mdc                      : OUT   std_logic                                                          := '0';
    io_phy_mdio                    : INOUT std_logic                                                          := 'Z';
    i_mac_address_valid            : IN    std_logic                                                          := '0';
    i_mac_address_value            : IN    std_logic_vector(47 DOWNTO 0)                                      := (OTHERS => '0');
    i_eth_reset                    : IN    std_logic                                                          := '0';
    i_phy_led_0                    : IN    std_logic                                                          := '0';
    i_phy_link_st                  : IN    std_logic                                                          := '0';
    i_eth_clock                    : IN    std_logic                                                          := '0';
    i_eth_gmii_rx_clock_en         : IN    std_logic                                                          := '0';
    i_eth_gmii_rx_en               : IN    std_logic                                                          := '0';
    i_eth_gmii_rx_err              : IN    std_logic                                                          := '0';
    i_eth_gmii_rx_data             : IN    std_logic_vector(7 DOWNTO 0)                                       := (OTHERS => '0');
    i_eth_gmii_tx_clock_en         : IN    std_logic                                                          := '0';
    o_eth_gmii_tx_en               : OUT   std_logic                                                          := '0';
    o_eth_gmii_tx_err              : OUT   std_logic                                                          := '0';
    o_eth_gmii_tx_data             : OUT   std_logic_vector(7 DOWNTO 0)                                       := (OTHERS => '0');
    o_debug_led                    : OUT   std_logic_vector(4 DOWNTO 0)                                       := (OTHERS => '0');
    i_hw_revision                  : IN    std_logic_vector(7 DOWNTO 0)                                       := (OTHERS => '0')
  );
END ENTITY vt5838_dsp_user;

--=ARCHITECTURE===============================================================
ARCHITECTURE rtl OF vt5838_dsp_user IS

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
frontpanel_LED_green_1(0) => o_frontpanel_led_green(0),
frontpanel_LED_green_10(0) => o_frontpanel_led_green(9),
frontpanel_LED_green_11(0) => o_frontpanel_led_green(10),
frontpanel_LED_green_12(0) => o_frontpanel_led_green(11),
frontpanel_LED_green_13(0) => o_frontpanel_led_green(12),
frontpanel_LED_green_14(0) => o_frontpanel_led_green(13),
frontpanel_LED_green_15(0) => o_frontpanel_led_green(14),
frontpanel_LED_green_16(0) => o_frontpanel_led_green(15),
frontpanel_LED_green_2(0) => o_frontpanel_led_green(1),
frontpanel_LED_green_3(0) => o_frontpanel_led_green(2),
frontpanel_LED_green_4(0) => o_frontpanel_led_green(3),
frontpanel_LED_green_5(0) => o_frontpanel_led_green(4),
frontpanel_LED_green_6(0) => o_frontpanel_led_green(5),
frontpanel_LED_green_7(0) => o_frontpanel_led_green(6),
frontpanel_LED_green_8(0) => o_frontpanel_led_green(7),
frontpanel_LED_green_9(0) => o_frontpanel_led_green(8),
frontpanel_LED_red_1(0) => o_frontpanel_led_red(0),
frontpanel_LED_red_10(0) => o_frontpanel_led_red(9),
frontpanel_LED_red_11(0) => o_frontpanel_led_red(10),
frontpanel_LED_red_12(0) => o_frontpanel_led_red(11),
frontpanel_LED_red_13(0) => o_frontpanel_led_red(12),
frontpanel_LED_red_14(0) => o_frontpanel_led_red(13),
frontpanel_LED_red_15(0) => o_frontpanel_led_red(14),
frontpanel_LED_red_16(0) => o_frontpanel_led_red(15),
frontpanel_LED_red_2(0) => o_frontpanel_led_red(1),
frontpanel_LED_red_3(0) => o_frontpanel_led_red(2),
frontpanel_LED_red_4(0) => o_frontpanel_led_red(3),
frontpanel_LED_red_5(0) => o_frontpanel_led_red(4),
frontpanel_LED_red_6(0) => o_frontpanel_led_red(5),
frontpanel_LED_red_7(0) => o_frontpanel_led_red(6),
frontpanel_LED_red_8(0) => o_frontpanel_led_red(7),
frontpanel_LED_red_9(0) => o_frontpanel_led_red(8),
h_areset => i_reset,
in_adc_1 => i_adc_data(0),
in_adc_2 => i_adc_data(1),
in_adc_3 => i_adc_data(2),
in_adc_4 => i_adc_data(3),
in_adc_5 => i_adc_data(4),
in_adc_6 => i_adc_data(5),
in_adc_7 => i_adc_data(6),
in_adc_8 => i_adc_data(7),
in_adc_data_valid => i_adc_valid,
in_application_board_io_input_1(0) => i_application_board_io_input(0),
in_application_board_io_input_10(0) => i_application_board_io_input(9),
in_application_board_io_input_11(0) => i_application_board_io_input(10),
in_application_board_io_input_12(0) => i_application_board_io_input(11),
in_application_board_io_input_13(0) => i_application_board_io_input(12),
in_application_board_io_input_14(0) => i_application_board_io_input(13),
in_application_board_io_input_15(0) => i_application_board_io_input(14),
in_application_board_io_input_16(0) => i_application_board_io_input(15),
in_application_board_io_input_17(0) => i_application_board_io_input(16),
in_application_board_io_input_18(0) => i_application_board_io_input(17),
in_application_board_io_input_19(0) => i_application_board_io_input(18),
in_application_board_io_input_2(0) => i_application_board_io_input(1),
in_application_board_io_input_20(0) => i_application_board_io_input(19),
in_application_board_io_input_21(0) => i_application_board_io_input(20),
in_application_board_io_input_22(0) => i_application_board_io_input(21),
in_application_board_io_input_23(0) => i_application_board_io_input(22),
in_application_board_io_input_24(0) => i_application_board_io_input(23),
in_application_board_io_input_25(0) => i_application_board_io_input(24),
in_application_board_io_input_26(0) => i_application_board_io_input(25),
in_application_board_io_input_27(0) => i_application_board_io_input(26),
in_application_board_io_input_28(0) => i_application_board_io_input(27),
in_application_board_io_input_29(0) => i_application_board_io_input(28),
in_application_board_io_input_3(0) => i_application_board_io_input(2),
in_application_board_io_input_30(0) => i_application_board_io_input(29),
in_application_board_io_input_31(0) => i_application_board_io_input(30),
in_application_board_io_input_32(0) => i_application_board_io_input(31),
in_application_board_io_input_33(0) => i_application_board_io_input(32),
in_application_board_io_input_34(0) => i_application_board_io_input(33),
in_application_board_io_input_35(0) => i_application_board_io_input(34),
in_application_board_io_input_36(0) => i_application_board_io_input(35),
in_application_board_io_input_37(0) => i_application_board_io_input(36),
in_application_board_io_input_38(0) => i_application_board_io_input(37),
in_application_board_io_input_39(0) => i_application_board_io_input(38),
in_application_board_io_input_4(0) => i_application_board_io_input(3),
in_application_board_io_input_40(0) => i_application_board_io_input(39),
in_application_board_io_input_41(0) => i_application_board_io_input(40),
in_application_board_io_input_42(0) => i_application_board_io_input(41),
in_application_board_io_input_43(0) => i_application_board_io_input(42),
in_application_board_io_input_44(0) => i_application_board_io_input(43),
in_application_board_io_input_45(0) => i_application_board_io_input(44),
in_application_board_io_input_46(0) => i_application_board_io_input(45),
in_application_board_io_input_5(0) => i_application_board_io_input(4),
in_application_board_io_input_6(0) => i_application_board_io_input(5),
in_application_board_io_input_7(0) => i_application_board_io_input(6),
in_application_board_io_input_8(0) => i_application_board_io_input(7),
in_application_board_io_input_9(0) => i_application_board_io_input(8),
in_dac_load => i_dac_load,
in_dac_ready => i_dac_ready,
in_digital_1(0) => i_digital(0),
in_digital_10(0) => i_digital(9),
in_digital_11(0) => i_digital(10),
in_digital_12(0) => i_digital(11),
in_digital_13(0) => i_digital(12),
in_digital_14(0) => i_digital(13),
in_digital_15(0) => i_digital(14),
in_digital_16(0) => i_digital(15),
in_digital_2(0) => i_digital(1),
in_digital_3(0) => i_digital(2),
in_digital_4(0) => i_digital(3),
in_digital_5(0) => i_digital(4),
in_digital_6(0) => i_digital(5),
in_digital_7(0) => i_digital(6),
in_digital_8(0) => i_digital(7),
in_digital_9(0) => i_digital(8),
in_eth_clock => i_eth_clock,
in_eth_gmii_rx_clock_en => i_eth_gmii_rx_clock_en,
in_eth_gmii_rx_data => i_eth_gmii_rx_data,
in_eth_gmii_rx_en => i_eth_gmii_rx_en,
in_eth_gmii_rx_err => i_eth_gmii_rx_err,
in_eth_gmii_tx_clock_en => i_eth_gmii_tx_clock_en,
in_eth_reset => i_eth_reset,
in_hw_revision => i_hw_revision,
in_ibc_1(0) => i_ibc(0),
in_ibc_2(0) => i_ibc(1),
in_ibc_3(0) => i_ibc(2),
in_ibc_4(0) => i_ibc(3),
in_ibc_plus_lane_block_rx_valid => i_ibc_plus_lane_block_rx_valid,
in_ibc_plus_lane_block_tx_ack => i_ibc_plus_lane_block_tx_ack,
in_ibc_plus_lane_block_tx_ready => i_ibc_plus_lane_block_tx_ready,
in_ibc_plus_lane_error_1 => i_ibc_plus_lane_error(0),
in_ibc_plus_lane_error_2 => i_ibc_plus_lane_error(1),
in_ibc_plus_lane_error_3 => i_ibc_plus_lane_error(2),
in_ibc_plus_lane_error_4 => i_ibc_plus_lane_error(3),
in_invar_update => i_invar_update,
in_mac_address_valid => i_mac_address_valid,
in_mac_address_value => i_mac_address_value,
in_phy_int_n => i_phy_int_n,
in_phy_led_0 => i_phy_led_0,
in_phy_link_status => i_phy_link_st,
in_serial_lvds_1(0) => i_serial_lvds(0),
in_serial_lvds_2(0) => i_serial_lvds(1),
in_serial_rs422_1(0) => i_serial_rs422(0),
in_serial_rs422_2(0) => i_serial_rs422(1),
in_timestamp => i_timestamp,
inout_phy_mdio => io_phy_mdio,
out_adc_sample => o_adc_sample,
out_application_board_io_control_1(0) => o_application_board_io_control(0),
out_application_board_io_control_10(0) => o_application_board_io_control(9),
out_application_board_io_control_11(0) => o_application_board_io_control(10),
out_application_board_io_control_12(0) => o_application_board_io_control(11),
out_application_board_io_control_13(0) => o_application_board_io_control(12),
out_application_board_io_control_14(0) => o_application_board_io_control(13),
out_application_board_io_control_15(0) => o_application_board_io_control(14),
out_application_board_io_control_16(0) => o_application_board_io_control(15),
out_application_board_io_control_17(0) => o_application_board_io_control(16),
out_application_board_io_control_18(0) => o_application_board_io_control(17),
out_application_board_io_control_19(0) => o_application_board_io_control(18),
out_application_board_io_control_2(0) => o_application_board_io_control(1),
out_application_board_io_control_20(0) => o_application_board_io_control(19),
out_application_board_io_control_21(0) => o_application_board_io_control(20),
out_application_board_io_control_22(0) => o_application_board_io_control(21),
out_application_board_io_control_23(0) => o_application_board_io_control(22),
out_application_board_io_control_24(0) => o_application_board_io_control(23),
out_application_board_io_control_25(0) => o_application_board_io_control(24),
out_application_board_io_control_26(0) => o_application_board_io_control(25),
out_application_board_io_control_27(0) => o_application_board_io_control(26),
out_application_board_io_control_28(0) => o_application_board_io_control(27),
out_application_board_io_control_29(0) => o_application_board_io_control(28),
out_application_board_io_control_3(0) => o_application_board_io_control(2),
out_application_board_io_control_30(0) => o_application_board_io_control(29),
out_application_board_io_control_31(0) => o_application_board_io_control(30),
out_application_board_io_control_32(0) => o_application_board_io_control(31),
out_application_board_io_control_33(0) => o_application_board_io_control(32),
out_application_board_io_control_34(0) => o_application_board_io_control(33),
out_application_board_io_control_35(0) => o_application_board_io_control(34),
out_application_board_io_control_36(0) => o_application_board_io_control(35),
out_application_board_io_control_37(0) => o_application_board_io_control(36),
out_application_board_io_control_38(0) => o_application_board_io_control(37),
out_application_board_io_control_39(0) => o_application_board_io_control(38),
out_application_board_io_control_4(0) => o_application_board_io_control(3),
out_application_board_io_control_40(0) => o_application_board_io_control(39),
out_application_board_io_control_41(0) => o_application_board_io_control(40),
out_application_board_io_control_42(0) => o_application_board_io_control(41),
out_application_board_io_control_43(0) => o_application_board_io_control(42),
out_application_board_io_control_44(0) => o_application_board_io_control(43),
out_application_board_io_control_45(0) => o_application_board_io_control(44),
out_application_board_io_control_46(0) => o_application_board_io_control(45),
out_application_board_io_control_5(0) => o_application_board_io_control(4),
out_application_board_io_control_6(0) => o_application_board_io_control(5),
out_application_board_io_control_7(0) => o_application_board_io_control(6),
out_application_board_io_control_8(0) => o_application_board_io_control(7),
out_application_board_io_control_9(0) => o_application_board_io_control(8),
out_application_board_io_output_1(0) => o_application_board_io_output(0),
out_application_board_io_output_10(0) => o_application_board_io_output(9),
out_application_board_io_output_11(0) => o_application_board_io_output(10),
out_application_board_io_output_12(0) => o_application_board_io_output(11),
out_application_board_io_output_13(0) => o_application_board_io_output(12),
out_application_board_io_output_14(0) => o_application_board_io_output(13),
out_application_board_io_output_15(0) => o_application_board_io_output(14),
out_application_board_io_output_16(0) => o_application_board_io_output(15),
out_application_board_io_output_17(0) => o_application_board_io_output(16),
out_application_board_io_output_18(0) => o_application_board_io_output(17),
out_application_board_io_output_19(0) => o_application_board_io_output(18),
out_application_board_io_output_2(0) => o_application_board_io_output(1),
out_application_board_io_output_20(0) => o_application_board_io_output(19),
out_application_board_io_output_21(0) => o_application_board_io_output(20),
out_application_board_io_output_22(0) => o_application_board_io_output(21),
out_application_board_io_output_23(0) => o_application_board_io_output(22),
out_application_board_io_output_24(0) => o_application_board_io_output(23),
out_application_board_io_output_25(0) => o_application_board_io_output(24),
out_application_board_io_output_26(0) => o_application_board_io_output(25),
out_application_board_io_output_27(0) => o_application_board_io_output(26),
out_application_board_io_output_28(0) => o_application_board_io_output(27),
out_application_board_io_output_29(0) => o_application_board_io_output(28),
out_application_board_io_output_3(0) => o_application_board_io_output(2),
out_application_board_io_output_30(0) => o_application_board_io_output(29),
out_application_board_io_output_31(0) => o_application_board_io_output(30),
out_application_board_io_output_32(0) => o_application_board_io_output(31),
out_application_board_io_output_33(0) => o_application_board_io_output(32),
out_application_board_io_output_34(0) => o_application_board_io_output(33),
out_application_board_io_output_35(0) => o_application_board_io_output(34),
out_application_board_io_output_36(0) => o_application_board_io_output(35),
out_application_board_io_output_37(0) => o_application_board_io_output(36),
out_application_board_io_output_38(0) => o_application_board_io_output(37),
out_application_board_io_output_39(0) => o_application_board_io_output(38),
out_application_board_io_output_4(0) => o_application_board_io_output(3),
out_application_board_io_output_40(0) => o_application_board_io_output(39),
out_application_board_io_output_41(0) => o_application_board_io_output(40),
out_application_board_io_output_42(0) => o_application_board_io_output(41),
out_application_board_io_output_43(0) => o_application_board_io_output(42),
out_application_board_io_output_44(0) => o_application_board_io_output(43),
out_application_board_io_output_45(0) => o_application_board_io_output(44),
out_application_board_io_output_46(0) => o_application_board_io_output(45),
out_application_board_io_output_5(0) => o_application_board_io_output(4),
out_application_board_io_output_6(0) => o_application_board_io_output(5),
out_application_board_io_output_7(0) => o_application_board_io_output(6),
out_application_board_io_output_8(0) => o_application_board_io_output(7),
out_application_board_io_output_9(0) => o_application_board_io_output(8),
out_dac_1 => o_dac_data(0),
out_dac_10 => o_dac_data(9),
out_dac_11 => o_dac_data(10),
out_dac_12 => o_dac_data(11),
out_dac_13 => o_dac_data(12),
out_dac_14 => o_dac_data(13),
out_dac_2 => o_dac_data(1),
out_dac_3 => o_dac_data(2),
out_dac_4 => o_dac_data(3),
out_dac_5 => o_dac_data(4),
out_dac_6 => o_dac_data(5),
out_dac_7 => o_dac_data(6),
out_dac_8 => o_dac_data(7),
out_dac_9 => o_dac_data(8),
out_dac_conv => o_dac_conv,
out_digital_1(0) => o_digital_data(0),
out_digital_10(0) => o_digital_data(9),
out_digital_11(0) => o_digital_data(10),
out_digital_12(0) => o_digital_data(11),
out_digital_13(0) => o_digital_data(12),
out_digital_14(0) => o_digital_data(13),
out_digital_15(0) => o_digital_data(14),
out_digital_16(0) => o_digital_data(15),
out_digital_2(0) => o_digital_data(1),
out_digital_3(0) => o_digital_data(2),
out_digital_4(0) => o_digital_data(3),
out_digital_5(0) => o_digital_data(4),
out_digital_6(0) => o_digital_data(5),
out_digital_7(0) => o_digital_data(6),
out_digital_8(0) => o_digital_data(7),
out_digital_9(0) => o_digital_data(8),
out_digital_tristate_1(0) => o_digital_tristate(0),
out_digital_tristate_10(0) => o_digital_tristate(9),
out_digital_tristate_11(0) => o_digital_tristate(10),
out_digital_tristate_12(0) => o_digital_tristate(11),
out_digital_tristate_13(0) => o_digital_tristate(12),
out_digital_tristate_14(0) => o_digital_tristate(13),
out_digital_tristate_15(0) => o_digital_tristate(14),
out_digital_tristate_16(0) => o_digital_tristate(15),
out_digital_tristate_2(0) => o_digital_tristate(1),
out_digital_tristate_3(0) => o_digital_tristate(2),
out_digital_tristate_4(0) => o_digital_tristate(3),
out_digital_tristate_5(0) => o_digital_tristate(4),
out_digital_tristate_6(0) => o_digital_tristate(5),
out_digital_tristate_7(0) => o_digital_tristate(6),
out_digital_tristate_8(0) => o_digital_tristate(7),
out_digital_tristate_9(0) => o_digital_tristate(8),
out_eth_gmii_tx_data => o_eth_gmii_tx_data,
out_eth_gmii_tx_en => o_eth_gmii_tx_en,
out_eth_gmii_tx_err => o_eth_gmii_tx_err,
out_ibc_1(0) => o_ibc(0),
out_ibc_2(0) => o_ibc(1),
out_ibc_3(0) => o_ibc(2),
out_ibc_4(0) => o_ibc(3),
out_ibc_plus_lane_block_tx_valid => o_ibc_plus_lane_block_tx_valid,
out_phy_led => o_phy_led,
out_phy_mdc => o_phy_mdc,
out_phy_reset_n => o_phy_reset_n,
out_serial_lvds_1(0) => o_serial_lvds(0),
out_serial_lvds_2(0) => o_serial_lvds(1),
out_serial_rs422_1(0) => o_serial_rs422(0),
out_serial_rs422_2(0) => o_serial_rs422(1),
out_serial_rs422_enable_1(0) => o_serial_rs422_enable(0),
out_serial_rs422_enable_2(0) => o_serial_rs422_enable(1),
WriteEnable_a_ch10(0)   => i_invar(0)(0),
WriteEnable_a_ch9(0)   => i_invar(0)(1),
WriteEnable_b_ch10(0)   => i_invar(0)(2),
WriteEnable_b_ch9(0)   => i_invar(0)(3),
Address_a_ch10   => i_invar(1)(31 downto 0),
Address_a_ch9   => i_invar(2)(31 downto 0),
Address_b_ch10   => i_invar(3)(31 downto 0),
Address_b_ch9   => i_invar(4)(31 downto 0),
DataIn_a_ch10   => i_invar(5)(31 downto 0),
DataIn_a_ch9   => i_invar(6)(31 downto 0),
DataIn_b_ch10   => i_invar(7)(31 downto 0),
DataIn_b_ch9   => i_invar(8)(31 downto 0),
DataOut_a_ch10   => o_outvar(0)(31 downto 0),
DataOut_a_ch9   => o_outvar(1)(31 downto 0),
DataOut_b_ch10   => o_outvar(2)(31 downto 0),
DataOut_b_ch9   => o_outvar(3)(31 downto 0)
);
  -- @CMD=PORTMAPEND

END rtl;
