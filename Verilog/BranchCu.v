`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: module_name.v
* Project: Project_Name
* Author: name and email
* Description: put your description here
*
* Change history: 27/10/23 - Created Module; Added branch logic
*
**********************************************************************/

module BranchCu(input cf,zf,sf,vf, branch, input [2:0] func3, output reg branchSignal);
    always @(*) begin
        if(branch) begin
            case (func3)
                `BR_BEQ: //BEQ
                branchSignal = zf;
                `BR_BNE: //BNE
                branchSignal = ~zf;
                `BR_BLT: //BLT
                branchSignal = (sf != vf);
               `BR_BGE: //BGE
                branchSignal = (sf == vf);
                `BR_BLTU: //BLTU
                branchSignal = ~cf;
                `BR_BGEU: //BGEU
                branchSignal = cf;
            endcase
        end
        else // if the instr is not a branch
            branchSignal = 1'b0;
    end
endmodule
