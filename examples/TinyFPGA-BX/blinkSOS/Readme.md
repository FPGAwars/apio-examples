Simple example for testing the TinyFPGA-BX board
It just blinks the led connected to pin 13


## Instructions

* Press the reset **button** on the **TinyFPGA-B2** board
* Execute the following command:

```sh
apio upload
```
This is a fragment of what will be written in the **console**:

```
Board: TinyFPGA-BX
[Thu Jan  4 12:04:42 2018] Processing TinyFPGA-BX
--------------------------------------------------------------------------------
FPGA_SIZE: 8k
FPGA_TYPE: lp
FPGA_PACK: cm81
PROG: tinyfpgab -c /dev/ttyACM0 --program
yosys -p "synth_ice40 -blif hardware.blif" -q BlinkSOS.v
arachne-pnr -d 8k -P cm81 -p TinyFPGA-BX-pins.pcf -o hardware.asc hardware.blif
[...]
icepack hardware.asc hardware.bin
tinyfpgab -c /dev/ttyACM0 --program hardware.bin

TinyFPGA B-series Programmer CLI
--------------------------------
Using device id 1d50:6130
Programming /dev/ttyACM0 with hardware.bin
Bootloader not active
Programming at addr 030000
Waking up SPI flash
135100 bytes to program
Erasing designated flash pages
Writing bitstream
Verifying bitstream
Success!
========================= [SUCCESS] Took 7.05 seconds =========================
```

After 10 seconds or so, the led will **blink**
