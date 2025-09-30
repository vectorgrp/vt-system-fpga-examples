# Demo UART Communication

- Version: 1.0

## Changelog



## Used projects

- [Communication](../../Projects/Communication/)
- [Common Source Files](../../Projects/CommonSourceFiles/)

## Overview

This demo shows the simulation of two UART transmitter and receiver. Each of the two channels of the VT2710 has one transmitter and one receiver.

### Transmitter

to use the transmitter the following steps need to be done:

1. Set/Change the necessary UART settings. 
2. Download the data words into the FIFO of the user FPGA by using the 'Data' field and the 'Download Data' button.
3. Send the data words by using the 'Send Data' button. The user FPGA will send all data words in the FIFO. Each data will be a single frame. In between two frames there will be a pause with the duration set in the 'Pause [s]' field.
4. 'Is empty', 'Is Full' and 'Number of Words' (field and bar) will show the appropriate state of the FIFO. In this demo the FIFO has a size of 50 data words.

### Receiver

1. Set/Change the necessary settings. 
2. Activate the receiver by using the 'Active' switch.
3. The data is automatically received an written in the FIFO of the receiver.
4. The data from the receiver FIFO is uploaded to CANoe by using the 'Upload Data' button.
5. 'Is empty', 'Is Full' and 'Number of Words' (field, LED and bar) will show the appropriate state of the FIFO. In this demo the FIFO has a size of 50 data words.

## FPGA Manager

The *Tx_Pause* variable uses a factor of *1.25 * 10 <sup>-8</sup>* so that the time is set in [sec] in CANoe.
