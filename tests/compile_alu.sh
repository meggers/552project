#!/bin/bash
iverilog -o alu_test.vvp ../alu.v ../adder.v ../andv.v ../norv.v ../paddsb.v ../shifter.v
