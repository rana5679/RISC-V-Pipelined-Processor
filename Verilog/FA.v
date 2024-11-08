`timescale 1ns / 1ps

module FA(input A, B,Cin, output Cout, sum);

assign {Cout, sum} = A + B + Cin;

endmodule
