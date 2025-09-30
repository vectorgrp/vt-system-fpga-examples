# Communication

- Version: 1.0

## Changelog



## Overview

This project contains code for different protocols:
- I<sup>2</sup>C
- UART.
- SPI

## I<sup>2</sup>C

The I<sup>2</sup>C project uses different VHDL code files for 7 and 10 bit sensor addresses.

### Generics

- **Data Width:** width of the protocol data (e.g. 8, 16, ... bits); default = 16 bits
- **Register Address Width:** width of the register address; default = 7 bits
- **Read:** value of the R/W bit for a read command; default = '1'

### Input

- **Sensor Address:** sensor address/ID; depending on the sensor it's 7 or 10 bits
- **SCL:** I<sup>2</sup>C clock
- **SDA:** incoming data signal
- **Reset Error:** resets the outgoing error signal (not used at the moment)
- **Register Data:** data received from the register

### Output

- **Register Data:** data send to the register
- **Register Address:** address for the register; incoming data doesn't need an enable signal, therefore the incoming register data always corresponds to the register address
- **Register Wren:** enable signal for writing data into the register
- **SDA:** outgoing data signal
- **Error Code:** error signal (not used at the moment)

### Architecture

- FSM (state machine) only handels the states
- States process handels what happens in the different states; depending on the rising and falling edges of the SCL signal

## UART

The UART project contains the code for a UART transmitter and a UART Receiver.

## Transmitter

### Generics

- Idle: sets the value for the idle state of the output signal

### Input

- Baudrate: the baudrate for the frame 
- Parity: sets the parity for the frame
  - 0: *no parity*
  - 1: *odd*
  - 2: *even*
  - 3: *mark*
  - 4: *space*
- Data Width: number of bits in a data word (typically 7-9 bits)
- Stop Width: number of stop bits (typically 1-2)
- Data: data word for a frame
- Send: command to send a frame; the code checks for a rising edge of this signal
- Error Code: *not in use*

### Output

- Signal: digital signal of the outoging frame
- Message Send: shows when a frame was send; set for 1 FPGA cycle

### Architecture

The project uses the [Phase Accumulator](../PhaseAccumulator/) for the send timing. The start value for the accumulator is 0 the FPGA frequency and every bits of the frame is send when an overflow accurs.

## Receiver

### Generics

- Idle: sets the value for the idle state of the incoming signal

### Input

- Baudrate: the baudrate for the frame 
- Parity: sets the parity for the frame
  - 0: *no parity*
  - 1: *odd*
  - 2: *even*
  - 3: *mark*
  - 4: *space*
- Data Width: number of bits in a data word (typically 7-9 bits)
- Stop Width: number of stop bits (typically 1-2)
- Active: the sensor is active while this signal is '1'
- Signal: incomig digital frame
- Reset Error: command to reset of current error code

### Output

- Data: received data word of a frame
- New Data: signals when a new data word was received; set for 1 FPGA cycle when 'Data' is set
- Error Code: error code (e.g. wrong parity)

### Architecture

The project uses the [Phase Accumulator](../PhaseAccumulator/) to create the timing to scan the incoming frame. The start value for the accumulator is 1&frasl;2 of the FPGA frequency and the incoming frame is scanned every time an overflow accurs. This leads to scanning a received bit in the middle of this bit.

## SPI

The SPI project contains the code for a re eiver and a transmitter.

### Generics

- **Data Width:** width of the protocol data (e.g. 8, 16, ... bits); default = 8 bits
- **Address Widht:** width of the data address; default = 7 bits
- **Idle value:** idle value for the output (MISO) signal; default = '1' (high)
- **nCS:** chip select active value; default = '0' (low active)
- **Read:** value for the read command (RW bit); default = '1'
- **MOSI Data:** number of different MOSI words are the width of the array (default = 1 to 3 -> 3 words); initialization values are the real size of the different words (default = 1, 7, 8 bits -> RW, address, data)
- **MISO Data:** number of different MISO words are the width of the array (default = 1 to 3 -> 3 words); initialization values are the real size of the different words (default = 1, 7, 8 bits -> RW + address, data)

### Input

- **CPOL:** polarity of the SPI signal
- **CPHA:** phase of the SPI signal
- **nCS:** chip select signal
- **SCLK:** SPI clock signal
- **MOSI:** MOSI signal
- **Data MISO:** data the should be send as MISO signal
- **Reset Error:** reets the error value

### Output

- **Data MOSI:** received MOSI data; value array
- **Dara MOSI Valid:** signals the received MOSI data; array index correpsonds to the value array
- **Data MISO Send:** signals that a specific data word was send; array index corresponds to *MISO Data* aaray
- **MISO:** MISO signal
- **Error Code:** error code (not in use)

### Architecture

- this block only provides receiving and transmitting data; it doesn't interpret data or simulates a sensor; this needs to in the shell of this block
- CPOL and CPHA create an internal enable signal (process *proc_InSignal*) that controls the state machine
- all incoming/outgoing data is treated identical (see point 1 *Architecture*)