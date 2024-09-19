# Demo Measurement

- Version: 1.0

## Changelog



## Used projects

- [Common Source Files](../../Projects/CommonSourceFiles/)
- [Measurement](../../Projects/Measurement/)

## Overview

This demo shows different measurement possibilities for the VT5838, including average, min and max for analog signals and counters used to calculate the frequency and duty cycle for digital signals.

The average value of the analog channels is calculated in two different ways.

1. **block:** Values are collected until the data array is full, then the average value is calculated. After that a new array of values is collected.
2. **rolling:** The average value is calculated with each new value by adding the new value and removing the oldest value in the array.

The counters for the pulse and period of the digital signal return the appropriate number of clock cycles. They can be used to calculate the frequency and the duty cycle of the signal.

## FPGA manager

### Analog in-/output channels

Analog values are converted to [V] in CANoe using the factor in the FPGA manager (Factor: $`10^{-6}`$). The FPGA uses [µV].