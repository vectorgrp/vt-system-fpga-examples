# FIFO

- Version: 1.0

## Changelog



## Overview

This project contains the VHDL code for a FIFO.

## Generics

- Data Width: width of the data words of the FIFO in bits
- Data Depth: number of max. data words in the FIFO

## Input

- Data: data word to be loaded into the FIFO
- Load Into FIFO: command to shift the data into the FIFO
- Read From FIFO: command to read the oldest data from the FIFO

## Output

- Data: data word to be read from the FIFO
- Num Of Words: number of words currently in the FIFO
- Is Full: is high when the FIFO is full (Num Of Words = Data Depth)
- Is Empty: is high when the FIFO is empty (Nm Of Words = 0)

## Architecture

- data is only written into the FIFO and read from it on a rising edge of the write and read command, for one FPGA cycle
- the register is created using logic cells
- data written into a full FIFO is lost