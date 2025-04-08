`timescale 1ns / 1ps
`include "defines.v"

module ID_HazardUnit(
    input jump,
    input isBranch,
    input [4:0] rs1_addr,
    input [4:0] rs2_addr, 
    input [4:0] EX_MEM_rd_addr,
    input [4:0] EX_MEM_opcode, 
    output stallA,
    output stallB, 
    output reg [2:0] signalA,
    output reg [2:0] signalB
);

    always @(*) begin
        if (EX_MEM_rd_addr != 0 & (EX_MEM_rd_addr == rs1_addr) & (isBranch | jump)) begin
                case (EX_MEM_opcode)
                    `OPCODE_Arith_I, `OPCODE_Arith_R:
                        signalA = 3'b001;
                    `OPCODE_LUI:
                        signalA = 3'b010;
                    `OPCODE_AUIPC:
                        signalA = 3'b011;
                    `OPCODE_JAL, `OPCODE_JALR:
                        signalA = 3'b100;
                    `OPCODE_Load:
                        signalA = 3'b101;
                endcase
            end
        else
            signalA = 3'b000;
    end
    
    assign stallA = (signalA == 5)? 1: 0;
    
    always @(*) begin
            if (EX_MEM_rd_addr != 0 & (EX_MEM_rd_addr == rs2_addr) & (isBranch | jump)) begin
                    case (EX_MEM_opcode)
                        `OPCODE_Arith_I, `OPCODE_Arith_R:
                            signalB = 3'b001;
                        `OPCODE_LUI:
                            signalB = 3'b010;
                        `OPCODE_AUIPC:
                            signalB = 3'b011;
                        `OPCODE_JAL, `OPCODE_JALR:
                            signalB = 3'b100;
                        `OPCODE_Load:
                            signalB = 3'b101;
                    endcase
                end
            else
                signalB = 3'b000;
        end
        
    assign stallB = (signalB == 5)? 1: 0;
endmodule
