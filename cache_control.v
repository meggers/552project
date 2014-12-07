module cache_control(
	clk, rst_n, i_fetch, i_hit, d_hit, d_dirty, m_rdy, re, we,
	d_tag,
	i_addr, d_addr, wr_data,
	d_line, m_line,

	i_re,		d_re,		m_re,
	i_we,		d_we,		m_we,
	i_dirty_in,	d_dirty_in, 	rdy,
	m_addr,
	i_data,	d_data,	m_data
);

//** PARAMETERS **//
localparam CACHE_READ		= 2'b00;
localparam MEM_READ		= 2'b01;
localparam WRITE_BACK		= 2'b10;
localparam READ_AFTER_WRITE	= 2'b11;

localparam ENABLE	= 1'b1;
localparam DISABLE	= 1'b0;

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
			if ((re | we) & ~d_hit) begin
				if (re & d_dirty) begin
				end else begin
				end

				nextState = MEM_READ;
			end else if (i_fetch & ~i_hit) begin
				m_addr	= i_addr[15:2];
				m_re 	= ENABLE;

				nextState = MEM_READ;
			end else begin
				rdy = ENABLE;
				nextState = CACHE_READ;
			end
		end
		
		MEM_READ : begin
			if (m_rdy) begin

				nextState = CACHE_READ;
			end else if ((re | we) & ~d_hit) begin

				nextState = MEM_READ;
			end else if (i_fetch & ~i_hit) begin

				nextState = MEM_READ;
			end else begin

				nextState = CACHE_READ;
			end
		end

		WRITE_BACK : begin
		end

		READ_AFTER_WRITE : begin
			m_addr = d_addr[15:2];
			m_re = ENABLE;
			nextState = MEM_READ;
		end

		default : begin
		end
	endcase
end

endmodule
