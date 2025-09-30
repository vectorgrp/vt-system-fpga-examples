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


ENTITY UART_Receiver IS

  GENERIC (
    fpga_frequency   : std_logic_vector(31 DOWNTO 0) := 32d"80000000";
    g_Idle           : std_logic                     := '1';
    g_WrongParityBit : natural                       := 0  -- Index for o_ErrorCode
    );
  PORT (
    i_clock      : IN  std_logic;
    i_reset      : IN  std_logic;
    --
    i_Baudrate   : IN  std_logic_vector(31 DOWNTO 0);
    i_Parity     : IN  std_logic_vector(2 DOWNTO 0);       -- 0: no parity; 1: odd; 2: even; 3: mark; 4: space
    i_DataWidth  : IN  std_logic_vector(3 DOWNTO 0);       -- number of data bits
    i_StopWidth  : IN  std_logic_vector(1 DOWNTO 0);       -- number of stop bits
    i_Active     : IN  std_logic;
    i_Signal     : IN  std_logic;
    i_ResetError : IN  std_logic;
    --
    o_Data       : OUT std_logic_vector(8 DOWNTO 0) := (OTHERS => '0');
    o_NewData    : OUT std_logic                    := '0';
    o_ErrorCode  : OUT std_logic_vector(7 DOWNTO 0) := (OTHERS => '0')
    );

END UART_Receiver;


