module cpu(clk, rst_n, hlt, pc);

input clk;        // global clock signal
input rst_n;      // reset signal, active on low
output hlt;       // Halt signal
output [15:0] pc; // Program counter

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
