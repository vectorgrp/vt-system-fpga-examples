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
END;

ARCHITECTURE rtl OF User IS

  CONSTANT c_FilterCycles : natural                                       := 8;
  CONSTANT c_FilterHigh   : std_logic_vector(c_FilterCycles - 1 DOWNTO 0) := (OTHERS => '1');
  CONSTANT c_FilterLow    : std_logic_vector(c_FilterCycles - 1 DOWNTO 0) := (OTHERS => '0');
  --
  TYPE t_Filter IS RECORD
    SCLVector : std_logic_vector(c_FilterCycles - 1 DOWNTO 0);
    SDAVector : std_logic_vector(c_FilterCycles - 1 DOWNTO 0);
    SCL       : std_logic;
    SDA       : std_logic;
  END RECORD;
  --
  SIGNAL s_Filter : t_Filter := (
    SCLVector => c_FilterHigh,
    SDAVector => c_FilterHigh,
    SCL       => '1',
    SDA       => '1');
  --
  --
  --
  CONSTANT c_NumOfSensors7Bit  : natural := 4;
  CONSTANT c_NumOfSensors10Bit : natural := 1;
  SUBTYPE c_NumOfSensors7Bit_Range IS natural RANGE 1 TO c_NumOfSensors7Bit;
  --
  TYPE t_I2CSensorGenerics7Bit IS RECORD
    DataWidth            : t_ArrayNatural(c_NumOfSensors7Bit_Range);
    RegisterAddressWidth : t_ArrayNatural(c_NumOfSensors7Bit_Range);
    ReadBit              : t_ArrayLogic(c_NumOfSensors7Bit_Range);
    MemInitFile          : t_ArrayString(c_NumOfSensors7Bit_Range);
  END RECORD;
  --
  TYPE t_I2CSensorGenerics10Bit IS RECORD
    DataWidth            : natural;
    RegisterAddressWidth : natural;
    ReadBit              : std_logic;
    MemInitFile          : string(1 TO 12);
  END RECORD;
  --
  TYPE t_I2CSensor7Bit IS RECORD
    SensorAddress   : t_ArrayVector(c_NumOfSensors7Bit_Range)(6 DOWNTO 0);
    SCL             : t_ArrayLogic(c_NumOfSensors7Bit_Range);
    SDAIn           : t_ArrayLogic(c_NumOfSensors7Bit_Range);
    ResetError      : t_ArrayLogic(c_NumOfSensors7Bit_Range);
    RegisterDataIn  : t_ArrayVector(c_NumOfSensors7Bit_Range)(15 DOWNTO 0);
    RegisterAddress : t_ArrayNatural(c_NumOfSensors7Bit_Range);
    RegisterDataOut : t_ArrayVector(c_NumOfSensors7Bit_Range)(15 DOWNTO 0);
    RegisterWren    : t_ArrayLogic(c_NumOfSensors7Bit_Range);
    SDAOut          : t_ArrayLogic(c_NumOfSensors7Bit_Range);
    ErrorCode       : t_ArrayVector(c_NumOfSensors7Bit_Range)(7 DOWNTO 0);
  END RECORD;
  --
  TYPE t_I2CSensor10Bit IS RECORD
    SensorAddress   : std_logic_vector(9 DOWNTO 0);
    SCL             : std_logic;
    SDAIn           : std_logic;
    ResetError      : std_logic;
    RegisterDataIn  : std_logic_vector(15 DOWNTO 0);
    RegisterAddress : natural;
    RegisterDataOut : std_logic_vector(15 DOWNTO 0);
    RegisterWren    : std_logic;
    SDAOut          : std_logic;
    ErrorCode       : std_logic_vector(7 DOWNTO 0);
  END RECORD;
  --
  TYPE t_CANoe7Bit IS RECORD
    WriteEnable : t_ArrayLogic(c_NumOfSensors7Bit_Range);
    DataIn      : t_ArrayVector(c_NumOfSensors7Bit_Range)(15 DOWNTO 0);
    Address     : t_ArrayNatural(c_NumOfSensors7Bit_Range);
    DataOut     : t_ArrayVector(c_NumOfSensors7Bit_Range)(15 DOWNTO 0);
  END RECORD;
  --
  TYPE t_CANoe10Bit IS RECORD
    WriteEnable : std_logic;
    DataIn      : std_logic_vector(15 DOWNTO 0);
    Address     : natural;
    DataOut     : std_logic_vector(15 DOWNTO 0);
  END RECORD;
  --
  --
  --
  CONSTANT c_I2CSensorGenerics7Bit : t_I2CSensorGenerics7Bit := (
    DataWidth            => (OTHERS => 16),
    RegisterAddressWidth => (OTHERS => 8),
    ReadBit              => (OTHERS => '1'),
    MemInitFile          => ("RAM_Sine.mif", "RAM_Zero.mif", "RAM_Zero.mif", "RAM_Zero.mif"));
  --
  CONSTANT c_I2CSensorGenerics10Bit : t_I2CSensorGenerics10Bit := (
    DataWidth            => 16,
    RegisterAddressWidth => 8,
    ReadBit              => '1',
    MemInitFile          => "RAM_Zero.mif");
  --
  SIGNAL s_I2CSensor7Bit : t_I2CSensor7Bit := (
    SensorAddress   => (7d"10", 7d"11", 7d"12", 7d"13"),
    SCL             => (OTHERS => '1'),
    SDAIn           => (OTHERS => '1'),
    ResetError      => (OTHERS => '0'),
    RegisterDataIn  => (OTHERS => (OTHERS => '0')),
    RegisterAddress => (OTHERS => 0),
    RegisterDataOut => (OTHERS => (OTHERS => '0')),
    RegisterWren    => (OTHERS => '0'),
    SDAOut          => (OTHERS => '1'),
    ErrorCode       => (OTHERS => (OTHERS => '0')));
  --
  SIGNAL s_I2CSensor10Bit : t_I2CSensor10Bit := (
    SensorAddress   => 10d"14",
    SCL             => '1',
    SDAIn           => '1',
    ResetError      => '0',
    RegisterDataIn  => (OTHERS => '0'),
    RegisterAddress => 0,
    RegisterDataOut => (OTHERS => '0'),
    RegisterWren    => '0',
    SDAOut          => '1',
    ErrorCode       => (OTHERS => '0'));
  --
  SIGNAL s_CANoe7Bit : t_CANoe7Bit := (
    WriteEnable => (OTHERS => '0'),
    DataIn      => (OTHERS => (OTHERS => '0')),
    Address     => (OTHERS => 0),
    DataOut     => (OTHERS => (OTHERS => '0')));
  --
  SIGNAL s_CANoe10Bit : t_CANoe10Bit := (
    WriteEnable => '0',
    DataIn      => (OTHERS => '0'),
    Address     => 0,
    DataOut     => (OTHERS => '0'));

