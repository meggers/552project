module paddsb(in1, in2, out);

// adder seems to work, haven't looked over test output thoroughly though
// Probably doesn't synthesize very small, but it's october so screw it




input [15:0] in1, in2;
output reg [15:0] out;
//output reg zr, neg, ov;
// output flags

reg [7:0] sum1;
reg [7:0] sum2;


always @(*) begin

	sum1 = in1[7:0] + in2[7:0];
    sum2 = in1[15:8] + in2[15:8];


	// Logic for saturation

	if (~in1[15] && ~in2[15] && sum2[7]) begin
		sum2 = 8'd127;
		//ov = 1;
	end  if (in1[15] && in2[15] && ~sum2[7]) begin
		sum2 = 8'd128;
		//ov = 1;
	end  if (~in1[7] && ~in2[7] && sum1[7]) begin
		sum1 = 8'd127;
	end  if (in1[7] && in2[7] && ~sum1[7]) begin
        sum1 = 8'd128;
    end

    out = {sum2, sum1};
	

    /*
	// Logic for zero bit flag
	if (sum == 16'h0000) begin
		zr = 1;
	end else begin
		zr = 0;
	end
	

	// Neg flag logic
	neg = out[15];
    */
end

endmodule
/*
module t_padder();

reg [15:0] in1, in2;
wire [15:0] out;
//wire zr, neg, ov;
integer i = 0;

paddsb dut_adder(in1, in2, out);


initial begin
	while (i < 10000) begin	
	#5
	in1 = $random;
	in2 = $random;
	#1
	$display("%h + %h = %h", in1, in2, out);
	i = i + 1;
	end
	$finish;
end
endmodule
	

*/




