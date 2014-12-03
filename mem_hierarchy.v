module sys_mem(clk, rst_n, re, we, wrt_data, i_addr, d_addr, instr, i_rdy, d_rdy, rd_data);

input [15:0] i_addr, d_addr, wrt_data;
input clk, rst_n, re, we;

output [15:0] instr, rd_data;
output i_rdy, d_rdy;
	
cache Lcache(
	clk,
	rst_n,
	addr,
	wr_data,
	wdirty,
	we,
	re,

	rd_data,
	tag_out,
	hit,
	dirty
);

cache Dcache(
	clk,
	rst_n,
	addr,
	wr_data,
	wdirty,
	we,
	re,

	rd_data,
	tag_out,
	hit,
	dirty
);

unified_mem main_memory(
	clk,
	rst_n,
	addr,
	re,
	we,
	wdata,

	rd_data,
	rdy
);

endmodule
