-- Copyright (c) 2024 Vector Informatik GmbH

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


ENTITY QuadratureDecoder IS

  GENERIC (
    g_PositionWidth : natural := 32;
    -- the filter is used to prevent wrong counter in-/decrement if the A/B signal and the index signal have a small phase difference
    -- the width determines how many FPGA cycles in front and behind the index signal the filter works
    -- e.g. width = 5 means that 5 cycles before and after the index signal is recognized are filtered
    g_FilterWidth   : natural := 5      
    );
  PORT (
    i_clock           : IN  std_logic;
    i_reset           : IN  std_logic;
    --
    i_AtrailsB        : IN  std_logic;  -- A before B; used to signal the code which signal follows the other
    i_SignalA         : IN  std_logic;
    i_SignalB         : IN  std_logic;
    i_SignalIndex     : IN  std_logic;
    --
    i_ResetPosition   : IN  std_logic;
    i_ResetError      : IN  std_logic;
    i_AutoMaxPosition : IN  std_logic;
    i_MaxPosition     : IN  std_logic_vector(g_PositionWidth - 1 DOWNTO 0);
    --
    o_Position        : OUT std_logic_vector(g_PositionWidth - 1 DOWNTO 0) := (OTHERS => '0');
    o_Error           : OUT std_logic                                      := '0'
    );

END QuadratureDecoder;


ARCHITECTURE rtl OF QuadratureDecoder IS

  -- directions
  CONSTANT c_Forward   : std_logic := '1';
  CONSTANT c_Backwards : std_logic := '0';
  --
  TYPE t_SignalAB IS RECORD
    SortedSignal : std_logic_vector(1 DOWNTO 0);
    NextEdge     : std_logic;           -- in-/decremement the counter based on the direction
    Direction    : std_logic;           -- used for the index signal recognition; '1': as long as forward motion is detected, '0' otherwise
  END RECORD;
  --
  TYPE t_Index IS RECORD                -- edges of the index signal; position reset for forward and backwards are different (rising/falling) edges
    Rising  : std_logic;
    Falling : std_logic;
  END RECORD;
  --
  TYPE t_Filter IS RECORD
    SignalAB     : std_logic_vector(2 * g_FilterWidth DOWNTO 0);
    IndexRising  : std_logic_vector(2 * g_FilterWidth DOWNTO 0);
    IndexFalling : std_logic_vector(2 * g_FilterWidth DOWNTO 0);
  END RECORD;
  --
  --
  SIGNAL s_SignalAB : t_SignalAB := (
    SortedSignal => (OTHERS => '0'),    -- signal after AtrailsB is applied
    NextEdge     => '0',
    Direction    => c_Forward);         -- default: forward
  --
  SIGNAL s_Index : t_Index := (
    Rising  => '0',
    Falling => '0');

