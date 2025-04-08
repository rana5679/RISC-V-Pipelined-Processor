`timescale 1ns / 1ps
`include "defines.v"

// Nov 8: fixed guidlines and added comments

module InstMem(
input [`PC_W_IN] addr,
output [31:0] data_out);

    // reserve memory space, with each location being 1 word
    reg [31:0] mem [0:`MEM_SIZE - 1];
    
    // return the instruction passed to the input address
    assign data_out = mem[addr];
    
    initial begin
    mem[0] = 32'b  00000000000000000001000010110111;
    mem[1] = 32'b  00000000000000000001000100010111;
    mem[2] = 32'b  00000001000000000000000111101111;
    mem[3] = 32'b  00000000010100010000000100010011;
    mem[4] = 32'b  00000000010100010000000100010011;
    mem[5] = 32'b  00000000000000100000000001100111;
    mem[6] = 32'b  00000001010000000000001001100111;
    mem[7] = 32'b  00000000000100000000000010010011;
    end
endmodule
