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


ENTITY I2C_10Bit IS

  GENERIC (
    g_DataWidth            : natural   := 8;
    g_RegisterAddressWidth : natural   := 8;
    g_Read                 : std_logic := '1'  -- 1: read; 0: write
    );
  PORT (
    i_clock           : IN  std_logic;
    i_reset           : IN  std_logic;
    --
    i_SensorAddress   : IN  std_logic_vector(9 DOWNTO 0);
    i_SCL             : IN  std_logic;
    i_SDA             : IN  std_logic;
    i_ResetError      : IN  std_logic;
    -- register data
    i_RegisterData    : IN  std_logic_vector(g_DataWidth - 1 DOWNTO 0);
    o_RegisterAddress : OUT natural RANGE 0 TO 2 ** g_RegisterAddressWidth - 1 := 0;
    o_RegisterData    : OUT std_logic_vector(g_DataWidth - 1 DOWNTO 0)         := (OTHERS => '0');
    o_RegisterWren    : OUT std_logic                                          := '0';
    --
    o_SDA             : OUT std_logic                                          := '0';
    o_ErrorCode       : OUT std_logic_vector(7 DOWNTO 0)                       := (OTHERS => '0')
    );

END I2C_10Bit;


ARCHITECTURE rtl OF I2C_10Bit IS

  TYPE t_SCL IS RECORD
    InDataValid  : std_logic;
    OutDataValid : std_logic;
  END RECORD;
  --
  SIGNAL s_SCL : t_SCL := (
    InDataValid  => '0',
    OutDataValid => '0');
  --
  TYPE t_SDA IS RECORD
    InputShiftRegister  : std_logic_vector(g_DataWidth -1 DOWNTO 0);
    DataReceived        : std_logic;
    OutputShiftRegister : std_logic_vector(g_DataWidth - 1 DOWNTO 0);
  END RECORD;
  --
  SIGNAL s_SDA : t_SDA := (
    InputShiftRegister  => (OTHERS => '0'),
    DataReceived        => '0',
    OutputShiftRegister => (OTHERS => '0'));
  --
  TYPE t_FSMStates IS (IDLE, START, SENSORADDRESS_MSB, SENSORADDRESS_LSB, REGISTERADDRESS, WRITEDATA, READDATA);  -- used as variable
  --
  TYPE t_FSM IS RECORD
    State       : t_FSMStates;
    BitCounter  : integer;                                                                                        -- counter for data byte + ACK bit
    DataCounter : integer;                                                                                        -- used for counting the data bits
  END RECORD;
  --
  SIGNAL s_FSM : t_FSM := (
    State       => IDLE,
    BitCounter  => 0,
    DataCounter => 0);
  --
  TYPE t_States IS RECORD
    IsReadCommand    : std_logic;                                                                                 -- 1: read; 0: write
    IsThisSensor     : std_logic;
    SendIdle         : std_logic;                                                                                 -- send a high signal
    SendACK          : std_logic;                                                                                 -- send a low signal
    SendData         : std_logic;                                                                                 -- send the current data bit
    ReadFromRegister : std_logic;                                                                                 -- load data from the register into the output shift register
  END RECORD;
  --
  SIGNAL s_States : t_States := (
    IsReadCommand    => '0',
    IsThisSensor     => '0',
    SendIdle         => '0',
    SendACK          => '0',
    SendData         => '0',
    ReadFromRegister => '0');


