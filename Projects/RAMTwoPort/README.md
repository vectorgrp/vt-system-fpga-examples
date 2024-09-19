# RAM Two Port

- Version: 1.0

## Changelog



## Overview

This project describes the syntax for a RAM block that uses two write and read ports. The size of the RAM and the iniliazation file are set as parameters (generics) and can be different for each instantiation. 

## Interface

### Generics

- **Address Width:** Adressbreite
- **DataWidth:** Datenbreite
- **Memory Init File:** Datei, die für das initialisieren des RAMs genutzt wird; Datei vom Typ .mif; wenn keine Datei genutzt wird, wird der RAM mit Nullen initialisiert

### Input & Output

- **Write Enable:** While set the data is written to the set RAM address.
- **Data:** Data that is written to the set address while the 'Write Enable' signal is set. Data is always read from the address.
- **Address:** Address used for writing and reading data.

## Architecture

- Data is written to the set address while the write enable signal is set.
- Data is always read from the set address. An enable signal for reading doesn't exist.