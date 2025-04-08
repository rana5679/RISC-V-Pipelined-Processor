`timescale 1ns / 1ps
`include "defines.v"

module ControlUnit(
    input [4:0] opcode, 
    output reg isBranch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUOp ,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite,
    output reg jump,
    output reg [1:0] WBSrc);

always @(*) begin
    case(opcode) // set control signals based on the instruction
    `OPCODE_Arith_R: 
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, jump, WBSrc} = 11'b00010001000;
    
    `OPCODE_Arith_I:
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, jump, WBSrc} = 11'b00010011000;
    
    `OPCODE_Load:
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, jump, WBSrc} = 11'b01100011000;
    
    `OPCODE_Store:
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, jump, WBSrc} = 11'b00000110000;
    
    `OPCODE_Branch:
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, jump, WBSrc} = 11'b10001000000;
    
    `OPCODE_JAL:
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, jump, WBSrc} = 11'b00000001111;
    
    `OPCODE_JALR:
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, jump, WBSrc} = 11'b00000011111;
    
    `OPCODE_AUIPC:
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, jump, WBSrc} = 11'b00000001010;
    
    `OPCODE_LUI:
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, jump, WBSrc} = 11'b00000001001;
    
    default: 
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, jump, WBSrc} = 11'b00000000000;
endcase
end

endmodule
