#!/bin/bash
iverilog -o WISC-F14 -c file_list.txt
vvp WISC-F14
gtkwave test.vcd traces.gtkw
