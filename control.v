module Control(instr, ctrl_signals, read_signals);

input [3:0] instr;
output reg [6:0] ctrl_signals;
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

localparam Halt         = 0;
localparam RegWrite     = 1;
localparam MemToReg     = 2;
localparam MemWrite     = 3;
localparam MemRead      = 4;
localparam Branch       = 5;
localparam ALUSrc       = 6;

localparam re0      	= 0;
localparam re1      	= 1;

localparam ASSERT 	= 1'b1;
localparam NO_ASSERT	= 1'b0;

always@(*) begin
	case (instr)
		ADD : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;
			ctrl_signals[ALUSrc] 	= NO_ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= ASSERT;
			end
		PADDSB : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;
			ctrl_signals[ALUSrc] 	= NO_ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= ASSERT;
			end
		SUB : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;
			ctrl_signals[ALUSrc] 	= NO_ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= ASSERT;
			end
		AND : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;
			ctrl_signals[ALUSrc] 	= NO_ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= ASSERT;
			end
		NOR : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;
			ctrl_signals[ALUSrc] 	= NO_ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= ASSERT;
			end
		SLL : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;
			ctrl_signals[ALUSrc] 	= ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= NO_ASSERT;
			end
		SRL : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;
			ctrl_signals[ALUSrc] 	= ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= NO_ASSERT;
			end
		SRA : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;
			ctrl_signals[ALUSrc] 	= ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= NO_ASSERT;
			end
		LW : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;
			ctrl_signals[ALUSrc] 	= ASSERT;

			read_signals[re0]	= NO_ASSERT;
			read_signals[re1]	= ASSERT;
			end
		SW : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= NO_ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;
			ctrl_signals[ALUSrc] 	= ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= ASSERT;
			end
		LHB : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;
			ctrl_signals[ALUSrc] 	= ASSERT;

			read_signals[re0]	= ASSERT;
			read_signals[re1]	= NO_ASSERT;
			end
		LLB : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;
			ctrl_signals[ALUSrc] 	= ASSERT;

			read_signals[re0]	= NO_ASSERT;
			read_signals[re1]	= NO_ASSERT;
			end
		B : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= NO_ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= ASSERT;
			ctrl_signals[ALUSrc] 	= NO_ASSERT;

			read_signals[re0]	= NO_ASSERT;
			read_signals[re1]	= NO_ASSERT;
			end
		JAL : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;
			ctrl_signals[ALUSrc] 	= NO_ASSERT;

			read_signals[re0]	= NO_ASSERT;
			read_signals[re1]	= NO_ASSERT;
			end
		JR : begin
			ctrl_signals[Halt] 	= NO_ASSERT;
			ctrl_signals[RegWrite] 	= NO_ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= ASSERT;
			ctrl_signals[ALUSrc] 	= NO_ASSERT;

			read_signals[re0]	= NO_ASSERT;
			read_signals[re1]	= ASSERT;
			end
		HLT : begin
			ctrl_signals[Halt] 	= ASSERT;
			ctrl_signals[RegWrite] 	= NO_ASSERT;
			ctrl_signals[MemToReg] 	= NO_ASSERT;
			ctrl_signals[MemWrite] 	= NO_ASSERT;
			ctrl_signals[MemRead] 	= NO_ASSERT;
			ctrl_signals[Branch] 	= NO_ASSERT;
			ctrl_signals[ALUSrc] 	= NO_ASSERT;

			read_signals[re0]	= NO_ASSERT;
			read_signals[re1]	= NO_ASSERT;
			end
		default : begin
			ctrl_signals = 0;
			read_signals = 0;
			end
	endcase
end

endmodule

