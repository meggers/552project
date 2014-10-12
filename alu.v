module alu(src0, src1, shamt, func, dst ,ov, zr, neg, paddsb, llb);
// ADD, PADDSB, SUB, AND, NOR, SLL, SRL, SRA

input [15:0] src0,src1;
input [2:0] func; // selects function to perform input [3:0] shamt; // shift amount
input paddsb, llb;
output [15:0] dst;
output ov,zr,neg; 

// ADD 0000
// PADDSB 0001
// SUB 0010
// AND 0011
// NOR 0100
// SLL 0101
// SRL 0110
// SRA 0111
// LW 1000


endmodule
