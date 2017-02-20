#!/bin/bash

cd build

avr-objdump -D LI3DS_ARDUINO.elf > LI3DS_ARDUINO.D.asm
avr-objdump -S LI3DS_ARDUINO.elf > LI3DS_ARDUINO.S.asm

cd -
