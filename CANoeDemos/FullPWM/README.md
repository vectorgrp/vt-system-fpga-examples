# Demo Full PWM

- Version: 1.0

## Changelog



## Used projects

- [Common Source Files](../../Projects/CommonSourceFiles/)
- [Measurement](../../Projects/Measurement/)
- [PhaseAccumulator](../../Projects/PhaseAccumulator/)

## Overview

This demo extends the capabilities of the VT2848 by allowing all 48 channels to be used for PWM output and PWM measurement. 
This project adds the PWM output to the channels 1-32 and the measurement to the channel 17-48. The other channels already have the capability per default without the need for the user FPGA.
By default all 48 channels are set to measurement and have to be set to PWM (channels 33-48) or FPGA (channels 1-32) to use them as output.

## FPGA manager

Measurement Duration

- Factor: $`1.25E^{-8} = {1 \over Frequency_{FPGA} [Hz]} = {1 \over 80000000}`$; conversion from [s] to FPGA cycles
- Min/Max: 0.01 s - 50 s
- Default: 50 s

Duty Cycle

- Factor: $`0.09765625 = {DC [\%] \over Scaling_{FPGA}} = {100 \over 1024}`$; 1024 is a scaling factor used in the user FPGA

Output frequency

- Min/Max: 0.02 Hz - 200000 Hz

Duty Cycle:

- Factor: $`1.25E^{-6} = {DC [\%] \over Frequency_{FPGA}} = {100 \over 80000000}`$
- Min/Max: 0 % - 100 %
- Default: 50 %