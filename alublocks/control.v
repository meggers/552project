endmodule Control(instr, ctrl_signals, read_signals);

localparam RegWrite = 0;
localparam MemToReg = 1;
localparam MemWrite = 2;
localparam MemRead  = 3;
localparam PCSrc    = 4;
localparam ALUSrc   = 5;
localparam ALUop    = 6;

input [3:0] instr;
output [8:0] ctrl_signals;

always@(*) begin

end
endmodule

