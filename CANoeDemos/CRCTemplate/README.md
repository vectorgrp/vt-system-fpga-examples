# Demo CRC Template

- Version: 1.0

## Changelog



## Used projects

- [Common Source Files](../../Projects/CommonSourceFiles/)
- [CRC Template](../../Projects/CRCTemplate/)

## Overview

This demo shows the interface for the CRC template.

Two different CRCs polynomials are implemented in the demo.

- 1. CRC
  - polynomial: 0x31 (x<sup>8</sup> + x<sup>5</sup> + x<sup>4</sup> + x<sup>0</sup>)
  - initial value: 0xFF
  - XOR Out: 0x00
- 2. CRC
  - polynomial: 0x04C11DB7 (x<sup>32</sup> + x<sup>26</sup> + x<sup>23</sup> + x<sup>22</sup> + x<sup>16</sup> + x<sup>12</sup> + x<sup>11</sup> + x<sup>10</sup> + x<sup>8</sup> + x<sup>7</sup> + x<sup>5</sup> + x<sup>4</sup> + x<sup>2</sup> + x<sup>1</sup> + x<sup>0</sup>)
  - initial value: 0xFFFFFFFF
  - XOR Out: 0xFFFFFFFF

The bits can only be set bit by bit in CANoe.