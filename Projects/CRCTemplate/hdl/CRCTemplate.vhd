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


ENTITY CRCTemplate IS

  GENERIC (
    g_Poly   : std_logic_vector;        -- CRC polynom
    g_Init   : std_logic_vector;        -- initial value
    g_XOROut : std_logic_vector
    );

  PORT (
    i_clock        : IN  std_logic;
    i_reset        : IN  std_logic;                                          -- max. degree of the CRC
    --
    i_DataBit      : IN  std_logic;                                          -- current data bit
    i_DataBitValid : IN  std_logic;                                          -- signals a new data bit
    i_SetInitValue :     std_logic;                                          -- set CRC shift register to inital value
    --
    o_CRC          : OUT std_logic_vector(g_Poly'range) := (OTHERS => '0');  -- CRC value
    o_CRCValid     : OUT std_logic                      := '0'               -- new CRC value
    );

END CRCTemplate;


ARCHITECTURE rtl OF CRCTemplate IS

  TYPE t_CRC IS RECORD
    ShiftRegister : std_logic_vector(g_Poly'range);
    BitValid      : std_logic;
  END RECORD;
  --
  SIGNAL s_CRC : t_CRC := (
    ShiftRegister => (OTHERS => '0'),
    BitValid      => '0');

BEGIN  -- rtl

  proc_CRC : PROCESS (i_clock, i_reset)
  BEGIN  -- PROCESS proc_CRC
    IF (i_reset = c_reset_active) THEN            -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN  -- rising clock edge
      s_CRC.BitValid <= '0';
      --
      IF (i_DataBitValid) THEN
        FOR n IN s_CRC.ShiftRegister'high DOWNTO 1 LOOP
          s_CRC.ShiftRegister(n) <= (((i_DataBit XOR s_CRC.ShiftRegister(s_CRC.ShiftRegister'high)) XOR s_CRC.ShiftRegister(n - 1)) AND g_Poly(n))
                                    OR
                                    (s_CRC.ShiftRegister(n - 1) AND NOT g_Poly(n));
        END LOOP;  -- n
        --
        s_CRC.ShiftRegister(0) <= i_DataBit XOR s_CRC.ShiftRegister(s_CRC.ShiftRegister'high);
        s_CRC.BitValid         <= '1';
      END IF;
      --
      --
      -- set init value
      IF (i_SetInitValue) THEN
        s_CRC.ShiftRegister <= g_Init;
      END IF;
    END IF;
  END PROCESS proc_CRC;

  --

  proc_Output : PROCESS (ALL)
  BEGIN  -- PROCESS proc_Output
    o_CRC      <= s_CRC.ShiftRegister XOR g_XOROut;
    o_CRCValid <= s_CRC.BitValid;
  END PROCESS proc_Output;

END rtl;
