module shifter(src, shamt, out, dir, zr);

localparam SLL = 2'b01;
localparam SRL = 2'b10;
localparam SRA = 2'b11;

input[15:0] src;
input [3:0] shamt;
input [1:0] dir;
output reg [15:0] out;
output reg zr;

reg [15:0] inter0;
reg [15:0] inter1;
reg [15:0] inter2;

always @(*) begin
	case (dir)
		SLL : begin // Shift left logical
			inter0 = shamt[0] ? {src[14:0],    1'b0}  : src;
			inter1 = shamt[1] ? {inter0[13:0], 2'b00} : inter0;
			inter2 = shamt[2] ? {inter1[11:0], 4'b0000}  : inter1;
			out    = shamt[3] ? {inter2[7:0],  8'b00000000} : inter2;
		end
		SRL : begin // Shift right logical
			inter0 = shamt[0] ? {1'b0,  src[15:1]}    : src;
			inter1 = shamt[1] ? {2'b00, inter0[15:2]} : inter0;
			inter2 = shamt[2] ? {4'h0,  inter1[15:4]} : inter1;
			out    = shamt[3] ? {8'h00, inter2[15:8]} : inter2;
		end
		SRA : begin // Shift right arithetic
			inter0 = shamt[0] ? {src[15], src[15:1]} : src;
			inter1 = shamt[1] ? {{2{inter0[15]}}, inter0[15:2]} : inter0;
			inter2 = shamt[2] ? {{4{inter1[15]}}, inter1[15:4]} : inter1;
			out    = shamt[3] ? {{8{inter2[15]}}, inter2[15:8]} : inter2;
		end
		default : begin
			inter0 = 0;
			inter1 = 0;
			inter2 = 0;
			out = src;
		end
	endcase

	zr  = ~|out;
end

endmodule
