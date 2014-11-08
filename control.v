module Control(instr, ctrl_signals, read_signals);

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

localparam Halt        = 0
localparam RegWrite    = 1;
localparam MemToReg    = 2;
localparam MemWrite    = 3;
localparam MemRead     = 4;
localparam Branch      = 5;
localparam ALUSrc      = 6;
localparam ALUOpLSB    = 7;
localparam ALUOpMSB    = 9;

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

