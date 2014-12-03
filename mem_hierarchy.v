module sys_mem(clk, rst_n, re, we, wrt_data, i_addr, d_addr, instr, i_rdy, d_rdy, rd_data);

input [15:0] i_addr, d_addr, wrt_data;
input clk, rst_n, re, we;

output [15:0] instr, rd_data;
output i_rdy, d_rdy;
	
endmodule
