module shifter(src, shamt, out, dir, zr);

// Appears to work, again haven't looked at output file closely. Again,
// probably not very small. or fast. 

input[15:0] src;
input [3:0] shamt;
input[1:0] dir;
output reg [15:0] out;
output reg zr;
reg [15:0] inter0;
reg [15:0] inter1;
reg [15:0] inter2;
reg [15:0] inter3;

always @(*) begin
	if(dir == 2'd1) begin

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
		if (dir == 2'd2) begin 
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

end

endmodule
