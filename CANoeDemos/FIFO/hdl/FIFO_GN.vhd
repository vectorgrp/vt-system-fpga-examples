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


-- User code VHD file

-- The VT2816A General-Purpose Analog I/O Module has 12 channels for measuring
-- analog voltages, of which 8 can also be used to measure currents.
-- You can output analog voltages on four further independent channels.
-- Also five debug LEDs are available.

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

LIBRARY work;
USE work.LibraryBase.ALL;


ENTITY User IS
  GENERIC (
    -- @CMD=CONSTSSTART
    fpga_frequency : std_logic_vector(31 DOWNTO 0) := 32d"80000000"
   -- @CMD=CONSTSEND
    );
  PORT (
    --
    -- @CMD=SYSVARSTART
    DataDownload_ch13 : in std_logic_vector(31 downto 0);
    DataDownload_ch14 : in std_logic_vector(31 downto 0);
    DataDownload_ch15 : in std_logic_vector(31 downto 0);
    DataDownload_ch16 : in std_logic_vector(31 downto 0);
    Download_ch13 : in std_logic_vector(0 downto 0);
    Download_ch14 : in std_logic_vector(0 downto 0);
    Download_ch15 : in std_logic_vector(0 downto 0);
    Download_ch16 : in std_logic_vector(0 downto 0);
    Send_ch13 : in std_logic_vector(0 downto 0);
    Send_ch14 : in std_logic_vector(0 downto 0);
    Send_ch15 : in std_logic_vector(0 downto 0);
    Send_ch16 : in std_logic_vector(0 downto 0);
    NumOfWords_ch13 : out std_logic_vector(31 downto 0) := (others => '0');
    NumOfWords_ch14 : out std_logic_vector(31 downto 0) := (others => '0');
    NumOfWords_ch15 : out std_logic_vector(31 downto 0) := (others => '0');
    NumOfWords_ch16 : out std_logic_vector(31 downto 0) := (others => '0');
    IsFull_ch13 : out std_logic_vector(0 downto 0) := (others => '0');
    IsFull_ch14 : out std_logic_vector(0 downto 0) := (others => '0');
    IsFull_ch15 : out std_logic_vector(0 downto 0) := (others => '0');
    IsFull_ch16 : out std_logic_vector(0 downto 0) := (others => '0');
    IsEmpty_ch13 : out std_logic_vector(0 downto 0) := (others => '0');
    IsEmpty_ch14 : out std_logic_vector(0 downto 0) := (others => '0');
    IsEmpty_ch15 : out std_logic_vector(0 downto 0) := (others => '0');
    IsEmpty_ch16 : out std_logic_vector(0 downto 0) := (others => '0');
    DataUpload_ch1 : out std_logic_vector(31 downto 0) := (others => '0');
    DataUpload_ch2 : out std_logic_vector(31 downto 0) := (others => '0');
    DataUpload_ch3 : out std_logic_vector(31 downto 0) := (others => '0');
    DataUpload_ch4 : out std_logic_vector(31 downto 0) := (others => '0');
    Upload_ch1 : in std_logic_vector(0 downto 0);
    Upload_ch2 : in std_logic_vector(0 downto 0);
    Upload_ch3 : in std_logic_vector(0 downto 0);
    Upload_ch4 : in std_logic_vector(0 downto 0);
    NumOfWords_ch1 : out std_logic_vector(31 downto 0) := (others => '0');
    NumOfWords_ch2 : out std_logic_vector(31 downto 0) := (others => '0');
    NumOfWords_ch3 : out std_logic_vector(31 downto 0) := (others => '0');
    NumOfWords_ch4 : out std_logic_vector(31 downto 0) := (others => '0');
    IsFull_ch1 : out std_logic_vector(0 downto 0) := (others => '0');
    IsFull_ch2 : out std_logic_vector(0 downto 0) := (others => '0');
    IsFull_ch3 : out std_logic_vector(0 downto 0) := (others => '0');
    IsFull_ch4 : out std_logic_vector(0 downto 0) := (others => '0');
    IsEmpty_ch1 : out std_logic_vector(0 downto 0) := (others => '0');
    IsEmpty_ch2 : out std_logic_vector(0 downto 0) := (others => '0');
    IsEmpty_ch3 : out std_logic_vector(0 downto 0) := (others => '0');
    IsEmpty_ch4 : out std_logic_vector(0 downto 0) := (others => '0');
    StoreUpload_ch1 : in std_logic_vector(0 downto 0);
    StoreUpload_ch2 : in std_logic_vector(0 downto 0);
    StoreUpload_ch3 : in std_logic_vector(0 downto 0);
    StoreUpload_ch4 : in std_logic_vector(0 downto 0);
    -- @CMD=SYSVAREND
    --
    -- @CMD=TIMESTAMPSTART
    -- @CMD=TIMESTAMPEND
    --
    -- @CMD=IBCSTART
    in_ibc_1   : IN std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- in_ibc_1.wire
    in_ibc_2   : IN std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- in_ibc_2.wire
    in_ibc_3   : IN std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- in_ibc_3.wire
    in_ibc_4   : IN std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- in_ibc_4.wire

    out_ibc_1   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- out_ibc_1.wire
    out_ibc_2   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- out_ibc_2.wire
    out_ibc_3   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- out_ibc_3.wire
    out_ibc_4   : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- out_ibc_4.wire
    -- @CMD=IBCEND
    --
    clk             : IN  std_logic;                                         -- Clock.clk
    areset          : IN  std_logic;                                         -- .reset
    h_areset        : IN  std_logic;
    --
    in_adc_1        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 1 (voltage or current)
    in_adc_2        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 2 (voltage or current)
    in_adc_3        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 3 (voltage or current)
    in_adc_4        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 4 (voltage or current)
    in_adc_5        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 5 (voltage or current)
    in_adc_6        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 6 (voltage or current)
    in_adc_7        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 7 (voltage or current)
    in_adc_8        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 8 (voltage or current)
    in_adc_9        : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 9 (voltage)
    in_adc_10       : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 10 (voltage)
    in_adc_11       : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 11 (voltage)
    in_adc_12       : IN  std_logic_vector(31 DOWNTO 0);                     -- analog input channel 12 (voltage)
    --
    out_dac_1       : OUT std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- analog voltage output on output channel 1
    out_dac_2       : OUT std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- analog voltage output on output channel 2
    out_dac_4       : OUT std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- analog voltage output on output channel 3
    out_dac_3       : OUT std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');  -- analog voltage output on output channel 4
    --
    in_adc_update   : IN  std_logic_vector(12 DOWNTO 1);                     -- ADC update notifications
    in_invar_update : IN  std_logic;                                         -- invar update notification
    in_timestamp    : IN  std_logic_vector(63 DOWNTO 0);                     -- current module time
    --
    debug_LED_1     : OUT std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- debug LED 1
    debug_LED_2     : OUT std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- debug LED 2
    debug_LED_3     : OUT std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- debug LED 3
    debug_LED_4     : OUT std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0');  -- debug LED 4
    debug_LED_5     : OUT std_logic_vector(0 DOWNTO 0)  := (OTHERS => '0')   -- debug LED 5
    );
