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

localparam SRC_ID_EX  = 2'b00;
localparam SRC_EX_MEM = 2'b10;
localparam SRC_MEM_WB = 2'b01;

localparam Halt        = 0;
localparam RegWrite    = 1;
localparam MemToReg    = 2;
localparam MemWrite    = 3;
localparam MemRead     = 4;
localparam Branch      = 5;
localparam ALUSrc      = 6;

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
localparam EX_MEM_INST = 3;

localparam MEM_WB_RD   = 0;
localparam MEM_WB_RSLT = 1;
localparam MEM_WB_INST = 2;

//** DEFINE REGISTERS **//
reg [2:0] FLAG;

reg [6:0] CTRL_ID_EX;
reg [5:0] CTRL_EX_MEM;
reg [2:0] CTRL_MEM_WB;

reg [15:0] DATA_IF_ID [1:0];
reg [15:0] DATA_ID_EX [3:0];
reg [15:0] DATA_EX_MEM [3:0];
reg [15:0] DATA_MEM_WB [2:0];

//** DEFINE WIRES **//
wire [15:0] pc_incr, instr, read_1, 
	    read_2, dm_read, op_1, op_2,
	    result, write_data, id_ex_b;

wire [6:0] ctrl_signals;

wire [2:0] flags;

wire [1:0] read_signals, forwardA, forwardB;

wire pc_write, if_id_write, stall, branch;

