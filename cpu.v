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
localparam PCSrc    = 4;
localparam ALUSrc   = 5;
localparam RegDst   = 6;
localparam ALUOpLSB = 7;
localparam ALUUpMSB = 8;

localparam IF_ID_PC    = 0;
localparam IF_ID_INST  = 1;

localparam ID_EX_PC    = 0;
localparam ID_EX_OP1   = 1;
localparam ID_EX_OP2   = 2;
localparam ID_EX_IMM   = 3;
localparam ID_EX_R0    = 0;
localparam ID_EX_R1    = 1;

localparam EX_MEM_PC   = 0;
localparam EX_MEM_RSLT = 1;
localparam EX_MEM_OP2  = 2;

localparam MEM_WB_RD   = 0;
localparam MEM_WB_RSLT = 1;

//** DEFINE REGISTERS **//
reg [2:0] FLAG;		// Flag register

reg [8:0] CTRL_ID_EX;
reg [4:0] CTRL_EX_MEM;
reg [1:0] CTRL_MEM_WB;

reg [15:0] DATA_IF_ID [1:0];
reg [15:0] DATA_ID_EX [3:0];
reg [15:0] DATA_EX_MEM [2:0];
reg [15:0] DATA_MEM_WB [1:0];

reg [3:0] REG_ID_EX [1:0];
reg [3:0] REG_EX_MEM;
reg [3:0] REG_MEM_WB;

//** DEFINE WIRES **//
wire [15:0] pc_incr;
wire [15:0] instr;
wire [8:0] ctrl_signals;
wire [15:0] read_1, read_2;

//** DEFINE MODULES **//
IM instr_mem(.clk(clk), 		// INSTRUCTION MEMORY
	     .addr(pc), 
             .rd_en(),// TODO
	     .instr(instr));	
			
DM  data_mem(.clk(clk),			// DATA MEMORY
	     .addr(DATA_EX_MEM[EX_MEM_RSLT]),
	     .re(CTRL_EX_MEM[MemRead]), 
             .we(CTRL_EX_MEM[MemWrite]),
	     .wrt_data(DATA_EX_MEM[EX_MEM_OP2]),
	     .rd_data());// TODO

rf  reg_file(.clk(clk), 		// REGISTER FILE
	     .p0_addr(DATA_IF_ID[IF_ID_INST][11:8]), 
	     .p1_addr(DATA_IF_ID[IF_ID_INST][7:4]), 
	     .p0(read_1), 
	     .p1(read_2),
	     .re0(), .re1(),// TODO 
	     .dst_addr(REG_MEM_WB), 
	     .dst(),// TODO 
	     .we(CTRL_MEM_WB[RegWrite]), 
	     .hlt(hlt));

Control ctrl(.instr(DATA_IF_ID[IF_ID_INST][15:12]),	// CONTROL BLOCK
	     .ctrl_signals(ctrl_signals));

//** CONTINUOUS ASSIGNS **//
assign pc_incr = pc + 4;

//** PROGRAM COUNTER **//
always @(posedge clk or negedge rst_n) begin 
	if (~rst_n) begin
		pc <= 0;
	end else begin
		pc <= (CTRL_EX_MEM[PCSrc] & FLAG[Z]) ? DATA_EX_EM[EX_MEM_PC] : pc_incr;
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
		DATA_IF_ID <= 0; // TODO: this doesn't work
		DATA_ID_EX <= 0;
		DATA_EX_MEM <= 0;
		DATA_MEM_WB <= 0;
	end else begin
		DATA_IF_ID[IF_ID_PC] <= pc_incr;
		DATA_IF_ID[IF_ID_INST] <= instr;

		DATA_ID_EX[ID_EX_PC] <= DATA_IF_ID[IF_ID_PC]; // TODO: Race conditions?
		DATA_ID_EX[ID_EX_OP1] <= read_1;
		DATA_ID_EX[ID_1EX_OP2] <= read_2;
		DATA_ID_EX[ID_EX_IMM] <= ;
		REG_ID_EX[ID_EX_R0] <= ;
		REG_ID_EX[ID_EX_R1] <= ;

		DATA_EX_MEM[EX_MEM_PC] <= ;
		DATA_EX_MEM[EX_MEM_RSLT] <= ;
		DATA_EX_MEM[EX_MEM_OP2] <= ;
		REG_EX_MEM <= ;

		DATA_MEM_WB[MEM_WB_RD] <= ;
		DATA_MEM_WB[MEM_WB_RSLT] <= ;
		REG_MEM_WB <= ;
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
