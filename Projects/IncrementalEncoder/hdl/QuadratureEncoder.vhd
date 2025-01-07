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


ENTITY QuadratureEncoder IS

  GENERIC (
    g_CounterWidth : natural := 16
    );
  PORT (
    i_clock                        : IN  std_logic;
    i_reset                        : IN  std_logic;
    -- settings
    i_NumOfTeeth                   : IN  std_logic_vector(g_CounterWidth - 1 DOWNTO 0);
    i_StatesPerTooth               : IN  std_logic_vector(g_CounterWidth - 1 DOWNTO 0);
    -- signal A
    i_SignalA_RisingEdgeState      : IN  std_logic_vector(g_CounterWidth - 1 DOWNTO 0);
    i_SignalA_FallingEdgeState     : IN  std_logic_vector(g_CounterWidth - 1 DOWNTO 0);
    -- signal B
    i_SignalB_RisingEdgeState      : IN  std_logic_vector(g_CounterWidth - 1 DOWNTO 0);
    i_SignalB_FallingEdgeState     : IN  std_logic_vector(g_CounterWidth - 1 DOWNTO 0);
    -- signal index
    i_SignalIndex_RisingEdgeTooth  : IN  std_logic_vector(g_CounterWidth - 1 DOWNTO 0);
    i_SignalIndex_RisingEdgeState  : IN  std_logic_vector(g_CounterWidth - 1 DOWNTO 0);
    i_SignalIndex_FallingEdgeTooth : IN  std_logic_vector(g_CounterWidth - 1 DOWNTO 0);
    i_SignalIndex_FallingEdgeState : IN  std_logic_vector(g_CounterWidth - 1 DOWNTO 0);
    --
    i_NextState                    : IN  std_logic;
    i_PreviousState                : IN  std_logic;
    i_ResetPosition                : IN  std_logic;
    -- output signals
    o_SignalA                      : OUT std_logic := '0';
    o_SignalB                      : OUT std_logic := '0';
    o_SignalIndex                  : OUT std_logic := '0'
    );

END QuadratureEncoder;


ARCHITECTURE rtl OF QuadratureEncoder IS

  --            ___     ___     ___
  -- signal A: |   |___|   |___|   |___... -> "1100"
  --              ___     ___     ___
  -- signal B: __|   |___|   |___|   |_... -> "0110"
  -- teeth:    |   0   |   1   |...
  -- states:   |0|1|2|3|...
  --            ___
  -- index:    |   |___________________...
  -- teeth:    | 0     |   1   |...
  -- states:   |0|1|2|3|...
  --
  TYPE t_Position IS RECORD
    Tooth : unsigned(g_CounterWidth - 1 DOWNTO 0);                                           -- number of teeth in a full rotation
    State : unsigned(g_CounterWidth - 1 DOWNTO 0);                                           -- number of states in a tooth; used for phase difference (e.g. 360°/90° = 4 states)
  END RECORD;
  --
  -- design as above
  SIGNAL s_Position : t_Position := (
    Tooth => (OTHERS => '0'),
    State => (OTHERS => '0'));
  --
  --
  --
  FUNCTION f_SignalAB (                                                                      -- function for the output signal A & B
    SIGNAL State                   : unsigned;
    SIGNAL RisingEdge, FallingEdge : std_logic_vector)
    RETURN std_logic IS
    VARIABLE v_Return : std_logic := '0';
  BEGIN  -- f_SignalAB
    v_Return := '0';
    --
    IF (State >= unsigned(RisingEdge) AND State < unsigned(FallingEdge)) THEN                -- pulse
      v_Return := '1';
    END IF;
    --
    RETURN v_Return;
  END f_SignalAB;
  --
  FUNCTION f_SignalIndex (                                                                   -- function for the output of the index signal
    SIGNAL Tooth            : unsigned;
    SIGNAL State            : unsigned;
    SIGNAL RisingEdgeTooth  : std_logic_vector;
    SIGNAL RisingEdgeState  : std_logic_vector;
    SIGNAL FallingEdgeTooth : std_logic_vector;
    SIGNAL FallingEdgeState : std_logic_vector)
    RETURN std_logic IS
    VARIABLE v_Return : std_logic := '0';
  BEGIN  -- f_SignalIndex
    v_Return := '0';
    --
    IF (Tooth > unsigned(FallingEdgeTooth)) THEN                                             -- teeth after the pulse
      v_Return := '0';
    ELSIF (Tooth = unsigned(FallingEdgeTooth) AND State >= unsigned(FallingEdgeState)) THEN  -- low state after the pulse in the same tooth
      v_Return := '0';
    ELSIF (Tooth > unsigned(RisingEdgeTooth)) THEN                                           -- pulse after the first tooth
      v_Return := '1';
    ELSIF (Tooth = unsigned(RisingEdgeTooth) AND State >= unsigned(RisingEdgeState)) THEN    -- pulse states of the first tooth
      v_Return := '1';
    END IF;
    --
    RETURN v_Return;
  END f_SignalIndex;

