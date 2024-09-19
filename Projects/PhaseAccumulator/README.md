# Phase Accumulator

- Version: 1.0

## Changelog



## Overview

This project is a phase accumulator. It allows to output frequency dependent signals without the need to convert the frequency to FPGA clock cycles.

## Interface

### Generics

- **FPGA Frequency:** The frequency used by the user FPGA (10, 40 & 80 MHz). It is available in the generics section of the *_GN file.
- **Width:** Width of the counter for the phase accumulator.
- **Resolution Factor:** This value is used to set the resolution of the output. It's a factor that increases the frequency resolution by an amount equal to this value (1: normal, 10: ten times). 

### Input

- **Active:** The phase accumulator is active while this signal is set. If reset the counter is set to 0.
- **Start Value:** This value is the start value of the counter. It's set while the signal 'Set Start Value' is set.
- **Set Start Value:** While this signal is set, the start value will be set.
- **Frequency Control Word:** Target frequency of the output signal.

### Output

- **Counter Value:** Value of the counter.
- **Overflow:** Shows the overflow of the counter.

## Architecture

- Only the absolute value of the frequency control word signal is used. This means the counter only increments but can't decrement. Therefore the phase accumulator can't implement a direction. This must be done outside the phase accumulator.
- This block outputs the counter value and sows when an overflow occurs. The signal for the overflow is set for a single FPGA cycle.

## Resolution Factor

The resolution factor (Generics) can be set to a bigger value than 1 to increase the resolution of the target frequency. The resolution is increased by an amount equal to the factor. A 1 means no increase, a 10 means 10 times the resolution. In return the 'frequency control word' must be multiplied by the same amount to get the correct results. This can be done via the FPGA manager or CAPL for example.

```math
Resolution [Hz] = {1 \over Resolution Factor}
```

```math
\to 1 [Hz] = {1 \over 1}
```

```math
\to 0.1 [Hz] = {1 \over 10}
```

### Example for 80 MHz

- Resolution Factor = 1: It takes 80,000,000 FPGA cycles with an increment of 1 for an overflow to happen and therefore creates a 1 sec period. The resolution is 1 Hz because decimal places ar rounded.
- Resolution Factor = 10: It takes 800,000,000 FPGA cycles with an increment of 1 for an overflow to happen and therefore creates a 10 sec period. The resolution is 0.1 Hz. To crrect this the frequency control word needs to be multiplied with the factor of 10. This leads to a period of 1 sec with an increment of 10. Because of the multiplication values of 1.5 Hz are possible as they are send as 15, not 1.5 and therefore rounded.