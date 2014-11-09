module cpu_tb();

wire [15:0] pc;
wire hlt;
reg clk, rst_n;

cpu iCPU(.clk(clk), .rst_n(rst_n), .hlt(hlt), .pc(pc));
  
always #5 clk = ~clk;

initial begin
	clk = 1'b0;
	rst_n = 1'b1;
	#1 rst_n = 1'b0;
	#5 rst_n = 1'b1;
end

initial begin
	$dumpfile("test.vcd");
	$dumpvars(0, cpu_tb);
end 

initial begin
	#200;
	$finish;
end

endmodule
