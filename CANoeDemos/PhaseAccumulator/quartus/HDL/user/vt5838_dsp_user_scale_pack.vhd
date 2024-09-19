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

PACKAGE dsp_user_scale IS

  CONSTANT p_reset_level                  : std_logic                    := '1';  -- '1'-high/'0'-low active reset
  --
  CONSTANT p_wclk  : natural RANGE 0 TO 2 := 0;
  --
  CONSTANT p_invar  : natural RANGE 0 TO 256 := 46;
  CONSTANT p_outvar  : natural RANGE 0 TO 256 := 15;
  --
  CONSTANT p_ibc_active                   : std_logic                    := '0';
  CONSTANT p_ibc_sync_master              : std_logic                    := '0';
  CONSTANT p_ibc_sync_master_period_in_us : natural RANGE 1 TO 1_000_000 := 1;
  CONSTANT p_ibc_invar                    : natural RANGE 0 TO 255       := 0;
  CONSTANT p_ibc_outvar                   : natural RANGE 0 TO 255       := 0;
  CONSTANT p_ibc_outvar_readback          : std_logic                    := '0';
  --
  CONSTANT p_ibc_plus_block_size_tx            : t_natural_matrix(0 TO 3)     := (4, 8, 16, 64);
  CONSTANT p_ibc_plus_mode                     : std_logic_vector(3 DOWNTO 0) := ('0', '0', '0', '0');  -- 0: cyclic; 1: manual
  CONSTANT p_ibc_plus_sampling_rate_ticks      : t_natural_matrix(0 TO 3)     := (40, 40, 1 * 80, 5 * 80);
  CONSTANT p_ibc_plus_block_size_rx            : t_natural_matrix(0 TO 3)     := (4, 8, 16, 64);
  CONSTANT p_ibc_plus_interface_version        : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
  CONSTANT p_ibc_plus_system_id                : std_logic_vector(27 DOWNTO 0):= (OTHERS => '0');   
  --
  CONSTANT p_dac_mode                          : std_logic                    := '0';  -- 0: cyclic; 1: manual
  CONSTANT p_dac_sampling_rate_ticks           : natural RANGE 5 TO 80_000    := 80000;
  --
  CONSTANT p_adc_mode                     : std_logic                    := '0';  -- 0: cyclic; 1: manual
  CONSTANT p_adc_sampling_rate_ticks      : natural RANGE 3 TO 80_000    := 80000;
  --
  CONSTANT p_ibc_id_invar_map             : t_natural_matrix(0 TO 255)   := (OTHERS => 256);
  CONSTANT p_ibc_outvar_id_map            : t_natural_matrix(0 TO 255)   := (OTHERS => 256);
  --
  CONSTANT p_hram0_number_of_avalon_interfaces : natural RANGE 0 TO 4 := 0;
  CONSTANT p_hram1_number_of_avalon_interfaces : natural RANGE 0 TO 4 := 0;
  --
  CONSTANT p_hram0_number_of_burst_interfaces  : natural RANGE 0 TO 4 := 0;
  CONSTANT p_hram1_number_of_burst_interfaces  : natural RANGE 0 TO 4 := 0;

END PACKAGE dsp_user_scale;

PACKAGE BODY dsp_user_scale IS

END PACKAGE BODY dsp_user_scale;