module cpu(clk, rst_n, hlt, pc);

//** DEFINE I/O INTERFACE **//
input clk;        	// Global clock signal
input rst_n;      	// Reset signal, active on low
output hlt;       	// Halt signal
output [15:0] pc; 	// Program counter

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

//** DEFINE REGISTERS **//
reg [2:0] FLAG;		// Flag register

reg [8:0] CTRL_ID_EX;
reg [4:0] CTRL_EX_MEM;
reg [1:0] CTRL_MEM_WB;

reg [x:0] DATA_IF_ID;
reg [x:0] DATA_ID_EX;
reg [x:0] DATA_EX_MEM;
reg [x:0] DATA_MEM_WB;

//** DEFINE WIRES **//
wire [8:0] ctrl_signals;

//** DEFINE MODULES **//
IM instr_mem(.clk(clk), addr, rd_en, instr);							// INSTRUCTION MEMORY
DM  data_mem(.clk(clk), addr, re, we, wrt_data, rd_data);					// DATA MEMORY
rf  reg_file(.clk(clk), p0_addr, p1_addr, p0, p1, re0, re1, dst_addr, dst, we, .hlt(hlt));	// REGISTER FILE

Control ctrl(instr, .ctrl_signals(ctrl_signals));						// CONTROL BLOCK

always @(posedge clk or negedge rst_n) begin 
	if (~rst_n) begin
		pc <= 16'h0000;
	end else begin
		
	end
end

//** CONTROL PIPELINE **//
always @(posedge clk) begin
	CTRL_ID_EX <= ctrl_signals;
	CTRL_EM_MEM <= CTRL_ID_EX[Branch:MemWrite];
	CTRL_MEM_WB <= CTRL_EM_MEM[MemToReg:RegWrite];
end

endmodule


module Control(instr, ctrl_signals);

input [5:0] instr;
output [8:0] ctrl_signals;

endmodule
