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


ENTITY SPI_Channel IS

  GENERIC (
    g_DataWidth    : natural;
    g_AddressWidth : natural;                              -- without the read/write bit
    g_Idle         : std_logic;                            -- tri-state
    g_nCS          : std_logic;                            -- chip select active value
    g_Read         : std_logic;                            -- 1: read; 0: write
    g_MOSIData     : t_ArrayNatural(1 TO 3) := (1, 7, 8);  -- width if the MOSI data
    g_MISOData     : t_ArrayNatural(1 TO 3) := (1, 7, 8);  -- width if the MISO data
    g_MemInitFile  : string                                -- name string for the RAM initialization file
    );
  PORT (
    i_clock           : IN  std_logic;
    i_reset           : IN  std_logic;
    --
    -- SPI sensor
    i_CPOL            : IN  std_logic;
    i_CPHA            : IN  std_logic;
    i_nCS             : IN  std_logic;
    i_SCLK            : IN  std_logic;
    --
    i_MOSI            : IN  std_logic;
    o_MISO            : OUT std_logic                                  := g_Idle;
    --
    i_ResetError      : IN  std_logic;
    o_ErrorCode       : OUT std_logic_vector(7 DOWNTO 0)               := (OTHERS => '0');
    --
    -- RAM
    i_RAM_WriteEnable : IN  std_logic;
    i_RAM_Data        : IN  std_logic_vector(g_DataWidth - 1 DOWNTO 0);
    i_RAM_Address     : IN  std_logic_vector(g_AddressWidth - 1 DOWNTO 0);
    o_RAM_Data        : OUT std_logic_vector(g_DataWidth - 1 DOWNTO 0) := (OTHERS => '0')
    );

END SPI_Channel;


ARCHITECTURE rtl OF SPI_Channel IS

  TYPE t_MOSI IS RECORD
    RW            : std_logic_vector(g_DataWidth - 1 DOWNTO 0);
    RW_Valid      : std_logic;
    Address       : std_logic_vector(g_DataWidth - 1 DOWNTO 0);
    Address_Valid : std_logic;
    Data          : std_logic_vector(g_DataWidth - 1 DOWNTO 0);
    Data_Valid    : std_logic;
  END RECORD;
  --
  TYPE t_MISO IS RECORD
    RW           : std_logic_vector(g_DataWidth - 1 DOWNTO 0);  -- response for the MOSI RW bit
    RW_Send      : std_logic;
    Address      : std_logic_vector(g_DataWidth - 1 DOWNTO 0);  -- response for the MOSI address bits
    Address_Send : std_logic;
    Data         : std_logic_vector(g_DataWidth - 1 DOWNTO 0);  -- response for the MOSI data bits
    Data_Send    : std_logic;
  END RECORD;
  --
  TYPE t_RAM IS RECORD
    WriteEnable : std_logic;
    DataIn      : std_logic_vector(g_DataWidth - 1 DOWNTO 0);
    Address     : natural RANGE 0 TO 2 ** g_AddressWidth - 1;
    DataOut     : std_logic_vector(g_DataWidth - 1 DOWNTO 0);
  END RECORD;
  --
  SIGNAL s_MOSI : t_MOSI := (
    RW            => (OTHERS => '0'),
    RW_Valid      => '0',
    Address       => (OTHERS => '0'),
    Address_Valid => '0',
    Data          => (OTHERS => '0'),
    Data_Valid    => '0');
  --
  SIGNAL s_MISO : t_MISO := (
    RW           => (OTHERS => g_Idle),
    RW_Send      => '0',
    Address      => (OTHERS => g_Idle),
    Address_Send => '0',
    Data         => (OTHERS => g_Idle),
    Data_Send    => '0');
  --
  SIGNAL s_RAM : t_RAM := (
    WriteEnable => '0',
    DataIn      => (OTHERS => '0'),
    Address     => 0,
    DataOut     => (OTHERS => '0'));


