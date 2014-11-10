module norv(in1, in2, out, zr);

input[15:0] in1, in2;
output reg[15:0] out;
output reg zr;

always@(*) begin
	out = ~(in1 | in2);
	zr  = ~|out;
end

endmodule

