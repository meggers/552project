endmodule Control(instr, ctrl_signals, read_signals);

// ADD 0000
// PADDSB 0001
// SUB 0010
// AND 0011
// NOR 0100
// SLL 0101
// SRL 0110
// SRA 0111
// LW 1000
// SW 1001
// LHB 1010
// LLB 1011
// B 1100
// JAL 1101
// JR 1110
// HLT 1111

localparam RegWrite = 0;
localparam MemToReg = 1;
localparam MemWrite = 2;
localparam MemRead  = 3;
localparam PCSrc    = 4;
localparam ALUSrc   = 5;
localparam ALUop    = 6;

input [3:0] instr;
output [8:0] ctrl_signals;
output [1:0] read_signals;
always@(*) begin

if(instr == 4'b1001 || instr == 4'b1100 || instr == 4'b1110 || instr == 4'b1111) begin
    ctr_signals[0] = 0;
end else
    ctr_signals[0] = 1;
end

if(instr == 4'b1000 || instr == 4'b1010 || instr == 4'b1011) begin
    ctr_signals[1] = 1;
end else
    ctr_signals[1] = 0;
end

if(instr == 4'b1001) begin
    ctr_signals[2] = 1;
end else
    ctr_signals[2] = 0;
end

if(instr == 4'b
ctr_signals[8:6] = instr[2:0];
end
endmodule

