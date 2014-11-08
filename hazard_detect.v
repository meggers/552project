module HDU(instr, write_data, mem_read, pc_write, if_id_write, stall);

input [15:0] instr, write_data;
input mem_read;
output pc_write, if_id_write, stall;

assign pc_write = 1'b1;
assign if_id_write = 1'b1;
assign stall = 1'b0;

endmodule
