# VT System user FPGA examples

This repository contains examples for users of our VT System FPGA modules. 

This repository includes multiple VHDL files for different tasks. These blocks can be included in custom projects. Each block is described in the appropriate README file.

The *project* folder includes the VHDL files necessary for the project.

The *demo* folder includes a CANoe demo and additional VHDL files used to integrate the source files into the demo.

## Projects

| Name | Current Version | Date | Project | Demo | Infos |
|---|:---:|:---:|:---:|:---:|:---:|
| Common Source Files | 1.0 | 09.07.2024 | [Project](/Projects/CommonSourceFiles/) | - |  |
| RAM Two Port | 1.0 | 09.07.2024 | [Project](/Projects/PhaseAccumulator/) | [VT5838](/CANoeDemos/RAMTwoPort/) |  |
| Phase Accumulator | 1.0 | 12.07.2024 | [Project](/Projects/PhaseAccumulator/) | [VT5838](/CANoeDemos/PhaseAccumulator/) |  |
| Measurement | 1.0| 26.07.2024 | [Project](/Projects/Measurement/) | [VT5838](/CANoeDemos/Measurement/) |  |
| Full PWM | 1.0 | 16.08.2024 | - | [VT2848](/CANoeDemos/FullPWM/) | uses all 48 channels for PWM output & measurement |

## Changelog

### Version 1.0 (2024-09-19)

- creation
