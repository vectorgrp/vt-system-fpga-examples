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

-- The VT2710 Sensor Module supports various protocols.
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
    Tx_Baudrate_ch7 : in std_logic_vector(31 downto 0);
    Tx_Parity_ch7 : in std_logic_vector(7 downto 0);
    Tx_DataWidth_ch7 : in std_logic_vector(7 downto 0);
    Tx_StopWidth_ch7 : in std_logic_vector(7 downto 0);
    Tx_Data_ch7 : in std_logic_vector(31 downto 0);
    Tx_Send_ch7 : in std_logic_vector(0 downto 0);
    Tx_DownloadData_ch7 : in std_logic_vector(0 downto 0);
    Tx_NumOfWords_ch7 : out std_logic_vector(31 downto 0) := (others => '0');
    Tx_IsFull_ch7 : out std_logic_vector(0 downto 0) := (others => '0');
    Tx_IsEmpty_ch7 : out std_logic_vector(0 downto 0) := (others => '0');
    Tx_Pause_ch7 : in std_logic_vector(31 downto 0);
    Rx_Baudrate_ch7 : in std_logic_vector(31 downto 0);
    Rx_Parity_ch7 : in std_logic_vector(7 downto 0);
    Rx_DataWidth_ch7 : in std_logic_vector(7 downto 0);
    Rx_StopWidth_ch7 : in std_logic_vector(7 downto 0);
    Rx_Active_ch7 : in std_logic_vector(0 downto 0);
    Rx_Data_ch7 : out std_logic_vector(15 downto 0) := (others => '0');
    Rx_UploadData_ch7 : in std_logic_vector(0 downto 0);
    Rx_NumOfWords_ch7 : out std_logic_vector(31 downto 0) := (others => '0');
    Rx_IsFull_ch7 : out std_logic_vector(0 downto 0) := (others => '0');
    Rx_IsEmpty_ch7 : out std_logic_vector(0 downto 0) := (others => '0');
    Tx_Baudrate_ch8 : in std_logic_vector(31 downto 0);
    Tx_Parity_ch8 : in std_logic_vector(7 downto 0);
    Tx_DataWidth_ch8 : in std_logic_vector(7 downto 0);
    Tx_StopWidth_ch8 : in std_logic_vector(7 downto 0);
    Tx_Data_ch8 : in std_logic_vector(31 downto 0);
    Tx_Send_ch8 : in std_logic_vector(0 downto 0);
    Tx_DownloadData_ch8 : in std_logic_vector(0 downto 0);
    Tx_NumOfWords_ch8 : out std_logic_vector(31 downto 0) := (others => '0');
    Tx_IsFull_ch8 : out std_logic_vector(0 downto 0) := (others => '0');
    Tx_IsEmpty_ch8 : out std_logic_vector(0 downto 0) := (others => '0');
    Tx_Pause_ch8 : in std_logic_vector(31 downto 0);
    Rx_Baudrate_ch8 : in std_logic_vector(31 downto 0);
    Rx_Parity_ch8 : in std_logic_vector(7 downto 0);
    Rx_DataWidth_ch8 : in std_logic_vector(7 downto 0);
    Rx_StopWidth_ch8 : in std_logic_vector(7 downto 0);
    Rx_Active_ch8 : in std_logic_vector(0 downto 0);
    Rx_Data_ch8 : out std_logic_vector(15 downto 0) := (others => '0');
    Rx_UploadData_ch8 : in std_logic_vector(0 downto 0);
    Rx_NumOfWords_ch8 : out std_logic_vector(31 downto 0) := (others => '0');
    Rx_IsFull_ch8 : out std_logic_vector(0 downto 0) := (others => '0');
    Rx_IsEmpty_ch8 : out std_logic_vector(0 downto 0) := (others => '0');
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
    clk                    : IN  std_logic;                                        -- Clock.clk
    areset                 : IN  std_logic;                                        -- .reset
    h_areset               : IN  std_logic;
    --
    in_con1_dio1           : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 1, pin 9
    in_con1_dio2_rs232_rx  : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 1, pin 8
    in_con1_dio3           : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 1, pin 7
    in_con1_dio4_rs485_rx  : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 1, pin 6
    in_con1_dio5           : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 1, pin 5
    in_con1_dio6           : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 1, pin 4
    in_con1_dio7_i2c_sda   : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 1, pin 3
    in_con1_dio8_i2c_scl   : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 1, pin 2
    --
    out_con1_dio1_rs232_tx : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 9
    out_con1_dio2          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 8
    out_con1_dio3_rs485_tx : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 7
    out_con1_dio4          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 6
    out_con1_dio5_rs485_oe : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 5
    out_con1_dio6          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 4
    out_con1_dio7_i2c_sda  : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 3
    out_con1_dio8_i2c_scl  : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 1, pin 2
    --
    in_con2_dio1           : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 2, pin 9
    in_con2_dio2_rs232_rx  : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 2, pin 8
    in_con2_dio3           : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 2, pin 7
    in_con2_dio4_rs485_rx  : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 2, pin 6
    in_con2_dio5           : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 2, pin 5
    in_con2_dio6           : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 2, pin 4
    in_con2_dio7_i2c_sda   : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 2, pin 3
    in_con2_dio8_i2c_scl   : IN  std_logic_vector(0 DOWNTO 0);                     -- Connector 2, pin 2
    --
    out_con2_dio1_rs232_tx : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 9
    out_con2_dio2          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 8
    out_con2_dio3_rs485_tx : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 7
    out_con2_dio4          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 6
    out_con2_dio5_rs485_oe : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 5
    out_con2_dio6          : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 4
    out_con2_dio7_i2c_sda  : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 3
    out_con2_dio8_i2c_scl  : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- Connector 2, pin 2
    --
    in_lvds_1              : IN  std_logic_vector(0 DOWNTO 0);                     -- lvds channel 1 input
    in_lvds_2              : IN  std_logic_vector(0 DOWNTO 0);                     -- lvds channel 2 input
    --
    out_lvds_1             : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- lvds channel 1 output
    out_lvds_2             : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- lvds channel 2 output
    --
    in_invar_update        : IN  std_logic;                                        -- invar update notification
    in_timestamp           : IN  std_logic_vector(63 DOWNTO 0);                    -- current module time
    --
    debug_LED_1            : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- debug LED 1
    debug_LED_2            : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- debug LED 2
    debug_LED_3            : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- debug LED 3
    debug_LED_4            : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0');  -- debug LED 4
    debug_LED_5            : OUT std_logic_vector(0 DOWNTO 0) := (OTHERS => '0')   -- debug LED 5
    );
