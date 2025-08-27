-- Copyright (c) 2025 Vector Informatik GmbH

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

-- The VT2710 Sensor Module supports various protocols.
-- Also five debug LEDs are available.

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

LIBRARY work;
USE work.LibraryBase.ALL;


ENTITY User IS
  PORT (

    -- @CMD=SYSVARSTART
    DataBit_CRC8_ch0 : in std_logic_vector(0 downto 0);
    DataBitValid_CRC8_ch0 : in std_logic_vector(0 downto 0);
    SetInitValue_CRC8_ch0 : in std_logic_vector(0 downto 0);
    CRC8_ch0 : out std_logic_vector(31 downto 0) := (others => '0');
    DataBit_CRC32_ch0 : in std_logic_vector(0 downto 0);
    DataBitValid_CRC32_ch0 : in std_logic_vector(0 downto 0);
    SetInitValue_CRC32_ch0 : in std_logic_vector(0 downto 0);
    CRC32_ch0 : out std_logic_vector(31 downto 0) := (others => '0');
    -- @CMD=SYSVAREND

    -- @CMD=TIMESTAMPSTART
    -- @CMD=TIMESTAMPEND

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

    clk      : IN std_logic;            -- Clock.clk
    areset   : IN std_logic;            -- .reset
    h_areset : IN std_logic;

    in_con1_dio1          : IN std_logic_vector(0 DOWNTO 0);  -- Connector 1, pin 9
    in_con1_dio2_rs232_rx : IN std_logic_vector(0 DOWNTO 0);  -- Connector 1, pin 8
    in_con1_dio3          : IN std_logic_vector(0 DOWNTO 0);  -- Connector 1, pin 7
    in_con1_dio4_rs485_rx : IN std_logic_vector(0 DOWNTO 0);  -- Connector 1, pin 6
    in_con1_dio5          : IN std_logic_vector(0 DOWNTO 0);  -- Connector 1, pin 5
    in_con1_dio6          : IN std_logic_vector(0 DOWNTO 0);  -- Connector 1, pin 4
    in_con1_dio7_i2c_sda  : IN std_logic_vector(0 DOWNTO 0);  -- Connector 1, pin 3
    in_con1_dio8_i2c_scl  : IN std_logic_vector(0 DOWNTO 0);  -- Connector 1, pin 2

    out_con1_dio1_rs232_tx : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 9
    out_con1_dio2          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 8
    out_con1_dio3_rs485_tx : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 7
    out_con1_dio4          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 6
    out_con1_dio5_rs485_oe : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 5
    out_con1_dio6          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 4
    out_con1_dio7_i2c_sda  : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 3
    out_con1_dio8_i2c_scl  : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 2

    in_con2_dio1          : IN std_logic_vector(0 DOWNTO 0);  -- Connector 2, pin 9
    in_con2_dio2_rs232_rx : IN std_logic_vector(0 DOWNTO 0);  -- Connector 2, pin 8
    in_con2_dio3          : IN std_logic_vector(0 DOWNTO 0);  -- Connector 2, pin 7
    in_con2_dio4_rs485_rx : IN std_logic_vector(0 DOWNTO 0);  -- Connector 2, pin 6
    in_con2_dio5          : IN std_logic_vector(0 DOWNTO 0);  -- Connector 2, pin 5
    in_con2_dio6          : IN std_logic_vector(0 DOWNTO 0);  -- Connector 2, pin 4
    in_con2_dio7_i2c_sda  : IN std_logic_vector(0 DOWNTO 0);  -- Connector 2, pin 3
    in_con2_dio8_i2c_scl  : IN std_logic_vector(0 DOWNTO 0);  -- Connector 2, pin 2

    out_con2_dio1_rs232_tx : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 9
    out_con2_dio2          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 8
    out_con2_dio3_rs485_tx : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 7
    out_con2_dio4          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 6
    out_con2_dio5_rs485_oe : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 5
    out_con2_dio6          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 4
    out_con2_dio7_i2c_sda  : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 3
    out_con2_dio8_i2c_scl  : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 2

    in_lvds_1 : IN std_logic_vector(0 DOWNTO 0);  -- lvds channel 1 input
    in_lvds_2 : IN std_logic_vector(0 DOWNTO 0);  -- lvds channel 2 input

    out_lvds_1 : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- lvds channel 1 output
    out_lvds_2 : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- lvds channel 2 output

    in_invar_update : IN std_logic;                      -- invar update notification
    in_timestamp    : IN std_logic_vector(63 DOWNTO 0);  -- current module time

    debug_LED_1 : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- debug LED 1
    debug_LED_2 : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- debug LED 2
    debug_LED_3 : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- debug LED 3
    debug_LED_4 : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- debug LED 4
    debug_LED_5 : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0')   -- debug LED 5
    );