BEGIN

  --
  -- filter for incoming signals
  --

  proc_Filter : PROCESS (ALL)
  BEGIN  -- PROCESS proc_Filter
    IF (areset = c_reset_active) THEN     -- asynchronous reset (active package defined)
      NULL;
    ELSIF (clk'event AND clk = '1') THEN  -- rising clock edge
      s_Filter.SCLVector <= s_Filter.SCLVector(s_Filter.SCLVector'length - 2 DOWNTO 0) & in_con1_dio8_i2c_scl(0);
      s_Filter.SDAVector <= s_Filter.SDAVector(s_Filter.SDAVector'length - 2 DOWNTO 0) & in_con1_dio7_i2c_sda(0);
      --
      -- SCL
      IF (s_Filter.SCLVector = c_FilterHigh) THEN
        s_Filter.SCL <= '1';
      ELSIF (s_Filter.SCLVector = c_FilterLow) THEN
        s_Filter.SCL <= '0';
      END IF;
      --
      -- SDA
      IF (s_Filter.SDAVector = c_FilterHigh) THEN
        s_Filter.SDA <= '1';
      ELSIF (s_Filter.SDAVector = c_FilterLow) THEN
        s_Filter.SDA <= '0';
      END IF;
    END IF;
  END PROCESS proc_Filter;

  --
  -- CANoe
  --

  proc_CANoeData : PROCESS (ALL)
  BEGIN  -- PROCESS proc_CANoeData
    s_I2CSensor7Bit.SensorAddress(1) <= SensorAddress_1_ch11(s_I2CSensor7Bit.SensorAddress(1)'range);
    s_I2CSensor7Bit.SensorAddress(2) <= SensorAddress_2_ch11(s_I2CSensor7Bit.SensorAddress(2)'range);
    s_I2CSensor7Bit.SensorAddress(3) <= SensorAddress_3_ch11(s_I2CSensor7Bit.SensorAddress(3)'range);
    s_I2CSensor7Bit.SensorAddress(4) <= SensorAddress_4_ch11(s_I2CSensor7Bit.SensorAddress(4)'range);
    s_I2CSensor10Bit.SensorAddress   <= SensorAddress_5_ch11(s_I2CSensor10Bit.SensorAddress'range);
    --
    s_CANoe7Bit.WriteEnable(1)       <= RegisterWren_1_ch11(0);
    s_CANoe7Bit.WriteEnable(2)       <= RegisterWren_2_ch11(0);
    s_CANoe7Bit.WriteEnable(3)       <= RegisterWren_3_ch11(0);
    s_CANoe7Bit.WriteEnable(4)       <= RegisterWren_4_ch11(0);
    s_CANoe10Bit.WriteEnable         <= RegisterWren_5_ch11(0);
    --
    s_CANoe7Bit.DataIn(1)            <= RegisterDataOut_1_ch11;
    s_CANoe7Bit.DataIn(2)            <= RegisterDataOut_2_ch11;
    s_CANoe7Bit.DataIn(3)            <= RegisterDataOut_3_ch11;
    s_CANoe7Bit.DataIn(4)            <= RegisterDataOut_4_ch11;
    s_CANoe10Bit.DataIn              <= RegisterDataOut_5_ch11;
    --
    s_CANoe7Bit.Address(1)           <= natural(to_integer(unsigned(RegisterAddress_1_ch11)));
    s_CANoe7Bit.Address(2)           <= natural(to_integer(unsigned(RegisterAddress_2_ch11)));
    s_CANoe7Bit.Address(3)           <= natural(to_integer(unsigned(RegisterAddress_3_ch11)));
    s_CANoe7Bit.Address(4)           <= natural(to_integer(unsigned(RegisterAddress_4_ch11)));
    s_CANoe10Bit.Address             <= natural(to_integer(unsigned(RegisterAddress_5_ch11)));
    --
    RegisterDataIn_1_ch11            <= s_CANoe7Bit.DataOut(1);
    RegisterDataIn_2_ch11            <= s_CANoe7Bit.DataOut(2);
    RegisterDataIn_3_ch11            <= s_CANoe7Bit.DataOut(3);
    RegisterDataIn_4_ch11            <= s_CANoe7Bit.DataOut(4);   
    RegisterDataIn_5_ch11            <= s_CANoe10Bit.DataOut;
  END PROCESS proc_CANoeData;

  --
  -- I2C signals
  --

  proc_I2CSignals : PROCESS (ALL)
  BEGIN  -- PROCESS proc_I2CSignals
    s_I2CSensor7Bit.SCL(1)   <= s_Filter.SCL;
    s_I2CSensor7Bit.SCL(2)   <= s_Filter.SCL;
    s_I2CSensor7Bit.SCL(3)   <= s_Filter.SCL;
    s_I2CSensor7Bit.SCL(4)   <= s_Filter.SCL;
    s_I2CSensor10Bit.SCL     <= s_Filter.SCL;
    --
    s_I2CSensor7Bit.SDAIn(1) <= s_Filter.SDA;
    s_I2CSensor7Bit.SDAIn(2) <= s_Filter.SDA;
    s_I2CSensor7Bit.SDAIn(3) <= s_Filter.SDA;
    s_I2CSensor7Bit.SDAIn(4) <= s_Filter.SDA;
    s_I2CSensor10Bit.SDAIn   <= s_Filter.SDA;
    --
    out_con1_dio7_i2c_sda(0) <= s_I2CSensor7Bit.SDAOut(1) AND
                                s_I2CSensor7Bit.SDAOut(2) AND
                                s_I2CSensor7Bit.SDAOut(3) AND
                                s_I2CSensor7Bit.SDAOut(4) AND
                                s_I2CSensor10Bit.SDAOut;  -- AND because low active
    --
    -- SCL out constant '1' because it's low active
    out_con1_dio8_i2c_scl(0) <= '1';
  END PROCESS proc_I2CSignals;

  --
  -- 7 bit address
  --

  Sensors7Bit : FOR Sensor IN c_NumOfSensors7Bit_Range GENERATE
    inst_I2C_7Bit : ENTITY work.I2C_7Bit
      GENERIC MAP (
        g_DataWidth            => c_I2CSensorGenerics7Bit.DataWidth(Sensor),
        g_RegisterAddressWidth => c_I2CSensorGenerics7Bit.RegisterAddressWidth(Sensor),
        g_Read                 => c_I2CSensorGenerics7Bit.ReadBit(Sensor)
        )
      PORT MAP (
        i_clock           => clk,
        i_reset           => areset,
        i_SensorAddress   => s_I2CSensor7Bit.SensorAddress(Sensor),
        i_SCL             => s_I2CSensor7Bit.SCL(Sensor),
        i_SDA             => s_I2CSensor7Bit.SDAIn(Sensor),
        i_ResetError      => s_I2CSensor7Bit.ResetError(Sensor),
        i_RegisterData    => s_I2CSensor7Bit.RegisterDataIn(Sensor),
        o_RegisterAddress => s_I2CSensor7Bit.RegisterAddress(Sensor),
        o_RegisterData    => s_I2CSensor7Bit.RegisterDataOut(Sensor),
        o_RegisterWren    => s_I2CSensor7Bit.RegisterWren(Sensor),
        o_SDA             => s_I2CSensor7Bit.SDAOut(Sensor),
        o_ErrorCode       => s_I2CSensor7Bit.ErrorCode(Sensor)
        );
    --
    inst_RAMTwoPort_7Bit : ENTITY work.RAMTwoPort
      GENERIC MAP (
        g_AddressWidth => c_I2CSensorGenerics7Bit.RegisterAddressWidth(Sensor),
        g_DataWidth    => c_I2CSensorGenerics7Bit.DataWidth(Sensor),
        g_MemInitFile  => c_I2CSensorGenerics7Bit.MemInitFile(Sensor)
        )
      PORT MAP (
        i_clock         => clk,
        i_reset         => areset,
        i_WriteEnable_a => s_I2CSensor7Bit.RegisterWren(Sensor),
        i_WriteEnable_b => s_CANoe7Bit.WriteEnable(Sensor),
        i_Data_a        => s_I2CSensor7Bit.RegisterDataOut(Sensor),
        i_Data_b        => s_CANoe7Bit.DataIn(Sensor),
        i_Address_a     => s_I2CSensor7Bit.RegisterAddress(Sensor),
        i_Address_b     => s_CANoe7Bit.Address(Sensor),
        o_Data_a        => s_I2CSensor7Bit.RegisterDataIn(Sensor),
        o_Data_b        => s_CANoe7Bit.DataOut(Sensor)
        );
  END GENERATE Sensors7Bit;

  --
  -- 10 bit address
  --

  inst_I2C_10Bit : ENTITY work.I2C_10Bit
    GENERIC MAP (
      g_DataWidth            => c_I2CSensorGenerics10Bit.DataWidth,
      g_RegisterAddressWidth => c_I2CSensorGenerics10Bit.RegisterAddressWidth,
      g_Read                 => c_I2CSensorGenerics10Bit.ReadBit)
    PORT MAP (
      i_clock           => clk,
      i_reset           => areset,
      i_SensorAddress   => s_I2CSensor10Bit.SensorAddress,
      i_SCL             => s_I2CSensor10Bit.SCL,
      i_SDA             => s_I2CSensor10Bit.SDAIn,
      i_ResetError      => s_I2CSensor10Bit.ResetError,
      i_RegisterData    => s_I2CSensor10Bit.RegisterDataIn,
      o_RegisterAddress => s_I2CSensor10Bit.RegisterAddress,
      o_RegisterData    => s_I2CSensor10Bit.RegisterDataOut,
      o_RegisterWren    => s_I2CSensor10Bit.RegisterWren,
      o_SDA             => s_I2CSensor10Bit.SDAOut,
      o_ErrorCode       => s_I2CSensor10Bit.ErrorCode
      );
  --
  inst_RAMTwoPort_10Bit : ENTITY work.RAMTwoPort
    GENERIC MAP (
      g_AddressWidth => c_I2CSensorGenerics10Bit.RegisterAddressWidth,
      g_DataWidth    => c_I2CSensorGenerics10Bit.DataWidth,
      g_MemInitFile  => c_I2CSensorGenerics10Bit.MemInitFile
      )
    PORT MAP (
      i_clock         => clk,
      i_reset         => areset,
      i_WriteEnable_a => s_I2CSensor10Bit.RegisterWren,
      i_WriteEnable_b => s_CANoe10Bit.WriteEnable,
      i_Data_a        => s_I2CSensor10Bit.RegisterDataOut,
      i_Data_b        => s_CANoe10Bit.DataIn,
      i_Address_a     => s_I2CSensor10Bit.RegisterAddress,
      i_Address_b     => s_CANoe10Bit.Address,
      o_Data_a        => s_I2CSensor10Bit.RegisterDataIn,
      o_Data_b        => s_CANoe10Bit.DataOut
      );

END ARCHITECTURE rtl;  -- of  User
