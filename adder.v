module adder(in1, in2, out, zr, neg, ov);

// adder seems to work, haven't looked over test output thoroughly though
// Probably doesn't synthesize very small, but it's october so screw it




input [15:0] in1, in2;
output reg [15:0] out;
output reg zr, neg, ov;
// output flags

reg [15:0] sum;



always @(*) begin

	sum = in1 + in2;


	// Logic for saturation

	if (~in1[15] && ~in2[15] && sum[15]) begin
		out = 16'h7FFF;
		ov = 1;
	end else if (in1[15] && in2[15] && ~sum[15]) begin
		out = 16'h8000;
		ov = 1;
	end else begin
		out = sum;
		ov = 0;
	end
	


	// Logic for zero bit flag
	if (sum == 16'h0000) begin
		zr = 1;
	end else begin
		zr = 0;
	end
	

	// Neg flag logic
	neg = out[15];
end

endmodule
/*
module t_adder();

reg [15:0] in1, in2;
wire [15:0] out;
wire zr, neg, ov;
integer i = 0;

adder dut_adder(in1, in2, out, zr, neg, ov);


initial begin
	while (i < 10000) begin	
	#5
	in1 = $random;
	in2 = $random;
	#1
	$display("%h + %h = %h, zr = %b, neg = %b, ov = %b", in1, in2, out, zr, neg, ov);
	i = i + 1;
	end
	$finish;
end
endmodule
	
*/





