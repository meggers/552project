module andv(in1, in2, out, zr);

input[15:0] in1, in2;
output reg[15:0] out;
output reg zr;

always@(*) begin
out = in1 & in2;
if(out == 16'h0000) begin
    zr = 1;
end
else begin
    zr = 0;
end

end
endmodule

