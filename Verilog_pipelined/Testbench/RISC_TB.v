`timescale 1ns / 1ps

module RISC_TB();
    localparam period = 10;
    reg clk, rst;
    reg[1:0] ledSel;
    reg[3:0] ssdSel;
    
    RISC_V risc (.clk(clk), .rst(rst));
    
    initial begin
    clk = 0;
    forever #(period/2) clk = ~clk;
    end
    
    initial begin
    rst = 1;
    #(period)
    rst = 0;
    #(50*period);
    $finish;
    end
endmodule
