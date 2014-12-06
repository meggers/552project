module cache_control(
	clk, rst_n, i_hit, d_hit, d_dirty, m_rdy, re, we,
	d_tag,
	i_addr, d_addr, wr_data,
	d_line, m_line,

	i_re,		d_re,		m_re,
	i_we,		d_we,		m_we,
	i_dirty_in,	d_dirty_in, 	rdy,
	m_addr,
	i_data,	d_data,	m_data
);

assign i_dirty_in = 1'b0;

endmodule
