## Warning

First please update the frequnce: 50 MHz on this board

## Requirements

The use of this kit require:
- A power jack 5V DC power supply (can be trough USB)
- A Altera USB Blaster Rev. C
- A USB-UART FTDI based cable

## Pin out

| FPGA Pin | Connect to |
| ------ | ----------- |
| 53 (P1-11) | USB-UART green wire |
| 55 (P1-12) | USB-UART white wire |

# Python tips

```python
import serial
ser = serial.Serial('/dev/ttyUSB0', 115200)
ser.read()
```