//** DEFINE MODULES **//
// INSTRUCTION MEMORY
IM instr_mem(
	.clk(clk),
	.addr(pc), 
	.rd_en(1'b1),
	.instr(instr)
);	
			
// DATA MEMORY
DM  data_mem(
	.clk(clk),
	.addr(DATA_EX_MEM[EX_MEM_RSLT]),
	.re(CTRL_EX_MEM[MemRead]), 
	.we(CTRL_EX_MEM[MemWrite]),
	.wrt_data(DATA_EX_MEM[EX_MEM_OP2]),
	.rd_data(dm_read)
);

// REGISTER FILE
rf  reg_file(
	.clk(clk),
	.p0_addr(DATA_IF_ID[IF_ID_INST][7:4]), 
	.p1_addr(DATA_IF_ID[IF_ID_INST][3:0]), 
	.p0(read_1), 
	.p1(read_2),
	.re0(read_signals[0]), 
	.re1(read_signals[1]), 
	.dst_addr(DATA_MEM_WB[MEM_WB_INST][11:8]), 
	.dst(write_data),
	.we(CTRL_MEM_WB[RegWrite]), 
	.hlt(hlt)
);

// CONTROL BLOCK
Control ctrl(
	.instr(DATA_IF_ID[IF_ID_INST][15:12]), 
	.ctrl_signals(ctrl_signals), 
	.read_signals(read_signals)
);

// ALU
alu alu_inst(
	.ALUop(DATA_ID_EX[ID_EX_INST][15:12]), 
	.src0(op_1), 
	.src1(op_2), 
	.offset(DATA_ID_EX[ID_EX_INST][3:0]),
	.result(result), 
	.flags(flags)
);

// HAZARD DETECTION UNIT
HDU hdu(
	.opcode(DATA_IF_ID[IF_ID_INST][15:12]),
	.if_id_rs(DATA_IF_ID[IF_ID_INST][7:4]), 
	.if_id_rt(DATA_IF_ID[IF_ID_INST][3:0]), 
	.id_ex_rt(DATA_ID_EX[ID_EX_INST][11:8]), 
	.id_ex_mr(CTRL_ID_EX[MemRead]), 
	.pc_write(pc_write), 
	.if_id_write(if_id_write), 
	.stall(stall)
);

// FORWARDING UNIT
FU forward_unit(
	.id_ex_rt(DATA_ID_EX[ID_EX_INST][3:0]), 
	.id_ex_rs(DATA_ID_EX[ID_EX_INST][7:4]), 
	.ex_mem_rd(DATA_EX_MEM[EX_MEM_INST][11:8]), 
	.mem_wb_rd(DATA_MEM_WB[MEM_WB_INST][11:8]), 
	.ex_mem_rw(CTRL_EX_MEM[RegWrite]), 
	.mem_wb_rw(CTRL_MEM_WB[RegWrite]), 
	.forwarda(forwardA), 
	.forwardb(forwardB)
);

// BRANCH CONDITION
Branch branch_logic(
	.condition(DATA_EX_MEM[EX_MEM_INST][11:9]), 
	.flags(FLAG), 
	.branch(branch)
);

//** CONTINUOUS ASSIGNS **//
assign pc_incr    = pc + 4;										// INCREMENT PC
assign write_data = CTRL_MEM_WB[MemToReg] ? DATA_MEM_WB[MEM_WB_RD] : DATA_MEM_WB[MEM_WB_RSLT];		// WHAT DATA IS RETURNED FROM MEM STAGE
assign id_ex_b    = CTRL_ID_EX[ALUSrc] ? {8'h00, DATA_ID_EX[ID_EX_INST][7:0]} : DATA_ID_EX[ID_EX_OP1];  // IS OP 2 IMM

// FORWARDING FOR ALU OP 1
assign op_1 = (forwardA == SRC_ID_EX)  ? DATA_ID_EX[ID_EX_OP1] :
	      (forwardA == SRC_EX_MEM) ? DATA_EX_MEM[EX_MEM_RSLT] :
	      (forwardA == SRC_MEM_WB) ? write_data : DATA_ID_EX[ID_EX_OP1];

// FORWARDING FOR ALU OP 2
assign op_2 = (forwardB == SRC_ID_EX)  ? id_ex_b : 
	      (forwardB == SRC_EX_MEM) ? DATA_EX_MEM[EX_MEM_RSLT] :
	      (forwardB == SRC_MEM_WB) ? write_data : id_ex_b;

//** PROGRAM COUNTER **//
always @(posedge clk or negedge rst_n) begin 
	if (~rst_n) begin
		pc <= 16'h0000;
	end else begin
		pc <= (branch & CTRL_EX_MEM[Branch]) ? DATA_EX_MEM[EX_MEM_PC] : pc_incr;
	end
end

//** CONTROL PIPELINE **//
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		CTRL_ID_EX  <= 7'b0000000;
		CTRL_EX_MEM <= 6'b000000;
		CTRL_MEM_WB <= 3'b000;
	end else begin
		CTRL_ID_EX  <= stall ? 7'b0000000 : ctrl_signals;
		CTRL_EX_MEM <= CTRL_ID_EX[Branch:Halt];
		CTRL_MEM_WB <= CTRL_EX_MEM[MemToReg:Halt];
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
		DATA_EX_MEM[3] <= 16'h0000;

		DATA_MEM_WB[0] <= 16'h0000;
		DATA_MEM_WB[1] <= 16'h0000;
		DATA_MEM_WB[2] <= 16'h0000;

		FLAG           <= 3'b000;
	end else begin
		if (if_id_write) begin
			DATA_IF_ID[IF_ID_PC]   <= pc_incr;
			DATA_IF_ID[IF_ID_INST] <= instr;
		end else begin
			DATA_IF_ID[IF_ID_PC]   <= DATA_IF_ID[IF_ID_PC];
			DATA_IF_ID[IF_ID_INST] <= DATA_IF_ID[IF_ID_INST];
		end

		DATA_ID_EX[ID_EX_PC]     <= DATA_IF_ID[IF_ID_PC];
		DATA_ID_EX[ID_EX_OP1]    <= read_1;
		DATA_ID_EX[ID_EX_OP2]    <= read_2;
		DATA_ID_EX[ID_EX_INST]   <= DATA_IF_ID[IF_ID_INST];

		DATA_EX_MEM[EX_MEM_PC]   <= DATA_ID_EX[ID_EX_PC] + {{5{DATA_ID_EX[ID_EX_INST][8]}}, DATA_ID_EX[ID_EX_INST][8:0], 2'b00};
		DATA_EX_MEM[EX_MEM_RSLT] <= result;
		DATA_EX_MEM[EX_MEM_OP2]  <= DATA_ID_EX[ID_EX_OP2];
		DATA_EX_MEM[EX_MEM_INST] <= DATA_ID_EX[ID_EX_INST];
		FLAG                     <= flags;

		DATA_MEM_WB[MEM_WB_RD]   <= dm_read;
		DATA_MEM_WB[MEM_WB_RSLT] <= DATA_EX_MEM[EX_MEM_RSLT];
		DATA_MEM_WB[MEM_WB_INST] <= DATA_EX_MEM[EX_MEM_INST];

		hlt 			 <= CTRL_MEM_WB[Halt];
	end
end

endmodule

module Branch(condition, flags, branch);

input [2:0] condition, flags;
output reg branch;

localparam NOT_EQUAL			= 3'b000;
localparam EQUAL			= 3'b001;
localparam GREATER_THAN			= 3'b010;
localparam LESS_THAN			= 3'b011;
localparam GREATER_THAN_OR_EQUAL	= 3'b100;
localparam LESS_THAN_OR_EQUAL		= 3'b101;
localparam OVERFLOW			= 3'b110;
localparam UNCONDITIONAL		= 3'b111;

localparam BRANCH			= 1'b1;
localparam NO_BRANCH			= 1'b0;

localparam Z = 0;	// Index for Zero flag
localparam V = 1;	// Index for Overflow flag
localparam N = 2;	// Index for Sign flag

always @(*) begin
	case (condition)
		NOT_EQUAL : 
			branch = ~flags[Z] ? BRANCH : NO_BRANCH;
		EQUAL : 
			branch = flags[Z] ? BRANCH : NO_BRANCH;
		GREATER_THAN : 
			branch = ~(flags[Z] | flags[N]) ? BRANCH : NO_BRANCH;
		LESS_THAN : 
			branch = flags[N] ? BRANCH : NO_BRANCH;
		GREATER_THAN_OR_EQUAL : 
			branch = (flags[Z] | ~flags[N]) ? BRANCH : NO_BRANCH;
		LESS_THAN_OR_EQUAL : 
			branch = (flags[N] | flags[Z]) ? BRANCH : NO_BRANCH;
		OVERFLOW : 
			branch = flags[V] ? BRANCH : NO_BRANCH;
		UNCONDITIONAL : 
			branch = BRANCH;
		default : 
			branch = NO_BRANCH;
	endcase
end

endmodule
