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
    CPOL_1_ch5 : in std_logic_vector(0 downto 0);
    CPOL_2_ch5 : in std_logic_vector(0 downto 0);
    CPOL_3_ch5 : in std_logic_vector(0 downto 0);
    CPOL_4_ch5 : in std_logic_vector(0 downto 0);
    CPOL_5_ch5 : in std_logic_vector(0 downto 0);
    CPHA_1_ch5 : in std_logic_vector(0 downto 0);
    CPHA_2_ch5 : in std_logic_vector(0 downto 0);
    CPHA_3_ch5 : in std_logic_vector(0 downto 0);
    CPHA_4_ch5 : in std_logic_vector(0 downto 0);
    CPHA_5_ch5 : in std_logic_vector(0 downto 0);
    RegisterDataIn_1_ch5 : out std_logic_vector(15 downto 0) := (others => '0');
    RegisterDataIn_2_ch5 : out std_logic_vector(15 downto 0) := (others => '0');
    RegisterDataIn_3_ch5 : out std_logic_vector(15 downto 0) := (others => '0');
    RegisterDataIn_4_ch5 : out std_logic_vector(15 downto 0) := (others => '0');
    RegisterDataIn_5_ch5 : out std_logic_vector(15 downto 0) := (others => '0');
    RegisterDataOut_1_ch5 : in std_logic_vector(15 downto 0);
    RegisterDataOut_2_ch5 : in std_logic_vector(15 downto 0);
    RegisterDataOut_3_ch5 : in std_logic_vector(15 downto 0);
    RegisterDataOut_4_ch5 : in std_logic_vector(15 downto 0);
    RegisterDataOut_5_ch5 : in std_logic_vector(15 downto 0);
    RegisterAddress_1_ch5 : in std_logic_vector(7 downto 0);
    RegisterAddress_2_ch5 : in std_logic_vector(7 downto 0);
    RegisterAddress_3_ch5 : in std_logic_vector(7 downto 0);
    RegisterAddress_4_ch5 : in std_logic_vector(7 downto 0);
    RegisterAddress_5_ch5 : in std_logic_vector(7 downto 0);
    RegisterWren_1_ch5 : in std_logic_vector(0 downto 0);
    RegisterWren_2_ch5 : in std_logic_vector(0 downto 0);
    RegisterWren_3_ch5 : in std_logic_vector(0 downto 0);
    RegisterWren_4_ch5 : in std_logic_vector(0 downto 0);
    RegisterWren_5_ch5 : in std_logic_vector(0 downto 0);
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

  -- a glitch filter is used to filter out glitches in incoming signals
  -- if all bits in the glitch filter are '0' the signal is '0'
  -- if all bits in the glitch filter are '1' the signal is '1'
  CONSTANT c_GlitchFilterSize : natural                                           := 3;
  CONSTANT c_GlitchFilterHigh : std_logic_vector(c_GlitchFilterSize - 1 DOWNTO 0) := (OTHERS => '1');  -- all '1'
  CONSTANT c_GlitchFilterLow  : std_logic_vector(c_GlitchFilterSize - 1 DOWNTO 0) := (OTHERS => '0');  -- all '0'
  --
  CONSTANT c_NumOfSensors     : natural                                           := 5;
  SUBTYPE c_NumOfSensorsRange IS natural RANGE 1 TO c_NumOfSensors;
  --
  TYPE t_GlitchFilter IS RECORD
    SCLK : std_logic;
    MOSI : std_logic;
    nCS  : std_logic;
  END RECORD;
  --
  TYPE t_GlitchFilterArray IS ARRAY (c_NumOfSensorsRange) OF t_GlitchFilter;
  --
  SIGNAL s_GlitchFilter : t_GlitchFilterArray := (
    OTHERS => (
      SCLK => '0',
      MOSI => '0',
      nCS  => '0'
      ));
  --
  --
  --
  TYPE t_SPISensorGenerics IS RECORD
    DataWidth    : natural;
    AddressWidth : natural;
    Idle         : std_logic;
    nCS          : std_logic;
    ReadBit      : std_logic;
    MOSIData     : t_ArrayNatural(1 TO 3);
    MISOData     : t_ArrayNatural(1 TO 3);
    MemInitFile  : string(1 TO 12);
  END RECORD;
  --
  TYPE t_SPISensorGenericsArray IS ARRAY (c_NumOfSensorsRange) OF t_SPISensorGenerics;
  --
  CONSTANT c_SPIGenerics : t_SPISensorGenericsArray := (
    1              => (
      DataWidth    => 16,
      AddressWidth => 7,
      Idle         => '1',
      nCS          => '0',
      ReadBit      => '1',
      MOSIData     => (1, 7, 16),
      MISOData     => (1, 7, 16),
      MemInitFile  => "RAM_Sine.mif"),
    OTHERS         => (
      DataWidth    => 16,
      AddressWidth => 7,
      Idle         => '1',
      nCS          => '0',
      ReadBit      => '1',
      MOSIData     => (1, 7, 16),
      MISOData     => (1, 7, 16),
      MemInitFile  => "RAM_Zero.mif")
    );
  --
  --
  --
  TYPE t_SPISensor IS RECORD
    CPOL       : std_logic;
    CPHA       : std_logic;
    nCS        : std_logic;
    SCLK       : std_logic;
    MOSI       : std_logic;
    MISO       : std_logic;
    ResetError : std_logic;
    ErrorCode  : std_logic_vector(7 DOWNTO 0);
  END RECORD;
  --
  TYPE t_SPISensorArray IS ARRAY (c_NumOfSensorsRange) OF t_SPISensor;
  --
  SIGNAL s_SPISensor : t_SPISensorArray := (
    OTHERS       => (
      CPOL       => '0',
      CPHA       => '0',
      nCS        => '0',
      SCLK       => '0',
      MOSI       => '1',
      MISO       => '1',
      ResetError => '0',
      ErrorCode  => (OTHERS => '0'))
    );
  --
  --
  --
  TYPE t_CANoe IS RECORD
    WriteEnable : std_logic;
    DataIn      : std_logic_vector(15 DOWNTO 0);                                                       -- CANoe -> register
    Address     : std_logic_vector(6 DOWNTO 0);
    DataOut     : std_logic_vector(15 DOWNTO 0);                                                       -- register -> CANoe
  END RECORD;
  --
  TYPE t_CANoeArray IS ARRAY (c_NumOfSensorsRange) OF t_CANoe;
  --
  SIGNAL s_CANoe : t_CANoeArray := (
    OTHERS        => (
      WriteEnable => '0',
      DataIn      => (OTHERS => '0'),
      Address     => (OTHERS => '0'),
      DataOut     => (OTHERS => '0'))
    );