END;

ARCHITECTURE rtl OF User IS

  -- @CMD=MODELRECORDSTART
  -- @CMD=MODELRECORDEND

  CONSTANT c_NumOfTxChannels : natural := 2;
  CONSTANT c_NumOfRxChannels : natural := 2;
  --
  SUBTYPE t_TxChannelsRange IS natural RANGE 1 TO c_NumOfTxChannels;
  SUBTYPE t_RxChannelsRange IS natural RANGE 1 TO c_NumOfRxChannels;
  --
  TYPE t_FIFOGenerics IS RECORD
    DataWidth : natural;
    DataDepth : natural;
  END RECORD;
  --
  CONSTANT c_FIFOGenerics : t_FIFOGenerics := (
    DataWidth => 9,
    DataDepth => 50);
  --
  TYPE t_FIFO IS RECORD
    DataIn       : std_logic_vector(c_FIFOGenerics.DataWidth - 1 DOWNTO 0);
    LoadIntoFIFO : std_logic;
    ReadFromFIFO : std_logic;
    DataOut      : std_logic_vector(c_FIFOGenerics.DataWidth - 1 DOWNTO 0);
    NumOfWords   : std_logic_vector(31 DOWNTO 0);
    IsFull       : std_logic;
    IsEmpty      : std_logic;
    Send         : std_logic;
    Pause        : natural;
  END RECORD;
  --
  TYPE t_Tx_FIFOArray IS ARRAY (t_TxChannelsRange) OF t_FIFO;
  --
  SIGNAL s_Tx_FIFO : t_Tx_FIFOArray := (
    OTHERS         => (
      DataIn       => (OTHERS => '0'),
      LoadIntoFIFO => '0',
      ReadFromFIFO => '0',
      DataOut      => (OTHERS => '0'),
      NumOfWords   => (OTHERS => '0'),
      IsFull       => '0',
      IsEmpty      => '1',
      Send         => '0',
      Pause        => 0));
  --
  TYPE t_Rx_FIFOArray IS ARRAY (t_RxChannelsRange) OF t_FIFO;
  --
  SIGNAL s_Rx_FIFO : t_Rx_FIFOArray := (
    OTHERS         => (
      DataIn       => (OTHERS => '0'),
      LoadIntoFIFO => '0',
      ReadFromFIFO => '0',
      DataOut      => (OTHERS => '0'),
      NumOfWords   => (OTHERS => '0'),
      IsFull       => '0',
      IsEmpty      => '1',
      Send         => '0',
      Pause        => 0));
  --
  TYPE t_FSMTransmitter IS (IDLE, READFROMFIFO, SEND, MESSAGESEND, PAUSE);
  --
  TYPE t_Transmitter IS RECORD
    Baudrate    : std_logic_vector(31 DOWNTO 0);
    Parity      : std_logic_vector(2 DOWNTO 0);
    DataWidth   : std_logic_vector(3 DOWNTO 0);
    StopWidth   : std_logic_vector(1 DOWNTO 0);
    DataIn      : std_logic_vector(8 DOWNTO 0);
    Send        : std_logic;
    ErrorCode   : std_logic_vector(7 DOWNTO 0);
    OutSignal   : std_logic;
    MessageSend : std_logic;
  END RECORD;
  --
  TYPE t_TransmitterArray IS ARRAY (t_TxChannelsRange) OF t_Transmitter;
  --
  SIGNAL s_Transmitter : t_TransmitterArray := (
    OTHERS        => (
      Baudrate    => 32d"1000",
      Parity      => 3d"0",
      DataWidth   => 4d"8",
      StopWidth   => 2d"1",
      DataIn      => 9d"0",
      Send        => '0',
      ErrorCode   => (OTHERS => '0'),
      OutSignal   => '0',
      MessageSend => '0'));
  --
  TYPE t_Receiver IS RECORD
    Baudrate   : std_logic_vector(31 DOWNTO 0);
    Parity     : std_logic_vector(2 DOWNTO 0);
    DataWidth  : std_logic_vector(3 DOWNTO 0);
    StopWidth  : std_logic_vector(1 DOWNTO 0);
    Active     : std_logic;
    InSignal   : std_logic;
    ResetError : std_logic;
    DataOut    : std_logic_vector(8 DOWNTO 0);
    ErrorCode  : std_logic_vector(7 DOWNTO 0);
  END RECORD;
  --
  TYPE t_ReceiverArray IS ARRAY (t_RxChannelsRange) OF t_Receiver;
  --
  SIGNAL s_Receiver : t_ReceiverArray := (
    OTHERS       => (
      Baudrate   => 32d"1000",
      Parity     => 3d"0",
      DataWidth  => 4d"8",
      StopWidth  => 2d"1",
      Active     => '0',
      InSignal   => '0',
      ResetError => '0',
      DataOut    => (OTHERS => '0'),
      ErrorCode  => (OTHERS => '0')));

