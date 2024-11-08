`timescale 1ns / 1ps


module Registe_load_rst # (parameter n = 12)(input clk, rst, load, input [n-1:0] in, output [n-1:0] out);
    wire [n-1:0] D;
    genvar i;
    
    generate
        for (i = 0; i < n; i = i+1) begin
            // need to add assign inside generate blocks
            assign D[i] = load? in[i]:D[i];
            DFlipFlop DFF (.clk(clk), .rst(rst), .D(D[i]), .Q(out[i]));
        end
    endgenerate
endmodule
