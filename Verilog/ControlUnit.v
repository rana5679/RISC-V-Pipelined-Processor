/*******************************************************************
*
* Module: module_name.v
* Project: Project_Name
* Author: name and email
* Description: put your description here
*
* Change history: ??/10/23 - Created Module; Added logic for the supported 5 instructions
                  27/10/2024 - added support for the rest of the RISC-V instructions
                  // Nov 8: fixed guidlines and added comments
*
**********************************************************************/
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
    output reg Jump,
    output reg [1:0] WBSrc);

always @(*) begin
    case(opcode) // set control signals based on the instruction
    `OPCODE_Arith_R: 
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b00010001000;
    
    `OPCODE_Arith_I:
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b00010011000;
    
    `OPCODE_Load:
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b01100011000;
    
    `OPCODE_Store:
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b00x001100xx;
    
    `OPCODE_Branch:
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b10x010000xx;
    
    `OPCODE_JAL:
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b00xxx0x1111;
    
    `OPCODE_JALR:
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b00x00011111;
    
    `OPCODE_AUIPC:
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b00xxx0x1010;
    
    `OPCODE_LUI:
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b00xxx0x1001;
    
    default: 
    {isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b00000000000;
endcase
end

endmodule