BEGIN

  --
  -- debug
  --

  proc_Debug: PROCESS (ALL)
  BEGIN  -- PROCESS proc_Debug
    debug_LED_1(0) <= s_Receiver(1).ErrorCode(1);
  END PROCESS proc_Debug;

  

  -- @CMD=MODELMAPSTART
  -- @CMD=MODELMAPEND

  proc_SignalAllocation : PROCESS (ALL)
  BEGIN  -- PROCESS proc_SignalAllocation
    --
    -- Tx_FIFO 1
    s_Tx_FIFO(1).DataIn                     <= Tx_Data_ch7(s_Tx_FIFO(1).DataIn'range);
    s_Tx_FIFO(1).LoadIntoFIFO               <= Tx_DownloadData_ch7(0);
    s_Tx_FIFO(1).Send                       <= Tx_Send_ch7(0);
    s_Tx_FIFO(1).Pause                      <= natural(to_integer(unsigned(Tx_Pause_ch7)));
    Tx_NumOfWords_ch7                       <= s_Tx_FIFO(1).NumOfWords;
    Tx_IsFull_ch7(0)                        <= s_Tx_FIFO(1).IsFull;
    Tx_IsEmpty_ch7(0)                       <= s_Tx_FIFO(1).IsEmpty;
    --
    -- Tx_FIFO 2
    s_Tx_FIFO(2).DataIn                     <= Tx_Data_ch8(s_Tx_FIFO(2).DataIn'range);
    s_Tx_FIFO(2).LoadIntoFIFO               <= Tx_DownloadData_ch8(0);
    s_Tx_FIFO(2).Send                       <= Tx_Send_ch8(0);
    s_Tx_FIFO(2).Pause                      <= natural(to_integer(unsigned(Tx_Pause_ch8)));
    Tx_NumOfWords_ch8                       <= s_Tx_FIFO(2).NumOfWords;
    Tx_IsFull_ch8(0)                        <= s_Tx_FIFO(2).IsFull;
    Tx_IsEmpty_ch8(0)                       <= s_Tx_FIFO(2).IsEmpty;
    --
    -- transmitter 1
    s_Transmitter(1).Baudrate               <= Tx_Baudrate_ch7;
    s_Transmitter(1).Parity                 <= Tx_Parity_ch7(s_Transmitter(1).Parity'range);
    s_Transmitter(1).DataWidth              <= Tx_DataWidth_ch7(s_Transmitter(1).DataWidth'range);
    s_Transmitter(1).StopWidth              <= Tx_StopWidth_ch7(s_Transmitter(1).StopWidth'range);
    s_Transmitter(1).DataIn                 <= s_Tx_FIFO(1).DataOut;        -- FIFO
    out_con1_dio1_rs232_tx(0)               <= s_Transmitter(1).OutSignal;  -- phoenix
    --
    -- transmitter 2
    s_Transmitter(2).Baudrate               <= Tx_Baudrate_ch8;
    s_Transmitter(2).Parity                 <= Tx_Parity_ch8(s_Transmitter(2).Parity'range);
    s_Transmitter(2).DataWidth              <= Tx_DataWidth_ch8(s_Transmitter(2).DataWidth'range);
    s_Transmitter(2).StopWidth              <= Tx_StopWidth_ch8(s_Transmitter(2).StopWidth'range);
    s_Transmitter(2).DataIn                 <= s_Tx_FIFO(2).DataOut;        -- FIFO
    out_con2_dio1_rs232_tx(0)               <= s_Transmitter(2).OutSignal;  -- phoenix
    --
    -- receiver 1
    s_Receiver(1).Baudrate                  <= Rx_Baudrate_ch7;
    s_Receiver(1).Parity                    <= Rx_Parity_ch7(s_Receiver(1).Parity'range);
    s_Receiver(1).DataWidth                 <= Rx_DataWidth_ch7(s_Receiver(1).DataWidth'range);
    s_Receiver(1).StopWidth                 <= Rx_StopWidth_ch7(s_Receiver(1).StopWidth'range);
    s_Receiver(1).Active                    <= Rx_Active_ch7(0);
    s_Receiver(1).InSignal                  <= in_con1_dio2_rs232_rx(0);    -- phoenix
    --
    -- receiver 2
    s_Receiver(2).Baudrate                  <= Rx_Baudrate_ch8;
    s_Receiver(2).Parity                    <= Rx_Parity_ch8(s_Receiver(2).Parity'range);
    s_Receiver(2).DataWidth                 <= Rx_DataWidth_ch8(s_Receiver(2).DataWidth'range);
    s_Receiver(2).StopWidth                 <= Rx_StopWidth_ch8(s_Receiver(2).StopWidth'range);
    s_Receiver(2).Active                    <= Rx_Active_ch8(0);
    s_Receiver(2).InSignal                  <= in_con1_dio2_rs232_rx(0);    -- phoenix
    --
    -- Rx_FIFO_1
    s_Rx_FIFO(1).ReadFromFIFO               <= Rx_UploadData_ch7(0);
    Rx_Data_ch7(s_Rx_FIFO(1).DataOut'range) <= s_Rx_FIFO(1).DataOut;
    Rx_NumOfWords_ch7                       <= s_Rx_FIFO(1).NumOfWords;
    Rx_IsFull_ch7(0)                        <= s_Rx_FIFO(1).IsFull;
    Rx_IsEmpty_ch7(0)                       <= s_Rx_FIFO(1).IsEmpty;
    --
    -- Rx_FIFO_2
    s_Rx_FIFO(2).ReadFromFIFO               <= Rx_UploadData_ch8(0);
    Rx_Data_ch8(s_Rx_FIFO(2).DataOut'range) <= s_Rx_FIFO(2).DataOut;
    Rx_NumOfWords_ch8                       <= s_Rx_FIFO(2).NumOfWords;
    Rx_IsFull_ch8(0)                        <= s_Rx_FIFO(2).IsFull;
    Rx_IsEmpty_ch8(0)                       <= s_Rx_FIFO(2).IsEmpty;
  END PROCESS proc_SignalAllocation;

  --
  --
  --

  TxChannels : FOR Channel IN t_TxChannelsRange GENERATE
    --
    -- write data from CANOe into the FIFO to send them as a package of messages
    inst_FIFO : ENTITY work.FIFO
      GENERIC MAP (
        g_DataWidth => c_FIFOGenerics.DataWidth,
        g_DataDepth => c_FIFOGenerics.DataDepth
        )
      PORT MAP (
        i_clock        => clk,
        i_reset        => areset,
        i_Data         => s_Tx_FIFO(Channel).DataIn,
        i_LoadIntoFIFO => s_Tx_FIFO(Channel).LoadIntoFIFO,
        i_ReadFromFIFO => s_Tx_FIFO(Channel).ReadFromFIFO,
        o_Data         => s_Tx_FIFO(Channel).DataOut,
        o_NumOfWords   => s_Tx_FIFO(Channel).NumOfWords,
        o_IsFull       => s_Tx_FIFO(Channel).IsFull,
        o_IsEmpty      => s_Tx_FIFO(Channel).IsEmpty
        );
    --
    -- read data from the FIFO and transfer it to the UART transmitter
    proc_Tx_FIFO : PROCESS (clk, areset)
      VARIABLE v_SendArray : std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');
      VARIABLE v_Counter   : natural                      := 0;
      VARIABLE v_FSM       : t_FSMTransmitter             := IDLE;
    BEGIN  -- PROCESS proc_Tx_FIFO
      IF (areset = c_reset_active) THEN                                                             -- asynchronous reset (active package defined)
        NULL;
      ELSIF (clk'event AND clk = '1') THEN                                                          -- rising clock edge
        --
        -- recognize send command
        v_SendArray                     := v_SendArray(0) & s_Tx_FIFO(Channel).Send;
        --
        -- state machine
        s_Tx_FIFO(Channel).ReadFromFIFO <= '0';
        s_Transmitter(Channel).Send     <= '0';
        --
        CASE v_FSM IS
          WHEN IDLE =>
            IF (v_SendArray = c_RisingEdge) THEN                                                    -- start of a message block
              v_FSM := READFROMFIFO;
            END IF;
          --
          WHEN READFROMFIFO =>                                                                      -- transfer the oldest (first) data from the FIFO to the UART transmitter
            s_Tx_FIFO(Channel).ReadFromFIFO <= '1';
            v_FSM                           := SEND;
          --
          WHEN SEND =>                                                                              -- send command for the UART transmitter
            s_Transmitter(Channel).Send <= '1';
            v_FSM                       := MESSAGESEND;
          --
          WHEN MESSAGESEND =>                                                                       -- recognition when a single message ends
            IF (s_Transmitter(Channel).MessageSend) THEN
              v_Counter := 0;
              v_FSM     := Pause;
            END IF;
          --
          WHEN PAUSE =>                                                                             -- wait between UART messages
            v_Counter := v_Counter + 1;
            --
            IF (v_Counter = s_Tx_FIFO(Channel).Pause AND s_Tx_FIFO(Channel).IsEmpty = '1') THEN     -- all words send
              v_FSM := IDLE;
            ELSIF (v_Counter = s_Tx_FIFO(Channel).Pause AND s_Tx_FIFO(Channel).IsEmpty = '0') THEN  -- words remaining
              v_FSM := ReadFromFIFO;
            END IF;
          --
          WHEN OTHERS =>
            v_FSM := IDLE;
        END CASE;
        --
        -- FIFO empty = stop condition
        IF (s_Tx_FIFO(Channel).IsEmpty) THEN
          v_FSM := IDLE;
        END IF;
      END IF;
    END PROCESS proc_Tx_FIFO;
    --
    --
    inst_UART_Transmitter : ENTITY work.UART_Transmitter
      PORT MAP (
        i_clock       => clk,
        i_reset       => areset,
        i_Baudrate    => s_Transmitter(Channel).Baudrate,
        i_Parity      => s_Transmitter(Channel).Parity,
        i_DataWidth   => s_Transmitter(Channel).DataWidth,
        i_StopWidth   => s_Transmitter(Channel).StopWidth,
        i_Data        => s_Transmitter(Channel).DataIn,
        i_Send        => s_Transmitter(Channel).Send,
        i_ErrorCode   => s_Transmitter(Channel).ErrorCode,
        o_Signal      => s_Transmitter(Channel).OutSignal,
        o_MessageSend => s_Transmitter(Channel).MessageSend
        );
  END GENERATE TxChannels;

  --

  RxChannels : FOR Channel IN t_RxChannelsRange GENERATE
    --
    -- get data from the receiver and write it ointo the FIFO
    inst_UART_Receiver : ENTITY work.UART_Receiver
      PORT MAP (
        i_clock      => clk,
        i_reset      => areset,
        i_Baudrate   => s_Receiver(Channel).Baudrate,
        i_Parity     => s_Receiver(Channel).Parity,
        i_DataWidth  => s_Receiver(Channel).DataWidth,
        i_StopWidth  => s_Receiver(Channel).StopWidth,
        i_Active     => s_Receiver(Channel).Active,
        i_Signal     => s_Receiver(Channel).InSignal,
        i_ResetError => s_Receiver(Channel).ResetError,
        o_Data       => s_Rx_FIFO(Channel).DataIn,          -- write into FIFO
        o_NewData    => s_Rx_FIFO(Channel).LoadIntoFIFO,    -- write into FIFO
        o_ErrorCode  => s_Receiver(Channel).ErrorCode
        );
    --
    -- write data from the UART receiver into the FIFO to send them to CANoe
    inst_FIFO : ENTITY work.FIFO
      GENERIC MAP (
        g_DataWidth => c_FIFOGenerics.DataWidth,
        g_DataDepth => c_FIFOGenerics.DataDepth
        )
      PORT MAP (
        i_clock        => clk,
        i_reset        => areset,
        i_Data         => s_Rx_FIFO(Channel).DataIn,        -- from the receiver
        i_LoadIntoFIFO => s_Rx_FIFO(Channel).LoadIntoFIFO,  -- from the receiver
        i_ReadFromFIFO => s_Rx_FIFO(Channel).ReadFromFIFO,
        o_Data         => s_Rx_FIFO(Channel).DataOut,
        o_NumOfWords   => s_Rx_FIFO(Channel).NumOfWords,
        o_IsFull       => s_Rx_FIFO(Channel).IsFull,
        o_IsEmpty      => s_Rx_FIFO(Channel).IsEmpty
        );
  END GENERATE RxChannels;

END ARCHITECTURE rtl;  -- of  User
