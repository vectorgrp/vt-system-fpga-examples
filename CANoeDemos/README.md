# Demo overview

The demos are examples for the use of the different user FPGA projects. They use the IP blocks from the projects as components. The blocks of the different projects are added to the demos via a .qip file which lists all necessary files. 

## Full PWM

- user FPGA project for the VT2848 to enable all 48 channels for PWM measurement and output (measurement channels: 17-48; output channels: 1-32)
- uses [Common Source Files](../Projects/CommonSourceFiles/)
- uses [Measurement](../Projects/Measurement/)
- uses [Phase Accumulator](../Projects/PhaseAccumulator/)

## Measurement

- demo for the [Measurement](../Projects/Measurement/) project
- uses [Common Source Files](../Projects/CommonSourceFiles/)

## Phase Accumulator 

- demo for the [Phase Accumulator](../Projects/PhaseAccumulator/) project
- uses [Common Source Files](../Projects/CommonSourceFiles/)
- uses [RAM Two Port](../Projects/RAMTwoPort/) project for the analog output signals

## RAM Two Port

- demo for the [RAM Two Port](..\Projects\RAMTwoPort) project
- uses [Common Source Files](../Projects/CommonSourceFiles/)

