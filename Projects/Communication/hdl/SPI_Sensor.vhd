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


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.NUMERIC_STD.ALL;

LIBRARY work;
USE work.LibraryBase.ALL;


ENTITY SPI_Sensor IS

  GENERIC (
    g_DataWidth    : natural                := 8;
    g_AddressWidth : natural                := 7;                                                                    -- without the read/write bit
    g_Idle         : std_logic              := '1';                                                                  -- tri-state
    g_nCS          : std_logic              := '0';                                                                  -- chip select active value
    g_Read         : std_logic              := '1';                                                                  -- 1: read; 0: write
    g_MOSIData     : t_ArrayNatural(1 TO 3) := (1, 7, 8);                                                            -- width if the MOSI data
    g_MISOData     : t_ArrayNatural(1 TO 3) := (1, 7, 8)                                                             -- width if the MISO data
    );
  PORT (
    i_clock         : IN  std_logic;
    i_reset         : IN  std_logic;
    --
    i_CPOL          : IN  std_logic;
    i_CPHA          : IN  std_logic;
    i_nCS           : IN  std_logic;
    i_SCLK          : IN  std_logic;
    -- MOSI
    i_MOSI          : IN  std_logic;
    o_DataMOSI      : OUT t_ArrayVector(g_MOSIData'range)(g_DataWidth - 1 DOWNTO 0) := (OTHERS => (OTHERS => '0'));  -- width = max. for all signals of the array; received data
    o_DataMOSIValid : OUT t_ArrayLogic(g_MISOData'range)                            := (OTHERS => '0');              -- signals that a MOSI data word was received
    -- MISO
    i_DataMISO      : IN  t_ArrayVector(g_MISOData'range)(g_DataWidth - 1 DOWNTO 0);                                 -- width = max. for all signals of the array; transmit data
    o_DataMISOSend  : OUT t_ArrayLogic(g_MISOData'range)                            := (OTHERS => '0');              -- signals taht a specific data word was just send
    o_MISO          : OUT std_logic                                                 := g_Idle;
    -- error
    i_ResetError    : IN  std_logic;
    o_ErrorCode     : OUT std_logic_vector(7 DOWNTO 0)                              := (OTHERS => '0')
    );

END SPI_Sensor;


ARCHITECTURE rtl OF SPI_Sensor IS

  TYPE t_InSignal IS RECORD
    ReceiveDataBit : std_logic;
    ReceiveValid   : std_logic;
    SCLKVector     : std_logic_vector(1 DOWNTO 0);
    SendValid      : std_logic;
  END RECORD;
  --
  SIGNAL s_InSignal : t_InSignal := (
    ReceiveDataBit => '0',
    ReceiveValid   => '0',
    SCLKVector     => (OTHERS => '0'),
    SendValid      => '0');
  --
  TYPE t_MOSI_FSM IS RECORD
    BitCounter    : natural;
    ShiftRegister : std_logic_vector(g_DataWidth - 1 DOWNTO 0);
    State         : natural RANGE 0 TO g_MOSIData'high;                             -- 0: idle
  END RECORD;
  --
  SIGNAL s_MOSI_FSM : t_MOSI_FSM := (
    BitCounter    => 0,
    ShiftRegister => (OTHERS => '0'),
    State         => o_DataMOSI'low);
  --
  TYPE t_MISO_FSM IS RECORD
    BitCounter    : natural;
    ShiftRegister : std_logic_vector(g_DataWidth - 1 DOWNTO 0);
    State         : natural RANGE 0 TO g_MISOData'high;                             -- 0: idle
  END RECORD;
  --
  SIGNAL s_MISO_FSM : t_MISO_FSM := (
    BitCounter    => 0,
    ShiftRegister => (OTHERS => '0'),
    State         => i_DataMISO'low);
  --
  -- receive -> sample incoming data (MOSI) on receive valid
  PROCEDURE p_MOSI_FSM (
    SIGNAL ReceiveValid   : IN    std_logic;
    SIGNAL ReceiveDataBit : IN    std_logic;
    SIGNAL CurrentState   : INOUT natural RANGE 0 TO g_MOSIData'high;
    CONSTANT NextState    : IN    natural RANGE 0 TO g_MOSIData'high;
    SIGNAL Data           : OUT   std_logic_vector(g_DataWidth - 1 DOWNTO 0);
    SIGNAL DataValid      : OUT   std_logic;
    SIGNAL BitCounter     : INOUT natural;
    SIGNAL ShiftRegister  : INOUT std_logic_vector(g_DataWidth - 1 DOWNTO 0))
  IS
  BEGIN  -- p_MOSI_FSM
    IF (ReceiveValid) THEN
      IF (BitCounter >= g_MOSIData(CurrentState) - 1) THEN                          -- last bit
        Data          <= ShiftRegister(g_DataWidth - 2 DOWNTO 0) & ReceiveDataBit;  -- current bit not yet in the shift register
        DataValid     <= '1';                                                       -- reset to '0' in the process
        ShiftRegister <= (OTHERS => '0');                                           -- reset shift register after data transfer instead o shifting a new bit into it
        BitCounter    <= 0;
        CurrentState  <= NextState;
      ELSE                                                                          -- bits remaininng
        ShiftRegister <= ShiftRegister(g_DataWidth - 2 DOWNTO 0) & ReceiveDataBit;
        BitCounter    <= BitCounter + 1;
      END IF;
    END IF;
  END p_MOSI_FSM;
  --
  -- transmit -> change outgoing data (MISO) on send valid
  PROCEDURE p_MISO_FSM(
    SIGNAL SendValid     : IN    std_logic;
    SIGNAL SendDataBit   : OUT   std_logic;
    SIGNAL CurrentState  : INOUT natural RANGE 0 TO g_MISOData'high;
    CONSTANT NextState   : IN    natural RANGE 0 TO g_MISOData'high;
    SIGNAL NextData      : IN    std_logic_vector(g_DataWidth - 1 DOWNTO 0);
    SIGNAL DataSend      : OUT   std_logic;
    SIGNAL BitCounter    : INOUT natural;
    SIGNAL ShiftRegister : INOUT std_logic_vector(g_DataWidth - 1 DOWNTO 0))
  IS
  BEGIN  -- p_MISO_FSM
    IF (SendValid) THEN
      IF (BitCounter >= g_MISOData(CurrentState) - 1) THEN                          -- last bit
        DataSend      <= '1';                                                       -- reset to '0' in the process
        ShiftRegister <= NextData;
        BitCounter    <= 0;
        CurrentState  <= NextState;
      ELSE                                                                          -- bits remaining
        ShiftRegister <= ShiftRegister(g_DataWidth - 2 DOWNTO 0) & g_Idle;          -- shift only when it's not the last databit, otherwise it will be set by 'BitCounter = 0' above
        BitCounter    <= BitCounter + 1;                                            -- increment counter with each new output bit unless it's the last of a data word
      END IF;
    END IF;
    --
    SendDataBit <= ShiftRegister(g_MISOData(CurrentState) - 1);                     -- output the real MSB based on the Generics settings
  END p_MISO_FSM;


BEGIN  -- rtl

  -- create a data valid signal based on SCLK, POL and PHA
  proc_InSignal : PROCESS (i_clock, i_reset)
  BEGIN  -- PROCESS proc_InSignal
    IF (i_reset = c_reset_active) THEN            -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN  -- rising clock edge
      s_InSignal.ReceiveValid <= '0';
      s_InSignal.SendValid    <= '0';
      s_InSignal.SCLKVector   <= s_InSignal.SCLKVector(0) & i_SCLK;
      --
      -- mode 0: Pol 0 & Pha 0
      -- mode 3: Pol 1 & Pha 1
      -- receive: rising edge of SCLK
      -- send: falling edge of SCLK
      IF (i_CPOL = i_CPHA) THEN
        IF (s_InSignal.SCLKVector = c_RisingEdge) THEN
          s_InSignal.ReceiveDataBit <= i_MOSI;
          s_InSignal.ReceiveValid   <= '1';
        ELSIF (s_InSignal.SCLKVector = c_FallingEdge) THEN
          s_InSignal.SendValid <= '1';
        END IF;
      -- mode 1: Pol 0 & Pha 1
      -- mode 2: Pol 1 & Pha 0
      -- receive: falling edge of SCLK
      -- send: rising edge of SCLK
      ELSIF (i_CPOL /= i_CPHA) THEN
        IF (s_InSignal.SCLKVector = c_FallingEdge) THEN
          s_InSignal.ReceiveDataBit <= i_MOSI;
          s_InSignal.ReceiveValid   <= '1';
        ELSIF (s_InSignal.SCLKVector = c_RisingEdge) THEN
          s_InSignal.SendValid <= '1';
        END IF;
      END IF;
    END IF;
  END PROCESS proc_InSignal;

  --

  -- receiver FSM
  proc_MOSI_FSM : PROCESS (i_clock, i_reset)
  BEGIN  -- PROCESS proc_MOSI_FSM
    IF (i_reset = c_reset_active) THEN            -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN  -- rising clock edge
      o_DataMOSIValid <= (OTHERS => '0');         -- only set to '1' for one FPGA clock in the procedure when the data is complete
      --
      CASE s_MOSI_FSM.State IS
        WHEN 0 =>
          IF (i_nCS = g_nCS) THEN                 -- sensor active
            s_MOSI_FSM.State <= 1;
          END IF;
        WHEN 1      => p_MOSI_FSM(s_InSignal.ReceiveValid, s_InSignal.ReceiveDataBit, s_MOSI_FSM.State, 2, o_DataMOSI(1), o_DataMOSIValid(1), s_MOSI_FSM.BitCounter, s_MOSI_FSM.ShiftRegister);
        WHEN 2      => p_MOSI_FSM(s_InSignal.ReceiveValid, s_InSignal.ReceiveDataBit, s_MOSI_FSM.State, 3, o_DataMOSI(2), o_DataMOSIValid(2), s_MOSI_FSM.BitCounter, s_MOSI_FSM.ShiftRegister);
        WHEN 3      => p_MOSI_FSM(s_InSignal.ReceiveValid, s_InSignal.ReceiveDataBit, s_MOSI_FSM.State, 3, o_DataMOSI(3), o_DataMOSIValid(3), s_MOSI_FSM.BitCounter, s_MOSI_FSM.ShiftRegister);
        WHEN OTHERS => s_MOSI_FSM.State <= 0;
      END CASE;
      --
      IF (i_nCS = NOT g_nCS) THEN                 -- sensor not active
        s_MOSI_FSM.State <= 0;
      END IF;
    END IF;
  END PROCESS proc_MOSI_FSM;

  --

  -- tansmitter FSM
  proc_MISO_FSM : PROCESS (i_clock, i_reset)
    VARIABLE v_ShiftRegister : std_logic_vector(g_DataWidth - 1 DOWNTO 0) := (OTHERS => '0');
  BEGIN  -- PROCESS proc_MISO_FSM
    IF (i_reset = c_reset_active) THEN                  -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN        -- rising clock edge
      o_MISO         <= g_Idle;
      o_DataMISOSend <= (OTHERS => '0');
      --
      CASE s_MISO_FSM.State IS
        WHEN 0 =>
          IF (i_nCS = g_nCS) THEN
            s_MISO_FSM.ShiftRegister <= i_DataMISO(1);  -- load first data word into shift register
            s_MISO_FSM.State         <= 1;
          END IF;
        WHEN 1      => p_MISO_FSM(s_InSignal.SendValid, o_MISO, s_MISO_FSM.State, 2, i_DataMISO(2), o_DataMISOSend(1), s_MISO_FSM.BitCounter, s_MISO_FSM.ShiftRegister);
        WHEN 2      => p_MISO_FSM(s_InSignal.SendValid, o_MISO, s_MISO_FSM.State, 3, i_DataMISO(3), o_DataMISOSend(2), s_MISO_FSM.BitCounter, s_MISO_FSM.ShiftRegister);
        WHEN 3      => p_MISO_FSM(s_InSignal.SendValid, o_MISO, s_MISO_FSM.State, 3, i_DataMISO(3), o_DataMISOSend(3), s_MISO_FSM.BitCounter, s_MISO_FSM.ShiftRegister);
        WHEN OTHERS => s_MISO_FSM.State <= 0;
      END CASE;
      --
      IF (i_nCS = NOT g_nCS) THEN
        s_MISO_FSM.State <= 0;
      END IF;
    END IF;
  END PROCESS proc_MISO_FSM;

END rtl;

