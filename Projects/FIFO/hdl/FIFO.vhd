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


ENTITY FIFO IS

  GENERIC (
    g_DataWidth : natural := 8;         -- width of the data words in bits
    g_DataDepth : natural := 4);        -- number of data words

  PORT (
    i_clock        : IN  std_logic;
    i_reset        : IN  std_logic;
    --
    i_Data         : IN  std_logic_vector(g_DataWidth - 1 DOWNTO 0);
    i_LoadIntoFIFO : IN  std_logic;
    i_ReadFromFIFO : IN  std_logic;
    --
    o_Data         : OUT std_logic_vector(g_DataWidth - 1 DOWNTO 0) := (OTHERS => '0');
    o_NumOfWords   : OUT std_logic_vector(31 DOWNTO 0)              := (OTHERS => '0');
    o_IsFull       : OUT std_logic                                  := '0';
    o_IsEmpty      : OUT std_logic                                  := '1'
    );

END FIFO;


ARCHITECTURE rtl OF FIFO IS


BEGIN  -- rtl

  proc_FIFO : PROCESS (i_clock, i_reset)
    VARIABLE v_NumOfWords : natural                                                           := 0;
    VARIABLE v_Register   : t_ArrayVector(g_DataDepth - 1 DOWNTO 0)(g_DataWidth - 1 DOWNTO 0) := (OTHERS => (OTHERS => '0'));
    VARIABLE v_LoadArray  : std_logic_vector(1 DOWNTO 0)                                      := (OTHERS => '0');
    VARIABLE v_ReadArray  : std_logic_vector(1 DOWNTO 0)                                      := (OTHERS => '0');
  BEGIN  -- PROCESS proc_FIFO
    IF (i_reset = c_reset_active) THEN            -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN  -- rising clock edge
      --
      -- shift data into the FIFO
      IF (v_LoadArray = c_RisingEdge AND NOT o_IsFull = '1') THEN
        v_Register   := v_Register(v_Register'length - 2 DOWNTO 0) & i_Data;
        v_NumOfWords := v_NumOfWords + 1;
      END IF;
      --
      -- read data from FIFO
      IF (v_ReadArray = c_RisingEdge AND NOT o_IsEmpty = '1') THEN
        o_Data       <= v_Register(v_NumOfWords - 1);
        v_NumOfWords := v_NumOfWords - 1;
      END IF;
      --
      v_LoadArray := v_LoadArray(0) & i_LoadIntoFIFO;
      v_ReadArray := v_ReadArray(0) & i_ReadFromFIFO;
      --
      -- check for full/empty
      o_IsFull    <= '0';
      o_IsEmpty   <= '0';
      --
      IF (v_NumOfWords = g_DataDepth) THEN
        o_IsFull <= '1';
      ELSIF (v_NumOfWords = 0) THEN
        o_IsEmpty <= '1';
      END IF;
      --
      --
      -- output number of waords in the FIFO
      o_NumOfWords <= std_logic_vector(to_unsigned(v_NumOfWords, o_NumOfWords'length));
    END IF;
  END PROCESS proc_FIFO;

END rtl;