END;

ARCHITECTURE rtl OF User IS

  TYPE t_CRC8 IS RECORD
    Poly   : std_logic_vector(7 DOWNTO 0);
    Init   : std_logic_vector(7 DOWNTO 0);
    XOROut : std_logic_vector(7 DOWNTO 0);
  END RECORD;
  --
  CONSTANT c_CRC8 : t_CRC8 := (
    Poly   => 8x"31",
    Init   => 8x"FF",
    XOROut => 8x"00"
    );
  --
  TYPE t_CRC32 IS RECORD
    Poly   : std_logic_vector(31 DOWNTO 0);
    Init   : std_logic_vector(31 DOWNTO 0);
    XOROut : std_logic_vector(31 DOWNTO 0);
  END RECORD;
  --
  CONSTANT c_CRC32 : t_CRC32 := (
    Poly   => 32x"04C11DB7",
    Init   => 32x"FFFFFFFF",
    XOROut => 32x"FFFFFFFF"
    );
  --
  TYPE t_CRC8_Template IS RECORD
    DataBit      : std_logic;
    DataBitValid : std_logic;
    SetInitValue : std_logic;
    CRC          : std_logic_vector(c_CRC8.Poly'range);
    CRCValid     : std_logic;
  END RECORD;
  --
  SIGNAL s_CRC8 : t_CRC8_Template := (
    DataBit      => '0',
    DataBitValid => '0',
    SetInitValue => '0',
    CRC          => (OTHERS => '0'),
    CRCValid     => '0'
    );
  --
  TYPE t_CRC32_Template IS RECORD
    DataBit      : std_logic;
    DataBitValid : std_logic;
    SetInitValue : std_logic;
    CRC          : std_logic_vector(c_CRC32.Poly'range);
    CRCValid     : std_logic;
  END RECORD;
  --
  SIGNAL s_CRC32 : t_CRC32_Template := (
    DataBit      => '0',
    DataBitValid => '0',
    SetInitValue => '0',
    CRC          => (OTHERS => '0'),
    CRCValid     => '0'
    );
  --
  TYPE t_EdgeDetection IS RECORD
    DataBitValid        : std_logic;
    DataBitValid_Vector : std_logic_vector(1 DOWNTO 0);
    SetInitValue        : std_logic;
    SetInitValue_Vector : std_logic_vector(1 DOWNTO 0);
    DataBit_Vector      : std_logic_vector(1 DOWNTO 0);
  END RECORD;
  --
  TYPE t_EdgeDetection_Array IS ARRAY (1 TO 2) OF t_EdgeDetection;  -- 1: 1-Wire; 2: Ethernet
  --
  SIGNAL s_EdgeDetection : t_EdgeDetection_Array := (
    OTHERS                => (
      DataBitValid        => '0',
      DataBitValid_Vector => (OTHERS => '0'),
      SetInitValue        => '0',
      SetInitValue_Vector => (OTHERS => '0'),
      DataBit_Vector      => (OTHERS => '0')
      ));



BEGIN

--
-- debug
--
  proc_Debug : PROCESS (ALL)
  BEGIN  -- PROCESS proc_Debug
    debug_LED_1 <= DataBitValid_CRC8_ch0;
    debug_LED_2 <= DataBit_CRC8_ch0;
  END PROCESS proc_Debug;
--
-- debug
--



  proc_EdgeDetection : PROCESS (ALL)
  BEGIN  -- PROCESS proc_EdgeDetection
    IF (areset = c_reset_active) THEN                                  -- asynchronous reset (active package defined)
      NULL;
    ELSIF (clk'event AND clk = '1') THEN                               -- rising clock edge
      --
      -- 1. polynom
      --
      s_EdgeDetection(1).DataBitValid        <= '0';
      s_EdgeDetection(1).SetInitValue        <= '0';
      --
      s_EdgeDetection(1).DataBitValid_Vector <= s_EdgeDetection(1).DataBitValid_Vector(0) & DataBitValid_CRC8_ch0(0);
      s_EdgeDetection(1).SetInitValue_Vector <= s_EdgeDetection(1).SetInitValue_Vector(0) & SetInitValue_CRC8_ch0(0);
      s_EdgeDetection(1).DataBit_Vector      <= s_EdgeDetection(1).DataBit_Vector(0) & DataBit_CRC8_ch0;
      --
      IF (s_EdgeDetection(1).DataBitValid_Vector = c_RisingEdge) THEN  -- rising edge
        s_EdgeDetection(1).DataBitValid <= '1';
      END IF;
      --
      IF (s_EdgeDetection(1).SetInitValue_Vector = c_RisingEdge) THEN  -- rising edge
        s_EdgeDetection(1).SetInitValue <= '1';
      END IF;
      --
      -- 2. polynom
      --
      s_EdgeDetection(2).DataBitValid        <= '0';
      s_EdgeDetection(2).SetInitValue        <= '0';
      --
      s_EdgeDetection(2).DataBitValid_Vector <= s_EdgeDetection(2).DataBitValid_Vector(0) & DataBitValid_CRC32_ch0(0);
      s_EdgeDetection(2).SetInitValue_Vector <= s_EdgeDetection(2).SetInitValue_Vector(0) & SetInitValue_CRC32_ch0(0);
      s_EdgeDetection(2).DataBit_Vector      <= s_EdgeDetection(2).DataBit_Vector(0) & DataBit_CRC32_ch0;
      --
      IF (s_EdgeDetection(2).DataBitValid_Vector = c_RisingEdge) THEN  -- rising edge
        s_EdgeDetection(2).DataBitValid <= '1';
      END IF;
      --
      IF (s_EdgeDetection(2).SetInitValue_Vector = c_RisingEdge) THEN  -- rising edge
        s_EdgeDetection(2).SetInitValue <= '1';
      END IF;
    END IF;
  END PROCESS proc_EdgeDetection;

  --

  proc_CRCTemplate : PROCESS (ALL)
  BEGIN  -- PROCESS proc_CRCTemplate
    IF (areset = c_reset_active) THEN     -- asynchronous reset (active package defined)
      NULL;
    ELSIF (clk'event AND clk = '1') THEN  -- rising clock edge
      --
      -- CRC: 1-Wire
      s_CRC8.DataBit                <= s_EdgeDetection(1).DataBit_Vector(s_EdgeDetection(1).DataBit_Vector'high);
      s_CRC8.DataBitValid           <= s_EdgeDetection(1).DataBitValid;
      s_CRC8.SetInitValue           <= s_EdgeDetection(1).SetInitValue;
      CRC8_ch0(c_CRC8.Poly'range)   <= s_CRC8.CRC;
      --
      -- CRC: Ethernet
      s_CRC32.DataBit               <= s_EdgeDetection(2).DataBit_Vector(s_EdgeDetection(2).DataBit_Vector'high);
      s_CRC32.DataBitValid          <= s_EdgeDetection(2).DataBitValid;
      s_CRC32.SetInitValue          <= s_EdgeDetection(2).SetInitValue;
      CRC32_ch0(c_CRC32.Poly'range) <= s_CRC32.CRC;
    END IF;
  END PROCESS proc_CRCTemplate;

  --
  --
  --

  inst_CRC8_Template : ENTITY work.CRCTemplate
    GENERIC MAP (
      g_Poly   => c_CRC8.Poly,
      g_Init   => c_CRC8.Init,
      g_XOROut => c_CRC8.XOROut
      )
    PORT MAP (
      i_clock        => clk,
      i_reset        => areset,
      i_DataBit      => s_CRC8.DataBit,
      i_DataBitValid => s_CRC8.DataBitValid,
      i_SetInitValue => s_CRC8.SetInitValue,
      o_CRC          => s_CRC8.CRC,
      o_CRCValid     => s_CRC8.CRCValid
      );

  --

  inst_CRC32_Template : ENTITY work.CRCTemplate
    GENERIC MAP (
      g_Poly   => c_CRC32.Poly,
      g_Init   => c_CRC32.Init,
      g_XOROut => c_CRC32.XOROut
      )
    PORT MAP (
      i_clock        => clk,
      i_reset        => areset,
      i_DataBit      => s_CRC32.DataBit,
      i_DataBitValid => s_CRC32.DataBitValid,
      i_SetInitValue => s_CRC32.SetInitValue,
      o_CRC          => s_CRC32.CRC,
      o_CRCValid     => s_CRC32.CRCValid
      );

END ARCHITECTURE rtl;  -- of  User
