`timescale 1ns / 1ps
`include "defines.v"

module Memory(
 input clk, 
    input MemRead, 
    input MemWrite,
    input [`PC] addr, 
    input [31:0] data_in,
    input [2:0] func3, 
    output reg [31:0] data_out
    );

    reg [7:0] mem [0:4*(`MEM_SIZE) - 1];
    
    always @ (negedge clk) begin
       if(MemWrite) // if MemWrite signal is active
           case(func3)
                0: // if the instr is sb
                mem[addr] = data_in[`BYTE_1]; // store the byte at the address
                1: // if the instr is sh
                begin
                 mem[addr] = data_in[`BYTE_1]; // store the byte at the address
                 mem[addr + 1] = data_in[`BYTE_2]; // store the second byte at address + 1
                end
                2: // if the instr is sw
                begin
                 mem[addr] = data_in[`BYTE_1]; // store the byte at the address
                 mem[addr + 1] = data_in[`BYTE_2]; // store the second byte at address + 1
                 mem[addr + 2] = data_in[`BYTE_3]; // store the third byte at address + 2
                 mem[addr + 3] = data_in[`BYTE_4]; // store the fourth byte at address + 3
                end    
            endcase 
     end

 //asynchronous reading
 //can't say always @ MemRead because this means the always block will be executed as long as MemRead "changes"
    always @(*) begin
    if(clk) begin
        data_out = {mem[addr + 3], mem[addr + 2],mem[addr + 1], mem[addr]};
    end
    else begin
        if(MemRead)// if MemRead is active
            case(func3)
                0: // if instr is lb, load the byte at addr and sign-extend
                data_out = {{24{mem[addr][7]}},mem[addr]};
                1: // if instr is lh, load the bytes at addr +1 and addr and sign-extend
                data_out = {{16{mem[addr + 1][7]}}, mem[addr + 1], mem[addr]};
                2:  // if instr is lw, load the bytes at addr + 3, addr+ 2, addr +1 and addr
                data_out = {mem[addr + 3], mem[addr + 2],mem[addr + 1], mem[addr]};
                4: // if instr is lbu, load the byte at addr and zero-extend
                data_out = {{24{1'b0}},mem[addr]};
                5: // if instr is lhu, load the bytes at addr +1 and addr and zero-extend
                data_out = {{16{1'b0}}, mem[addr + 1], mem[addr]};
           endcase
           end
    end

    initial begin
    $readmemh("D:/University/7.Fall 2024/Arch/Project/MS3 Submission/Testcases/Hex Byte/Test 3 byte.hex",mem);
    end

endmodule
