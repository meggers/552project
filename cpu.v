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

localparam RegWrite    = 0;
localparam MemToReg    = 1;
localparam MemWrite    = 2;
localparam MemRead     = 3;
localparam PCSrc       = 4;
localparam ALUSrc      = 5;
localparam ALUOpLSB    = 6;
localparam ALUOpMSB    = 8;

localparam IF_ID_PC    = 0;
localparam IF_ID_INST  = 1;

localparam ID_EX_PC    = 0;
localparam ID_EX_OP1   = 1;
localparam ID_EX_OP2   = 2;
localparam ID_EX_INST  = 3;
localparam ID_EX_R0    = 0;
localparam ID_EX_R1    = 1;

localparam EX_MEM_PC   = 0;
localparam EX_MEM_RSLT = 1;
localparam EX_MEM_OP2  = 2;

localparam MEM_WB_RD   = 0;
localparam MEM_WB_RSLT = 1;

//** DEFINE REGISTERS **//
reg [2:0] FLAG;

reg [8:0] CTRL_ID_EX;
reg [4:0] CTRL_EX_MEM;
reg [1:0] CTRL_MEM_WB;

reg [15:0] DATA_IF_ID [1:0];
reg [15:0] DATA_ID_EX [3:0];
reg [15:0] DATA_EX_MEM [2:0];
reg [15:0] DATA_MEM_WB [1:0];

reg [3:0] REG_EX_MEM, REG_MEM_WB;

//** DEFINE WIRES **//
wire [15:0] pc_incr, instr, read_1, 
	    read_2, dm_read, op_2,
	    result, write_data;

wire [8:0] ctrl_signals;

wire [2:0] flags;

wire [1:0] read_signals;

wire pc_write, if_id_write, stall;

//** DEFINE MODULES **//
// INSTRUCTION MEMORY
IM instr_mem(.clk(clk),
	     .addr(pc), 
             .rd_en(1'b1),
	     .instr(instr)
);	
			
// DATA MEMORY
DM  data_mem(.clk(clk),
	     .addr(DATA_EX_MEM[EX_MEM_RSLT]),
	     .re(CTRL_EX_MEM[MemRead]), 
             .we(CTRL_EX_MEM[MemWrite]),
	     .wrt_data(DATA_EX_MEM[EX_MEM_OP2]),
	     .rd_data(dm_read)
);

// REGISTER FILE
rf  reg_file(.clk(clk),
	     .p0_addr(DATA_IF_ID[IF_ID_INST][11:8]), 
	     .p1_addr(DATA_IF_ID[IF_ID_INST][7:4]), 
	     .p0(read_1), 
	     .p1(read_2),
	     .re0(read_signals[0]), 
	     .re1(read_signals[1]), 
	     .dst_addr(REG_MEM_WB), 
	     .dst(write_data),
	     .we(CTRL_MEM_WB[RegWrite]), 
	     .hlt(hlt)
);

// CONTROL BLOCK
Control ctrl(.instr(DATA_IF_ID[IF_ID_INST][15:12]), 
	     .ctrl_signals(ctrl_signals), 
	     .read_signals(read_signals)
);

// ALU
alu alu_inst(.ALUop(CTRL_ID_EX[ALUOpMSB:ALUOpLSB]), 
	     .src0(DATA_ID_EX[ID_EX_OP1]), 
	     .src1(op_2), 
	     .result(result), 
	     .flags(flags)
);

// HAZARD DETECTION UNIT
HDU hdu(.instr(DATA_IF_IF[IF_ID_INST]),
	.write_data(write_data),
	.mem_read(CTRL_ID_EX[MemRead]),
	.pc_write(pc_write),
	.if_id_write(if_id_write),
	.stall(stall)
);

//** CONTINUOUS ASSIGNS **//
assign pc_incr = pc + 4;
assign op_2 = CTRL_ID_EX[ALUSrc] ? {12'h000, DATA_ID_EX[ID_EX_INST][3:0]} : DATA_ID_EX[ID_EX_OP1];
assign write_data = CTRL_MEM_WB[MemToReg] ? DATA_MEM_WB[MEM_WB_RD] : DATA_MEM_WB[MEM_WB_RSLT];

//** PROGRAM COUNTER **//
always @(posedge clk or negedge rst_n) begin 
	if (~rst_n) begin
		pc <= 16'h0000;
	end else begin
		pc <= (CTRL_EX_MEM[PCSrc] & FLAG[Z]) ? DATA_EX_EM[EX_MEM_PC] : pc_incr;
	end
end

//** CONTROL PIPELINE **//
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		CTRL_ID_EX  <= 9'b000000000;
		CTRL_EX_MEM <= 5'b00000;
		CTRL_MEM_WB <= 2'b00;
	end else begin
		CTRL_ID_EX  <= stall ? 9'b000000000 : ctrl_signals;
		CTRL_EX_MEM <= CTRL_ID_EX[Branch:MemWrite];
		CTRL_MEM_WB <= CTRL_EX_MEM[MemToReg:RegWrite];
	end
end

//** DATA PIPELINE **//
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		DATA_IF_ID[0] <= 16'h0000;
		DATA_IF_ID[1] <= 16'h0000;

		DATA_ID_EX[0] <= 16'h0000;
		DATA_ID_EX[1] <= 16'h0000;
		DATA_ID_EX[2] <= 16'h0000;
		DATA_ID_EX[3] <= 16'h0000;

		DATA_EX_MEM[0] <= 16'h0000;
		DATA_EX_MEM[1] <= 16'h0000;
		DATA_EX_MEM[2] <= 16'h0000;

		DATA_MEM_WB[0] <= 16'h0000;
		DATA_MEM_WB[1] <= 16'h0000;

		REG_EX_MEM <= 4'b0000;
		REG_MEM_WB <= 4'b0000;

		FLAG <= 3'b000;
	end else begin
		if (if_id_write) begin
			DATA_IF_ID[IF_ID_PC] <= pc_incr;
			DATA_IF_ID[IF_ID_INST] <= instr;
		end else begin
			DATA_IF_ID[IF_ID_PC] <= DATA_IF_ID[IF_ID_PC];
			DATA_IF_ID[IF_ID_INST] <= DATA_IF_ID[IF_ID_INST];
		end

		DATA_ID_EX[ID_EX_PC] <= DATA_IF_ID[IF_ID_PC];
		DATA_ID_EX[ID_EX_OP1] <= read_1;
		DATA_ID_EX[ID_EX_OP2] <= read_2;
		DATA_ID_EX[ID_EX_INST] <= DATA_IF_ID[IF_ID_INST];

		DATA_EX_MEM[EX_MEM_PC] <= DATA_ID_EX[ID_EX_PC];
		DATA_EX_MEM[EX_MEM_RSLT] <= result;
		DATA_EX_MEM[EX_MEM_OP2] <= DATA_ID_EX[ID_EX_OP2];
		REG_EX_MEM <= DATA_ID_EX[ID_EX_INST][11:8];
		FLAG <= flags;

		DATA_MEM_WB[MEM_WB_RD] <= dm_read;
		DATA_MEM_WB[MEM_WB_RSLT] <= DATA_EX_MEM[EX_MEM_RSLT];
		REG_MEM_WB <= REG_EX_MEM;
	end
end

module
