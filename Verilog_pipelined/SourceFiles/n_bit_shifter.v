`timescale 1ns / 1ps

module n_bit_shifter #(parameter n = 32)(
input signed [n-1:0] a,
input[4:0] shamt,
input[1:0] type,
output reg [n-1:0] r);

 
 always @(*) begin
     case(type)
        2'b00: r = a >> shamt; // SRL
        2'b10: r = a >>> shamt; //SRA
        2'b01: r = a << shamt; // SLL
    endcase
 end   
endmodule
