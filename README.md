# VT System User FPGA examples

This repository contains examples for users of our VT System FPGA modules. 

This repository includes multiple VHDL files for different tasks. These blocks can be included in custom projects. Each block is described in the appropriate README file.

The *projects* folder (table below) includes the VHDL files necessary for the project.

The *CANoe demos* folder (table below) includes a CANoe demo and additional VHDL files used to integrate the source files into the demo.

## Projects

| Name | Current Version | Date | Projects | CANoe Demos | Infos |
|---|:---:|:---:|:---:|:---:|:---:|
| Common Source Files | 1.0 | 2024-07-09 | [Project](/Projects/CommonSourceFiles/) | - |  |
| Full PWM | 1.0 | 2024-08-16 | - | [VT2848](/CANoeDemos/FullPWM/) | uses all 48 channels for PWM output & measurement |
| FIFO | 1.0 | 2025-06-17 | [Project](/Projects/FIFO/) | [VT2816](/CANoeDemos/FIFO/) |  |
| Incremental Encoder | 1.0 | 2025-01-07 | [Project](/Projects/IncrementalEncoder/) | [VT2848](/CANoeDemos/IncrementalEncoder/) |  |
| Measurement | 1.0| 2024-07-26 | [Project](/Projects/Measurement/) | [VT5838](/CANoeDemos/Measurement/) |  |
| Phase Accumulator | 1.0 | 2024-07-12 | [Project](/Projects/PhaseAccumulator/) | [VT5838](/CANoeDemos/PhaseAccumulator/) |  |
| RAM Two Port | 1.0 | 2024-07-09 | [Project](/Projects/RAMTwoPort/) | [VT5838](/CANoeDemos/RAMTwoPort/) |  |

## Issues

Bugs, glitches, notes and requests can be specified under [Issues](https://github.com/vectorgrp/vt-system-fpga-examples/issues).

## Changelog

### Version 1.2 (2025-06-17)

- added 'FIFO' (project & demo)

### Version 1.1 (2025-01-07)

- added 'Incremental Encoder' (project & demo)
- added .qip files to the 'Projects' folders

### Version 1.0 (2024-09-19)

- creation

