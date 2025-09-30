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


ENTITY UART_Transmitter IS

  GENERIC (
    fpga_frequency : std_logic_vector(31 DOWNTO 0) := 32d"80000000";
    g_Idle         : std_logic                     := '1'
    );
  PORT (
    i_clock       : IN  std_logic;
    i_reset       : IN  std_logic;
    --
    i_Baudrate    : IN  std_logic_vector(31 DOWNTO 0);
    i_Parity      : IN  std_logic_vector(2 DOWNTO 0);  -- 0: no parity; 1: odd; 2: even; 3: mark; 4: space
    i_DataWidth   : IN  std_logic_vector(3 DOWNTO 0);  -- number of data bits
    i_StopWidth   : IN  std_logic_vector(1 DOWNTO 0);  -- number of stop bits
    i_Data        : IN  std_logic_vector(8 DOWNTO 0);
    i_Send        : IN  std_logic;
    i_ErrorCode   : IN  std_logic_vector(7 DOWNTO 0);
    --
    o_Signal      : OUT std_logic := g_Idle;
    o_MessageSend : OUT std_logic := '0'
    );

END UART_Transmitter;


ARCHITECTURE rtl OF UART_Transmitter IS

  TYPE t_Control IS RECORD
    Send : std_logic;
  END RECORD;
  --
  SIGNAL s_Control : t_Control := (
    Send => '0');
  --
  TYPE t_FSMStates IS (IDLE, STARTBIT, DATA, PARITY, STOPBITS);
  --
  TYPE t_FSM IS RECORD
    State                : t_FSMStates;
    BitCounter           : natural;
    StartPhaseAccumlator : std_logic;
    StopPhaseAccumlator  : std_logic;
    NewBit               : std_logic;
  END RECORD;
  --
  SIGNAL s_FSM : t_FSM := (
    State                => IDLE,
    BitCounter           => 0,
    StartPhaseAccumlator => '0',
    StopPhaseAccumlator  => '0',
    NewBit               => '0');
  --
  TYPE t_States IS RECORD
    DataShiftRegister : std_logic_vector(i_Data'range);
    Parity            : std_logic;
  END RECORD;
  --
  SIGNAL s_States : t_States := (
    DataShiftRegister => (OTHERS => '0'),
    Parity            => '0');
  --
  TYPE t_PhaseAccumulator IS RECORD
    Active               : std_logic;
    SetStartValue        : std_logic;
    FrequencyControlWord : std_logic_vector(31 DOWNTO 0);
    Overflow             : std_logic;
  END RECORD;
  --
  SIGNAL s_PhaseAccumulator : t_PhaseAccumulator := (
    Active               => '0',
    SetStartValue        => '0',
    FrequencyControlWord => (OTHERS => '0'),
    Overflow             => '0');

BEGIN  -- rtl

  proc_Control : PROCESS (i_clock, i_reset)
    VARIABLE v_SendArray : std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');
  BEGIN  -- PROCESS proc_Control
    IF (i_reset = c_reset_active) THEN            -- asynchronous reset (active package defined)
      s_Control.Send <= '0';
    ELSIF (i_clock'event AND i_clock = '1') THEN  -- rising clock edge
      s_Control.Send <= '0';
      v_SendArray    := v_SendArray(0) & i_Send;
      --
      IF (v_SendArray = c_RisingEdge) THEN
        s_Control.Send <= '1';
      END IF;
    END IF;
  END PROCESS proc_Control;

  --

  proc_FSM : PROCESS (i_clock, i_reset)
  BEGIN  -- PROCESS proc_FSM
    IF (i_reset = c_reset_active) THEN                              -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                    -- rising clock edge
      s_FSM.StartPhaseAccumlator <= '0';
      s_FSM.StopPhaseAccumlator  <= '0';
      s_FSM.NewBit               <= '0';
      --
      CASE s_FSM.State IS
        WHEN IDLE =>
          IF (s_Control.Send) THEN
            s_FSM.StartPhaseAccumlator <= '1';                      -- start phase accumulator
            s_FSM.State                <= STARTBIT;
          END IF;
        --
        WHEN STARTBIT =>
          IF (s_PhaseAccumulator.Overflow) THEN
            s_FSM.NewBit     <= '1';
            s_FSM.BitCounter <= natural(to_integer(unsigned(i_DataWidth))) - 1;
            s_FSM.State      <= DATA;
          END IF;
        --
        WHEN DATA =>
          IF (s_PhaseAccumulator.Overflow) THEN
            s_FSM.NewBit <= '1';
            --
            IF (s_FSM.BitCounter = 0 AND i_Parity /= 3d"0") THEN
              s_FSM.State <= PARITY;
            ELSIF (s_FSM.BitCounter = 0 AND i_Parity = 3d"0") THEN  -- no parity
              s_FSM.BitCounter <= natural(to_integer(unsigned(i_StopWidth))) - 1;
              s_FSM.State      <= STOPBITS;
            ELSE                                                    -- data bits left
              s_FSM.BitCounter <= s_FSM.BitCounter - 1;
            END IF;
          END IF;
        --
        WHEN PARITY =>
          IF (s_PhaseAccumulator.Overflow) THEN
            s_FSM.NewBit     <= '1';
            s_FSM.BitCounter <= natural(to_integer(unsigned(i_StopWidth))) - 1;
            s_FSM.State      <= STOPBITS;
          END IF;
        --
        WHEN STOPBITS =>
          IF (s_PhaseAccumulator.Overflow) THEN
            s_FSM.NewBit <= '1';
            --
            IF (s_FSM.BitCounter = 0) THEN
              s_FSM.StopPhaseAccumlator <= '1';                     -- stop phase accumulator
              s_FSM.State               <= IDLE;
            ELSE
              s_FSM.BitCounter <= s_FSM.BitCounter - 1;
            END IF;
          END IF;
        --
        WHEN OTHERS =>
          s_FSM.State <= IDLE;
      END CASE;
    END IF;
  END PROCESS proc_FSM;

  --

  proc_States : PROCESS (i_clock, i_reset)
  BEGIN  -- PROCESS proc_States
    IF (i_reset = c_reset_active) THEN                                                                    -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                                                          -- rising clock edge
      o_MessageSend <= '0';
      --
      -- IDLE
      --
      IF (s_FSM.State = IDLE) THEN
        o_Signal        <= g_Idle;
        s_States.Parity <= '0';                                                                           -- reset parity for new calculation
      END IF;
      --
      -- STARTBIT
      --
      IF (s_FSM.State = STARTBIT) THEN
        o_Signal                   <= NOT g_Idle;
        s_States.DataShiftRegister <= i_Data;                                                             -- load data into the shift register
      END IF;
      --
      -- DATA
      --
      IF (s_FSM.State = DATA) THEN
        IF (s_FSM.NewBit) THEN
          o_Signal                   <= s_States.DataShiftRegister(0);                                    -- output LSB3
          s_States.Parity            <= s_States.Parity XOR s_States.DataShiftRegister(0);
          s_States.DataShiftRegister <= g_Idle & s_States.DataShiftRegister(i_Data'length - 1 DOWNTO 1);  -- shift to the right
        END IF;
      END IF;
      --
      -- PARITY
      --
      IF (s_FSM.State = PARITY) THEN
        IF (s_FSM.NewBit) THEN
          IF (i_Parity = 3d"1") THEN                                                                      -- 1: odd
            o_Signal <= NOT s_States.Parity;
          ELSIF (i_Parity = 3d"2") THEN                                                                   -- 2: even
            o_Signal <= s_States.Parity;
          ELSIF (i_Parity = 3d"3") THEN                                                                   -- 3: mark
            o_Signal <= '1';
          ELSIF (i_Parity = 3d"4") THEN                                                                   -- 4: space
            o_Signal <= '0';
          END IF;
        END IF;
      END IF;
      --
      -- STOPBITS
      --
      IF (s_FSM.State = STOPBITS) THEN
        IF (s_FSM.NewBit) THEN
          o_Signal <= g_Idle;
          --
          IF (s_FSM.BitCounter = 0) THEN
            o_MessageSend <= '1';
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS proc_States;

  --

  proc_PhaseAccumukatorControl : PROCESS (i_clock, i_reset)
  BEGIN  -- PROCESS proc_PhaseAccumukatorControl
    IF (i_reset = c_reset_active) THEN                   -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN         -- rising clock edge
      s_PhaseAccumulator.SetStartValue <= '0';
      --
      IF (s_FSM.StartPhaseAccumlator) THEN
        s_PhaseAccumulator.Active               <= '1';  -- activate phase accumulator (BCLK) with a preset start value
        s_PhaseAccumulator.SetStartValue        <= '1';
        s_PhaseAccumulator.FrequencyControlWord <= i_Baudrate;
      ELSIF (s_FSM.StopPhaseAccumlator) THEN
        s_PhaseAccumulator.Active <= '0';
      END IF;
    END IF;
  END PROCESS proc_PhaseAccumukatorControl;

  --
  --
  --

  inst_PhaseAccumulator : ENTITY work.PhaseAccumulator
    GENERIC MAP (
      fpga_frequency     => fpga_frequency,
      g_width            => i_Baudrate'length,
      g_ResolutionFactor => 32d"1")
    PORT MAP (
      i_clock                => i_clock,
      i_reset                => i_reset,
      i_Active               => s_PhaseAccumulator.Active,
      i_StartValue           => (OTHERS => '0'),
      i_SetStartValue        => s_PhaseAccumulator.SetStartValue,
      i_FrequencyControlWord => s_PhaseAccumulator.FrequencyControlWord,
      o_CounterValue         => OPEN,
      o_Overflow             => s_PhaseAccumulator.Overflow);

END rtl;
