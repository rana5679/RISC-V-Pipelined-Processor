`timescale 1ns / 1ps

module RISC_Top(input rclk, sclk, rst, input [1:0] ledSel, input [3:0] ssdSel, output [15:0] leds, output [3:0] Anode, output [6:0] LED_out);
wire [12:0] ssd;

RISC_V risc (.clk(rclk), .rst(rst),.ledSel(ledSel), .ssdSel(ssdSel), .leds(leds), .ssd(ssd));

Four_Digit_Seven_Segment_Driver FDSSD ( .clk(sclk), .num(ssd), .Anode(Anode), .LED_out(LED_out));

endmodule
