module cpu(clk, rst_n, hlt, pc);

//** DEFINE I/O INTERFACE **//
input clk;        	// Global clock signal
input rst_n;      	// Reset signal, active on low
output reg hlt;       	// Halt signal
output reg [15:0] pc; 	// Program counter

//** DEFINE GLOBAL VARS **//
localparam Z = 0;	// Index for Zero flag
localparam V = 1;	// Index for Overflow flag
localparam N = 2;	// Index for Sign flag

localparam RegWrite = 0;
localparam MemToReg = 1;
localparam MemWrite = 2;
localparam MemRead  = 3;
localparam Branch   = 4;
localparam ALUSrc   = 5;
localparam RegDst   = 6;
localparam ALUOpLSB = 7;
localparam ALUUpMSB = 8;

localparam ID_EX_PC = 1;

//** DEFINE REGISTERS **//
reg [2:0] FLAG;		// Flag register

reg [8:0] CTRL_ID_EX;
reg [4:0] CTRL_EX_MEM;
reg [1:0] CTRL_MEM_WB;

reg [15:0] DATA_IF_ID [1:0];
reg [15:0] DATA_ID_EX [3:0];
reg [15:0] DATA_EX_MEM [2:0];
reg [15:0] DATA_MEM_WB [1:0];

reg [2:0] REG_ID_EX [1:0];
reg [2:0] REG_EX_MEM;
reg [2:0] REG_MEM_WB;

//** DEFINE WIRES **//
wire [15:0] instr;
wire [8:0] ctrl_signals;

//** DEFINE MODULES **//
IM instr_mem(.clk(clk), 		// INSTRUCTION MEMORY
	     .addr(pc), 
             rd_en,// TODO
	     .instr(instr));	
			
DM  data_mem(.clk(clk),			// DATA MEMORY
	     addr,// TODO
	     .re(CTRL_EX_MEM[MemRead]), 
             .we(CTRL_EX_MEM[MemWrite]),
	     wrt_data,// TODO
	     rd_data);// TODO

rf  reg_file(.clk(clk), 		// REGISTER FILE
	     .p0_addr(instr[7:4]), 
	     .p1_addr(instr[3:0]), 
	     p0, p1,// TODO 
	     re0, re1,// TODO 
	     .dst_addr(11:8), 
	     dst,// TODO 
	     .we(CTRL_MEM_WB[RegWrite]), 
	     .hlt(hlt));

Control ctrl(.instr(instr[15:12]),	// CONTROL BLOCK
	     .ctrl_signals(ctrl_signals));

//** PROGRAM COUNTER **//
always @(posedge clk or negedge rst_n) begin 
	if (~rst_n) begin
		pc <= 0;
	end else begin
		pc <= pc + 4; // TODO: flesh this out
	end
end

//** CONTROL PIPELINE **//
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		CTRL_ID_EX  <= 0;
		CTRL_EM_MEM <= 0;
		CTRL_MEM_WB <= 0;
	end else begin
		CTRL_ID_EX  <= ctrl_signals;
		CTRL_EM_MEM <= CTRL_ID_EX[Branch:MemWrite];
		CTRL_MEM_WB <= CTRL_EM_MEM[MemToReg:RegWrite];
	end
end

//** DATA PIPELINE **//
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		DATA_IF_ID <= 0;
		DATA_ID_EX <= 0;
		DATA_EX_MEM <= 0;
		DATA_MEM_WB <= 0;
	end else begin
		
	end
end

module


endmodule Control(instr, ctrl_signals);

input [3:0] instr;
output [8:0] ctrl_signals;



endmodule


module aluControl(ALUOp, instr);

endmodule


module alu(ctrl, op1, op2, result, flags);

endmodule
