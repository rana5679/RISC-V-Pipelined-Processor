`timescale 1ns / 1ps

// Nov 8: fixed guidlines and added comments

module Register # (parameter n = 12)(
    input clk,
    input rst,
    input load, 
    input [n-1:0] in,
    output [n-1:0] out
    );
     
    wire [n-1:0] D;
    genvar i;
    
    // for loop to generate a chain of D flip flops to form a register
    generate
        for (i = 0; i < n; i = i+1) begin
            // need to add assign inside generate blocks
            assign D[i] = load? in[i]:D[i];
            DFlipFlop DFF (.clk(clk), .rst(rst), .D(D[i]), .Q(out[i]));
        end
    endgenerate
endmodule
