module cpu(clk, rst_n, hlt, pc);

input clk;             // global clock signal
input rst_n;          // reset signal, active on low
output hlt;           // Halt signal
output [15:0] pc; // Program counter

endmodule
