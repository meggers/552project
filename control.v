module Control(instr, rd, rs, rt, imm, opcode, cond, ctrl_signals, read_signals);

input [15:0] instr;
output reg [15:0] imm;
output reg [5:0] ctrl_signals;
output reg [3:0] rd, rs, rt, opcode;
output reg [2:0] cond;
output reg [1:0] read_signals;

localparam ADD 		= 4'b0000;
localparam PADDSB 	= 4'b0001;
localparam SUB 		= 4'b0010;
localparam AND 		= 4'b0011;
localparam NOR 		= 4'b0100;
localparam SLL 		= 4'b0101;
localparam SRL 		= 4'b0110;
localparam SRA 		= 4'b0111;
localparam LW 		= 4'b1000;
localparam SW 		= 4'b1001;
localparam LHB 		= 4'b1010;
localparam LLB 		= 4'b1011;
localparam B 		= 4'b1100;
localparam JAL 		= 4'b1101;
localparam JR 		= 4'b1110;
localparam HLT 		= 4'b1111;

localparam r0		= 4'b0000;
localparam clear_imm	= 16'h0000;

localparam Halt         = 0;
localparam RegWrite     = 1;
localparam MemToReg     = 2;
localparam MemWrite     = 3;
localparam MemRead      = 4;
localparam Branch       = 5;

localparam re0      	= 0;
localparam re1      	= 1;

localparam ASSERT 	= 1'b1;
localparam NO_ASSERT	= 1'b0;

always@(*) begin
	opcode = instr[15:12];
	cond   = instr[11:9];
	case (instr[15:12])
		ADD : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= ASSERT;

			rd = instr[11:8];
			rs = instr[7:4];
			rt = instr[3:0];

			imm = clear_imm;
			end
		PADDSB : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= ASSERT;

			rd = instr[11:8];
			rs = instr[7:4];
			rt = instr[3:0];

			imm = clear_imm;
			end
		SUB : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;
			read_signals[re0]	= ASSERT;
			read_signals[re1]	= ASSERT;

			rd = instr[11:8];
			rs = instr[7:4];
			rt = instr[3:0];

			imm = clear_imm;
			end
		AND : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= ASSERT;

			rd = instr[11:8];
			rs = instr[7:4];
			rt = instr[3:0];

			imm = clear_imm;
			end
		NOR : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= ASSERT;

			rd = instr[11:8];
			rs = instr[7:4];
			rt = instr[3:0];

			imm = clear_imm;
			end
		SLL : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= NO_ASSERT;

			rd = instr[11:8];
			rs = instr[7:4];
			rt = r0;

			imm = {12'h000, instr[3:0]};
			end
		SRL : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= NO_ASSERT;

			rd = instr[11:8];
			rs = instr[7:4];
			rt = r0;

			imm = {12'h000, instr[3:0]};
			end
		SRA : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= NO_ASSERT;

			rd = instr[11:8];
			rs = instr[7:4];
			rt = r0;

			imm = {12'h000, instr[3:0]};
			end
		LW : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= NO_ASSERT;

			rd = instr[11:8];
			rs = instr[7:4];
			rt = r0;

			imm = {{12{instr[3]}}, {instr[3:0]}};
			end
		SW : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= NO_ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= ASSERT;

			rd = r0;
			rs = instr[7:4];
			rt = instr[11:8];

			imm = {{12{instr[3]}}, {instr[3:0]}};
			end
		LHB : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= NO_ASSERT;

			rd = instr[11:8];
			rs = instr[11:8];
			rt = r0;

			imm = {8'h00, instr[7:0]};
			end
		LLB : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;

			read_signals[re0]	= NO_ASSERT;
			read_signals[re1]	= NO_ASSERT;

			rd = instr[11:8];
			rs = r0;
			rt = r0;

			imm = {{8{instr[7]}}, {instr[7:0]}};
			end
		B : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= NO_ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= ASSERT;

			read_signals[re0]	= NO_ASSERT;
			read_signals[re1]	= NO_ASSERT;

			rd = r0;
			rs = r0;
			rt = r0;

			imm = {{7{instr[8]}}, {instr[8:0]}};
			end
		JAL : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;

			read_signals[re0]	= NO_ASSERT;
			read_signals[re1]	= NO_ASSERT;

			rd = 4'd15;
			rs = r0;
			rt = r0;

			imm = {{4{instr[11]}}, {instr[11:0]}};
			end
		JR : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= NO_ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= NO_ASSERT;

			rd = r0;
			rs = instr[7:4];
			rt = r0;

			imm = clear_imm;
			end
		HLT : begin
			ctrl_signals[Halt] 	= ASSERT;
			ctrl_signals[RegWrite] 	= NO_ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;

			read_signals[re0]	= NO_ASSERT;
			read_signals[re1]	= NO_ASSERT;

			rd = r0;
			rs = r0;
			rt = r0;

			imm = clear_imm;
			end
		default : begin
			ctrl_signals = 0;
			read_signals = 0;

			rd = 0;
			rs = 0;
			rt = 0;

			imm = 0;
			end
	endcase
end

endmodule

