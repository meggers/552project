module paddsb(in1, in2, out);

input [15:0] in1, in2;
output reg [15:0] out;

reg [7:0] sum1;
reg [7:0] sum2;

always @(*) begin
	sum1 = in1[7:0] + in2[7:0];
	sum2 = in1[15:8] + in2[15:8];

	if (~in1[15] && ~in2[15] && sum2[7]) begin
		out[15:8] = 8'h80;
	end else if (in1[15] && in2[15] && ~sum2[7]) begin
		out[15:8] = 8'h7F;
	end else begin
		out[15:8] = sum2;
	end

	if (~in1[7] && ~in2[7] && sum1[7]) begin
		out[7:0] = 8'h80;
	end if (in1[7] && in2[7] && ~sum1[7]) begin
        	out[7:0] = 8'h7F;
    	end else begin
		out[7:0] = sum1;
	end
end

endmodule
