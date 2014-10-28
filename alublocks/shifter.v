module shifter(src, shamt, out, dir, arr, zr, neg);

// Appears to work, again haven't looked at output file closely. Again,
// probably not very small. or fast. 



input[15:0] src;
input [3:0] shamt;
input dir, arr;
output reg [15:0] out;
output reg zr, neg;
reg [15:0] inter0;
reg [15:0] inter1;
reg [15:0] inter2;
reg [15:0] inter3;

localparam left = 0;
localparam right = 1;
localparam arith = 1;
localparam logical = 0;


always @(*) begin
	if(dir == left) begin

		if(shamt[0]) begin
			inter0 = src << 1;
		end else begin
			inter0 = src;
		end

		if(shamt[1]) begin
			inter1 = inter0 << 2;
		end else begin
			inter1 = inter0;
		end

		if(shamt[2]) begin
			inter2 = inter1 << 4;
		end else begin
			inter2 = inter1;
		end

		if(shamt[3]) begin
			out = inter2 << 8;
		end else begin
			out  = inter2;
		end

	end else begin
		if (arr == logical) begin 
			if(shamt[0]) begin
				inter0 = src >> 1;
			end else begin
				inter0 = src;
			end

			if(shamt[1]) begin
				inter1 = inter0 >> 2;
			end else begin
				inter1 = inter0;
			end

			if(shamt[2]) begin
				inter2 = inter1 >> 4;
			end else begin
				inter2 = inter1;
			end

			if(shamt[3]) begin
				out = inter2 >> 8;
			end else begin
				out  = inter2;
			end
		end else begin
			if(shamt[0]) begin         
				inter0 = src >> 1;
			end else begin
				inter0 = src;
			end

			if(shamt[1]) begin
				inter1 = inter0 >> 2;
			end else begin
				inter1 = inter0;
			end

			if(shamt[2]) begin
				inter2 = inter1 >> 4;
			end else begin
				inter2 = inter1;
			end

			if(shamt[3]) begin
				out = inter2 >> 8;
			end else begin
				out  = inter2;
			end
		end 


	end


	if (out == 16'h0000) begin
		zr = 1;
	end else begin
		zr = 0;
	end

	neg = out[15]; 

end

endmodule

module t_shifter();

wire [15:0] out;
reg [15:0] src;
reg [3:0] shamt;
reg dir, arr;
integer i=0;


shifter dut(.src(src), .out(out), .shamt(shamt), .dir(dir), .arr(arr));



initial begin
	while (i < 10000) begin

	#5
	src = $random;
	shamt = $random;
	dir = $random;
	arr = $random;

	#1
	$display("%h << %d = %h, dir = %b, arr = %b", src, shamt, out, dir, arr);
	i = i + 1;
	end
	$finish;
end
endmodule