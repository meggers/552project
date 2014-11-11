module adder(in1, in2, out, zr, neg, ov);

input [15:0] in1, in2;
output reg [15:0] out;
output reg zr, neg, ov;
// output flags

wire [15:0] sum = in1 + in2;

always @(*) begin
	if (~in1[15] && ~in2[15] && sum[15]) begin
		out = 16'h7FFF;
		ov  = 1'b1;
		neg = 1'b0;
		zr  = 1'b0;
	end else if (in1[15] && in2[15] && ~sum[15]) begin
		out = 16'h8000;
		ov  = 1'b1;
		neg = 1'b1;
		zr  = 1'b0;	
	end else begin
		out = sum;
		ov  = 1'b0;
		neg = out[15];
		zr = ~|sum;
	end
end

endmodule





