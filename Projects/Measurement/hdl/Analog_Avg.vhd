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


ENTITY Analog_Avg IS

  GENERIC (
    g_DataWidth         : natural   := 32;
    g_BlockSizeExponent : natural   := 7;  -- 2 ** g_BlockSizeExponent = 128 Values
    g_UseBlock          : std_logic := '1';
    g_UseRolling        : std_logic := '1'
    );
  PORT (
    i_clock          : IN  std_logic;
    i_reset          : IN  std_logic;
    --
    i_Signal         : IN  std_logic_vector(g_DataWidth - 1 DOWNTO 0);
    i_NewValue       : IN  std_logic;
    --
    o_AvgBlock       : OUT std_logic_vector(g_DataWidth - 1 DOWNTO 0) := (OTHERS => '0');
    o_AvgRolling     : OUT std_logic_vector(g_DataWidth - 1 DOWNTO 0) := (OTHERS => '0');
    o_NewDataBlock   : OUT std_logic                                  := '0';
    o_NewDataRolling : OUT std_logic                                  := '0'
    );

END Analog_Avg;


ARCHITECTURE rtl OF Analog_Avg IS


BEGIN  -- rtl

  proc_AverageBlock : PROCESS (i_clock, i_reset)
    VARIABLE v_Counter : natural                                                := 0;
    VARIABLE v_Value   : signed(g_DataWidth + g_BlockSizeExponent - 1 DOWNTO 0) := (OTHERS => '0');
  BEGIN  -- PROCESS proc_AverageBlock
    IF (i_reset = c_reset_active) THEN                                                                   -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                                                         -- rising clock edge
      IF (g_UseBlock) THEN
        o_NewDataBlock <= '0';
        --
        IF (i_NewValue) THEN
          v_Value := v_Value + signed(i_Signal);                                                         -- add newest value
          --
          IF (v_Counter >= 2 ** g_BlockSizeExponent - 1) THEN                                            -- at least maximum number of values
            o_AvgBlock     <= std_logic_vector(v_Value(v_Value'length - 1 DOWNTO g_BlockSizeExponent));  -- only the top e.g. 32 bits -> divided by  g_BlockSizeExponent
            o_NewDataBlock <= '1';
            --
            v_Counter      := 0;                                                                         -- for the next value
            v_Value        := (OTHERS => '0');
          --
          ELSE
            v_Counter := v_Counter + 1;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS proc_AverageBlock;

  --

  proc_AverageRolling : PROCESS (i_clock, i_reset)
    VARIABLE v_ShiftRegister : t_ArraySigned(2 ** g_BlockSizeExponent - 1 DOWNTO 0)(g_DataWidth - 1 DOWNTO 0) := (OTHERS => (OTHERS => '0'));
    VARIABLE v_Value         : signed(g_DataWidth + g_BlockSizeExponent - 1 DOWNTO 0)                         := (OTHERS => '0');
  BEGIN  -- PROCESS proc_AverageRolling
    IF (i_reset = c_reset_active) THEN                                                                   -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                                                         -- rising clock edge
      IF (g_UseRolling) THEN
        o_NewDataRolling <= '0';
        --
        IF (i_NewValue) THEN
          v_Value          := v_Value + signed(i_Signal) - v_ShiftRegister(v_ShiftRegister'length - 1);  -- add the new value, remove the oldest value
          o_AvgRolling     <= std_logic_vector(v_Value(v_Value'length - 1 DOWNTO g_BlockSizeExponent));
          o_NewDataRolling <= '1';
          --
          v_ShiftRegister  := v_ShiftRegister(v_ShiftRegister'length - 2 DOWNTO 0) & signed(i_Signal);
        END IF;
      END IF;
    END IF;
  END PROCESS proc_AverageRolling;

END rtl;
