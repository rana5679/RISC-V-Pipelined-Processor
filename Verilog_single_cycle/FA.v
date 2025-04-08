`timescale 1ns / 1ps

// Nov 8: fixed guidlines and added comments

module FA(
    input A,
    input B,
    input Cin,
    output Cout,
    output sum
    );
    
    /* adds two 1-bit inputs and a carry in and ouputs the result
     in the form of carry out bit and sum*/
    assign {Cout, sum} = A + B + Cin;

endmodule
