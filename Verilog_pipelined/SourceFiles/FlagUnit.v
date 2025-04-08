`timescale 1ns / 1ps

module FlagUnit(
    input   wire [31:0] a, b,
	output  wire cf, zf, vf, sf
);

    wire [31:0] add, op_b;
    
    assign op_b = (~b);
    
    assign {cf, add} = a + op_b + 1'b1;
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
 
endmodule
