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


ENTITY PhaseMeasurement IS

  GENERIC (
    g_CounterWidth      : natural                      := 32;
    g_PhaseCounterState : std_logic_vector(1 DOWNTO 0) := "10"  -- phase counter is incremented while A & B = g_PhaseCounterState (A = '1' and B ='0')
    );
  PORT (
    i_clock         : IN  std_logic;
    i_reset         : IN  std_logic;
    --
    i_SignalA       : IN  std_logic;
    i_SignalB       : IN  std_logic;
    --
    o_PhaseCounter  : OUT std_logic_vector(g_CounterWidth - 1 DOWNTO 0) := std_logic_vector(to_unsigned(1, g_CounterWidth));
    o_PeriodCounter : OUT std_logic_vector(g_CounterWidth - 1 DOWNTO 0) := std_logic_vector(to_unsigned(1, g_CounterWidth))
    );

END PhaseMeasurement;


ARCHITECTURE rtl OF PhaseMeasurement IS

  TYPE t_PhaseMeasurement IS RECORD
    EdgeRecognition : std_logic_vector(1 DOWNTO 0);
    PhaseCounter    : unsigned(o_PhaseCounter'range);
    PeriodCounter   : unsigned(o_PeriodCounter'range);
  END RECORD;
  --
--  SIGNAL s_PhaseMeasurement : t_PhaseMeasurement := (
--    EdgeRecognition => (OTHERS => '0'),
--    PhaseCounter    => to_unsigned(1, g_CounterWidth),
--    PeriodCounter   => to_unsigned(1, g_CounterWidth)
--    );

BEGIN  -- rtl

  proc_PhaseMeasurement : PROCESS (i_clock, i_reset)
    VARIABLE v_PhaseMeasurement : t_PhaseMeasurement := (
      EdgeRecognition => (OTHERS => '0'),
      PhaseCounter    => to_unsigned(1, g_CounterWidth),
      PeriodCounter   => to_unsigned(1, g_CounterWidth));
  BEGIN  -- PROCESS proc_PhaseMeasurement
    IF (i_reset = c_reset_active) THEN                                       -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                             -- rising clock edge
      v_PhaseMeasurement.EdgeRecognition := v_PhaseMeasurement.EdgeRecognition(0) & i_SignalA;
      --
      -- the data is output after a whole period
      IF (v_PhaseMeasurement.EdgeRecognition = c_RisingEdge) THEN
        o_PhaseCounter                   <= std_logic_vector(v_PhaseMeasurement.PhaseCounter);
        o_PeriodCounter                  <= std_logic_vector(v_PhaseMeasurement.PeriodCounter);
        --
        v_PhaseMeasurement.PhaseCounter  := to_unsigned(0, g_CounterWidth);  -- reset for the next period
        v_PhaseMeasurement.PeriodCounter := to_unsigned(0, g_CounterWidth);
      END IF;
      --
      -- state for the phase difference -> phase counter
      -- it doesn't matter if AB is "10" or "01"
      IF (i_SignalA & i_SignalB = g_PhaseCounterState) THEN
        v_PhaseMeasurement.PhaseCounter := v_PhaseMeasurement.PhaseCounter + 1;
      END IF;
      --
      v_PhaseMeasurement.PeriodCounter := v_PhaseMeasurement.PeriodCounter + 1;
    END IF;
  END PROCESS proc_PhaseMeasurement;

END rtl;
