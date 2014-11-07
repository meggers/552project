module Control(instr, ctrl_signals, read_signals);

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
localparam re0      = 0;
localparam re1      = 1;

input [3:0] instr;
output reg [8:0] ctrl_signals;
output reg [1:0] read_signals;
always@(*) begin

if(instr == 4'b1001 || instr == 4'b1100 || instr == 4'b1110 || instr == 4'b1111) begin
    ctrl_signals[RegWrite] = 0;
end else begin
    ctrl_signals[RegWrite] = 1;
end

if(instr == 4'b1000 || instr == 4'b1010 || instr == 4'b1011) begin
    ctrl_signals[MemToReg] = 1;
end else begin
    ctrl_signals[MemToReg] = 0;
end

if(instr == 4'b1001) begin
    ctrl_signals[MemWrite] = 1;
end else begin
    ctrl_signals[MemWrite] = 0;
end

if(instr == 4'b1000 || instr == 4'b1010 || instr == 4'b1011) begin
    ctrl_signals[MemRead] = 1;
end else begin
    ctrl_signals[MemRead] = 0;
end

if(instr == 4'b1100 || instr == 4'b1101 || instr == 4'b1110 || instr == 4'b1111) begin
    ctrl_signals[PCSrc] = 1;
end else begin
    ctrl_signals[PCSrc] = 0;
end

if(instr == 4'b1000 || instr == 4'b1001 || instr == 4'b1010 || instr == 4'b1011) begin
    ctrl_signals[ALUSrc] = 1;
end else begin
    ctrl_signals[ALUSrc] = 0;
end

if(instr == 4'b1010 || instr == 4'b1011 || instr == 4'b1100 || instr == 4'b1101 || instr == 4'b1111) begin
    read_signals[re0] = 0;
end else begin
    read_signals[re0] = 1;
end

if(instr == 4'b0000 || instr == 4'b0001 || instr == 4'b0010 || instr == 4'b0011 || instr == 4'b0100) begin
    read_signals[re1] = 0;
end else begin
    read_signals[re1] = 1;
end

ctrl_signals[8:6] = instr[2:0];
end
endmodule

