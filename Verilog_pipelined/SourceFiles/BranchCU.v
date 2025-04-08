`timescale 1ns / 1ps
`include "defines.v"

module BranchCU(
    input cf,
    input zf,
    input sf,
    input vf, 
    input isBranch,
    input [2:0] func3,
    output reg branch);

    always @(*) begin
        if(isBranch) begin // if this instruction is a branch
            case (func3)
                `BR_BEQ: //BEQ
                branch = zf;
                `BR_BNE: //BNE
                branch = ~zf;
                `BR_BLT: //BLT
                branch = (sf != vf);
               `BR_BGE: //BGE
                branch = (sf == vf);
                `BR_BLTU: //BLTU
                branch = ~cf;
                `BR_BGEU: //BGEU
                branch = cf;
            endcase
        end
        else // if the instr is not a branch
            branch = 1'b0;
    end
endmodule
