# Demo FIFO

- Version: 1.0

## Changelog



## Used projects

- [Common Source Files](../../Projects/CommonSourceFiles/)
- [FIFO](../../Projects/FIFO/)

## Overview

This demo shows a simple usage of a FIFO usig the analog in- (channel 1-4) and outputs (channel 13-16) of the VT2816. The output data (voltage [V]) is downloaded into the FIFO from CANoe and then output. The input data (voltage [V]) is also written into the FIFO and can then be uploaded to CANoe.

The panel 'Control' shows the current number of words in the FIFO and if the FIFO is empty (0 words) or full (16 words). The bar on the right of a channel also shows the current number of words. 

## FPGA manager

### Analog in-/output channels

Analog values are converted to [V] in CANoe using the factor in the FPGA manager (Factor: $`10^{-6}`$). The FPGA uses [µV].