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
localparam Jal	       = 5;
localparam JR          = 6;
localparam Branch      = 7;

localparam IF_ID_PC    = 0;
localparam IF_ID_INST  = 1;

localparam ID_EX_OP1   = 0;
localparam ID_EX_OP2   = 1;
localparam ID_EX_PC    = 2;
localparam ID_EX_Rd    = 0;
localparam ID_EX_Rs    = 1;
localparam ID_EX_Rt    = 2;

localparam EX_MEM_RSLT = 0;
localparam EX_MEM_OP2  = 1;

localparam MEM_WB_RD   = 0;
localparam MEM_WB_RSLT = 1;

//** DEFINE REGISTERS **//
// Control Pipeline Registers
reg [5:0] CTRL_ID_EX;
reg [4:0] CTRL_EX_MEM;
reg [2:0] CTRL_MEM_WB;

// Data Pipeline Registers
reg [15:0] DATA_IF_ID [1:0];
reg [15:0] DATA_ID_EX [2:0];
reg [15:0] DATA_EX_MEM [1:0];
reg [15:0] DATA_MEM_WB [1:0];

// Accessory Pipeline Registers
reg [15:0] IMM_ID_EX;
reg [3:0]  REG_ID_EX [2:0];
reg [3:0]  REG_EX_MEM_Rd, 
	   REG_MEM_WB_Rd,
	   OPCODE_ID_EX;
reg [2:0]  FLAG;

//** DEFINE WIRES **//
wire [15:0] pc_incr, instr, read_1, 
	    read_2, dm_read, op_1, op_2,
	    result, write_data,
	    IF_ID_Imm, pc_branch,
	    DATA_ID_EX_OP2, jr_branch;

wire [7:0] ctrl_signals;

wire [3:0] IF_ID_Rd, 
	   IF_ID_Rs,
	   IF_ID_Rt,
	   IF_ID_Opcode;

wire [2:0] flags,
	   IF_ID_Cond;

wire [1:0] read_signals, forwardA, forwardB;

wire pc_write, if_id_write, stall, mem_ready, branch, jal, jr_forward;

//** DEFINE MODULES **//
// SYSTEM MEMORY
system_memory memory(
	.clk(clk),
	.rst_n(rst_n),
	.i_fetch(if_id_write),
	.re(CTRL_EX_MEM[MemRead]),
	.we(CTRL_EX_MEM[MemWrite]),
	.wrt_data(DATA_EX_MEM[EX_MEM_OP2]),
	.i_addr(pc),
	.d_addr(DATA_EX_MEM[EX_MEM_RSLT]),

	.instr(instr),
	.rd_data(dm_read),
	.ready(mem_ready)
);

// CONTROL BLOCK
Control ctrl(
	.instr(DATA_IF_ID[IF_ID_INST]), 

	.ctrl_signals(ctrl_signals), 
	.read_signals(read_signals),
	.opcode(IF_ID_Opcode), 
	.cond(IF_ID_Cond), 
	.rd(IF_ID_Rd), 
	.rs(IF_ID_Rs), 
	.rt(IF_ID_Rt), 
	.imm(IF_ID_Imm) 
);

// HAZARD DETECTION UNIT
HDU hdu(
	.opcode(IF_ID_Opcode),
	.if_id_rs(IF_ID_Rs), 
	.if_id_rt(IF_ID_Rt), 
	.id_ex_rt(REG_ID_EX[ID_EX_Rd]), 
	.id_ex_mr(CTRL_ID_EX[MemRead]),

	.pc_write(pc_write), 
	.if_id_write(if_id_write), 
	.stall(stall)
);

// REGISTER FILE
rf  reg_file(
	.clk(clk),
	.p0_addr(IF_ID_Rs), 
	.p1_addr(IF_ID_Rt), 
	.re0(read_signals[0]), 
	.re1(read_signals[1]), 
	.dst_addr(REG_MEM_WB_Rd), 
	.dst(write_data),
	.we(CTRL_MEM_WB[RegWrite]), 
	.hlt(hlt),

	.p0(read_1), 
	.p1(read_2)
);

// ALU
alu alu_inst(
	.ALUop(OPCODE_ID_EX), 
	.src0(op_1), 
	.src1(op_2), 
	.imm(IMM_ID_EX),
	.flag_reg(FLAG),

	.result(result), 
	.flags(flags)
);

// FORWARDING UNIT
FU forward_unit(
	.id_ex_rt(REG_ID_EX[ID_EX_Rt]), 
	.id_ex_rs(REG_ID_EX[ID_EX_Rs]), 
	.ex_mem_rd(REG_EX_MEM_Rd), 
	.mem_wb_rd(REG_MEM_WB_Rd), 
	.ex_mem_rw(CTRL_EX_MEM[RegWrite]), 
	.mem_wb_rw(CTRL_MEM_WB[RegWrite]), 

	.forwarda(forwardA), 
	.forwardb(forwardB)
);

