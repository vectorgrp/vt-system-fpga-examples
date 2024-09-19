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


ENTITY Analog_MinMax IS

  GENERIC (
    g_DataWidth : natural := 32
    );
  PORT (
    i_clock       : IN  std_logic;
    i_reset       : IN  std_logic;
    --
    i_Signal      : IN  std_logic_vector(g_DataWidth - 1 DOWNTO 0);
    i_NewValue    : IN  std_logic;
    i_ResetMinMax : IN  std_logic;
    --
    o_NewData     : OUT std_logic                                  := '0';
    o_Min         : OUT std_logic_vector(g_DataWidth - 1 DOWNTO 0) := (OTHERS => '0');
    o_Max         : OUT std_logic_vector(g_DataWidth - 1 DOWNTO 0) := (OTHERS => '0')
    );

END Analog_MinMax;


ARCHITECTURE rtl OF Analog_MinMax IS
  

BEGIN  -- rtl

  proc_MinMaxComparison : PROCESS (i_clock, i_reset)
    VARIABLE v_Min : signed(g_DataWidth - 1 DOWNTO 0) := (OTHERS => '0');
    VARIABLE v_Max : signed(g_DataWidth - 1 DOWNTO 0) := (OTHERS => '0');
  BEGIN  -- PROCESS proc_MinMaxComparison
    IF (i_reset = c_reset_active) THEN            -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN  -- rising clock edge
      o_NewData <= '0';
      --
      IF (i_ResetMinMax) THEN
        v_Min := (OTHERS => '0');
        v_Max := (OTHERS => '0');
        --
        o_Min <= (OTHERS => '0');
        o_Max <= (OTHERS => '0');
      --
      ELSIF (i_NewValue) THEN
        IF (signed(i_Signal) < v_Min) THEN        -- new minimum
          v_Min     := signed(i_Signal);
          o_Min     <= std_logic_vector(v_Min);
          o_NewData <= '1';
        --
        ELSIF (signed(i_Signal) > v_Max) THEN     -- new maximum
          v_Max     := signed(i_Signal);
          o_Max     <= std_logic_vector(v_Max);
          o_NewData <= '1';
        END IF;
      END IF;
    END IF;
  END PROCESS proc_MinMaxComparison;

END rtl;
