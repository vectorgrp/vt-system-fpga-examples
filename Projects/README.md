# Project overview

Here are the different IP blocks that can be used for user FPGA projects. There different ways how they can be added to a project.

1. The files can be added via a .qip (Quartus® Prime IP) file. The .qip file has the relative paths to files necessary for a project. The .qip file has to be added manually to Quartus®. This method is used by the demo.
2. The files can be added manualy to Quartus®.
3. The files can be copied/moved to the 'hdl' folder of the user FPGA project. In this case the FPGA manager will add them automtically to the Quartus® project file. (This applies only to .vhd and .v files.)

## Common Source Files

In this folder are files which are used by multiple projects, e.g. common packages.

## Phase Accumulator

This project is a phase accumultor. It can be used to output frequency dependent signals without the need to convert the frequency to FPGA clock cycles.

## RAM Two Port

This project shows how to implement a RAM in the user FPGA with two parallel write and read port. The size of the RAM, the size of the data and the initialization file (.mif format) can be set as parameters (via generics in the entity).

## Measurement

This project contains VHDL blocks that are used for measurement purposes of digital and analog input signals.