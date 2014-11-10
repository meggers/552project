module alu(ALUop, src0, src1, imm, flag_reg, result, flags);

input [15:0] src0, src1, imm;
input [3:0] ALUop;
input [2:0] flag_reg;
output reg [15:0] result;
output reg [2:0] flags; 

localparam ADD    = 4'b0000;
localparam PADDSB = 4'b0001;
localparam SUB 	  = 4'b0010;
localparam AND    = 4'b0011;
localparam NOR    = 4'b0100;
localparam SLL    = 4'b0101;
localparam SRL    = 4'b0110;
localparam SRA    = 4'b0111;
localparam LW     = 4'b1000;
localparam SW     = 4'b1001;
localparam LHB    = 4'b1010;
localparam LLB    = 4'b1011;

localparam Z = 0;	// Index for Zero flag
localparam V = 1;	// Index for Overflow flag
localparam N = 2;	// Index for Sign flag

reg neg, ov, zr;
always @ (*) begin
	flags = {neg, ov, zr};
end

wire [15:0] add_out, sub_out, shift_out;
wire add_zr, add_ng, add_ov,
     sub_zr, sub_ng, sub_ov;

sub subv(
    .in1 (src0), 
    .in2 (src1), 

    .out (sub_out), 
    .zr (sub_zr), 
    .neg (sub_neg), 
    .ov (sub_ov)
);

adder add(
    .in1 (src0), 
    .in2 (src1), 

    .out (add_out), 
    .zr (add_zr), 
    .neg (add_neg), 
    .ov (add_ov)
);

wire [15:0] padd_out;
paddsb padd(
    .in1 (src0),
    .in2 (src1),
    .out (padd_out)
);

wire [15:0] and_out;
wire and_zr;
andv andALU(
    .in1 (src0),
    .in2 (src1),
    .out (and_out),
    .zr (and_zr)
);

wire [15:0] nor_out;
wire nor_zr;
norv norALUE(
    .in1 (src0),
    .in2 (src1),
    .out (nor_out),
    .zr (nor_zr)
);

wire shift_zr;
shifter shift(
    .src (src0),
    .shamt (src1[3:0]),
    .out (shift_out),
    .dir (ALUop[1:0]),
    .zr (shift_zr)
);

always@(*) begin
    if(ALUop == SUB) begin
	result = sub_out;
	ov  = sub_ov;
	zr  = sub_zr;
	neg = sub_neg;
    end else if(ALUop == ADD) begin
        result = add_out;
        ov  = add_ov;
        zr  = add_zr;
        neg = add_neg;
    end else if(ALUop == PADDSB) begin
        result = padd_out;
        ov  = flag_reg[V];
        zr  = flag_reg[Z];
        neg = flag_reg[N];
    end else if(ALUop == AND) begin
        result = and_out;
        ov  = flag_reg[V];
        zr  = and_zr;
        neg = flag_reg[N];
    end else if(ALUop == NOR) begin
        result = nor_out;
        ov  = flag_reg[V];
        zr  = nor_zr;
        neg = flag_reg[N];
    end else if(ALUop == SLL) begin
        result = shift_out;
        ov  = flag_reg[V];
        zr = shift_zr;
        neg = flag_reg[N];
    end else if(ALUop == SRL) begin
        result = shift_out;
        ov  = flag_reg[V];
        zr = shift_zr;
        neg = flag_reg[N];
    end else if(ALUop == SRA) begin
        result = shift_out;
        ov  = flag_reg[V];
        zr = shift_zr;
        neg = flag_reg[N]; 
    end else if(ALUop == LW) begin
        result = imm + src0;
        ov  = flag_reg[V];
        zr  = flag_reg[Z];
        neg = flag_reg[N];
    end else if (ALUop == SW) begin
        result = imm + src0;
        ov  = flag_reg[V];
        zr  = flag_reg[Z];
        neg = flag_reg[N];
    end else if (ALUop == LHB) begin
        result = {imm[7:0], src0[7:0]};
        ov  = flag_reg[V];
        zr  = flag_reg[Z];
        neg = flag_reg[N];
    end else if (ALUop == LLB) begin
	result = imm;
        ov  = flag_reg[V];
        zr  = flag_reg[Z];
        neg = flag_reg[N];
    end else begin
	result = 16'h0000;
        ov  = flag_reg[V];
        zr  = flag_reg[Z];
        neg = flag_reg[N];
    end   
end          

endmodule
