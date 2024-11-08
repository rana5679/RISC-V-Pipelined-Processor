`timescale 1ns / 1ps

module RCA #(parameter n = 32) (input [n-1:0] A, B , output [n-1:0] out, output c_out); 

genvar i;
wire [n:0] C;

assign C[0] = 1'b0;

generate
    for (i = 0; i < n; i = i + 1) begin
        FA adder (.A(A[i]),.B(B[i]), .Cin(C[i]), .Cout(C[i+1]), .sum(out[i]));
    end
endgenerate

assign c_out = C[n];

endmodule
