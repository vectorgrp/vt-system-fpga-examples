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
--  $Workfile: vt1004_dsp_user.vhd $
--  $Author: visstz $
--  $Date: 2019-03-27 09:48:32 +0100 (Mi, 27 Mrz 2019) $
--  $Revision: 101875 $
--  Abstract      :
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
ENTITY vt2710_dsp_user IS
  GENERIC (
    g_invar      : natural RANGE 0 TO 256;
    --
    g_outvar     : natural RANGE 0 TO 256;
    --
    g_ibc_invar  : natural RANGE 0 TO 32;
    g_ibc_outvar : natural RANGE 0 TO 32);
  PORT (
    i_reset              : IN  std_logic;
    i_clock              : IN  std_logic;
    --
    i_con1_dio1          : IN  std_logic_vector(0 DOWNTO 0);
    o_con1_dio1_rs232_tx : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con1_dio2_rs232_rx : IN  std_logic_vector(0 DOWNTO 0);
    o_con1_dio2          : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con1_dio3          : IN  std_logic_vector(0 DOWNTO 0);
    o_con1_dio3_rs485_tx : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con1_dio4_rs485_rx : IN  std_logic_vector(0 DOWNTO 0);
    o_con1_dio4          : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con1_dio5          : IN  std_logic_vector(0 DOWNTO 0);
    o_con1_dio5_rs485_oe : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con1_dio6          : IN  std_logic_vector(0 DOWNTO 0);
    o_con1_dio6          : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con1_dio7_i2c_sda  : IN  std_logic_vector(0 DOWNTO 0);
    o_con1_dio7_i2c_sda  : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con1_dio8_i2c_scl  : IN  std_logic_vector(0 DOWNTO 0);
    o_con1_dio8_i2c_scl  : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con2_dio1          : IN  std_logic_vector(0 DOWNTO 0);
    o_con2_dio1_rs232_tx : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con2_dio2_rs232_rx : IN  std_logic_vector(0 DOWNTO 0);
    o_con2_dio2          : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con2_dio3          : IN  std_logic_vector(0 DOWNTO 0);
    o_con2_dio3_rs485_tx : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con2_dio4_rs485_rx : IN  std_logic_vector(0 DOWNTO 0);
    o_con2_dio4          : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con2_dio5          : IN  std_logic_vector(0 DOWNTO 0);
    o_con2_dio5_rs485_oe : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con2_dio6          : IN  std_logic_vector(0 DOWNTO 0);
    o_con2_dio6          : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con2_dio7_i2c_sda  : IN  std_logic_vector(0 DOWNTO 0);
    o_con2_dio7_i2c_sda  : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con2_dio8_i2c_scl  : IN  std_logic_vector(0 DOWNTO 0);
    o_con2_dio8_i2c_scl  : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con1_lvds          : IN  std_logic_vector(0 DOWNTO 0);
    o_con1_lvds          : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_con2_lvds          : IN  std_logic_vector(0 DOWNTO 0);
    o_con2_lvds          : OUT std_logic_vector(0 DOWNTO 0)        := "0";
    --
    i_timestamp          : IN  std_logic_vector(63 DOWNTO 0);
    i_invar              : IN  t_slv32_matrix(0 TO g_invar-1);
    i_invar_update       : IN  std_logic;
    o_outvar             : OUT t_slv32_matrix(0 TO g_outvar-1)     := (OTHERS => (OTHERS => '0'));
    --
    i_ibc_sync           : IN  std_logic;
    i_ibc_ready          : IN  std_logic;
    i_ibc_busy           : IN  std_logic;
    o_ibc_error_clear    : OUT std_logic_vector(7 DOWNTO 0);
    i_ibc_error          : IN  std_logic_vector(7 DOWNTO 0);
    i_ibc_invar_update   : IN  std_logic_vector(g_ibc_invar-1 DOWNTO 0);
    i_ibc_invar          : IN  t_slv32_matrix(0 TO g_ibc_invar-1);
    i_ibc_outvar_busy    : IN  std_logic;
    o_ibc_outvar         : OUT t_slv32_matrix(0 TO g_ibc_outvar-1) := (OTHERS => (OTHERS => '0'));
    --
    i_ibc                : IN  std_logic_vector(3 DOWNTO 0);
    o_ibc                : OUT std_logic_vector(3 DOWNTO 0)        := (OTHERS => '0');
    --
    o_debug_led          : OUT std_logic_vector(4 DOWNTO 0)        := (OTHERS => '0'));
END vt2710_dsp_user;