ARCHITECTURE rtl OF UART_Receiver IS

  TYPE t_FSMStates IS (IDLE, STARTBIT, DATA, PARITY, STOPBITS);
  --
  TYPE t_FSM IS RECORD
    State                : t_FSMStates;
    BitCounter           : natural;
    StartPhaseAccumlator : std_logic;
    StopPhaseAccumlator  : std_logic;
  END RECORD;
  --
  SIGNAL s_FSM : t_FSM := (
    State                => IDLE,
    BitCounter           => 0,
    StartPhaseAccumlator => '0',
    StopPhaseAccumlator  => '0');
  --
  TYPE t_States IS RECORD
    DataShiftRegister : std_logic_vector(o_Data'range);
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
  --
  TYPE t_SampleTiming IS RECORD
    PhaseAccumulatorValue : std_logic_vector(i_Baudrate'range);
    NewBit                : std_logic;
  END RECORD;
  --
  SIGNAL s_SampleTiming : t_SampleTiming := (
    PhaseAccumulatorValue => (OTHERS => '0'),
    NewBit                => '0');

BEGIN  -- rtl

  proc_FSM : PROCESS (i_clock, i_reset)
    VARIABLE v_EdgeDetection : std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');
  BEGIN  -- PROCESS proc_FSM
    IF (i_reset = c_reset_active) THEN                                                                  -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                                                        -- rising clock edge
      s_FSM.StartPhaseAccumlator <= '0';
      s_FSM.StopPhaseAccumlator  <= '0';
      --
      CASE s_FSM.State IS
        WHEN IDLE =>
          IF (i_Active = '1' AND v_EdgeDetection(1) = g_Idle AND v_EdgeDetection(0) = NOT g_Idle) THEN  -- check for first edge of the startbit
            s_FSM.StartPhaseAccumlator <= '1';                                                          -- start phase accumulator
            s_FSM.State                <= STARTBIT;
          END IF;
          --
          v_EdgeDetection := v_EdgeDetection(0) & i_Signal;
        --
        WHEN STARTBIT =>
          IF (s_PhaseAccumulator.Overflow) THEN
            s_FSM.BitCounter <= natural(to_integer(unsigned(i_DataWidth))) - 1;
            s_FSM.State      <= DATA;
          END IF;
        --
        WHEN DATA =>
          IF (s_PhaseAccumulator.Overflow) THEN
            IF (s_FSM.BitCounter = 0 AND i_Parity /= 3d"0") THEN                                        -- all data bits -> parity
              s_FSM.State <= PARITY;
            ELSIF (s_FSM.BitCounter = 0 AND i_Parity = 3d"0") THEN                                      -- all data bits -> no parity
              s_FSM.BitCounter <= natural(to_integer(unsigned(i_StopWidth))) - 1;
              s_FSM.State      <= STOPBITS;
            ELSE                                                                                        -- data bits left
              s_FSM.BitCounter <= s_FSM.BitCounter - 1;
            END IF;
          END IF;
        --
        WHEN PARITY =>
          IF (s_PhaseAccumulator.Overflow) THEN
            s_FSM.BitCounter <= natural(to_integer(unsigned(i_StopWidth))) - 1;
            s_FSM.State      <= STOPBITS;
          END IF;
        --
        WHEN STOPBITS =>
          IF (s_PhaseAccumulator.Overflow) THEN
            IF (s_FSM.BitCounter = 0) THEN                                                              -- end of the message
              s_FSM.StopPhaseAccumlator <= '1';                                                         -- stop phase accumulator
              s_FSM.State               <= IDLE;
            ELSE                                                                                        -- stop bits left
              s_FSM.BitCounter <= s_FSM.BitCounter - 1;
            END IF;
          END IF;
        --
        WHEN OTHERS =>
          s_FSM.State <= IDLE;
      END CASE;
      --
      --
      --
      IF (NOT i_Active) THEN                                                                            -- deactivated receiver
        s_FSM.StopPhaseAccumlator <= '1';                                                               -- stop phase accumulator
        s_FSM.State               <= IDLE;
      END IF;
    END IF;
  END PROCESS proc_FSM;

  --

  proc_States : PROCESS (i_clock, i_reset)
  BEGIN  -- PROCESS proc_States
    IF (i_reset = c_reset_active) THEN                                                                      -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                                                            -- rising clock edge
      o_NewData <= '0';
      --
      -- IDLE
      --
      IF (s_FSM.State = IDLE) THEN
        s_States.Parity <= '0';                                                                             -- reset parity for new calculation
      END IF;
      --
      -- STARTBIT
      --
      IF (s_FSM.State = STARTBIT) THEN
        NULL;
      END IF;
      --
      -- DATA
      --
      IF (s_FSM.State = DATA) THEN
        IF (s_SampleTiming.NewBit) THEN
          s_States.DataShiftRegister <= i_Signal & s_States.DataShiftRegister(o_Data'length - 1 DOWNTO 1);  -- LSB first -> shift to the right
          s_States.Parity            <= s_States.Parity XOR i_Signal;
        END IF;
      END IF;
      --
      -- PARITY
      --
      IF (s_FSM.State = PARITY) THEN
        IF (s_SampleTiming.NewBit) THEN
          IF (i_Parity = 3d"1" AND s_States.Parity /= NOT i_Signal) THEN                                    -- 1: odd
            o_ErrorCode(g_WrongParityBit) <= '1';
          ELSIF (i_Parity = 3d"2" AND s_States.Parity /= i_Signal) THEN                                     -- 2: even
            o_ErrorCode(g_WrongParityBit) <= '1';
          ELSIF (i_Parity = 3d"3" AND s_States.Parity /= '1') THEN                                          -- 3: mark
            o_ErrorCode(g_WrongParityBit) <= '1';
          ELSIF (i_Parity = 3d"4" AND s_States.Parity /= '0') THEN                                          -- 4: space
            o_ErrorCode(g_WrongParityBit) <= '1';
          ELSE                                                                                              -- parity bit correct
            o_ErrorCode(g_WrongParityBit) <= '0';
          END IF;
        END IF;
      END IF;
      --
      -- STOPBITS
      --
      IF (s_FSM.State = STOPBITS) THEN
        IF (s_PhaseAccumulator.Overflow = '1' AND s_FSM.BitCounter = 0) THEN
          o_NewData <= '1';
          --
          IF (i_DataWidth = 4d"7") THEN                                                                     -- 7 bit data
            o_Data <= "00" & s_States.DataShiftRegister(8 DOWNTO 2);
          ELSIF (i_DataWidth = 4d"8") THEN                                                                  -- 8 bit data
            o_Data <= "0" & s_States.DataShiftRegister(8 DOWNTO 1);
          ELSIF (i_DataWidth = 4d"9") THEN                                                                  -- 9 bit data
            o_Data <= s_States.DataShiftRegister;
          END IF;
        END IF;
      END IF;
      --
      --
      --
      IF (i_ResetError) THEN
        o_ErrorCode <= (OTHERS => '0');
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

  proc_SampleTiming : PROCESS (i_clock, i_reset)
    VARIABLE v_ValueArray : t_ArrayUnsigned(1 DOWNTO 0)(i_Baudrate'range);
  BEGIN  -- PROCESS proc_SampleTiming
    IF (i_reset = c_reset_active) THEN                                                                          -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                                                                -- rising clock edge
      v_ValueArray          := v_ValueArray(0) & unsigned(s_SampleTiming.PhaseAccumulatorValue);
      s_SampleTiming.NewBit <= '0';
      --
      IF (v_ValueArray(1) < unsigned(fpga_frequency)/2 AND v_ValueArray(0) >= unsigned(fpga_frequency)/2) THEN  -- similar to overflow but half way
        s_SampleTiming.NewBit <= '1';
      END IF;
    END IF;
  END PROCESS proc_SampleTiming;

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
      i_StartValue           => std_logic_vector(unsigned(fpga_frequency) / 2),  -- start in the middle of a bit
      i_SetStartValue        => s_PhaseAccumulator.SetStartValue,
      i_FrequencyControlWord => s_PhaseAccumulator.FrequencyControlWord,
      o_CounterValue         => s_SampleTiming.PhaseAccumulatorValue,
      o_Overflow             => s_PhaseAccumulator.Overflow);

END rtl;
