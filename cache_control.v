module cache_control(
	clk, rst_n, re, we, i_fetch, wrt_data, stall, instr, rd_data,
	i_hit, 		d_hit, 
			d_dirty, 	m_rdy,
			d_tag,
	i_addr, 	d_addr, 	
	i_out, 		d_out, 		m_out,
					m_re,
	i_we,		d_we,		m_we,
	i_dirty_in,	d_dirty_in, 	
					m_addr,
	i_data,		d_data
);

//** I/O **//
input clk, rst_n, re, we, i_fetch, i_hit, d_hit, d_dirty, m_rdy;
input [7:0] d_tag;
input [15:0] i_addr, d_addr, wrt_data;
input [63:0] i_out, d_out, m_out;

output i_dirty_in;
output reg m_re, i_we, d_we, m_we, d_dirty_in, stall;
output [15:0] instr, rd_data;
output reg [13:0] m_addr;
output reg [63:0] i_data, d_data, m_data;

//** PARAMETERS **//
localparam CACHE_READ		= 2'b00;
localparam MEM_READ		= 2'b01;
localparam WRITE_BACK		= 2'b10;
localparam READ_AFTER_WRITE	= 2'b11;

localparam INSTRUCTION_START 	= 16'h0000;
localparam DATA_START		= 16'hF000;

localparam ENABLE		= 1'b1;
localparam DISABLE		= 1'b0;

//** REGISTERS **//
reg [1:0] state, nextState; 

//** CONTINUOUS ASSIGNS **//
assign i_dirty_in 	= DISABLE; // Will never set dirty

assign instr = ~rst_n ? INSTRUCTION_START : (
	i_addr[1] ? (
		i_addr[0] ? i_out[63:48] : i_out[47:32]
	) : (
		i_addr[0] ? i_out[31:16] : i_out[15:0]
	)
);

assign rd_data = ~rst_n ? DATA_START : (
	d_addr[1] ? (
		d_addr[0] ? d_out[63:48] : d_out[47:32]
	) : (
		d_addr[0] ? d_out[31:16] : d_out[15:0]
	)		
);

//** FSM CONTROLLER **//
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		state <= CACHE_READ;
	end else begin
		state <= nextState;
	end
end

//** FSM LOGIC **//
always @(*) begin

	// Avoid inferring latches
	i_we 		= DISABLE;
	i_data 		= 0;

	d_we 		= DISABLE;
	d_dirty_in 	= DISABLE;
	d_data 		= 0;

	m_we		= DISABLE;
	m_re 		= DISABLE;
	m_addr 		= 0;

	stall 		= ENABLE;

	nextState 	= CACHE_READ;

	case (state)
		// Default State
		// Checking for cache misses and handling as necessary
		//
		CACHE_READ : begin
			// If we were trying to read/write data and missed
			if ((re | we) & ~d_hit) begin
				// Write miss (Write Back Policy)
				if (we & d_dirty) begin
					m_addr 	= {d_tag, d_addr[7:2]};
					m_we 	= ENABLE;
					
					nextState = WRITE_BACK;					
				end else begin
					m_addr 	= d_addr[15:2];
					m_re 	= ENABLE;

					nextState = MEM_READ;
				end

			// If we were trying to fetch an instruction and missed
			end else if (i_fetch & ~i_hit) begin
				m_addr	= i_addr[15:2];
				m_re 	= ENABLE;

				nextState = MEM_READ;

			// If there was no miss
			end else begin
				// Write hit
				if (we) begin
					d_data		= shift_in(d_out, wrt_data, d_addr[1:0]);
					d_dirty_in 	= ENABLE;
					d_we 		= ENABLE;
				end

				stall = DISABLE;
				nextState = CACHE_READ;
			end
		end
		
		// Memory State
		// Waiting for memory to return
		//
		MEM_READ : begin
			// Previous cycle complete
			if (m_rdy) begin
				// Dealing with data request
				if ((re | we) & ~d_hit) begin
					if (we) begin
						d_data		= shift_in(m_out, wrt_data, d_addr[1:0]);
						d_dirty_in 	= ENABLE;
						d_we 		= ENABLE;	
					end else begin
						d_data		= m_out;
						d_we		= ENABLE;
					end

				// Dealing with instruction request	
				end else begin
					i_data 	= m_out;
					i_we 	= ENABLE;
				end

				nextState = CACHE_READ;

			// If we are waiting for data
			end else if ((re | we) & ~d_hit) begin
				m_addr 	= d_addr[15:2];
				m_re 	= ENABLE;

				nextState = MEM_READ;

			// If we are waiting for instruction
			end else if (i_fetch & ~i_hit) begin
				m_addr	= i_addr[15:2];
				m_re 	= ENABLE;

				nextState = MEM_READ;

			// Should not get to this state
			end else begin
				nextState = CACHE_READ;
			end
		end

		// Write Back Policy
		//
		WRITE_BACK : begin
			m_addr 	= {d_tag, d_addr[7:2]};
			m_we 	= ENABLE;

			nextState = m_rdy ? READ_AFTER_WRITE : WRITE_BACK;
		end

		// Memory read after right back
		//
		READ_AFTER_WRITE : begin
			m_addr 	= d_addr[15:2];
			m_re 	= ENABLE;

			nextState = MEM_READ;
		end

		default : begin end
	endcase
end

function [63:0] shift_in;

input [63:0] data_line;
input [15:0] data_in;
input [1:0] shamt;

begin
	case (shamt)
		2'b00 : shift_in = {data_line[63:16], data_in};
		2'b01 : shift_in = {data_line[63:32], data_in, data_line[15:0]};
		2'b10 : shift_in = {data_line[63:48], data_in, data_line[31:0]};
		2'b11 : shift_in = {data_in, data_line[47:0]};
	endcase	
end

endfunction

endmodule
