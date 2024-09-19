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
USE ieee.std_logic_1164.ALL;

LIBRARY work;
USE work.global_definitions.ALL;
USE work.ethernet_definitions.ALL;
USE work.global_scale.ALL;
USE work.dsp_user_scale.ALL;


ENTITY vt5838_dsp_top IS
  PORT (
    pi_reset_n                  : IN    std_logic;
    pi_clk12m                   : IN    std_logic;
    pi_clk25m                   : IN    std_logic;
    ---------------------------------------------------------------------------
    po_hram0_reset_n            : OUT   std_logic;
    po_hram0_ck                 : OUT   std_logic;
    po_hram0_ck_n               : OUT   std_logic;
    po_hram0_cs_n               : OUT   std_logic;
    pio_hram0_rwds              : INOUT std_logic                     := '0';
    pio_hram0_dq                : INOUT std_logic_vector(7 DOWNTO 0)  := (OTHERS => '0');
    --
    po_hram1_reset_n            : OUT   std_logic;
    po_hram1_ck                 : OUT   std_logic;
    po_hram1_ck_n               : OUT   std_logic;
    po_hram1_cs_n               : OUT   std_logic;
    pio_hram1_rwds              : INOUT std_logic                     := '0';
    pio_hram1_dq                : INOUT std_logic_vector(7 DOWNTO 0)  := (OTHERS => '0');
    ---------------------------------------------------------------------------
    pi_ibc                      : IN    std_logic_vector(3 DOWNTO 0)  := (OTHERS => '0');
    po_ibc                      : OUT   std_logic_vector(3 DOWNTO 0);
    ---------------------------------------------------------------------------
    pi_bridge_reset             : IN    std_logic;
    pi_bridge_request           : IN    std_logic;
    po_bridge_ready_n           : OUT   std_logic;
    --
    pi_bridge_clock             : IN    std_logic                     := '0';
    pi_bridge_valid             : IN    std_logic                     := '0';
    pi_bridge_data              : IN    std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');
    --
    po_bridge_clock             : OUT   std_logic;
    po_bridge_valid             : OUT   std_logic;
    po_bridge_data              : OUT   std_logic_vector(15 DOWNTO 0);
    ---------------------------------------------------------------------------
    pi_digital_input            : IN    std_logic_vector(15 DOWNTO 0);
    po_digital_output_pull      : OUT   std_logic_vector(15 DOWNTO 0);
    po_digital_output_push      : OUT   std_logic_vector(15 DOWNTO 0);
    ---------------------------------------------------------------------------
    pi_adc_clock                : IN    std_logic_vector(1 DOWNTO 0);
    pi_adc_data                 : IN    std_logic_vector(7 DOWNTO 0);
    po_adc_clock                : OUT   std_logic_vector(1 DOWNTO 0);
    po_adc_acquisition          : OUT   std_logic_vector(1 DOWNTO 0);
    ---------------------------------------------------------------------------
    po_dac_clock                : OUT   std_logic_vector(1 DOWNTO 0);
    po_dac_cs_n                 : OUT   std_logic_vector(13 DOWNTO 0);
    po_dac_data                 : OUT   std_logic_vector(13 DOWNTO 0);
    ---------------------------------------------------------------------------
    pi_serial                   : IN    std_logic_vector(3 DOWNTO 0);
    po_serial                   : OUT   std_logic_vector(3 DOWNTO 0);
    ---------------------------------------------------------------------------
    pi_uart_tx                  : IN    std_logic;
    po_uart_rx                  : OUT   std_logic;
    ---------------------------------------------------------------------------
    pi_ibc_plus_cable_present_n : IN    std_logic;
    pi_ibc_plus_refclk_p        : IN    std_logic;
    pi_ibc_plus_rx_p            : IN    std_logic_vector(3 DOWNTO 0);
    po_ibc_plus_tx_p            : OUT   std_logic_vector(3 DOWNTO 0);
    ---------------------------------------------------------------------------
    pi_phy_misc                 : IN    std_logic;
    pi_phy_led_0                : IN    std_logic;
    pi_phy_link_st              : IN    std_logic;
    po_phy_reset_n              : OUT   std_logic;
    pi_phy_int_n                : IN    std_logic;
    po_phy_led                  : OUT   std_logic_vector(2 DOWNTO 0);
    po_phy_mdc                  : OUT   std_logic;
    pio_phy_mdio                : INOUT std_logic;
    pi_phy_rx                   : IN    rgmii_port_array(0 TO 0);
    po_phy_tx                   : OUT   rgmii_port_array(0 TO 0);
    ---------------------------------------------------------------------------
    po_driver_enable            : OUT   std_logic_vector(4 DOWNTO 0);
    ---------------------------------------------------------------------------
    pio_application_board_io    : INOUT std_logic_vector(45 DOWNTO 0);
   ---------------------------------------------------------------------------
    po_debug_led                : OUT   std_logic_vector(4 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE rtl OF vt5838_dsp_top IS

  SIGNAL s_dsp_user_reset                        : std_logic;
  SIGNAL s_dsp_user_clock                        : std_logic;
  SIGNAL s_dsp_user_eth_reset                    : std_logic;
  SIGNAL s_dsp_user_eth_clock                    : std_logic_vector(1 DOWNTO 0);
  SIGNAL s_dsp_user_timestamp                    : std_logic_vector(63 DOWNTO 0);
  SIGNAL s_dsp_user_invar                        : t_slv32_matrix(0 TO p_invar - 1);
  SIGNAL s_dsp_user_invar_update                 : std_logic;
  SIGNAL s_dsp_user_outvar                       : t_slv32_matrix(0 TO p_outvar - 1);
  SIGNAL s_dsp_user_ibc_sync                     : std_logic;
  SIGNAL s_dsp_user_ibc_ready                    : std_logic;
  SIGNAL s_dsp_user_ibc_busy                     : std_logic;
  SIGNAL s_dsp_user_ibc_error_clear              : std_logic_vector(7 DOWNTO 0);
  SIGNAL s_dsp_user_ibc_error                    : std_logic_vector(7 DOWNTO 0);
  SIGNAL s_dsp_user_ibc_invar_update             : std_logic_vector(p_ibc_invar - 1 DOWNTO 0);
  SIGNAL s_dsp_user_ibc_invar                    : t_slv32_matrix(0 TO p_ibc_invar - 1);
  SIGNAL s_dsp_user_ibc_outvar_busy              : std_logic;
  SIGNAL s_dsp_user_ibc_outvar                   : t_slv32_matrix(0 TO p_ibc_outvar - 1);
  SIGNAL s_dsp_user_ibc_in                       : std_logic_vector(3 DOWNTO 0);
  SIGNAL s_dsp_user_ibc_out                      : std_logic_vector(3 DOWNTO 0);
  SIGNAL s_dsp_user_ibc_plus_interface_version   : std_logic_vector(3 DOWNTO 0);
  SIGNAL s_dsp_user_ibc_plus_system_id           : std_logic_vector(27 DOWNTO 0);
  SIGNAL s_dsp_user_ibc_plus_lane_error          : t_slv8_matrix(0 TO 3);
  SIGNAL s_dsp_user_ibc_plus_lane_block_tx_ready : std_logic_vector(3 DOWNTO 0);
  SIGNAL s_dsp_user_ibc_plus_lane_block_tx_ack   : std_logic_vector(3 DOWNTO 0);
  SIGNAL s_dsp_user_ibc_plus_lane_block_tx_valid : std_logic_vector(3 DOWNTO 0);
  SIGNAL s_dsp_user_ibc_plus_lane_block_tx_data  : t_ibc_plus_block_data_array(0 TO 3);
  SIGNAL s_dsp_user_ibc_plus_lane_block_rx_valid : std_logic_vector(3 DOWNTO 0);
  SIGNAL s_dsp_user_ibc_plus_lane_block_rx_data  : t_ibc_plus_block_data_array(0 TO 3);
  SIGNAL s_dsp_user_digital_output_tristate      : std_logic_vector(15 DOWNTO 0);
  SIGNAL s_dsp_user_digital_output_data          : std_logic_vector(15 DOWNTO 0);
  SIGNAL s_dsp_user_digital_input                : std_logic_vector(15 DOWNTO 0);
  SIGNAL s_dsp_user_frontpanel_led_green         : std_logic_vector(15 DOWNTO 0);
  SIGNAL s_dsp_user_frontpanel_led_red           : std_logic_vector(15 DOWNTO 0);
  SIGNAL s_dsp_user_adc_sample                   : std_logic_vector(0 DOWNTO 0);
  SIGNAL s_dsp_user_adc_data                     : t_slv32_matrix(0 TO 7);
  SIGNAL s_dsp_user_adc_valid                    : std_logic_vector(0 DOWNTO 0);
  SIGNAL s_dsp_user_dac_load                     : std_logic_vector(0 DOWNTO 0);
  SIGNAL s_dsp_user_dac_ready                    : std_logic_vector(0 DOWNTO 0);
  SIGNAL s_dsp_user_dac_conv                     : std_logic_vector(0 DOWNTO 0);
  SIGNAL s_dsp_user_dac_data                     : t_slv32_matrix(0 TO 13);
  SIGNAL s_dsp_user_debug_led                    : std_logic_vector(po_debug_led'RANGE);
  SIGNAL s_dsp_user_hw_revision                  : std_logic_vector(7 DOWNTO 0);
  SIGNAL s_dsp_user_hram0_avalon_select          : std_logic_vector(p_hram0_number_of_avalon_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram0_avalon_waitrequest     : std_logic_vector(p_hram0_number_of_avalon_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram0_avalon_address         : t_slv24_matrix(0 TO p_hram0_number_of_avalon_interfaces - 1);
  SIGNAL s_dsp_user_hram0_avalon_be              : t_slv4_matrix(0 TO p_hram0_number_of_avalon_interfaces - 1);
  SIGNAL s_dsp_user_hram0_avalon_write           : std_logic_vector(p_hram0_number_of_avalon_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram0_avalon_writedata       : t_slv32_matrix(0 TO p_hram0_number_of_avalon_interfaces - 1);
  SIGNAL s_dsp_user_hram0_avalon_read            : std_logic_vector(p_hram0_number_of_avalon_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram0_avalon_readdata        : t_slv32_matrix(0 TO p_hram0_number_of_avalon_interfaces - 1);
  SIGNAL s_dsp_user_hram0_burst_busy             : std_logic_vector(p_hram0_number_of_burst_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram0_burst_grant            : std_logic_vector(p_hram0_number_of_burst_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram0_burst_address          : t_slv24_matrix(0 TO p_hram0_number_of_burst_interfaces - 1);
  SIGNAL s_dsp_user_hram0_burst_count            : t_slv10_matrix(0 TO p_hram0_number_of_burst_interfaces - 1);
  SIGNAL s_dsp_user_hram0_burst_be               : t_slv4_matrix(0 TO p_hram0_number_of_burst_interfaces - 1);
  SIGNAL s_dsp_user_hram0_burst_write            : std_logic_vector(p_hram0_number_of_burst_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram0_burst_writedata        : t_slv32_matrix(0 TO p_hram0_number_of_burst_interfaces - 1);
  SIGNAL s_dsp_user_hram0_burst_read             : std_logic_vector(p_hram0_number_of_burst_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram0_burst_readdata_valid   : std_logic_vector(p_hram0_number_of_burst_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram0_burst_readdata         : t_slv32_matrix(0 TO p_hram0_number_of_burst_interfaces - 1);
  SIGNAL s_dsp_user_hram1_avalon_select          : std_logic_vector(p_hram1_number_of_avalon_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram1_avalon_waitrequest     : std_logic_vector(p_hram1_number_of_avalon_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram1_avalon_address         : t_slv24_matrix(0 TO p_hram1_number_of_avalon_interfaces - 1);
  SIGNAL s_dsp_user_hram1_avalon_be              : t_slv4_matrix(0 TO p_hram1_number_of_avalon_interfaces - 1);
  SIGNAL s_dsp_user_hram1_avalon_write           : std_logic_vector(p_hram1_number_of_avalon_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram1_avalon_writedata       : t_slv32_matrix(0 TO p_hram1_number_of_avalon_interfaces - 1);
  SIGNAL s_dsp_user_hram1_avalon_read            : std_logic_vector(p_hram1_number_of_avalon_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram1_avalon_readdata        : t_slv32_matrix(0 TO p_hram1_number_of_avalon_interfaces - 1);
  SIGNAL s_dsp_user_hram1_burst_busy             : std_logic_vector(p_hram1_number_of_burst_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram1_burst_grant            : std_logic_vector(p_hram1_number_of_burst_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram1_burst_address          : t_slv24_matrix(0 TO p_hram1_number_of_burst_interfaces - 1);
  SIGNAL s_dsp_user_hram1_burst_count            : t_slv10_matrix(0 TO p_hram1_number_of_burst_interfaces - 1);
  SIGNAL s_dsp_user_hram1_burst_be               : t_slv4_matrix(0 TO p_hram1_number_of_burst_interfaces - 1);
  SIGNAL s_dsp_user_hram1_burst_write            : std_logic_vector(p_hram1_number_of_burst_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram1_burst_writedata        : t_slv32_matrix(0 TO p_hram1_number_of_burst_interfaces - 1);
  SIGNAL s_dsp_user_hram1_burst_read             : std_logic_vector(p_hram1_number_of_burst_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram1_burst_readdata_valid   : std_logic_vector(p_hram1_number_of_burst_interfaces - 1 DOWNTO 0);
  SIGNAL s_dsp_user_hram1_burst_readdata         : t_slv32_matrix(0 TO p_hram1_number_of_burst_interfaces - 1);
  SIGNAL s_dsp_user_serial_enable                : std_logic_vector(1 DOWNTO 0);
  SIGNAL s_dsp_user_application_board_io_control : std_logic_vector(45 DOWNTO 0);
  SIGNAL s_dsp_user_application_board_io_output  : std_logic_vector(45 DOWNTO 0);
  SIGNAL s_dsp_user_application_board_io_input   : std_logic_vector(45 DOWNTO 0);
  --
  SIGNAL s_dsp_user_mac_address_valid            : std_logic;
  SIGNAL s_dsp_user_mac_address_value            : std_logic_vector(47 DOWNTO 0);
  SIGNAL s_dsp_user_eth_gmii_rx_clock_en         : std_logic;
  SIGNAL s_dsp_user_eth_gmii_rx                  : t_gmii_port_noclock;
  SIGNAL s_dsp_user_eth_gmii_tx_clock_en         : std_logic;
  SIGNAL s_dsp_user_eth_gmii_tx                  : t_gmii_port_noclock;
  --
  SIGNAL s_dsp_user_phy_link_st                  : std_logic;
  SIGNAL s_dsp_user_phy_led_0                    : std_logic;
  --
  ATTRIBUTE ALTERA_ATTRIBUTE                     : string;
  ATTRIBUTE ALTERA_ATTRIBUTE OF rtl : ARCHITECTURE IS p_timing_constraints;

BEGIN

  -----------------------------------------------------------------------------
  --
  -----------------------------------------------------------------------------
  inst_vt5838_dsp_base : ENTITY work.vt5838_dsp_base
    PORT MAP (
      i_reset                                 => NOT pi_reset_n,
      i_clk12m                                => pi_clk12m,
      i_clk25m                                => pi_clk25m,
      -------------------------------------------------------------------------
      o_hram0_reset_n                         => po_hram0_reset_n,
      o_hram0_ck                              => po_hram0_ck,
      o_hram0_ck_n                            => po_hram0_ck_n,
      o_hram0_cs_n                            => po_hram0_cs_n,
      io_hram0_rwds                           => pio_hram0_rwds,
      io_hram0_dq                             => pio_hram0_dq,
      --
      o_hram1_reset_n                         => po_hram1_reset_n,
      o_hram1_ck                              => po_hram1_ck,
      o_hram1_ck_n                            => po_hram1_ck_n,
      o_hram1_cs_n                            => po_hram1_cs_n,
      io_hram1_rwds                           => pio_hram1_rwds,
      io_hram1_dq                             => pio_hram1_dq,
      -------------------------------------------------------------------------
      i_ibc                                   => pi_ibc,
      o_ibc                                   => po_ibc,
      -------------------------------------------------------------------------
      i_bridge_reset                          => pi_bridge_reset,
      i_bridge_request                        => pi_bridge_request,
      o_bridge_ready_n                        => po_bridge_ready_n,
      --
      i_bridge_clock                          => pi_bridge_clock,
      i_bridge_valid                          => pi_bridge_valid,
      i_bridge_data                           => pi_bridge_data,
      --
      o_bridge_clock                          => po_bridge_clock,
      o_bridge_valid                          => po_bridge_valid,
      o_bridge_data                           => po_bridge_data,
      -------------------------------------------------------------------------
      o_digital_output_pull                   => po_digital_output_pull,
      o_digital_output_push                   => po_digital_output_push,
      i_digital_input                         => pi_digital_input,
      -------------------------------------------------------------------------
      i_adc_clock                             => pi_adc_clock,
      i_adc_data                              => pi_adc_data,
      o_adc_clock                             => po_adc_clock,
      o_adc_acquisition                       => po_adc_acquisition,
      -------------------------------------------------------------------------
      o_dac_clock                             => po_dac_clock,
      o_dac_cs_n                              => po_dac_cs_n,
      o_dac_data                              => po_dac_data,
      -------------------------------------------------------------------------
      i_ibc_plus_cable_present_n              => pi_ibc_plus_cable_present_n,
      i_ibc_plus_refclk_p                     => pi_ibc_plus_refclk_p,
      i_ibc_plus_rx_p                         => pi_ibc_plus_rx_p,
      o_ibc_plus_tx_p                         => po_ibc_plus_tx_p,
      -------------------------------------------------------------------------
      o_driver_enable                         => po_driver_enable,
      -------------------------------------------------------------------------
      io_application_board_io                 => pio_application_board_io,
      -------------------------------------------------------------------------
      o_debug_led                             => po_debug_led,
      -------------------------------------------------------------------------
      o_dsp_user_reset                        => s_dsp_user_reset,
      o_dsp_user_clock                        => s_dsp_user_clock,
      o_dsp_user_eth_reset                    => s_dsp_user_eth_reset,
      o_dsp_user_eth_clock                    => s_dsp_user_eth_clock,
      --
      o_dsp_user_timestamp                    => s_dsp_user_timestamp,
      o_dsp_user_invar_update                 => s_dsp_user_invar_update,
      o_dsp_user_invar                        => s_dsp_user_invar,
      i_dsp_user_outvar                       => s_dsp_user_outvar,
      --
      i_dsp_user_digital_output_tristate      => s_dsp_user_digital_output_tristate,
      i_dsp_user_digital_output_data          => s_dsp_user_digital_output_data,
      o_dsp_user_digital_input                => s_dsp_user_digital_input,
      --
      o_dsp_user_mac_address_valid            => s_dsp_user_mac_address_valid,
      o_dsp_user_mac_address_value            => s_dsp_user_mac_address_value,
      --
      o_dsp_user_ibc_sync                     => s_dsp_user_ibc_sync,
      o_dsp_user_ibc_ready                    => s_dsp_user_ibc_ready,
      o_dsp_user_ibc_busy                     => s_dsp_user_ibc_busy,
      i_dsp_user_ibc_error_clear              => s_dsp_user_ibc_error_clear,
      o_dsp_user_ibc_error                    => s_dsp_user_ibc_error,
      o_dsp_user_ibc_invar_update             => s_dsp_user_ibc_invar_update,
      o_dsp_user_ibc_invar                    => s_dsp_user_ibc_invar,
      o_dsp_user_ibc_outvar_busy              => s_dsp_user_ibc_outvar_busy,
      i_dsp_user_ibc_outvar                   => s_dsp_user_ibc_outvar,
      --
      i_dsp_user_ibc                          => s_dsp_user_ibc_out,
      o_dsp_user_ibc                          => s_dsp_user_ibc_in,
      --
      i_dsp_user_ibc_plus_interface_version   => s_dsp_user_ibc_plus_interface_version,
      i_dsp_user_ibc_plus_system_id           => s_dsp_user_ibc_plus_system_id,
      o_dsp_user_ibc_plus_lane_error          => s_dsp_user_ibc_plus_lane_error,
      o_dsp_user_ibc_plus_lane_block_tx_ready => s_dsp_user_ibc_plus_lane_block_tx_ready,
      o_dsp_user_ibc_plus_lane_block_tx_ack   => s_dsp_user_ibc_plus_lane_block_tx_ack,
      i_dsp_user_ibc_plus_lane_block_tx_valid => s_dsp_user_ibc_plus_lane_block_tx_valid,
      i_dsp_user_ibc_plus_lane_block_tx_data  => s_dsp_user_ibc_plus_lane_block_tx_data,
      o_dsp_user_ibc_plus_lane_block_rx_valid => s_dsp_user_ibc_plus_lane_block_rx_valid,
      o_dsp_user_ibc_plus_lane_block_rx_data  => s_dsp_user_ibc_plus_lane_block_rx_data,
      --
      i_dsp_user_hram0_avalon_select          => s_dsp_user_hram0_avalon_select,
      o_dsp_user_hram0_avalon_waitrequest     => s_dsp_user_hram0_avalon_waitrequest,
      i_dsp_user_hram0_avalon_address         => s_dsp_user_hram0_avalon_address,
      i_dsp_user_hram0_avalon_be              => s_dsp_user_hram0_avalon_be,
      i_dsp_user_hram0_avalon_write           => s_dsp_user_hram0_avalon_write,
      i_dsp_user_hram0_avalon_writedata       => s_dsp_user_hram0_avalon_writedata,
      i_dsp_user_hram0_avalon_read            => s_dsp_user_hram0_avalon_read,
      o_dsp_user_hram0_avalon_readdata        => s_dsp_user_hram0_avalon_readdata,
      --
      o_dsp_user_hram0_burst_busy             => s_dsp_user_hram0_burst_busy,
      o_dsp_user_hram0_burst_grant            => s_dsp_user_hram0_burst_grant,
      i_dsp_user_hram0_burst_address          => s_dsp_user_hram0_burst_address,
      i_dsp_user_hram0_burst_count            => s_dsp_user_hram0_burst_count,
      i_dsp_user_hram0_burst_be               => s_dsp_user_hram0_burst_be,
      i_dsp_user_hram0_burst_write            => s_dsp_user_hram0_burst_write,
      i_dsp_user_hram0_burst_writedata        => s_dsp_user_hram0_burst_writedata,
      i_dsp_user_hram0_burst_read             => s_dsp_user_hram0_burst_read,
      o_dsp_user_hram0_burst_readdata_valid   => s_dsp_user_hram0_burst_readdata_valid,
      o_dsp_user_hram0_burst_readdata         => s_dsp_user_hram0_burst_readdata,
      --
      i_dsp_user_hram1_avalon_select          => s_dsp_user_hram1_avalon_select,
      o_dsp_user_hram1_avalon_waitrequest     => s_dsp_user_hram1_avalon_waitrequest,
      i_dsp_user_hram1_avalon_address         => s_dsp_user_hram1_avalon_address,
      i_dsp_user_hram1_avalon_be              => s_dsp_user_hram1_avalon_be,
      i_dsp_user_hram1_avalon_write           => s_dsp_user_hram1_avalon_write,
      i_dsp_user_hram1_avalon_writedata       => s_dsp_user_hram1_avalon_writedata,
      i_dsp_user_hram1_avalon_read            => s_dsp_user_hram1_avalon_read,
      o_dsp_user_hram1_avalon_readdata        => s_dsp_user_hram1_avalon_readdata,
      --
      o_dsp_user_hram1_burst_busy             => s_dsp_user_hram1_burst_busy,
      o_dsp_user_hram1_burst_grant            => s_dsp_user_hram1_burst_grant,
      i_dsp_user_hram1_burst_address          => s_dsp_user_hram1_burst_address,
      i_dsp_user_hram1_burst_count            => s_dsp_user_hram1_burst_count,
      i_dsp_user_hram1_burst_be               => s_dsp_user_hram1_burst_be,
      i_dsp_user_hram1_burst_write            => s_dsp_user_hram1_burst_write,
      i_dsp_user_hram1_burst_writedata        => s_dsp_user_hram1_burst_writedata,
      i_dsp_user_hram1_burst_read             => s_dsp_user_hram1_burst_read,
      o_dsp_user_hram1_burst_readdata_valid   => s_dsp_user_hram1_burst_readdata_valid,
      o_dsp_user_hram1_burst_readdata         => s_dsp_user_hram1_burst_readdata,
      --
      i_dsp_user_adc_sample                   => s_dsp_user_adc_sample,
      o_dsp_user_adc_data                     => s_dsp_user_adc_data,
      o_dsp_user_adc_valid                    => s_dsp_user_adc_valid,
      --
      o_dsp_user_dac_ready                    => s_dsp_user_dac_ready,
      o_dsp_user_dac_load                     => s_dsp_user_dac_load,
      i_dsp_user_dac_conv                     => s_dsp_user_dac_conv,
      i_dsp_user_dac_data                     => s_dsp_user_dac_data,
      --
      i_dsp_user_serial_enable                => s_dsp_user_serial_enable,
      --
      i_dsp_user_frontpanel_led_green         => s_dsp_user_frontpanel_led_green,
      i_dsp_user_frontpanel_led_red           => s_dsp_user_frontpanel_led_red,
      --
      i_dsp_user_application_board_io_control => s_dsp_user_application_board_io_control,
      i_dsp_user_application_board_io_output  => s_dsp_user_application_board_io_output,
      o_dsp_user_application_board_io_input   => s_dsp_user_application_board_io_input,
      --
      i_dsp_user_debug_led                    => s_dsp_user_debug_led,
      --
      i_phy_link_st                           => pi_phy_link_st,
      o_dsp_user_phy_link_st                  => s_dsp_user_phy_link_st,
      i_phy_led_0                             => pi_phy_led_0,
      o_dsp_user_phy_led_0                    => s_dsp_user_phy_led_0,
      --
      o_dsp_user_hw_revision                  => s_dsp_user_hw_revision
    );

  -----------------------------------------------------------------------------
  --
  -----------------------------------------------------------------------------
  inst_rgmii_to_gmii_conv_sync : ENTITY work.rgmii_to_gmii_conv_sync
    PORT MAP (
      i_ethernet_reset      => s_dsp_user_eth_reset,
      i_ethernet_clock      => s_dsp_user_eth_clock(0),
      i_ethernet_data_clock => "0" & s_dsp_user_eth_clock,
      i_ethernet_tx_clock   => "0" & s_dsp_user_eth_clock,
      i_sw_reset            => '0',
      i_invert_tx_clock     => '0',
      i_link_speed          => "011",
      i_rmii_mode           => '0',
      i_rgmii_rx.clock      => pi_phy_rx(0).clock,
      i_rgmii_rx.ctrl       => pi_phy_rx(0).ctrl,
      i_rgmii_rx.data       => pi_phy_rx(0).data,
      o_rgmii_tx.clock      => po_phy_tx(0).clock,
      o_rgmii_tx.ctrl       => po_phy_tx(0).ctrl,
      o_rgmii_tx.data       => po_phy_tx(0).data,
      o_gmii_rx_clock_en    => s_dsp_user_eth_gmii_rx_clock_en,
      o_gmii_rx             => s_dsp_user_eth_gmii_rx,
      o_gmii_tx_clock_en    => s_dsp_user_eth_gmii_tx_clock_en,
      i_gmii_tx             => s_dsp_user_eth_gmii_tx
    );

  -----------------------------------------------------------------------------
  --
  -----------------------------------------------------------------------------
  inst_vt5838_dsp_user : ENTITY work.vt5838_dsp_user
    PORT MAP (
      i_reset                        => s_dsp_user_reset,
      i_clock                        => s_dsp_user_clock,
      --
      i_timestamp                    => s_dsp_user_timestamp,
      i_invar                        => s_dsp_user_invar,
      i_invar_update                 => s_dsp_user_invar_update,
      o_outvar                       => s_dsp_user_outvar,
      --
      i_ibc_sync                     => s_dsp_user_ibc_sync,
      i_ibc_ready                    => s_dsp_user_ibc_ready,
      i_ibc_busy                     => s_dsp_user_ibc_busy,
      o_ibc_error_clear              => s_dsp_user_ibc_error_clear,
      i_ibc_error                    => s_dsp_user_ibc_error,
      i_ibc_invar_update             => s_dsp_user_ibc_invar_update,
      i_ibc_invar                    => s_dsp_user_ibc_invar,
      i_ibc_outvar_busy              => s_dsp_user_ibc_outvar_busy,
      o_ibc_outvar                   => s_dsp_user_ibc_outvar,
      --
      i_ibc                          => s_dsp_user_ibc_in,
      o_ibc                          => s_dsp_user_ibc_out,
      --
      o_ibc_plus_interface_version   => s_dsp_user_ibc_plus_interface_version,
      o_ibc_plus_system_id           => s_dsp_user_ibc_plus_system_id,
      i_ibc_plus_lane_error          => s_dsp_user_ibc_plus_lane_error,
      i_ibc_plus_lane_block_tx_ready => s_dsp_user_ibc_plus_lane_block_tx_ready,
      i_ibc_plus_lane_block_tx_ack   => s_dsp_user_ibc_plus_lane_block_tx_ack,
      o_ibc_plus_lane_block_tx_valid => s_dsp_user_ibc_plus_lane_block_tx_valid,
      o_ibc_plus_lane_block_tx_data  => s_dsp_user_ibc_plus_lane_block_tx_data,
      i_ibc_plus_lane_block_rx_valid => s_dsp_user_ibc_plus_lane_block_rx_valid,
      i_ibc_plus_lane_block_rx_data  => s_dsp_user_ibc_plus_lane_block_rx_data,
      --
      i_serial_rs422                 => pi_serial(1 DOWNTO 0),
      o_serial_rs422_enable          => s_dsp_user_serial_enable,
      o_serial_rs422                 => po_serial(1 DOWNTO 0),
      i_serial_lvds                  => pi_serial(3 DOWNTO 2),
      o_serial_lvds                  => po_serial(3 DOWNTO 2),
      --
      i_digital                      => s_dsp_user_digital_input,
      o_digital_tristate             => s_dsp_user_digital_output_tristate,
      o_digital_data                 => s_dsp_user_digital_output_data,
      --
      o_hram0_avalon_select          => s_dsp_user_hram0_avalon_select,
      i_hram0_avalon_waitrequest     => s_dsp_user_hram0_avalon_waitrequest,
      o_hram0_avalon_address         => s_dsp_user_hram0_avalon_address,
      o_hram0_avalon_be              => s_dsp_user_hram0_avalon_be,
      o_hram0_avalon_write           => s_dsp_user_hram0_avalon_write,
      o_hram0_avalon_writedata       => s_dsp_user_hram0_avalon_writedata,
      o_hram0_avalon_read            => s_dsp_user_hram0_avalon_read,
      i_hram0_avalon_readdata        => s_dsp_user_hram0_avalon_readdata,
      --
      i_hram0_burst_busy             => s_dsp_user_hram0_burst_busy,
      i_hram0_burst_grant            => s_dsp_user_hram0_burst_grant,
      o_hram0_burst_address          => s_dsp_user_hram0_burst_address,
      o_hram0_burst_count            => s_dsp_user_hram0_burst_count,
      o_hram0_burst_be               => s_dsp_user_hram0_burst_be,
      o_hram0_burst_write            => s_dsp_user_hram0_burst_write,
      o_hram0_burst_writedata        => s_dsp_user_hram0_burst_writedata,
      o_hram0_burst_read             => s_dsp_user_hram0_burst_read,
      i_hram0_burst_readdata_valid   => s_dsp_user_hram0_burst_readdata_valid,
      i_hram0_burst_readdata         => s_dsp_user_hram0_burst_readdata,
      --
      o_hram1_avalon_select          => s_dsp_user_hram1_avalon_select,
      i_hram1_avalon_waitrequest     => s_dsp_user_hram1_avalon_waitrequest,
      o_hram1_avalon_address         => s_dsp_user_hram1_avalon_address,
      o_hram1_avalon_be              => s_dsp_user_hram1_avalon_be,
      o_hram1_avalon_write           => s_dsp_user_hram1_avalon_write,
      o_hram1_avalon_writedata       => s_dsp_user_hram1_avalon_writedata,
      o_hram1_avalon_read            => s_dsp_user_hram1_avalon_read,
      i_hram1_avalon_readdata        => s_dsp_user_hram1_avalon_readdata,
      --
      i_hram1_burst_busy             => s_dsp_user_hram1_burst_busy,
      i_hram1_burst_grant            => s_dsp_user_hram1_burst_grant,
      o_hram1_burst_address          => s_dsp_user_hram1_burst_address,
      o_hram1_burst_count            => s_dsp_user_hram1_burst_count,
      o_hram1_burst_be               => s_dsp_user_hram1_burst_be,
      o_hram1_burst_write            => s_dsp_user_hram1_burst_write,
      o_hram1_burst_writedata        => s_dsp_user_hram1_burst_writedata,
      o_hram1_burst_read             => s_dsp_user_hram1_burst_read,
      i_hram1_burst_readdata_valid   => s_dsp_user_hram1_burst_readdata_valid,
      i_hram1_burst_readdata         => s_dsp_user_hram1_burst_readdata,
      --
      o_adc_sample                   => s_dsp_user_adc_sample,
      i_adc_data                     => s_dsp_user_adc_data,
      i_adc_valid                    => s_dsp_user_adc_valid,
      --
      i_dac_ready                    => s_dsp_user_dac_ready,
      i_dac_load                     => s_dsp_user_dac_load,
      o_dac_conv                     => s_dsp_user_dac_conv,
      o_dac_data                     => s_dsp_user_dac_data,
      --
      o_frontpanel_led_green         => s_dsp_user_frontpanel_led_green,
      o_frontpanel_led_red           => s_dsp_user_frontpanel_led_red,
      --
      o_application_board_io_control => s_dsp_user_application_board_io_control,
      o_application_board_io_output  => s_dsp_user_application_board_io_output,
      i_application_board_io_input   => s_dsp_user_application_board_io_input,
      --
      o_phy_reset_n                  => po_phy_reset_n,
      i_phy_int_n                    => pi_phy_int_n,
      i_phy_led_0                    => s_dsp_user_phy_led_0,
      i_phy_link_st                  => s_dsp_user_phy_link_st,
      o_phy_led                      => po_phy_led,
      o_phy_mdc                      => po_phy_mdc,
      io_phy_mdio                    => pio_phy_mdio,
      i_mac_address_valid            => s_dsp_user_mac_address_valid,
      i_mac_address_value            => s_dsp_user_mac_address_value,
      i_eth_reset                    => s_dsp_user_eth_reset,
      i_eth_clock                    => s_dsp_user_eth_clock(0),
      i_eth_gmii_rx_clock_en         => s_dsp_user_eth_gmii_rx_clock_en,
      i_eth_gmii_rx_en               => s_dsp_user_eth_gmii_rx.en,
      i_eth_gmii_rx_err              => s_dsp_user_eth_gmii_rx.err,
      i_eth_gmii_rx_data             => s_dsp_user_eth_gmii_rx.data,
      i_eth_gmii_tx_clock_en         => s_dsp_user_eth_gmii_tx_clock_en,
      o_eth_gmii_tx_en               => s_dsp_user_eth_gmii_tx.en,
      o_eth_gmii_tx_err              => s_dsp_user_eth_gmii_tx.err,
      o_eth_gmii_tx_data             => s_dsp_user_eth_gmii_tx.data,
      o_debug_led                    => s_dsp_user_debug_led,
      i_hw_revision                  => s_dsp_user_hw_revision
    );

  --
  s_dsp_user_eth_gmii_tx.crs <= '0';
  s_dsp_user_eth_gmii_tx.col <= '0';
  po_uart_rx                 <= pi_uart_tx;
  
END ARCHITECTURE;
