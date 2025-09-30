--==============================================================================
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
--  $Workfile: vt2848_dsp_user_scale_pack.vhd $
--  $Author: visstz $
--  $Date: 2019-03-27 09:48:32 +0100 (Mi, 27 Mrz 2019) $
--  $Revision: 101875 $
--  Abstract:
--            Global definitions
--==============================================================================



--=LIBRARY======================================================================
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

LIBRARY work;
USE work.global_definitions.ALL;
USE work.type_conversion_pack.ALL;
--==============================================================================



--=PACKAGE======================================================================
PACKAGE global_scale IS

  CONSTANT p_fpga_vendor     : t_fpga_vendor := ALTERA;
  CONSTANT p_fpga_technology : t_fpga_technology := CYCLONE;


  ------------------------------------------------------------------------------
  -- version definition
  ------------------------------------------------------------------------------
  CONSTANT p_module                       : string(1 TO 6)               := "VT2710";  -- Module
  --
  CONSTANT p_wclk  : natural RANGE 0 TO 2 := 0;
  CONSTANT p_reset_level                  : std_logic                    := '1';  -- '1'-high/'0'-low active reset
  --
  CONSTANT p_invar  : natural RANGE 0 TO 128 := 6;
  CONSTANT p_outvar  : natural RANGE 0 TO 128 := 3;
  --
  CONSTANT p_ibc_active                   : std_logic                    := '0';
  CONSTANT p_ibc_sync_master              : std_logic                    := '0';
  CONSTANT p_ibc_sync_master_period_in_us : natural RANGE 1 TO 1_000_000 := 1;
  CONSTANT p_ibc_invar                    : natural RANGE 0 TO 256       := 0;
  CONSTANT p_ibc_outvar                   : natural RANGE 0 TO 256       := 0;
  CONSTANT p_ibc_outvar_readback          : std_logic                    := '0';
  CONSTANT p_ibc_id_invar_map : t_natural_matrix(0 TO 255) := (OTHERS => 256);
  CONSTANT p_ibc_outvar_id_map : t_natural_matrix(0 TO 255) := (OTHERS => 256);

END global_scale;
--==============================================================================




--=PACKAGE BODY=================================================================
PACKAGE BODY global_scale IS


END global_scale;
--==============================================================================
