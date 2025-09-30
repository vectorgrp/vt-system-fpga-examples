# Demo I<sup>2</sup>C Communication

- Version: 1.0

## Changelog



## Used projects

- [Communication](../../Projects/Communication/)
- [Common Source Files](../../Projects/CommonSourceFiles/)
- [RAM Two Port](../../Projects/RAMTwoPort/)

## Overview

This demo shows the simulation of 5 I<sup>2</sup>C sensors. Each of the sensors has a different address (10, 11, 12, 13, 14). Only channel 1 of the VT2710 is used for the sensors.

The sensors 1-4 (addresses 10, 11, 12 and 13) are using a 7 bit address. The sensor 5 (address 14) is using a 10 bit address.

Each sensor has a register for data storage (using the 'RAM Two Port' project). Data can be written into the register and read from the register via systemvariables in CANoe and directly via a I<sup>2</sup>C message.

The register for sensor 1 (address 10) is initialized with a sine wave. The registers of the other sensors are initialized with zeros. All sensors have 128 register addresses (0-127).

### Sensor 1

A sine wave with a value range of 0 - 10000 and an address range of 0 -127.

<p align="center"><img src="CANoe/Panel/Pictures/SineWave.png" alt="sensor 1 sine wave" width =600/></p>