BEGIN

  -- systemvariables used to communicate with CANoe
  proc_CANoeData : PROCESS (ALL)
  BEGIN  -- PROCESS proc_CANoeData
    IF (areset = c_reset_active) THEN     -- asynchronous reset (active package defined)
      NULL;
    ELSIF (clk'event AND clk = '1') THEN  -- rising clock edge
      -- CANoe -> Register
      s_CANoe(1).WriteEnable <= RegisterWren_1_ch5(0);
      s_CANoe(2).WriteEnable <= RegisterWren_2_ch5(0);
      s_CANoe(3).WriteEnable <= RegisterWren_3_ch5(0);
      s_CANoe(4).WriteEnable <= RegisterWren_4_ch5(0);
      s_CANoe(5).WriteEnable <= RegisterWren_5_ch5(0);
      --
      s_CANoe(1).DataIn      <= RegisterDataOut_1_ch5;
      s_CANoe(2).DataIn      <= RegisterDataOut_2_ch5;
      s_CANoe(3).DataIn      <= RegisterDataOut_3_ch5;
      s_CANoe(4).DataIn      <= RegisterDataOut_4_ch5;
      s_CANoe(5).DataIn      <= RegisterDataOut_5_ch5;
      --
      s_CANoe(1).Address     <= RegisterAddress_1_ch5(s_CANoe(1).Address'range);
      s_CANoe(2).Address     <= RegisterAddress_2_ch5(s_CANoe(2).Address'range);
      s_CANoe(3).Address     <= RegisterAddress_3_ch5(s_CANoe(3).Address'range);
      s_CANoe(4).Address     <= RegisterAddress_4_ch5(s_CANoe(4).Address'range);
      s_CANoe(5).Address     <= RegisterAddress_5_ch5(s_CANoe(5).Address'range);
      --
      RegisterDataIn_1_ch5   <= s_CANoe(1).DataOut;
      RegisterDataIn_2_ch5   <= s_CANoe(2).DataOut;
      RegisterDataIn_3_ch5   <= s_CANoe(3).DataOut;
      RegisterDataIn_4_ch5   <= s_CANoe(4).DataOut;
      RegisterDataIn_5_ch5   <= s_CANoe(5).DataOut;
    END IF;
  END PROCESS proc_CANoeData;

  --

  -- SPI signals
  proc_SPISignals : PROCESS (ALL)
  BEGIN  -- PROCESS proc_SPISignals
    IF (areset = c_reset_active) THEN                    -- asynchronous reset (active package defined)
      NULL;
    ELSIF (clk'event AND clk = '1') THEN                 -- rising clock edge
      -- input
      s_GlitchFilter(1).SCLK    <= in_con1_dio3(0);
      s_GlitchFilter(2).SCLK    <= in_con1_dio3(0);
      s_GlitchFilter(3).SCLK    <= in_con1_dio3(0);
      s_GlitchFilter(4).SCLK    <= in_con1_dio3(0);
      s_GlitchFilter(5).SCLK    <= in_con1_dio3(0);
      --
      s_GlitchFilter(1).nCS     <= in_con1_dio6(0);
      s_GlitchFilter(2).nCS     <= in_con1_dio1(0);
      s_GlitchFilter(3).nCS     <= in_con1_dio2_rs232_rx(0);
      s_GlitchFilter(4).nCS     <= in_con1_dio7_i2c_sda(0);
      s_GlitchFilter(5).nCS     <= in_con1_dio8_i2c_scl(0);
      --
      s_GlitchFilter(1).MOSI    <= in_con1_dio4_rs485_rx(0);
      s_GlitchFilter(2).MOSI    <= in_con1_dio4_rs485_rx(0);
      s_GlitchFilter(3).MOSI    <= in_con1_dio4_rs485_rx(0);
      s_GlitchFilter(4).MOSI    <= in_con1_dio4_rs485_rx(0);
      s_GlitchFilter(5).MOSI    <= in_con1_dio4_rs485_rx(0);
      --
      --
      -- output
      out_con1_dio5_rs485_oe(0) <= s_SPISensor(1).MISO AND
                                   s_SPISensor(2).MISO AND
                                   s_SPISensor(3).MISO AND
                                   s_SPISensor(4).MISO AND
                                   s_SPISensor(5).MISO;  -- AND because low active
    END IF;
  END PROCESS proc_SPISignals;

  --
  --
  --

  Sensors : FOR Sensor IN c_NumOfSensorsRange GENERATE
    proc_GlitchFilter : PROCESS (ALL)
      VARIABLE v_SCLKArray : std_logic_vector(c_GlitchFilterHigh'range) := (OTHERS => '0');
      VARIABLE v_MOSIArray : std_logic_vector(c_GlitchFilterHigh'range) := (OTHERS => '0');
      VARIABLE v_nCSArray  : std_logic_vector(c_GlitchFilterHigh'range) := (OTHERS => '0');
    BEGIN  -- PROCESS proc_GlitchFilter
      IF (areset = c_reset_active) THEN     -- asynchronous reset (active package defined)
        NULL;
      ELSIF (clk'event AND clk = '1') THEN  -- rising clock edge
        v_SCLKArray := v_SCLKArray(v_SCLKArray'length - 2 DOWNTO 0) & s_GlitchFilter(Sensor).SCLK;
        v_MOSIArray := v_MOSIArray(v_MOSIArray'length - 2 DOWNTO 0) & s_GlitchFilter(Sensor).MOSI;
        v_nCSArray  := v_nCSArray(v_nCSArray'length - 2 DOWNTO 0) & s_GlitchFilter(Sensor).nCS;
        --
        IF (v_SCLKArray = c_GlitchFilterHigh) THEN
          s_SPISensor(Sensor).SCLK <= '1';
        ELSIF (v_SCLKArray = c_GlitchFilterLow) THEN
          s_SPISensor(Sensor).SCLK <= '0';
        END IF;
        --
        IF (v_MOSIArray = c_GlitchFilterHigh) THEN
          s_SPISensor(Sensor).MOSI <= '1';
        ELSIF (v_MOSIArray = c_GlitchFilterLow) THEN
          s_SPISensor(Sensor).MOSI <= '0';
        END IF;
        --
        IF (v_nCSArray = c_GlitchFilterHigh) THEN
          s_SPISensor(Sensor).nCS <= '1';
        ELSIF (v_nCSArray = c_GlitchFilterLow) THEN
          s_SPISensor(Sensor).nCS <= '0';
        END IF;
      END IF;
    END PROCESS proc_GlitchFilter;
    --
    --
    --
    inst_SPI_Channel : ENTITY work.SPI_Channel
      GENERIC MAP (
        g_DataWidth    => c_SPIGenerics(Sensor).DataWidth,
        g_AddressWidth => c_SPIGenerics(Sensor).AddressWidth,
        g_Idle         => c_SPIGenerics(Sensor).Idle,
        g_nCS          => c_SPIGenerics(Sensor).nCS,
        g_Read         => c_SPIGenerics(Sensor).ReadBit,
        g_MOSIData     => c_SPIGenerics(Sensor).MOSIData,
        g_MISOData     => c_SPIGenerics(Sensor).MISOData,
        g_MemInitFile  => c_SPIGenerics(Sensor).MemInitFile
        )
      PORT MAP (
        i_clock           => clk,
        i_reset           => areset,
        i_CPOL            => s_SPISensor(Sensor).CPOL,
        i_CPHA            => s_SPISensor(Sensor).CPHA,
        i_nCS             => s_SPISensor(Sensor).nCS,
        i_SCLK            => s_SPISensor(Sensor).SCLK,
        i_MOSI            => s_SPISensor(Sensor).MOSI,
        o_MISO            => s_SPISensor(Sensor).MISO,
        i_ResetError      => s_SPISensor(Sensor).ResetError,
        o_ErrorCode       => s_SPISensor(Sensor).ErrorCode,
        i_RAM_WriteEnable => s_CANoe(Sensor).WriteEnable,
        i_RAM_Data        => s_CANoe(Sensor).Datain,
        i_RAM_Address     => s_CANoe(Sensor).Address,
        o_RAM_Data        => s_CANoe(Sensor).DataOut
        );
  END GENERATE Sensors;

END ARCHITECTURE rtl;  -- of  User
