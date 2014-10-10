module cpu(clk, rst_n, hlt, pc);

//** DEFINE I/O INTERFACE **//
input clk;        	// Global clock signal
input rst_n;      	// Reset signal, active on low
output hlt;       	// Halt signal
output [15:0] pc; 	// Program counter

//** DEFINE GLOBAL VARS **//
localparam Z = 0;	// Index for Zero flag
localparam V = 1;	// Index for Overflow flag
localparam N = 2;	// Index for Sign flag

//** DEFINE REGISTERS **//
reg [2:0] FLAG;		// Flag register

IM instr_mem(.clk(clk), addr, rd_en, instr);
DM  data_mem(.clk(clk), addr, re, we, wrt_data, rd_data);
rf  reg_file(.clk(clk), p0_addr, p1_addr, p0, p1, re0, re1, dst_addr, dst, we, .hlt(hlt));

always @(posedge clk or negedge rst_n) begin 
	if (~rst_n) begin
		pc <= 16'h0000;
	end else begin
		
	end
end

endmodule
