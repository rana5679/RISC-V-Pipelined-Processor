`timescale 1ns / 1ps
`include "defines.v"

module ALUcu(
    input [31:0] inst,
    input [1:0] ALUOp,
    output reg  [3:0] ALUSel
    );
    
    always @* begin
        case (ALUOp) // set the ALU selection based on the ALUOP
            2'b00: ALUSel = `ALU_ADD;
            2'b01: ALUSel = `ALU_SUB;
            2'b10: begin
            case(inst[`IR_funct3])
            `F3_ADD: ALUSel = inst[5] & inst[30]? `ALU_SUB: `ALU_ADD; // inst[5] => R-type
            `F3_XOR: ALUSel = `ALU_XOR;
            `F3_OR: ALUSel = `ALU_OR;
            `F3_AND: ALUSel = `ALU_AND;
            `F3_SLL: ALUSel = `ALU_SLL;
            `F3_SRL: ALUSel = inst[30]? `ALU_SRA: `ALU_SRL;
            `F3_SLT: ALUSel = `ALU_SLT;
            `F3_SLTU: ALUSel = `ALU_SLTU;
                endcase
            end
            default: ALUSel = `ALU_PASS;
        endcase
    end

endmodule
