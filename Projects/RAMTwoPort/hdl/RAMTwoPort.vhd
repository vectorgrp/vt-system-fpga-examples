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


ENTITY RAMTwoPort IS

  GENERIC (
    g_AddressWidth : natural;
    g_DataWidth    : natural;
    g_MemInitFile  : string
    );
  PORT (
    i_clock         : IN  std_logic;
    i_reset         : IN  std_logic;
    --
    i_WriteEnable_a : IN  std_logic;
    i_WriteEnable_b : IN  std_logic;
    i_Data_a        : IN  std_logic_vector (g_DataWidth - 1 DOWNTO 0);
    i_Data_b        : IN  std_logic_vector (g_DataWidth - 1 DOWNTO 0);
    i_Address_a     : IN  natural RANGE 0 TO 2 ** g_AddressWidth - 1;
    i_Address_b     : IN  natural RANGE 0 TO 2 ** g_AddressWidth - 1;
    --
    o_Data_a        : OUT std_logic_vector (g_DataWidth - 1 DOWNTO 0) := (OTHERS => '0');
    o_Data_b        : OUT std_logic_vector (g_DataWidth - 1 DOWNTO 0) := (OTHERS => '0')
    );

END RAMTwoPort;


ARCHITECTURE rtl OF RAMTwoPort IS

  SHARED VARIABLE s_RAM            : t_ArrayVector(2 ** g_AddressWidth - 1 DOWNTO 0)(g_DataWidth - 1 DOWNTO 0);
  ATTRIBUTE ram_init_file          : string;
  ATTRIBUTE ram_init_file OF s_RAM : VARIABLE IS g_MemInitFile;

BEGIN  -- rtl

  -- port a
  proc_RAM_a : PROCESS (i_clock, i_reset)
  BEGIN  -- PROCESS proc_RAM_a
    IF (i_clock'event AND i_clock = '1') THEN  -- rising clock edge
      IF (i_WriteEnable_a) THEN
        s_RAM(i_Address_a) := i_Data_a;
      END IF;
      --
      o_Data_a <= s_RAM(i_Address_a);
    END IF;
  END PROCESS proc_RAM_a;

  --

  --port b
  proc_RAM_b : PROCESS (i_clock, i_reset)
  BEGIN  -- PROCESS proc_RAM_b
    IF (i_clock'event AND i_clock = '1') THEN  -- rising clock edge
      IF (i_WriteEnable_b) THEN
        s_RAM(i_Address_b) := i_Data_b;
      END IF;
      --
      o_Data_b <= s_RAM(i_Address_b);
    END IF;
  END PROCESS proc_RAM_b;

END rtl;