BEGIN  -- rtl

  proc_Position : PROCESS (i_clock, i_reset)
    VARIABLE v_ResetPosition : std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');
  BEGIN  -- PROCESS proc_Position
    IF (i_reset = c_reset_active) THEN                                 -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                       -- rising clock edge
      -- forward
      IF (i_NextState) THEN
        IF (s_Position.State >= unsigned(i_StatesPerTooth) - 1) THEN   -- last state -> first state
          s_Position.State <= (OTHERS => '0');
          --
          IF (s_Position.Tooth >= unsigned(i_NumOfTeeth) - 1) THEN     -- last tooth -> first tooth
            s_Position.Tooth <= (OTHERS => '0');
          ELSE                                                         -- next tooth
            s_Position.Tooth <= s_Position.Tooth + 1;
          END IF;
        --
        ELSE                                                           -- next state of the same tooth
          s_Position.State <= s_Position.State + 1;
        END IF;
      --
      -- backwards
      ELSIF (i_PreviousState) THEN
        IF (s_Position.State = to_unsigned(0, g_CounterWidth)) THEN    -- first state -> last state
          s_Position.State <= unsigned(i_StatesPerTooth) - 1;
          --
          IF (s_Position.Tooth = to_unsigned(0, g_CounterWidth)) THEN  -- first -> last tooth
            s_Position.Tooth <= unsigned(i_NumOfTeeth) - 1;
          ELSE
            s_Position.Tooth <= s_Position.Tooth - 1;                  -- previous tooth
          END IF;
        --
        ELSE                                                           -- previous state of the same tooth
          s_Position.State <= s_Position.State - 1;
        END IF;
      END IF;
      --
      --
      -- reset position
      v_ResetPosition := v_ResetPosition(0) & i_ResetPosition;
      --
      IF (v_ResetPosition = c_RisingEdge) THEN
        s_Position.Tooth <= (OTHERS => '0');
        s_Position.State <= (OTHERS => '0');
      END IF;
    END IF;
  END PROCESS proc_Position;

  --

  proc_OutputSignals : PROCESS (i_clock, i_reset)
  BEGIN  -- PROCESS proc_OutputSignals
    IF (i_reset = c_reset_active) THEN                                                                   -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                                                         -- rising clock edge
      o_SignalA <= f_SignalAB(s_Position.State, i_SignalA_RisingEdgeState, i_SignalA_FallingEdgeState);  -- signal A
      o_SignalB <= f_SignalAB(s_Position.State, i_SignalB_RisingEdgeState, i_SignalB_FallingEdgeState);  -- signal B
      o_SignalIndex <= f_SignalIndex(s_Position.Tooth, s_Position.State,                                 -- index signal
                                     i_SignalIndex_RisingEdgeTooth, i_SignalIndex_RisingEdgeState,
                                     i_SignalIndex_FallingEdgeTooth, i_SignalIndex_FallingEdgeState);
    END IF;
  END PROCESS proc_OutputSignals;

END rtl;
