module system_memory(clk, rst_n, i_fetch, re, we, wrt_data, i_addr, d_addr, instr, i_rdy, d_rdy, rd_data);

input [15:0] i_addr, d_addr, wrt_data;
input clk, rst_n, re, we;

output [15:0] instr, rd_data;
output i_rdy, d_rdy;

wire rdy;
wire		i_we,		d_we,		m_we,
		i_re,		d_re, 		m_re,
		i_hit, 		d_hit,
		i_dirty_in,	d_dirty_in,
		i_dirty_out,	d_dirty_out,
						m_rdy;

wire [7:0] 	i_tag,		d_tag;

wire [13:0] 					m_addr;	

wire [63:0] 	i_out,		d_out,		m_out, 
	    	i_in,		d_in,		m_in;

cache Icache(
	.clk(clk),
	.rst_n(rst_n),
	.addr(i_addr[15:2]),
	.wr_data(i_in),
	.wdirty(i_dirty_in),
	.we(i_we),
	.re(i_re),

	.rd_data(i_out),
	.tag_out(i_tag),
	.hit(i_hit),
	.dirty(i_dirty_out)
);

cache Dcache(
	.clk(clk),
	.rst_n(rst_n),
	.addr(d_addr[15:2]),
	.wr_data(d_in),
	.wdirty(d_dirty_in),
	.we(d_we),
	.re(d_re),

	.rd_data(d_out),
	.tag_out(d_tag),
	.hit(d_hit),
	.dirty(d_dirty_out)
);

cache_control cacheControl(
	.clk(clk), 
	.rst_n(rst_n),
	.i_fetch(i_fetch),
	.i_hit(i_hit), 
	.d_hit(d_hit), 
	.d_dirty(d_dirty_out),
	.m_rdy(m_rdy), 
	.re(re), 
	.we(we),
	.d_tag(d_tag),
	.i_addr(i_addr), 
	.d_addr(d_addr), 
	.wr_data(wrt_data),
	.i_out(i_out),
	.d_out(d_out), 
	.m_out(m_out),

	.i_re(i_re),
	.d_re(d_re),
	.m_re(m_re),
	.i_we(i_we),
	.d_we(d_we),	
	.m_we(m_we),
	.i_dirty_in(i_dirty_in),
	.d_dirty_in(d_dirty_in),
	.rdy(rdy),
	.m_addr(m_addr),
	.i_data(i_in),	
	.d_data(d_in),
	.m_data(m_in),
	.instr(instr),
	.rd_data(rd_data)
);

unified_mem main_memory(
	.clk(clk),
	.rst_n(rst_n),
	.addr(m_addr),
	.re(m_re),
	.we(m_we),
	.wdata(m_data),

	.rd_data(m_out),
	.rdy(m_rdy)
);

endmodule
