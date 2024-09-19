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


ENTITY Digital_FrequencyDutyCycle IS

  GENERIC (
    g_CounterSize : natural := 32
    );
  PORT (
    i_clock         : IN  std_logic;
    i_reset         : IN  std_logic;
    --
    i_Active        : IN  std_logic;
    i_Signal        : IN  std_logic;
    i_Timeout       : IN  std_logic_vector(g_CounterSize - 1 DOWNTO 0);
    --
    o_NewData       : OUT std_logic                                    := '0';
    o_PeriodCounter : OUT std_logic_vector(g_CounterSize - 1 DOWNTO 0) := (OTHERS => '0');
    o_PulseCounter  : OUT std_logic_vector(g_CounterSize - 1 DOWNTO 0) := (OTHERS => '0');
    o_TimeoutHigh   : OUT std_logic                                    := '0';
    o_TimeoutLow    : OUT std_logic                                    := '0'
    );

END Digital_FrequencyDutyCycle;


ARCHITECTURE rtl OF Digital_FrequencyDutyCycle IS

  CONSTANT c_TimeoutValueHigh : std_logic_vector(g_CounterSize - 1 DOWNTO 0) := (OTHERS => '1');
  CONSTANT c_TimeoutValueLow  : std_logic_vector(g_CounterSize - 1 DOWNTO 0) := (OTHERS => '0');

BEGIN  -- rtl

  proc_FSM : PROCESS (i_clock, i_reset)
    TYPE t_FSM IS (IDLE, PULSE, OFF, TIMEOUT);
    VARIABLE v_FSM            : t_FSM                           := IDLE;
    VARIABLE v_SignalEdge     : std_logic_vector(1 DOWNTO 0)    := (OTHERS => '0');
    VARIABLE v_PulseCounter   : unsigned(o_PulseCounter'range)  := (OTHERS => '0');
    VARIABLE v_PeriodCounter  : unsigned(o_PeriodCounter'range) := (OTHERS => '0');
    VARIABLE v_TimeoutCounter : unsigned(i_Timeout'range)       := (OTHERS => '0');
  BEGIN  -- PROCESS proc_FSM
    IF (i_reset = c_reset_active) THEN                              -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                    -- rising clock edge
      v_SignalEdge  := v_SignalEdge(0) & i_Signal;                  -- used to find rising and falling edges of the signal
      o_NewData     <= '0';
      o_TimeoutHigh <= '0';
      o_TimeoutLow  <= '0';
      --
      CASE v_FSM IS
        WHEN IDLE =>
          v_PulseCounter  := (OTHERS => '0');
          v_PeriodCounter := (OTHERS => '0');
          --
          IF (i_Active = '1' AND v_SignalEdge = c_RisingEdge) THEN  -- first rising edge; beginning of the pulse
            v_FSM := PULSE;
          END IF;
        --
        WHEN PULSE =>
          v_PulseCounter  := v_PulseCounter + 1;
          v_PeriodCounter := v_PeriodCounter + 1;
          --
          IF (v_SignalEdge = c_FallingEdge) THEN
            v_FSM := OFF;
          END IF;
        --
        WHEN OFF =>
          v_PeriodCounter := v_PeriodCounter + 1;
          --
          IF (v_SignalEdge = c_RisingEdge) THEN
            o_PulseCounter  <= std_logic_vector(v_PulseCounter);
            o_PeriodCounter <= std_logic_vector(v_PeriodCounter);
            o_NewData       <= '1';
            --
            v_PulseCounter  := (OTHERS => '0');                     -- reset for the new period; similar to the IDLE state
            v_PeriodCounter := (OTHERS => '0');
            v_FSM           := PULSE;
          END IF;
        --
        WHEN TIMEOUT =>                                             -- wait state
          IF (v_SignalEdge = c_RisingEdge) THEN
            v_FSM := PULSE;
          END IF;
        --
        WHEN OTHERS =>
          v_FSM := IDLE;
      END CASE;
      --
      --
      -- timeout check
      IF (v_SignalEdge = c_RisingEdge OR v_SignalEdge = c_FallingEdge) THEN
        v_TimeoutCounter := (OTHERS => '0');                        -- reset counter on both edges
      END IF;
      --
      IF(v_TimeoutCounter < unsigned(i_Timeout) - 1) THEN
        v_TimeoutCounter := v_TimeoutCounter + 1;
      ELSIF (v_TimeoutCounter = unsigned(i_Timeout) - 1) THEN       -- timeout occured
        v_TimeoutCounter := v_TimeoutCounter + 1;                   -- one addtional time so that this state occurs for only one FPGA cycle
        v_FSM            := TIMEOUT;
        -- set once for one FPGA cycle
        o_NewData        <= '1';
        o_PeriodCounter  <= c_TimeoutValueHigh;                     -- always the high value
        --
        IF (i_Signal) THEN                                          -- signal is '1' when timeout occurs
          o_TimeoutHigh  <= '1';
          o_PulseCounter <= c_TimeoutValueHigh;
        ELSE                                                        -- signal is '0' when timeout occurs
          o_TimeoutLow   <= '1';
          o_PulseCounter <= c_TimeoutValueLow;
        END IF;
      END IF;
      --
      --
      --
      IF (NOT i_Active) THEN
        v_FSM := IDLE;
      END IF;
    END IF;
  END PROCESS proc_FSM;

END rtl;
