module FU(id_ex_rt, id_ex_rs, ex_mem_rd, mem_wb_rd, ex_mem_rw, mem_wb_rw, forwarda, forwardb);

input [3:0] id_ex_rt, id_ex_rs, ex_mem_rd, mem_wb_rd;
input ex_mem_rw, mem_wb_rw;
output [1:0] forwarda, forwardb;

localparam NO_HAZARD  = 2'b00;
localparam EX_HAZARD  = 2'b10;
localparam MEM_Hazard = 2'b01;

always @(*) begin
	if (ex_mem_rw & |ex_mem_rd) begin // EX Hazards
		if (ex_mem_rd == id_ex_rs) begin
			forwarda <= EX_HAZARD;
		end else begin
			forwarda <= NO_HAZARD;
		end

		if (ex_mem_rd == id_ex_rt) begin
			forwardb <= EX_HAZARD;
		end else begin
			forwardb <= NO_HAZARD;
		end
	end else if ((mem_wb_rw & |mem_wb_rd)) begin // MEM Hazards

	end else begin
		forwarda <= NO_HAZARD;
		forwardb <= NO_HAZARD: 
	end
end

endmodule


