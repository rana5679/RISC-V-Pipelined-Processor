`timescale 1ns / 1ps

module RegFile #(parameter n = 32)(
    input clk,
    input rst,
    input RegWrite,
    input [4:0] rs1_addr,
    input [4:0] rs2_addr,
    input [4:0] rd_addr,
    input [n-1:0] write_data,
    output [n-1:0] rs1,
    output [n-1:0]  rs2
    );

    // reserve memory for a reg file, each location being of size n
    reg [n-1:0] RF [31:0];
    
    // return in rs1 the data at location rs1_addr
    assign rs1 = RF [rs1_addr];
    
    // return in rs2 the data at location rs2_addr
    assign rs2 = RF [rs2_addr];
    
    integer i;
    
    always @(posedge clk , posedge rst) begin
        if(rst) begin
            for(i = 0; i < 32; i = i+1) begin
                RF[i] = 0;
            end
         end
         // if RegWrite signal is active and the register to be written to is not zero
        else if (RegWrite && rd_addr != 0) begin
            RF[rd_addr] = write_data; // update the register at rd_addr
        end
    end

endmodule
