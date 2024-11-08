`timescale 1ns / 1ps

module RegFile #(parameter n=32)(input clk, rst,RegWrite, input [4:0] rs1_addr, rs2_addr, rd_addr, input [n-1:0] rd,output [n-1:0] rs1, rs2);

reg [n-1:0] RF [31:0];
assign rs1 = RF [rs1_addr];
assign rs2 = RF [rs2_addr];
integer i;

always @(posedge clk , posedge rst) begin
    if(rst) begin
        for(i = 0; i < 32; i = i+1) begin
            RF[i] = 0;
        end
     end
     // the else is important here
    else if (RegWrite && rd_addr != 0) begin
        RF[rd_addr]=rd;
    end
end

endmodule