END;

ARCHITECTURE rtl OF User IS

  -- @CMD=MODELRECORDSTART
  -- @CMD=MODELRECORDEND

  CONSTANT c_NumOfDownloadChannels : natural := 4;
  CONSTANT c_NumOfUploadChannels   : natural := 4;
  --
  SUBTYPE c_NumOfDownloadChannelsRange IS natural RANGE 1 TO c_NumOfDownloadChannels;
  SUBTYPE c_NumOfUploadChannelsRange IS natural RANGE 1 TO c_NumOfUploadChannels;
  --
  TYPE t_GenericsFIFO IS RECORD
    DataWidth : natural;
    DataDepth : natural;
  END RECORD;
  --
  CONSTANT c_GenericsFIFO : t_GenericsFIFO := (
    DataWidth => 32,
    DataDepth => 16);
  --
  TYPE t_SignalsFIFO IS RECORD
    DataIn       : std_logic_vector(DataDownload_ch13'range);
    LoadIntoFIFO : std_logic;
    ReadFromFIFO : std_logic;
    DataOut      : std_logic_vector(out_dac_1'range);
    NumOfWords   : std_logic_vector(NumOfWords_ch13'range);
    IsFull       : std_logic;
    IsEmpty      : std_logic;
  END RECORD;
  --
  TYPE t_DownloadFIFOArray IS ARRAY (c_NumOfDownloadChannelsRange) OF t_SignalsFIFO;
  TYPE t_UploadFIFOArray IS ARRAY (c_NumOfDownloadChannelsRange) OF t_SignalsFIFO;
  --
  SIGNAL s_DownloadFIFO : t_DownloadFIFOArray := (
    OTHERS         => (
      DataIn       => (OTHERS => '0'),
      LoadIntoFIFO => '0',
      ReadFromFIFO => '0',
      DataOut      => (OTHERS => '0'),
      NumOfWords   => (OTHERS => '0'),
      IsFull       => '0',
      IsEmpty      => '1'));
  --
  SIGNAL s_UploadFIFO : t_DownloadFIFOArray := (
    OTHERS         => (
      DataIn       => (OTHERS => '0'),
      LoadIntoFIFO => '0',
      ReadFromFIFO => '0',
      DataOut      => (OTHERS => '0'),
      NumOfWords   => (OTHERS => '0'),
      IsFull       => '0',
      IsEmpty      => '1'));
  --
  TYPE t_DownloadControl IS RECORD
    StartArray : std_logic_vector(1 DOWNTO 0);
    Pause      : natural;
  END RECORD;
  --
  TYPE t_DownloadControlArray IS ARRAY (c_NumOfDownloadChannelsRange) OF t_DownloadControl;
  --
  SIGNAL s_DownloadControl : t_DownloadControlArray := (
    OTHERS       => (
      StartArray => (OTHERS => '0'),
      Pause      => natural(to_integer(unsigned(fpga_frequency)))));

BEGIN

  -- @CMD=MODELMAPSTART
  -- @CMD=MODELMAPEND

  proc_DownloadSignals : PROCESS (ALL)
  BEGIN  -- PROCESS proc_DownloadSignals
    s_DownloadFIFO(1).DataIn       <= DataDownload_ch13;
    s_DownloadFIFO(2).DataIn       <= DataDownload_ch14;
    s_DownloadFIFO(3).DataIn       <= DataDownload_ch15;
    s_DownloadFIFO(4).DataIn       <= DataDownload_ch16;
    --
    s_DownloadFIFO(1).LoadIntoFIFO <= Download_ch13(0);
    s_DownloadFIFO(2).LoadIntoFIFO <= Download_ch14(0);
    s_DownloadFIFO(3).LoadIntoFIFO <= Download_ch15(0);
    s_DownloadFIFO(4).LoadIntoFIFO <= Download_ch16(0);
    --
    out_dac_1                      <= s_DownloadFIFO(1).DataOut;
    out_dac_2                      <= s_DownloadFIFO(2).DataOut;
    out_dac_3                      <= s_DownloadFIFO(3).DataOut;
    out_dac_4                      <= s_DownloadFIFO(4).DataOut;
    --
    NumOfWords_ch13                <= s_DownloadFIFO(1).NumOfWords;
    NumOfWords_ch14                <= s_DownloadFIFO(2).NumOfWords;
    NumOfWords_ch15                <= s_DownloadFIFO(3).NumOfWords;
    NumOfWords_ch16                <= s_DownloadFIFO(4).NumOfWords;
    --
    IsFull_ch13(0)                 <= s_DownloadFIFO(1).IsFull;
    IsFull_ch14(0)                 <= s_DownloadFIFO(2).IsFull;
    IsFull_ch15(0)                 <= s_DownloadFIFO(3).IsFull;
    IsFull_ch16(0)                 <= s_DownloadFIFO(4).IsFull;
    --
    IsEmpty_ch13(0)                <= s_DownloadFIFO(1).IsEmpty;
    IsEmpty_ch14(0)                <= s_DownloadFIFO(2).IsEmpty;
    IsEmpty_ch15(0)                <= s_DownloadFIFO(3).IsEmpty;
    IsEmpty_ch16(0)                <= s_DownloadFIFO(4).IsEmpty;
  END PROCESS proc_DownloadSignals;

  --

  proc_DownloadControlSignals : PROCESS (ALL)
  BEGIN  -- PROCESS proc_DownloadControlSignals
    IF (areset = c_reset_active) THEN     -- asynchronous reset (active package defined)
      NULL;
    ELSIF (clk'event AND clk = '1') THEN  -- rising clock edge
      s_DownloadControl(1).StartArray <= s_DownloadControl(1).StartArray(0) & Send_ch13;
      s_DownloadControl(2).StartArray <= s_DownloadControl(2).StartArray(0) & Send_ch14;
      s_DownloadControl(3).StartArray <= s_DownloadControl(3).StartArray(0) & Send_ch15;
      s_DownloadControl(4).StartArray <= s_DownloadControl(4).StartArray(0) & Send_ch16;
      --
      s_DownloadFIFO(1).ReadFromFIFO  <= '0';
      s_DownloadFIFO(2).ReadFromFIFO  <= '0';
      s_DownloadFIFO(3).ReadFromFIFO  <= '0';
      s_DownloadFIFO(4).ReadFromFIFO  <= '0';
      --
      IF (s_DownloadControl(1).StartArray = c_RisingEdge) THEN
        s_DownloadFIFO(1).ReadFromFIFO <= '1';
      END IF;
      --
      IF (s_DownloadControl(2).StartArray = c_RisingEdge) THEN
        s_DownloadFIFO(2).ReadFromFIFO <= '1';
      END IF;
      --
      IF (s_DownloadControl(3).StartArray = c_RisingEdge) THEN
        s_DownloadFIFO(3).ReadFromFIFO <= '1';
      END IF;
      --
      IF (s_DownloadControl(4).StartArray = c_RisingEdge) THEN
        s_DownloadFIFO(4).ReadFromFIFO <= '1';
      END IF;
    END IF;
  END PROCESS proc_DownloadControlSignals;

  --

  DownloadFIFOs : FOR Channel IN c_NumOfDownloadChannelsRange GENERATE
    inst_FIFO : ENTITY work.FIFO
      GENERIC MAP (
        g_DataWidth => c_GenericsFIFO.DataWidth,
        g_DataDepth => c_GenericsFIFO.DataDepth
        )
      PORT MAP (
        i_clock        => clk,
        i_reset        => areset,
        i_Data         => s_DownloadFIFO(Channel).DataIn,
        i_LoadIntoFIFO => s_DownloadFIFO(Channel).LoadIntoFIFO,
        i_ReadFromFIFO => s_DownloadFIFO(Channel).ReadFromFIFO,
        o_Data         => s_DownloadFIFO(Channel).DataOut,
        o_NumOfWords   => s_DownloadFIFO(Channel).NumOfWords,
        o_IsFull       => s_DownloadFIFO(Channel).IsFull,
        o_IsEmpty      => s_DownloadFIFO(Channel).IsEmpty
        );
  END GENERATE DownloadFIFOs;

  --
  --
  --

  proc_UploadSignals : PROCESS (ALL)
  BEGIN  -- PROCESS proc_UploadSignals
    s_UploadFIFO(1).DataIn       <= in_adc_1;
    s_UploadFIFO(2).DataIn       <= in_adc_2;
    s_UploadFIFO(3).DataIn       <= in_adc_3;
    s_UploadFIFO(4).DataIn       <= in_adc_4;
    --
    s_UploadFIFO(1).LoadIntoFIFO <= StoreUpload_ch1(0);
    s_UploadFIFO(2).LoadIntoFIFO <= StoreUpload_ch2(0);
    s_UploadFIFO(3).LoadIntoFIFO <= StoreUpload_ch3(0);
    s_UploadFIFO(4).LoadIntoFIFO <= StoreUpload_ch4(0);
    --
    s_UploadFIFO(1).ReadFromFIFO <= Upload_ch1(0);
    s_UploadFIFO(2).ReadFromFIFO <= Upload_ch2(0);
    s_UploadFIFO(3).ReadFromFIFO <= Upload_ch3(0);
    s_UploadFIFO(4).ReadFromFIFO <= Upload_ch4(0);
    --
    DataUpload_ch1               <= s_UploadFIFO(1).DataOut;
    DataUpload_ch2               <= s_UploadFIFO(2).DataOut;
    DataUpload_ch3               <= s_UploadFIFO(3).DataOut;
    DataUpload_ch4               <= s_UploadFIFO(4).DataOut;
    --
    NumOfWords_ch1               <= s_UploadFIFO(1).NumOfWords;
    NumOfWords_ch2               <= s_UploadFIFO(2).NumOfWords;
    NumOfWords_ch3               <= s_UploadFIFO(3).NumOfWords;
    NumOfWords_ch4               <= s_UploadFIFO(4).NumOfWords;
    --
    IsFull_ch1(0)                <= s_UploadFIFO(1).IsFull;
    IsFull_ch2(0)                <= s_UploadFIFO(2).IsFull;
    IsFull_ch3(0)                <= s_UploadFIFO(3).IsFull;
    IsFull_ch4(0)                <= s_UploadFIFO(4).IsFull;
    --
    IsEmpty_ch1(0)               <= s_UploadFIFO(1).IsEmpty;
    IsEmpty_ch2(0)               <= s_UploadFIFO(2).IsEmpty;
    IsEmpty_ch3(0)               <= s_UploadFIFO(3).IsEmpty;
    IsEmpty_ch4(0)               <= s_UploadFIFO(4).IsEmpty;
  END PROCESS proc_UploadSignals;

  --

  UploadFIFOs : FOR Channel IN c_NumOfUploadChannelsRange GENERATE
    inst_FIFO : ENTITY work.FIFO
      GENERIC MAP (
        g_DataWidth => c_GenericsFIFO.DataWidth,
        g_DataDepth => c_GenericsFIFO.DataDepth
        )
      PORT MAP (
        i_clock        => clk,
        i_reset        => areset,
        i_Data         => s_UploadFIFO(Channel).DataIn,
        i_LoadIntoFIFO => s_UploadFIFO(Channel).LoadIntoFIFO,
        i_ReadFromFIFO => s_UploadFIFO(Channel).ReadFromFIFO,
        o_Data         => s_UploadFIFO(Channel).DataOut,
        o_NumOfWords   => s_UploadFIFO(Channel).NumOfWords,
        o_IsFull       => s_UploadFIFO(Channel).IsFull,
        o_IsEmpty      => s_UploadFIFO(Channel).IsEmpty
        );
  END GENERATE UploadFIFOs;

END ARCHITECTURE rtl;  -- of  User
