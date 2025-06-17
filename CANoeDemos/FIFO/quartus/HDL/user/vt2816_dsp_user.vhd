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
--  $Workfile: vt2816_dsp_user.vhd $
--  $Author: visstz $
--  $Date: 2019-03-27 09:48:32 +0100 (Mi, 27 Mrz 2019) $
--  $Revision: 101875 $
--  Abstract      :
--           FPGA top
--           contains CPU interface and functional top
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
ENTITY vt2816_dsp_user IS
  GENERIC (
    g_invar      : natural RANGE 0 TO 256;
    g_outvar     : natural RANGE 0 TO 256;
    --
    g_ibc_invar  : natural RANGE 0 TO 32;
    g_ibc_outvar : natural RANGE 0 TO 32);
  PORT (
    i_reset            : IN  std_logic;
    i_clock            : IN  std_logic;
    --
    i_adc              : IN  t_slv32_matrix(0 TO 11);
    i_adc_update       : IN  std_logic_vector(11 DOWNTO 0);
    o_dac              : OUT t_slv32_matrix(0 TO 3)              := (OTHERS => (OTHERS => '0'));
    --
    i_timestamp        : IN  std_logic_vector(63 DOWNTO 0);
    i_invar            : IN  t_slv32_matrix(0 TO g_invar-1);
    i_invar_update     : IN  std_logic;
    o_outvar           : OUT t_slv32_matrix(0 TO g_outvar-1)     := (OTHERS => (OTHERS => '0'));
    --
    i_ibc_sync         : IN  std_logic;
    i_ibc_ready        : IN  std_logic;
    i_ibc_busy         : IN  std_logic;
    o_ibc_error_clear  : OUT std_logic_vector(7 DOWNTO 0);
    i_ibc_error        : IN  std_logic_vector(7 DOWNTO 0);
    i_ibc_invar_update : IN  std_logic_vector(g_ibc_invar-1 DOWNTO 0);
    i_ibc_invar        : IN  t_slv32_matrix(0 TO g_ibc_invar-1);
    i_ibc_outvar_busy  : IN  std_logic;
    o_ibc_outvar       : OUT t_slv32_matrix(0 TO g_ibc_outvar-1) := (OTHERS => (OTHERS => '0'));
    --
    i_ibc              : IN  std_logic_vector(3 DOWNTO 0);
    o_ibc              : OUT std_logic_vector(3 DOWNTO 0)        := (OTHERS => '0');
    --
    o_debug_led        : OUT std_logic_vector(4 DOWNTO 0)        := (OTHERS => '0'));
END vt2816_dsp_user;