// JR FORWARDING
JR_forward jr_f(
	.ctrl_jr(ctrl_signals[JR]), 
	.id_rs(IF_ID_Rs), 
	.ex_rd(REG_ID_EX[ID_EX_Rd]), 

	.forward(jr_forward)
);

// BRANCH CONDITION
Branch branch_logic(
	.ctrl(ctrl_signals[Branch]),
	.condition(IF_ID_Cond), 
	.flags(flags), 
	.clk(clk),
	.branch(branch)
);

//** CONTINUOUS ASSIGNS **//
assign pc_incr        = pc + 1;	// INCREMENT PC
assign jr_branch      = jr_forward ? result : read_1;				           
assign pc_branch      = ctrl_signals[JR] ? jr_branch : DATA_IF_ID[IF_ID_PC] + IF_ID_Imm;	   // CALCULATED BRANCH ADDRESS
assign write_data     = CTRL_MEM_WB[MemToReg] ? DATA_MEM_WB[MEM_WB_RD] : DATA_MEM_WB[MEM_WB_RSLT]; // WHAT DATA IS RETURNED FROM MEM STAGE
assign DATA_ID_EX_OP2 = CTRL_ID_EX[Jal] ? DATA_ID_EX[ID_EX_PC] : DATA_ID_EX[ID_EX_OP2];            // PASS THROUGH JAL ADDRESS IF JAL

// FORWARDING FOR ALU OP 1
assign op_1 = (forwardA == SRC_ID_EX)  ? DATA_ID_EX[ID_EX_OP1] :
	      (forwardA == SRC_EX_MEM) ? DATA_EX_MEM[EX_MEM_RSLT] :
	      (forwardA == SRC_MEM_WB) ? write_data : DATA_ID_EX[ID_EX_OP1];

// FORWARDING FOR ALU OP 2
assign op_2 = (forwardB == SRC_ID_EX)  ? DATA_ID_EX_OP2 : 
	      (forwardB == SRC_EX_MEM) ? DATA_EX_MEM[EX_MEM_RSLT] :
	      (forwardB == SRC_MEM_WB) ? write_data : DATA_ID_EX_OP2;

//** PROGRAM COUNTER **//
always @(posedge clk or negedge rst_n) begin 
	if (~rst_n) begin
		pc <= 16'h0000;
	end else if (pc_write & mem_ready) begin
		pc <= (branch ? pc_branch : pc_incr);
	end else begin
		pc <= pc;
	end
end

//** CONTROL PIPELINE **//
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		CTRL_ID_EX  <= 6'b000000;
		CTRL_EX_MEM <= 5'b00000;
		CTRL_MEM_WB <= 3'b000;

		hlt	    <= 1'b0;
	end else if (mem_ready) begin
		CTRL_ID_EX  <= (stall & ~ctrl_signals[Halt]) ? 6'b00000 : ctrl_signals[Jal:Halt];
		CTRL_EX_MEM <= CTRL_ID_EX[MemRead:Halt];
		CTRL_MEM_WB <= CTRL_EX_MEM[MemToReg:Halt];

		hlt 	    <= CTRL_EX_MEM[Halt];
	end else begin
		CTRL_ID_EX  <= CTRL_ID_EX;
		CTRL_EX_MEM <= CTRL_EX_MEM;
		CTRL_MEM_WB <= CTRL_MEM_WB;

		hlt 	    <= hlt;
	end
end