BEGIN  -- rtl

  -- MOSI reaction
  -- RW bit + 7 address bts + 8 data bits
  -- consecutive data in one frame will increment the RAM address (for writing and reading)
  proc_MOSI : PROCESS (i_clock, i_reset)
    VARIABLE v_NextAddress_Delay : std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');
  BEGIN  -- PROCESS proc_MOSI
    IF (i_reset = c_reset_active) THEN                                    -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN                          -- rising clock edge
      s_RAM.WriteEnable <= '0';
      --
      -- RW bit
      IF (s_MOSI.RW_Valid) THEN
        NULL;
      -- address bits
      ELSIF (s_MOSI.Address_Valid) THEN
        s_RAM.Address <= natural(to_integer(unsigned(s_MOSI.Address)));   -- initial RAM address
      -- data bits
      ELSIF (s_MOSI.Data_Valid = '1' AND s_MOSI.RW(0) = NOT g_Read) THEN  -- write command
        s_RAM.DataIn      <= s_MOSI.Data;                                 -- current data word
        s_RAM.WriteEnable <= '1';                                         -- enable for 1 cycle
      END IF;
      --
      -- next address
      -- delayed until the current data word is written/read
      IF (v_NextAddress_Delay(v_NextAddress_Delay'length - 1)) THEN       -- MSB = MOSI data valid
        s_RAM.Address <= s_RAM.Address + 1;                               -- next address
      END IF;
      --
      v_NextAddress_Delay := v_NextAddress_Delay(v_NextAddress_Delay'length - 2 DOWNTO 0) & s_MOSI.Data_Valid;
    END IF;
  END PROCESS proc_MOSI;

  --

  -- MISO reaction
  -- 8 bit IDLE (RW + address) + 8 data bits
  -- consecutive data in one frame will increment the RAM address (for writing and reading)
  proc_MISO : PROCESS (i_clock, i_reset)
  BEGIN  -- PROCESS proc_MISO
    IF (i_reset = c_reset_active) THEN            -- asynchronous reset (active package defined)
      NULL;
    ELSIF (i_clock'event AND i_clock = '1') THEN  -- rising clock edge
      --
      -- RW bit (always IDLE)
      s_MISO.RW(0)   <= g_Idle;
      --
      -- address bits (always IDLE)
      s_MISO.Address <= (OTHERS => g_Idle);
      --
      -- data bits
      IF (s_MOSI.RW(0) = g_Read) THEN             -- read command -> output current RAM data
        s_MISO.Data <= s_RAM.DataOut;
      ELSE                                        -- write command -> output IDLE
        s_MISO.Data <= (OTHERS => g_Idle);
      END IF;
    END IF;
  END PROCESS proc_MISO;

  --
  --
  --

  inst_SPI_Sensor : ENTITY work.SPI_Sensor
    GENERIC MAP (
      g_DataWidth    => g_DataWidth,
      g_AddressWidth => g_AddressWidth,
      g_Idle         => g_Idle,
      g_nCS          => g_nCS,
      g_Read         => g_Read,
      g_MOSIData     => g_MOSIData,
      g_MISOData     => g_MISOData
      )
    PORT MAP (
      i_clock            => i_clock,
      i_reset            => i_reset,
      i_CPOL             => i_CPOL,                -- CANoe
      i_CPHA             => i_CPHA,                -- CANoe
      i_nCS              => i_nCS,                 -- Phoenix
      i_SCLK             => i_SCLK,                -- Phoenix
      i_MOSI             => i_MOSI,                -- Phoenix
      o_DataMOSI(1)      => s_MOSI.RW,             -- sensor specific
      o_DataMOSI(2)      => s_MOSI.Address,        -- sensor specific
      o_DataMOSI(3)      => s_MOSI.Data,           -- sensor specific
      o_DataMOSIValid(1) => s_MOSI.RW_Valid,       -- sensor specific
      o_DataMOSIValid(2) => s_MOSI.Address_Valid,  -- sensor specific
      o_DataMOSIValid(3) => s_MOSI.Data_Valid,     -- sensor specific
      i_DataMISO(1)      => s_MISO.RW,             -- sensor specific
      i_DataMISO(2)      => s_MISO.Address,        -- sensor specific
      i_DataMISO(3)      => s_MISO.Data,           -- sensor specific
      o_DataMISOSend(1)  => s_MISO.RW_Send,        -- sensor specific
      o_DataMISOSend(2)  => s_MISO.Address_Send,   -- sensor specific
      o_DataMISOSend(3)  => s_MISO.Data_Send,      -- sensor specific
      o_MISO             => o_MISO,                -- Phoenix
      i_ResetError       => i_ResetError,          -- CANoe
      o_ErrorCode        => o_ErrorCode            -- CANoe
      );

  --

  inst_RAMTwoPort : ENTITY work.RAMTwoPort
    GENERIC MAP (
      g_AddressWidth => g_AddressWidth,
      g_DataWidth    => g_DataWidth,
      g_MemInitFile  => g_MemInitFile
      )
    PORT MAP (
      i_clock         => i_clock,
      i_reset         => i_reset,
      i_WriteEnable_a => s_RAM.WriteEnable,
      i_WriteEnable_b => i_RAM_WriteEnable,
      i_Data_a        => s_RAM.DataIn,
      i_Data_b        => i_RAM_Data,
      i_Address_a     => s_RAM.Address,
      i_Address_b     => natural(to_integer(unsigned(i_RAM_Address))),
      o_Data_a        => s_RAM.DataOut,
      o_Data_b        => o_RAM_Data
      );

END rtl;
