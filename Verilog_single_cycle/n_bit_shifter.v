`timescale 1ns / 1ps
/*******************************************************************
*
* Module: module_name.v
* Project: Project_Name
* Author: name and email
* Description: put your description here
*
* Change history: 24/10/23 - Cretad the module and added the shifting logic
* 27/10/24 - fixed some logical errors; change shift operations
*
**********************************************************************/

module n_bit_shifter #(parameter n = 32)(
input signed [n-1:0] a,
input[4:0] shamt,
input[1:0] type,
output reg [n-1:0] r);

 
 always @(*) begin
     case(type)
        2'b00: r = a >> shamt; // SRL
        2'b10: r = a >>> shamt; //SRA
        2'b01: r = a << shamt; // SLL
    endcase
 end   
endmodule
