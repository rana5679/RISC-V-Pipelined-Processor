`timescale 1ns / 1ps

// Nov 8: fixed guidlines and added comments

module RCA #(parameter n = 32) (
    input [n-1:0] A,
    input [n-1:0] B,
    output [n-1:0] out,
    output c_out
     ); 
    
    genvar i;
    wire [n:0] C;
    
    // set carry in to zero
    assign C[0] = 1'b0;
    
    // loop to create a chain of full adders
    generate
        for (i = 0; i < n; i = i + 1) begin
            FA adder (.A(A[i]),.B(B[i]), .Cin(C[i]), .Cout(C[i+1]), .sum(out[i]));
        end
    endgenerate
    
    // set carry out as last bit
    assign c_out = C[n];

endmodule