--=ARCHITECTURE===============================================================
ARCHITECTURE rtl OF vt2710_dsp_user IS

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
    SensorAddress_1_ch11 : in std_logic_vector(7 downto 0);
    SensorAddress_2_ch11 : in std_logic_vector(7 downto 0);
    SensorAddress_3_ch11 : in std_logic_vector(7 downto 0);
    SensorAddress_4_ch11 : in std_logic_vector(7 downto 0);
    SensorAddress_5_ch11 : in std_logic_vector(15 downto 0);
    RegisterDataIn_1_ch11 : out std_logic_vector(15 downto 0) := (others => '0');
    RegisterDataIn_2_ch11 : out std_logic_vector(15 downto 0) := (others => '0');
    RegisterDataIn_3_ch11 : out std_logic_vector(15 downto 0) := (others => '0');
    RegisterDataIn_4_ch11 : out std_logic_vector(15 downto 0) := (others => '0');
    RegisterDataIn_5_ch11 : out std_logic_vector(15 downto 0) := (others => '0');
    RegisterDataOut_1_ch11 : in std_logic_vector(15 downto 0);
    RegisterDataOut_2_ch11 : in std_logic_vector(15 downto 0);
    RegisterDataOut_3_ch11 : in std_logic_vector(15 downto 0);
    RegisterDataOut_4_ch11 : in std_logic_vector(15 downto 0);
    RegisterDataOut_5_ch11 : in std_logic_vector(15 downto 0);
    RegisterAddress_1_ch11 : in std_logic_vector(7 downto 0);
    RegisterAddress_2_ch11 : in std_logic_vector(7 downto 0);
    RegisterAddress_3_ch11 : in std_logic_vector(7 downto 0);
    RegisterAddress_4_ch11 : in std_logic_vector(7 downto 0);
    RegisterAddress_5_ch11 : in std_logic_vector(7 downto 0);
    RegisterWren_1_ch11 : in std_logic_vector(0 downto 0);
    RegisterWren_2_ch11 : in std_logic_vector(0 downto 0);
    RegisterWren_3_ch11 : in std_logic_vector(0 downto 0);
    RegisterWren_4_ch11 : in std_logic_vector(0 downto 0);
    RegisterWren_5_ch11 : in std_logic_vector(0 downto 0);
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
    clk                    : IN  std_logic;                                        -- Clock.clk
    areset                 : IN  std_logic;                                        -- .reset
    h_areset               : IN  std_logic;
    --
    in_con1_dio1           : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 1, pin 9
    in_con1_dio2_rs232_rx  : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 1, pin 8
    in_con1_dio3           : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 1, pin 7
    in_con1_dio4_rs485_rx  : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 1, pin 6
    in_con1_dio5           : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 1, pin 5
    in_con1_dio6           : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 1, pin 4
    in_con1_dio7_i2c_sda   : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 1, pin 3
    in_con1_dio8_i2c_scl   : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 1, pin 2
    --
    out_con1_dio1_rs232_tx : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 9
    out_con1_dio2          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 8
    out_con1_dio3_rs485_tx : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 7
    out_con1_dio4          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 6
    out_con1_dio5_rs485_oe : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 5
    out_con1_dio6          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 4
    out_con1_dio7_i2c_sda  : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 3
    out_con1_dio8_i2c_scl  : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 2
    --
    in_con2_dio1           : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 2, pin 9
    in_con2_dio2_rs232_rx  : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 2, pin 8
    in_con2_dio3           : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 2, pin 7
    in_con2_dio4_rs485_rx  : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 2, pin 6
    in_con2_dio5           : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 2, pin 5
    in_con2_dio6           : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 2, pin 4
    in_con2_dio7_i2c_sda   : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 2, pin 3
    in_con2_dio8_i2c_scl   : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 2, pin 2
    --
    out_con2_dio1_rs232_tx : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 9
    out_con2_dio2          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 8
    out_con2_dio3_rs485_tx : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 7
    out_con2_dio4          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 6
    out_con2_dio5_rs485_oe : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 5
    out_con2_dio6          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 4
    out_con2_dio7_i2c_sda  : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 3
    out_con2_dio8_i2c_scl  : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 2
    --
    in_lvds_1              : IN  std_logic_vector(0 DOWNTO 0);                     -- lvds channel 1 input
    in_lvds_2              : IN  std_logic_vector(0 DOWNTO 0);                     -- lvds channel 2 input
    --
    out_lvds_1             : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- lvds channel 1 output
    out_lvds_2             : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- lvds channel 2 output
    --
    in_invar_update        : IN  std_logic;                                        -- invar update notification
    in_timestamp           : IN  std_logic_vector(63 DOWNTO 0);                    -- current module time
    --
    debug_LED_1            : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- debug LED 1
    debug_LED_2            : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- debug LED 2
    debug_LED_3            : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- debug LED 3
    debug_LED_4            : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- debug LED 4
    debug_LED_5            : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0')   -- debug LED 5
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
in_con1_dio1 => i_con1_dio1,
in_con1_dio2_rs232_rx => i_con1_dio2_rs232_rx,
in_con1_dio3 => i_con1_dio3,
in_con1_dio4_rs485_rx => i_con1_dio4_rs485_rx,
in_con1_dio5 => i_con1_dio5,
in_con1_dio6 => i_con1_dio6,
in_con1_dio7_i2c_sda => i_con1_dio7_i2c_sda,
in_con1_dio8_i2c_scl => i_con1_dio8_i2c_scl,
in_con2_dio1 => i_con2_dio1,
in_con2_dio2_rs232_rx => i_con2_dio2_rs232_rx,
in_con2_dio3 => i_con2_dio3,
in_con2_dio4_rs485_rx => i_con2_dio4_rs485_rx,
in_con2_dio5 => i_con2_dio5,
in_con2_dio6 => i_con2_dio6,
in_con2_dio7_i2c_sda => i_con2_dio7_i2c_sda,
in_con2_dio8_i2c_scl => i_con2_dio8_i2c_scl,
in_ibc_1(0) => i_ibc(0),
in_ibc_2(0) => i_ibc(1),
in_ibc_3(0) => i_ibc(2),
in_ibc_4(0) => i_ibc(3),
in_invar_update => i_invar_update,
in_lvds_1 => i_con1_lvds,
in_lvds_2 => i_con2_lvds,
in_timestamp => i_timestamp,
out_con1_dio1_rs232_tx => o_con1_dio1_rs232_tx,
out_con1_dio2 => o_con1_dio2,
out_con1_dio3_rs485_tx => o_con1_dio3_rs485_tx,
out_con1_dio4 => o_con1_dio4,
out_con1_dio5_rs485_oe => o_con1_dio5_rs485_oe,
out_con1_dio6 => o_con1_dio6,
out_con1_dio7_i2c_sda => o_con1_dio7_i2c_sda,
out_con1_dio8_i2c_scl => o_con1_dio8_i2c_scl,
out_con2_dio1_rs232_tx => o_con2_dio1_rs232_tx,
out_con2_dio2 => o_con2_dio2,
out_con2_dio3_rs485_tx => o_con2_dio3_rs485_tx,
out_con2_dio4 => o_con2_dio4,
out_con2_dio5_rs485_oe => o_con2_dio5_rs485_oe,
out_con2_dio6 => o_con2_dio6,
out_con2_dio7_i2c_sda => o_con2_dio7_i2c_sda,
out_con2_dio8_i2c_scl => o_con2_dio8_i2c_scl,
out_ibc_1(0) => o_ibc(0),
out_ibc_2(0) => o_ibc(1),
out_ibc_3(0) => o_ibc(2),
out_ibc_4(0) => o_ibc(3),
out_lvds_1 => o_con1_lvds,
out_lvds_2 => o_con2_lvds,
RegisterWren_1_ch11(0)   => i_invar(0)(0),
RegisterWren_2_ch11(0)   => i_invar(0)(1),
RegisterWren_3_ch11(0)   => i_invar(0)(2),
RegisterWren_4_ch11(0)   => i_invar(0)(3),
RegisterWren_5_ch11(0)   => i_invar(0)(4),
RegisterAddress_1_ch11   => i_invar(0)(15 downto 8),
RegisterAddress_2_ch11   => i_invar(0)(23 downto 16),
RegisterAddress_3_ch11   => i_invar(0)(31 downto 24),
RegisterAddress_4_ch11   => i_invar(1)(7 downto 0),
RegisterAddress_5_ch11   => i_invar(1)(15 downto 8),
SensorAddress_1_ch11   => i_invar(1)(23 downto 16),
SensorAddress_2_ch11   => i_invar(1)(31 downto 24),
SensorAddress_3_ch11   => i_invar(2)(7 downto 0),
SensorAddress_4_ch11   => i_invar(2)(15 downto 8),
RegisterDataOut_1_ch11   => i_invar(2)(31 downto 16),
RegisterDataOut_2_ch11   => i_invar(3)(15 downto 0),
RegisterDataOut_3_ch11   => i_invar(3)(31 downto 16),
RegisterDataOut_4_ch11   => i_invar(4)(15 downto 0),
RegisterDataOut_5_ch11   => i_invar(4)(31 downto 16),
SensorAddress_5_ch11   => i_invar(5)(15 downto 0),
RegisterDataIn_1_ch11   => o_outvar(0)(15 downto 0),
RegisterDataIn_2_ch11   => o_outvar(0)(31 downto 16),
RegisterDataIn_3_ch11   => o_outvar(1)(15 downto 0),
RegisterDataIn_4_ch11   => o_outvar(1)(31 downto 16),
RegisterDataIn_5_ch11   => o_outvar(2)(15 downto 0)
);
  -- @CMD=PORTMAPEND

END rtl;