BEGIN  -- rtl

  -- outputs the rising and falling edges of the index signal
  proc_SignalIndex : PROCESS (i_clock, i_reset)
    VARIABLE v_SignalIndex : std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');
  BEGIN  -- PROCESS proc_SignalIndex
    IF (i_reset = c_reset_active) THEN            -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN  -- rising clock edge
      s_Index.Rising  <= '0';
      s_Index.Falling <= '0';
      --
      v_SignalIndex   := v_SignalIndex(0) & i_SignalIndex;
      --
      IF (v_SignalIndex = c_RisingEdge) THEN      -- only for one cycle
        s_Index.Rising <= '1';
      ELSIF (v_SignalIndex = c_FallingEdge) THEN  -- only for one cycle
        s_Index.Falling <= '1';
      END IF;
    END IF;
  END PROCESS proc_SignalIndex;

  --

  -- recognition of the direction based on the A and B signals
  -- outputs when a forward or backwards motion was detected
  proc_SignalAB : PROCESS (i_clock, i_reset)
    VARIABLE v_ResetError : std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');
    VARIABLE v_FSM        : std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');
    VARIABLE v_SignalAB : t_SignalAB := (
      SortedSignal => (OTHERS => '0'),
      NextEdge     => '0',
      Direction    => c_Forward);
  BEGIN  -- PROCESS proc_SignalAB
    IF (i_reset = c_reset_active) THEN                     -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN           -- rising clock edge
      v_SignalAB.NextEdge := '0';
      --
      --
      --
      IF (NOT i_AtrailsB) THEN
        v_SignalAB.SortedSignal := i_SignalA & i_SignalB;  -- A -> B
      ELSE
        v_SignalAB.SortedSignal := i_SignalB & i_SignalA;  -- B -> A
      END IF;
      --
      --
      --
      CASE v_FSM IS
        WHEN "00" =>
          IF (v_SignalAB.SortedSignal = "10") THEN         -- forward
            v_SignalAB.NextEdge  := '1';
            v_SignalAB.Direction := c_Forward;
          ELSIF (v_SignalAB.SortedSignal = "01") THEN      -- backwards
            v_SignalAB.NextEdge  := '1';
            v_SignalAB.Direction := c_Backwards;
          ELSIF (v_SignalAB.SortedSignal = "11") THEN      -- error
            o_Error <= '1';
          END IF;
        --
        WHEN "10" =>
          IF (v_SignalAB.SortedSignal = "11") THEN         -- forward
            v_SignalAB.NextEdge  := '1';
            v_SignalAB.Direction := c_Forward;
          ELSIF (v_SignalAB.SortedSignal = "00") THEN      -- backwards
            v_SignalAB.NextEdge  := '1';
            v_SignalAB.Direction := c_Backwards;
          ELSIF (v_SignalAB.SortedSignal = "01") THEN      -- error
            o_Error <= '1';
          END IF;
        --
        WHEN "11" =>
          IF (v_SignalAB.SortedSignal = "01") THEN         -- forward
            v_SignalAB.NextEdge  := '1';
            v_SignalAB.Direction := c_Forward;
          ELSIF (v_SignalAB.SortedSignal = "10") THEN      -- backwards
            v_SignalAB.NextEdge  := '1';
            v_SignalAB.Direction := c_Backwards;
          ELSIF (v_SignalAB.SortedSignal = "00") THEN      -- error
            o_Error <= '1';
          END IF;
        --
        WHEN "01" =>
          IF (v_SignalAB.SortedSignal = "00") THEN         -- forward
            v_SignalAB.NextEdge  := '1';
            v_SignalAB.Direction := c_Forward;
          ELSIF (v_SignalAB.SortedSignal = "11") THEN      -- backwards
            v_SignalAB.NextEdge  := '1';
            v_SignalAB.Direction := c_Backwards;
          ELSIF (v_SignalAB.SortedSignal = "10") THEN      -- error
            o_Error <= '1';
          END IF;
        --
        WHEN OTHERS =>
          v_FSM := "00";
      END CASE;
      --
      -- next state (only if no error occured)
      IF (v_SignalAB.NextEdge) THEN
        v_FSM := v_SignalAB.SortedSignal;
      END IF;
      --
      --
      -- position counter
      s_SignalAB.NextEdge  <= v_SignalAB.NextEdge;
      s_SignalAB.Direction <= v_SignalAB.Direction;
      --
      --
      -- reset error
      v_ResetError         := v_ResetError(0) & i_ResetError;
      --
      IF (v_ResetError = c_RisingEdge) THEN
        o_Error <= '0';                                    -- only a manual reset can reset the error flag
      END IF;
    END IF;
  END PROCESS proc_SignalAB;

  --

  proc_Position : PROCESS (i_clock, i_reset)
    VARIABLE v_ResetPosition  : std_logic_vector(1 DOWNTO 0)       := (OTHERS => '0');
    VARIABLE v_SetMaxPosition : std_logic                          := '0';
    VARIABLE v_MaxPosition    : std_logic_vector(o_Position'range) := (OTHERS => '0');
    VARIABLE v_Filter : t_Filter := (
      SignalAB     => (OTHERS => '0'),
      IndexRising  => (OTHERS => '0'),
      IndexFalling => (OTHERS => '0'));
  BEGIN  -- PROCESS proc_Position
    IF (i_reset = c_reset_active) THEN                                                                -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                                                      -- rising clock edge
      v_ResetPosition  := v_ResetPosition(0) & i_ResetPosition;
      v_SetMaxPosition := '0';
      --
      --
      --
      IF (i_AutoMaxPosition AND v_SetMaxPosition) THEN                                                -- automatically set max position
        v_MaxPosition := o_Position;
      ELSIF (NOT i_AutoMaxPosition) THEN                                                              -- manually set max position
        v_MaxPosition := i_MaxPosition;
      END IF;
      --
      --
      -- the filter works by delaying the time for the in-/decrement of the counter using a shift register
      -- the index signal is delayed by half the time of the A/B signal using a shift register
      -- the index signal blocks the in-/decrement request if at least one bit of the index signal shift register is '1'
      -- -> A/B signal in-/decrement request is overwritten by the index signal in the filter range
      v_Filter.SignalAB     := v_Filter.SignalAB(v_Filter.SignalAB'length - 2 DOWNTO 0) & s_SignalAB.NextEdge;
      v_Filter.IndexRising  := v_Filter.IndexRising(v_Filter.IndexRising'length - 2 DOWNTO 0) & s_Index.Rising;
      v_Filter.IndexFalling := v_Filter.IndexFalling(v_Filter.IndexFalling'length - 2 DOWNTO 0) & s_Index.Falling;
      --
      IF (s_SignalAB.Direction = c_Forward AND v_Filter.IndexRising /= std_logic_vector(to_unsigned(0, v_Filter.IndexRising'length))) THEN
        v_Filter.SignalAB := (OTHERS => '0');                                                         -- reset if index is recognized
      ELSIF (s_SignalAB.Direction = c_Backwards AND v_Filter.IndexFalling /= std_logic_vector(to_unsigned(0, v_Filter.IndexFalling'length))) THEN
        v_Filter.SignalAB := (OTHERS => '0');
      END IF;
      --
      --
      -- counter
      IF (s_SignalAB.Direction = c_Forward AND v_Filter.IndexRising(g_FilterWidth) = '1') THEN        -- moving forward over index
        v_SetMaxPosition := '1';                                                                      -- set current position as max position
        o_Position       <= (OTHERS => '0');
      ELSIF (s_SignalAB.Direction = c_Backwards AND v_Filter.IndexFalling(g_FilterWidth) = '1') THEN  -- moving backwards over index
        o_Position <= v_MaxPosition;
      ELSIF (s_SignalAB.Direction = c_Forward AND v_Filter.SignalAB(0) = '1') THEN                    -- moving forward
        o_Position <= std_logic_vector(signed(o_Position) + 1);
      ELSIF (s_SignalAB.Direction = c_Backwards AND v_Filter.SignalAB(0) = '1') THEN                  -- moving backwards
        o_Position <= std_logic_vector(signed(o_Position) - 1);
      END IF;
      --
      --
      -- reset position
      IF (v_ResetPosition = c_RisingEdge) THEN                                                        -- set the position manually to 0
        o_Position <= (OTHERS => '0');
      END IF;
    END IF;
  END PROCESS proc_Position;

END rtl;
