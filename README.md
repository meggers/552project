WISC-F14 Project
==========

WISC-F14 is a 16-bit computer with a load/store architecture. Design, test, and synthesize this architecture using Verilog.

WISC-F14 has a register file, a 3-bit FLAG register, and sixteen instructions. The register file comprises sixteen 16-bit registers. Register $0 is hardwired to 0x0000. Register $15 serves as a Return Address register for the jump-and-link (JAL) instruction. The FLAG register contains three bits: Zero (Z), Overflow (V), and Sign bit (N).

WISC-F14’s instructions can be categorized into four major classes: Arithmetic, Memory, Load Immediate and Control. 