//** DATA PIPELINE **//
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		DATA_IF_ID[0] <= 16'h0000;
		DATA_IF_ID[1] <= 16'h0000;

		DATA_ID_EX[0] <= 16'h0000;
		DATA_ID_EX[1] <= 16'h0000;
		DATA_ID_EX[2] <= 16'b0000;
		REG_ID_EX[0]  <= 4'h0;
		REG_ID_EX[1]  <= 4'h0;
		REG_ID_EX[2]  <= 4'h0;
		OPCODE_ID_EX  <= 4'h0;
		IMM_ID_EX     <= 16'h0000;

		DATA_EX_MEM[0] <= 16'h0000;
		DATA_EX_MEM[1] <= 16'h0000;
		REG_EX_MEM_Rd  <= 4'h0;
		FLAG           <= 3'b000;

		DATA_MEM_WB[0] <= 16'h0000;
		DATA_MEM_WB[1] <= 16'h0000;
		REG_MEM_WB_Rd  <= 4'h0;
	end else if (mem_ready) begin
		if (branch) begin
			DATA_IF_ID[IF_ID_PC]   <= pc_incr;
			DATA_IF_ID[IF_ID_INST] <= 16'h0000;
		end else if (if_id_write) begin
			DATA_IF_ID[IF_ID_PC]   <= pc_incr;
			DATA_IF_ID[IF_ID_INST] <= instr;
		end else begin
			DATA_IF_ID[IF_ID_PC]   <= DATA_IF_ID[IF_ID_PC];
			DATA_IF_ID[IF_ID_INST] <= DATA_IF_ID[IF_ID_INST];
		end

		DATA_ID_EX[ID_EX_OP1]    <= read_1;
		DATA_ID_EX[ID_EX_OP2]    <= read_2;
		DATA_ID_EX[ID_EX_PC]     <= DATA_IF_ID[IF_ID_PC];
		REG_ID_EX[ID_EX_Rd]	 <= IF_ID_Rd;
		REG_ID_EX[ID_EX_Rs]	 <= IF_ID_Rs;
		REG_ID_EX[ID_EX_Rt]	 <= IF_ID_Rt;
		OPCODE_ID_EX		 <= IF_ID_Opcode;
		IMM_ID_EX		 <= IF_ID_Imm;

		DATA_EX_MEM[EX_MEM_RSLT] <= result;
		DATA_EX_MEM[EX_MEM_OP2]  <= op_2;
		REG_EX_MEM_Rd		 <= REG_ID_EX[ID_EX_Rd];
		FLAG                     <= flags;

		DATA_MEM_WB[MEM_WB_RD]   <= dm_read;
		DATA_MEM_WB[MEM_WB_RSLT] <= DATA_EX_MEM[EX_MEM_RSLT];
		REG_MEM_WB_Rd		 <= REG_EX_MEM_Rd;
	end else begin
		DATA_IF_ID[IF_ID_PC]   <= DATA_IF_ID[IF_ID_PC];
		DATA_IF_ID[IF_ID_INST] <= DATA_IF_ID[IF_ID_INST];

		DATA_ID_EX[ID_EX_OP1]    <= DATA_ID_EX[ID_EX_OP1];
		DATA_ID_EX[ID_EX_OP2]    <= DATA_ID_EX[ID_EX_OP2];
		DATA_ID_EX[ID_EX_PC]     <= DATA_ID_EX[ID_EX_PC];
		REG_ID_EX[ID_EX_Rs]	 <= REG_ID_EX[ID_EX_Rs];
		REG_ID_EX[ID_EX_Rt]	 <= REG_ID_EX[ID_EX_Rt];
		OPCODE_ID_EX		 <= OPCODE_ID_EX;
		IMM_ID_EX		 <= IMM_ID_EX;

		DATA_EX_MEM[EX_MEM_RSLT] <= DATA_EX_MEM[EX_MEM_RSLT];
		DATA_EX_MEM[EX_MEM_OP2]  <= DATA_EX_MEM[EX_MEM_OP2];
		REG_EX_MEM_Rd		 <= REG_EX_MEM_Rd;
		FLAG                     <= FLAG;

		DATA_MEM_WB[MEM_WB_RD]   <= DATA_MEM_WB[MEM_WB_RD];
		DATA_MEM_WB[MEM_WB_RSLT] <= DATA_MEM_WB[MEM_WB_RSLT];
		REG_MEM_WB_Rd		 <= REG_MEM_WB_Rd;
	end
end

endmodule

module Branch(ctrl, condition, flags, branch, clk);

input [2:0] condition, flags;
input ctrl, clk;
output reg branch;
reg [2:0] flags_d;

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

// Flip flop to meet timing constraints
always @(posedge clk) begin
	flags_d <= flags;
end

always @(posedge clk) begin
	if (ctrl) begin
		case (condition)
			NOT_EQUAL : 
				branch = ~flags_d[Z] ? BRANCH : NO_BRANCH;
			EQUAL : 
				branch = flags_d[Z] ? BRANCH : NO_BRANCH;
			GREATER_THAN : 
				branch = ~(flags_d[Z] | flags_d[N]) ? BRANCH : NO_BRANCH;
			LESS_THAN : 
				branch = flags_d[N] ? BRANCH : NO_BRANCH;
			GREATER_THAN_OR_EQUAL : 
				branch = (flags_d[Z] | ~flags_d[N]) ? BRANCH : NO_BRANCH;
			LESS_THAN_OR_EQUAL : 
				branch = (flags_d[N] | flags_d[Z]) ? BRANCH : NO_BRANCH;
			OVERFLOW : 
				branch = flags_d[V] ? BRANCH : NO_BRANCH;
			UNCONDITIONAL : 
				branch = BRANCH;
			default : 
				branch = NO_BRANCH;
		endcase
	end else begin
		branch = NO_BRANCH;
	end
end

endmodule
