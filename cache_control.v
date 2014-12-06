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

//** STATES **//
localparam CACHE_READ	= 2'b00;
localparam MEM_READ	= 2'b01;
localparam CACHE_MISS	= 2'b10;
localparam WRITE_BACK	= 2'b11;

//** REGISTERS **//
reg [1:0] state, nextState; 

//** CONTINUOUS ASSIGNS **//
assign i_dirty_in = 1'b0;

//** FSM STATES **//
always $(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		state = CACHE_READ;
	end else begin
		state = nextState;
	end
end

//** FSM LOGIC **//
always @(*) begin
	case (start)
		CACHE_READ : begin
		end
		
		MEM_READ : begin
		end

		CACHE_MISS : begin
		end

		WRITE_BACK : begin
		end

		default : begin
		end
	endcase
end

endmodule