BEGIN  -- rtl

  -- edge rcognition of SCL
  proc_SCL : PROCESS (i_clock, i_reset)
    VARIABLE v_SCLVector : std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');
  BEGIN  -- PROCESS proc_SCL
    IF (i_reset = c_reset_active) THEN            -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN  -- rising clock edge
      s_SCL.InDataValid  <= '0';
      s_SCL.OutDataValid <= '0';
      --
      v_SCLVector        := v_SCLVector(0) & i_SCL;
      --
      -- receive data
      IF (v_SCLVector = c_RisingEdge) THEN
        s_SCL.InDataValid <= '1';                 -- in data valid on the rising edge of SCL
      -- send data
      ELSIF (v_SCLVector = c_FallingEdge) THEN
        s_SCL.OutDataValid <= '1';                -- in data valid on the falling edge of SCL
      END IF;
    END IF;
  END PROCESS proc_SCL;

  --

  -- data input and output
  proc_SDA : PROCESS (i_clock, i_reset)
  BEGIN  -- PROCESS proc_SDA
    IF (i_reset = c_reset_active) THEN                                                                 -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                                                       -- rising clock edge
      s_SDA.DataReceived <= '0';
      --
      -- receive data
      IF (s_SCL.InDataValid = '1' AND s_FSM.BitCounter >= 0) THEN                                      -- during each state while the bit counter is >= 0;ACK (-1) are not shifted
        s_SDA.InputShiftRegister <= s_SDA.inputShiftRegister(s_SDA.InputShiftRegister'length - 2 DOWNTO 0) & i_SDA;
        s_SDA.DataReceived       <= '1';
      END IF;
      -- send data
      IF (s_States.SendIdle) THEN                                                                      -- high
        o_SDA <= '1';
      ELSIF (s_States.SendACK) THEN                                                                    -- low
        o_SDA <= '0';
      ELSIF (s_States.SendData) THEN                                                                   -- MSB is send
        o_SDA                     <= s_SDA.OutputShiftRegister(s_SDA.OutputShiftRegister'length - 1);  -- send MSB
        s_SDA.OutputShiftRegister <= s_SDA.OutputShiftRegister(s_SDA.OutputShiftRegister'length - 2 DOWNTO 0) & '1';
      END IF;
      -- load register data into output shift register
      IF (s_States.ReadFromRegister) THEN
        s_SDA.OutputShiftRegister <= i_RegisterData;
      END IF;
    END IF;
  END PROCESS proc_SDA;

  --

  -- state machine
  proc_FSM : PROCESS (i_clock, i_reset)
    VARIABLE v_SDAVector : std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');      -- for start and stop condition
  BEGIN  -- PROCESS proc_FSM
    IF (i_reset = c_reset_active) THEN                                           -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                                 -- rising clock edge
      v_SDAVector := v_SDAVector(0) & i_SDA;
      --
      IF (v_SDAVector = c_FallingEdge AND i_SCL = '1') THEN                      -- start condition
        s_FSM.State <= START;
      ELSIF (v_SDAVector = c_RisingEdge AND i_SCL = '1') THEN                    -- stop condition
        s_FSM.State <= IDLE;
      END IF;
      --
      --
      --
      CASE s_FSM.State IS
        WHEN IDLE =>
          NULL;
        --
        WHEN START =>
          s_FSM.BitCounter  <= 7;                                                -- it's always a byte structure (1 byte + ACK)
          s_FSM.DataCounter <= g_DataWidth - 1;
          -- next state
          IF (s_SCL.OutDataValid) THEN
            s_FSM.State <= SENSORADDRESS_MSB;
          END IF;
        --
        WHEN SENSORADDRESS_MSB =>
          IF (s_SCL.InDataValid) THEN
            -- bit counter
            s_FSM.BitCounter <= s_FSM.BitCounter - 1;
            -- next state
            IF (s_FSM.BitCounter = -1 AND s_States.IsThisSensor = '0') THEN      -- not this sensor
              s_FSM.State <= IDLE;
            ELSIF (s_FSM.BitCounter = -1 AND s_States.IsReadCommand = '1') THEN  -- only address bits 9 and 8 are checked for a read command
              s_FSM.BitCounter <= 7;
              s_FSM.State      <= READDATA;
            ELSIF (s_FSM.BitCounter = -1) THEN                                   -- write command
              s_FSM.BitCounter <= 7;
              s_FSM.State      <= SENSORADDRESS_LSB;
            END IF;
          END IF;
        --
        WHEN SENSORADDRESS_LSB =>
          IF (s_SCL.InDataValid) THEN
            -- bit counter
            s_FSM.BitCounter <= s_FSM.BitCounter - 1;
            -- next state
            IF (s_FSM.BitCounter = -1 AND s_States.IsThisSensor = '0') THEN      -- not this sensor
              s_FSM.State <= IDLE;
            ELSIF (s_FSM.BitCounter = -1 AND s_States.IsReadCommand = '1') THEN
              s_FSM.BitCounter <= 7;
              s_FSM.State      <= READDATA;
            ELSIF (s_FSM.BitCounter = -1 AND s_States.IsReadCommand = '0') THEN
              s_FSM.BitCounter <= 7;
              s_FSM.State      <= REGISTERADDRESS;
            END IF;
          END IF;
        --
        WHEN REGISTERADDRESS =>
          IF (s_SCL.InDataValid) THEN
            -- bit counter
            s_FSM.BitCounter <= s_FSM.BitCounter - 1;
            -- next state
            IF (s_FSM.BitCounter = -1) THEN
              s_FSM.BitCounter  <= 7;
              s_FSM.DataCounter <= g_DataWidth - 1;
              s_FSM.State       <= WRITEDATA;
            END IF;
          END IF;
        --
        WHEN WRITEDATA =>
          IF (s_SCL.InDataValid) THEN
            -- bit counter
            s_FSM.BitCounter <= s_FSM.BitCounter - 1;
            -- data counter
            IF (s_FSM.BitCounter >= 0 AND s_FSM.DataCounter > 0) THEN            -- still data bits left
              s_FSM.DataCounter <= s_FSM.DataCounter - 1;
            ELSIF (s_FSM.BitCounter >= 0 AND s_FSM.DataCounter = 0) THEN         -- no data bits left
              s_FSM.DataCounter <= g_DataWidth - 1;
            END IF;
            -- next state
            IF (s_FSM.BitCounter = -1 AND s_FSM.DataCounter > 0) THEN
              s_FSM.BitCounter <= 7;
              s_FSM.State      <= WRITEDATA;
            ELSIF (s_FSM.BitCounter = -1 AND s_FSM.DataCounter = 0) THEN         -- no data bits left
              s_FSM.BitCounter <= 7;
              s_FSM.State      <= WRITEDATA;
            END IF;
          END IF;
        --
        WHEN READDATA =>
          IF (s_SCL.InDataValid) THEN
            -- bit counter
            s_FSM.BitCounter <= s_FSM.BitCounter - 1;
            -- data counter
            IF (s_FSM.BitCounter >= 0 AND s_FSM.DataCounter > 0) THEN            -- still data bits left
              s_FSM.DataCounter <= s_FSM.DataCounter - 1;
            ELSIF (s_FSM.BitCounter >= 0 AND s_FSM.DataCounter = 0) THEN         -- no data bits left
              s_FSM.DataCounter <= g_DataWidth - 1;
            END IF;
            -- next state
            IF (s_FSM.BitCounter = -1 AND i_SDA = '0') THEN                      -- ACKM
              s_FSM.BitCounter <= 7;
              s_FSM.State      <= READDATA;
            ELSIF (s_FSM.BitCounter = -1 AND i_SDA = '1') THEN                   -- nACKM
              s_FSM.State <= IDLE;
            END IF;
          END IF;
        --
        WHEN OTHERS =>
          s_FSM.State <= IDLE;
      END CASE;
    END IF;
  END PROCESS proc_FSM;

  --

  -- used for the fifferent FSM states
  proc_States : PROCESS (i_clock, i_reset)
  BEGIN  -- PROCESS proc_States
    IF (i_reset = c_reset_active) THEN                                                                                                -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                                                                                      -- rising clock edge
      -- all commands are only set for 1 clock cycle
      s_States.SendIdle         <= '0';
      s_States.SendACK          <= '0';
      s_States.SendData         <= '0';
      s_States.ReadFromRegister <= '0';
      --
      -- idle
      --
      IF (s_FSM.State = IDLE) THEN
        s_States.SendIdle     <= '1';
        s_States.IsThisSensor <= '0';
      END IF;
      --
      -- start
      --
      IF (s_FSM.State = START) THEN
        s_States.SendIdle     <= '1';
        s_States.IsThisSensor <= '0';
      END IF;
      --
      -- sensoraddress MSB (1. byte)
      --
      IF (s_FSM.State = SENSORADDRESS_MSB) THEN
        IF(s_FSM.BitCounter = -1 AND s_SDA.DataReceived = '1') THEN
          -- check "11110" and address bits 9..8
          IF (s_SDA.InputShiftRegister(7 DOWNTO 1) = "11110" & i_SensorAddress(9 DOWNTO 8)) THEN                                      -- this sensor
            s_States.IsThisSensor <= '1';
          ELSE                                                                                                                        -- not this sensor
            s_States.IsThisSensor <= '0';
          END IF;
          -- check read/write bit
          IF (s_SDA.InputShiftRegister(0) = g_Read) THEN                                                                              -- read command
            s_States.IsReadCommand <= '1';
          ELSE                                                                                                                        -- write command
            s_States.IsReadCommand <= '0';
          END IF;
        END IF;
        -- output signal
        IF(s_SCL.OutDataValid = '1' AND s_FSM.BitCounter >= 0)THEN                                                                    -- idle
          s_States.SendIdle <= '1';
        ELSIF (s_SCL.OutDataValid = '1' AND s_FSM.BitCounter = -1) THEN                                                               -- ACK
          s_States.SendACK <= '1';
        END IF;
        --
        IF (s_SCL.InDataValid = '1' AND s_FSM.BitCounter = -1 AND s_States.IsThisSensor = '1' AND s_States.IsReadCommand = '1') THEN  -- read data from register for read command
          s_States.ReadFromRegister <= '1';
        END IF;
      END IF;
      --
      -- sensoraddress LSB (2. byte)
      --
      IF (s_FSM.State = SENSORADDRESS_LSB) THEN
        IF (s_FSM.BitCounter = -1 AND s_SDA.DataReceived = '1') THEN
          -- check address bits 7..0
          IF (s_SDA.InputShiftRegister(7 DOWNTO 0) = i_SensorAddress(7 DOWNTO 0)) THEN                                                -- still this sensor
            s_States.IsThisSensor <= '1';
          ELSE                                                                                                                        -- not this sensor
            s_States.IsThisSensor <= '0';
          END IF;
        END IF;
        -- output signal
        IF (s_SCL.OutDataValid = '1' AND s_FSM.BitCounter >= 0) THEN                                                                  -- idle
          s_States.SendIdle <= '1';
        ELSIF (s_SCL.OutDataValid = '1' AND s_FSM.BitCounter = -1) THEN                                                               -- ACK
          s_States.SendACK <= '1';
        END IF;
      END IF;
      --
      -- registeraddress
      --
      IF (s_FSM.State = REGISTERADDRESS) THEN
        IF(s_FSM.BitCounter = -1 AND s_SDA.DataReceived = '1') THEN
          o_RegisterAddress <= natural(to_integer(unsigned(s_SDA.InputShiftRegister(g_RegisterAddressWidth - 1 DOWNTO 0))));
        END IF;
        -- output signal
        IF(s_SCL.OutDataValid = '1' AND s_FSM.BitCounter >= 0)THEN                                                                    -- idle
          s_States.SendIdle <= '1';
        ELSIF (s_SCL.OutDataValid = '1' AND s_FSM.BitCounter = -1) THEN                                                               -- ACK
          s_States.SendACK <= '1';
        END IF;
      END IF;
      --
      -- writedata
      --
      o_RegisterWren <= '0';                                                                                                          -- only set in specific cycles
      --
      IF (s_FSM.State = WRITEDATA) THEN
        IF (s_FSM.BitCounter = -1 AND s_FSM.DataCounter = g_DataWidth - 1 AND s_SDA.DataReceived = '1') THEN                          -- write data into register
          o_RegisterData <= s_SDA.InputShiftRegister;
          o_RegisterWren <= '1';
          NULL;
        END IF;
        -- output signal
        IF (s_SCL.OutDataValid = '1' AND s_FSM.BitCounter >= 0) THEN                                                                  -- idle
          s_States.SendIdle <= '1';
        ELSIF (s_SCL.OutDataValid = '1' AND s_FSM.BitCounter = -1) THEN                                                               -- ACK
          s_States.SendACK <= '1';
        END IF;
      END IF;
      --
      -- readdata
      --
      IF (s_FSM.State = READDATA) THEN
        -- load next data
        IF (s_SCL.InDataValid = '1' AND s_FSM.BitCounter = -1 AND s_FSM.DataCounter = g_DataWidth - 1) THEN                           -- next data
          s_States.ReadFromRegister <= '1';
        END IF;
        -- output signal
        IF (s_SCL.OutDataValid = '1' AND s_FSM.BitCounter >= 0) THEN                                                                  -- data output
          s_States.SendData <= '1';
        ELSIF (s_SCL.OutDataValid = '1' AND s_FSM.BitCounter = -1) THEN                                                               -- ACKM
          s_States.SendIdle <= '1';
        END IF;
      END IF;
      --
      -- nextaddress
      --
      IF (s_FSM.State = WRITEDATA OR s_FSM.State = READDATA) THEN
        IF(s_FSM.BitCounter = -1 AND s_FSM.DataCounter = g_DataWidth - 1 AND s_SCL.OutDataValid = '1') THEN
          o_RegisterAddress <= o_RegisterAddress + 1;
        END IF;
      END IF;
    END IF;
  END PROCESS proc_States;

END rtl;
