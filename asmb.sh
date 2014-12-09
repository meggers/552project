#!/bin/bash
rm -f instr.hex
./asmbl.pl $1 > instr.hex
