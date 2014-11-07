module alu(src0, src1, shamt, func, dst ,ov, zr, neg, paddsb, llb);
// ADD, PADDSB, SUB, AND, NOR, SLL, SRL, SRA

// ADD 0000
// PADDSB 0001
// SUB 0010
// AND 0011
// NOR 0100
// SLL 0101
// SRL 0110
// SRA 0111
// LW 1000

input [15:0] src0,src1;
input [2:0] func; // selects function to perform
input [3:0] shamt; // shift amount
input paddsb, llb;
output [15:0] dst;
output ov,zr,neg; 

wire [15:0] add_out, and_out, nor_out, shift_out, lhb_out;
wire add_zr, add_ng, add_ov;
adder add(src0, src1, add_out, add_zr, add_neg, add_or);
assign and_out = src0 && src1;
assign nor_out = !(src0 && src1);
wire shift_zr, shift_neg;
shifter shift(src0, shamt, shift_out, func[1], func[0], shift_zr, shift_neg);

wire paddsb_out;
my_paddsb paddsb(src1, src2, paddsb_out);




endmodule
