`timescale 1ns / 1ps
`include "defines.v"

module PCCU(
    input branch, 
    input [4:0] opcode,
    output reg [1:0] PCSrc
    );
    
     always @* begin
         if(opcode == `OPCODE_JALR) // if jalr
           PCSrc = 2'b00;
        else if(branch | opcode == `OPCODE_JAL) // if will branch or a jal instruction
            PCSrc = 2'b01;
         else // could make this into two cases for compression
            PCSrc = 2'b10;
     end
     
endmodule
