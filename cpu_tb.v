module cpu_tb();

wire [15:0] pc;
reg clk = 0;
reg rst_n = 0;

//////////////////////
// Instantiate CPU //
////////////////////
cpu iCPU(.clk(clk), .rst_n(rst_n), .hlt(hlt), .pc(pc));
  
always #5 clk = ~clk;

initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,cpu_tb);
	#25;
  $finish;
end 
endmodule
