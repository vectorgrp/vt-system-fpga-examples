# Demo Incremental Encoder

- Version: 1.0

## Changelog

## Used projects

- [Common Source Files](../../Projects/CommonSourceFiles/)
- [IncrementalEncoder](../../Projects/IncrementalEncoder/)
- [PhaseAccumulator](../../Projects/PhaseAccumulator/)

## Overview

This demo shows an incremental encoder and decoder for the VT2848. 8 encoder (channels 25-48) and 8 decoder (channels 1-24) are implemented in this demo. Each with an A, a B and an Index signal. The A and B signals consist of 10 teeth per rotation. The index signal consists of the single pulse that's equal to one pulse of the A signal. In addition the phase difference between the signals A and B is measured for each of the 8 decoder channels.

## FPGA Manager

### Phase Difference

The factor is calculate as follows: $`Factor = {360 [°] \over 1024}`$; the factor is needed to equalize the factor used in the user FPGA (phase difference value is too big by a factor of 1024) and to convert it into [°].