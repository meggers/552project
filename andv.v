module andv(in1, in2, out, zr);

input[15:0] in1, in2;
output reg[15:0] out;
output reg zr;

wire [15:0] andv;

assign andv = in1 & in2;
always @(*) begin
	out = andv;
	zr = ~|andv;
end

endmodule
