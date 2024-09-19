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


ENTITY PhaseAccumulator IS

  GENERIC (
    fpga_frequency     : std_logic_vector(31 DOWNTO 0);
    g_Width            : natural                       := 32;     -- width/size of the phase accumulator counter
    g_ResolutionFactor : std_logic_vector(31 DOWNTO 0) := 32d"1"  -- the resolution factor is used for higher resolution; counter max. = fpga_frequency * c_ResolutionFactor - 1
    );

  PORT (
    i_clock                : IN  std_logic;
    i_reset                : IN  std_logic;
    --
    i_Active               : IN  std_logic;
    i_StartValue           : IN  std_logic_vector(g_Width -1 DOWNTO 0);
    i_SetStartValue        : IN  std_logic;
    i_FrequencyControlWord : IN  std_logic_vector(g_Width - 1 DOWNTO 0);
    --
    o_CounterValue         : OUT std_logic_vector(g_Width - 1 DOWNTO 0) := (OTHERS => '0');
    o_Overflow             : OUT std_logic                              := '0'
    );

END PhaseAccumulator;


ARCHITECTURE rtl OF PhaseAccumulator IS

  CONSTANT c_PACounterMaximum   : unsigned(g_Width - 1 DOWNTO 0) := resize(unsigned(fpga_frequency) * unsigned(g_ResolutionFactor) - 1, g_Width);
  --
  SIGNAL s_FrequencyControlWord : unsigned(g_Width - 1 DOWNTO 0) := (OTHERS => '0');

BEGIN  -- rtl

  proc_FrequencyControlWord : PROCESS (i_clock, i_reset)
  BEGIN  -- PROCESS proc_FrequencyControlWord
    IF (i_reset = c_reset_active) THEN                                          -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                                -- rising clock edge
      s_FrequencyControlWord <= unsigned(ABS(signed(i_FrequencyControlWord)));  -- absolute value
    END IF;
  END PROCESS proc_FrequencyControlWord;

  --

  proc_PhaseAccumulator : PROCESS (i_clock, i_reset)
  BEGIN  -- PROCESS proc_PhaseAccumulator
    IF (i_reset = c_reset_active) THEN                                                    -- asynchronous reset (active package defined)
      o_CounterValue <= (OTHERS => '0');
      o_Overflow     <= '0';
    ELSIF (i_clock'event AND i_clock = '1') THEN                                          -- rising clock edge
      o_Overflow <= '0';
      --
      IF (i_Active) THEN                                                                  -- active
        IF (unsigned(o_CounterValue) > c_PACounterMaximum - s_FrequencyControlWord) THEN  -- next imcrement would be bigger than the maximum -> overflow
          o_CounterValue <= std_logic_vector(unsigned(o_CounterValue) + s_FrequencyControlWord - c_PACounterMaximum - 1);
          o_Overflow     <= '1';
        ELSE
          o_CounterValue <= std_logic_vector(unsigned(o_CounterValue) + s_FrequencyControlWord);
        END IF;
        --
        IF (i_SetStartValue) THEN                                                         -- set start value for the counter; used e.g. for phaseshift
          o_CounterValue <= i_StartValue;
        END IF;
      --
      ELSE                                                                                -- inactive
        o_CounterValue <= (OTHERS => '0');
      END IF;
    END IF;
  END PROCESS proc_PhaseAccumulator;

END rtl;