--=ARCHITECTURE===============================================================
ARCHITECTURE rtl OF vt2816_dsp_user IS
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
    DataDownload_ch13 : in std_logic_vector(31 downto 0);
    DataDownload_ch14 : in std_logic_vector(31 downto 0);
    DataDownload_ch15 : in std_logic_vector(31 downto 0);
    DataDownload_ch16 : in std_logic_vector(31 downto 0);
    Download_ch13 : in std_logic_vector(0 downto 0);
    Download_ch14 : in std_logic_vector(0 downto 0);
    Download_ch15 : in std_logic_vector(0 downto 0);
    Download_ch16 : in std_logic_vector(0 downto 0);
    Send_ch13 : in std_logic_vector(0 downto 0);
    Send_ch14 : in std_logic_vector(0 downto 0);
    Send_ch15 : in std_logic_vector(0 downto 0);
    Send_ch16 : in std_logic_vector(0 downto 0);
    NumOfWords_ch13 : out std_logic_vector(31 downto 0) := (others => '0');
    NumOfWords_ch14 : out std_logic_vector(31 downto 0) := (others => '0');
    NumOfWords_ch15 : out std_logic_vector(31 downto 0) := (others => '0');
    NumOfWords_ch16 : out std_logic_vector(31 downto 0) := (others => '0');
    IsFull_ch13 : out std_logic_vector(0 downto 0) := (others => '0');
    IsFull_ch14 : out std_logic_vector(0 downto 0) := (others => '0');
    IsFull_ch15 : out std_logic_vector(0 downto 0) := (others => '0');
    IsFull_ch16 : out std_logic_vector(0 downto 0) := (others => '0');
    IsEmpty_ch13 : out std_logic_vector(0 downto 0) := (others => '0');
    IsEmpty_ch14 : out std_logic_vector(0 downto 0) := (others => '0');
    IsEmpty_ch15 : out std_logic_vector(0 downto 0) := (others => '0');
    IsEmpty_ch16 : out std_logic_vector(0 downto 0) := (others => '0');
    DataUpload_ch1 : out std_logic_vector(31 downto 0) := (others => '0');
    DataUpload_ch2 : out std_logic_vector(31 downto 0) := (others => '0');
    DataUpload_ch3 : out std_logic_vector(31 downto 0) := (others => '0');
    DataUpload_ch4 : out std_logic_vector(31 downto 0) := (others => '0');
    Upload_ch1 : in std_logic_vector(0 downto 0);
    Upload_ch2 : in std_logic_vector(0 downto 0);
    Upload_ch3 : in std_logic_vector(0 downto 0);
    Upload_ch4 : in std_logic_vector(0 downto 0);
    NumOfWords_ch1 : out std_logic_vector(31 downto 0) := (others => '0');
    NumOfWords_ch2 : out std_logic_vector(31 downto 0) := (others => '0');
    NumOfWords_ch3 : out std_logic_vector(31 downto 0) := (others => '0');
    NumOfWords_ch4 : out std_logic_vector(31 downto 0) := (others => '0');
    IsFull_ch1 : out std_logic_vector(0 downto 0) := (others => '0');
    IsFull_ch2 : out std_logic_vector(0 downto 0) := (others => '0');
    IsFull_ch3 : out std_logic_vector(0 downto 0) := (others => '0');
    IsFull_ch4 : out std_logic_vector(0 downto 0) := (others => '0');
    IsEmpty_ch1 : out std_logic_vector(0 downto 0) := (others => '0');
    IsEmpty_ch2 : out std_logic_vector(0 downto 0) := (others => '0');
    IsEmpty_ch3 : out std_logic_vector(0 downto 0) := (others => '0');
    IsEmpty_ch4 : out std_logic_vector(0 downto 0) := (others => '0');
    StoreUpload_ch1 : in std_logic_vector(0 downto 0);
    StoreUpload_ch2 : in std_logic_vector(0 downto 0);
    StoreUpload_ch3 : in std_logic_vector(0 downto 0);
    StoreUpload_ch4 : in std_logic_vector(0 downto 0);
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
    clk             : IN  std_logic;                                         -- Clock.clk
    areset          : IN  std_logic;                                         -- .reset
    h_areset        : IN  std_logic;
    --
    in_adc_1        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 1 (voltage or current)
    in_adc_2        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 2 (voltage or current)
    in_adc_3        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 3 (voltage or current)
    in_adc_4        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 4 (voltage or current)
    in_adc_5        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 5 (voltage or current)
    in_adc_6        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 6 (voltage or current)
    in_adc_7        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 7 (voltage or current)
    in_adc_8        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 8 (voltage or current)
    in_adc_9        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 9 (voltage)
    in_adc_10       : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 10 (voltage)
    in_adc_11       : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 11 (voltage)
    in_adc_12       : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 12 (voltage)
    --
    out_dac_1       : OUT std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- analog voltage output on output channel 1
    out_dac_2       : OUT std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- analog voltage output on output channel 2
    out_dac_4       : OUT std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- analog voltage output on output channel 3
    out_dac_3       : OUT std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- analog voltage output on output channel 4
    --
    in_adc_update   : IN  std_logic_vector(12 DOWNTO 1);                     -- ADC update notifications
    in_invar_update : IN  std_logic;                                         -- invar update notification
    in_timestamp    : IN  std_logic_vector(63 DOWNTO 0);                     -- current module time
    --
    debug_LED_1     : OUT std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- debug LED 1
    debug_LED_2     : OUT std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- debug LED 2
    debug_LED_3     : OUT std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- debug LED 3
    debug_LED_4     : OUT std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- debug LED 4
    debug_LED_5     : OUT std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0')   -- debug LED 5
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
in_adc_1 => i_adc(0),
in_adc_10 => i_adc(9),
in_adc_11 => i_adc(10),
in_adc_12 => i_adc(11),
in_adc_2 => i_adc(1),
in_adc_3 => i_adc(2),
in_adc_4 => i_adc(3),
in_adc_5 => i_adc(4),
in_adc_6 => i_adc(5),
in_adc_7 => i_adc(6),
in_adc_8 => i_adc(7),
in_adc_9 => i_adc(8),
in_adc_update => i_adc_update,
in_ibc_1(0) => i_ibc(0),
in_ibc_2(0) => i_ibc(1),
in_ibc_3(0) => i_ibc(2),
in_ibc_4(0) => i_ibc(3),
in_invar_update => i_invar_update,
in_timestamp => i_timestamp,
out_dac_1 => o_dac(0),
out_dac_2 => o_dac(1),
out_dac_3 => o_dac(2),
out_dac_4 => o_dac(3),
out_ibc_1(0) => o_ibc(0),
out_ibc_2(0) => o_ibc(1),
out_ibc_3(0) => o_ibc(2),
out_ibc_4(0) => o_ibc(3),
Download_ch13(0)   => i_invar(0)(0),
Download_ch14(0)   => i_invar(0)(1),
Download_ch15(0)   => i_invar(0)(2),
Download_ch16(0)   => i_invar(0)(3),
Send_ch13(0)   => i_invar(0)(4),
Send_ch14(0)   => i_invar(0)(5),
Send_ch15(0)   => i_invar(0)(6),
Send_ch16(0)   => i_invar(0)(7),
StoreUpload_ch1(0)   => i_invar(0)(8),
StoreUpload_ch2(0)   => i_invar(0)(9),
StoreUpload_ch3(0)   => i_invar(0)(10),
StoreUpload_ch4(0)   => i_invar(0)(11),
Upload_ch1(0)   => i_invar(0)(12),
Upload_ch2(0)   => i_invar(0)(13),
Upload_ch3(0)   => i_invar(0)(14),
Upload_ch4(0)   => i_invar(0)(15),
DataDownload_ch13   => i_invar(1)(31 downto 0),
DataDownload_ch14   => i_invar(2)(31 downto 0),
DataDownload_ch15   => i_invar(3)(31 downto 0),
DataDownload_ch16   => i_invar(4)(31 downto 0),
IsEmpty_ch1(0)   => o_outvar(0)(0),
IsEmpty_ch13(0)   => o_outvar(0)(1),
IsEmpty_ch14(0)   => o_outvar(0)(2),
IsEmpty_ch15(0)   => o_outvar(0)(3),
IsEmpty_ch16(0)   => o_outvar(0)(4),
IsEmpty_ch2(0)   => o_outvar(0)(5),
IsEmpty_ch3(0)   => o_outvar(0)(6),
IsEmpty_ch4(0)   => o_outvar(0)(7),
IsFull_ch1(0)   => o_outvar(0)(8),
IsFull_ch13(0)   => o_outvar(0)(9),
IsFull_ch14(0)   => o_outvar(0)(10),
IsFull_ch15(0)   => o_outvar(0)(11),
IsFull_ch16(0)   => o_outvar(0)(12),
IsFull_ch2(0)   => o_outvar(0)(13),
IsFull_ch3(0)   => o_outvar(0)(14),
IsFull_ch4(0)   => o_outvar(0)(15),
DataUpload_ch1   => o_outvar(1)(31 downto 0),
DataUpload_ch2   => o_outvar(2)(31 downto 0),
DataUpload_ch3   => o_outvar(3)(31 downto 0),
DataUpload_ch4   => o_outvar(4)(31 downto 0),
NumOfWords_ch1   => o_outvar(5)(31 downto 0),
NumOfWords_ch13   => o_outvar(6)(31 downto 0),
NumOfWords_ch14   => o_outvar(7)(31 downto 0),
NumOfWords_ch15   => o_outvar(8)(31 downto 0),
NumOfWords_ch16   => o_outvar(9)(31 downto 0),
NumOfWords_ch2   => o_outvar(10)(31 downto 0),
NumOfWords_ch3   => o_outvar(11)(31 downto 0),
NumOfWords_ch4   => o_outvar(12)(31 downto 0)
);
  -- @CMD=PORTMAPEND
END rtl;
