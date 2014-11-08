module HDU(if_id_rs, if_id_rt, id_ex_rt, id_ex_mr, pc_write, if_id_write, stall);

input [3:0] if_id_rs, if_id_rt, id_ex_rt;
input mem_read;
output pc_write, if_id_write, stall;

localparam DETECTED 	= 1'b1;
localparam NOT_DETECTED = 1'b0;

reg detected;

assign pc_write = ~detected;
assign if_id_write = ~detected;
assign stall = detected;

always @(*) begin
	if (id_ex_mr) begin
		if (id_ex_rt == if_id_rs || id_ex_rt == if_id_rt) begin
			detected <= DETECTED;
		end else begin
			detected <= NOT_DETECTED;
		end
	end else begin
		detected <= NOT_DETECTED;
	end
end

endmodule
