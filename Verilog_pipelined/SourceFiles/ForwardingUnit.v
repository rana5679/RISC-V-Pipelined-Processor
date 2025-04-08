`timescale 1ns / 1ps

module ForwardingUnit(
    input [4:0] ID_EX_rs1_addr,
    input [4:0] ID_EX_rs2_addr, 
    input [4:0] MEM_WB_rd_addr, 
    input MEM_WB_RegWrite, 
    output reg forwardA,
    output reg forwardB
    );

always @(*) begin
if(MEM_WB_RegWrite & MEM_WB_rd_addr != 0 & (MEM_WB_rd_addr == ID_EX_rs1_addr ))
        forwardA = 2'b1;
else
        forwardA = 2'b0;
        
if(MEM_WB_RegWrite & MEM_WB_rd_addr != 0 & (MEM_WB_rd_addr == ID_EX_rs2_addr ))
        forwardB = 2'b1;
    else
        forwardB = 2'b0; 
end
endmodule
