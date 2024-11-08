/*******************************************************************
*
* Module: module_name.v
* Project: Project_Name
* Author: name and email
* Description: put your description here
*
* Change history: ??/10/23 - Created Module; Added logic for the supported 5 instructions
                  27/10/2024 - added support for the rest of the RISC-V instructions
*
**********************************************************************/
`timescale 1ns / 1ps
`include "defines.v"

module ControlUnit(input [31:0] inst, output reg Branch, MemRead, MemtoReg,
output reg [1:0] ALUOp ,output reg MemWrite, ALUSrc, RegWrite, Jump, output reg [1:0] WBSrc);

always @(*) begin
    case(inst[6:2])
    `OPCODE_Arith_R: 
    {Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b00010001000;
    
    `OPCODE_Arith_I:
    {Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b00010011000;
    
    `OPCODE_Load:
    {Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b01100011000;
    
    `OPCODE_Store:
    {Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b00x001100xx;
    
    `OPCODE_Branch:
    {Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b10x010000xx;
    
    `OPCODE_JAL:
    {Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b00xxx0x1111;
    
    `OPCODE_JALR:
    {Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b00x00011111;
    
    `OPCODE_AUIPC:
    {Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b00xxx0x1010;
    
    `OPCODE_LUI:
    {Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'b00xxx0x1001;
    
    default: 
    {Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc} = 11'bxxxxxxxxxxx;
endcase
end

endmodule
