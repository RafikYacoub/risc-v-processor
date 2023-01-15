`timescale 1ns / 1ps

// Module Name: MUX
// Authors: Mohamed Ali

module MUX #(parameter n=32)(
    input [n-1:0]A,
    input [n-1:0]B,
    input S,
    output [n-1:0]Out
    );
    assign Out = (S)? B:A;
    
endmodule




module MUX2x4 #(parameter n=32)(
    input [n-1:0]A,
    input [n-1:0]B,
    input [n-1:0]C,
    input [n-1:0]D,
    input [1:0]S,
    output [n-1:0]Out
    );
    assign Out = (S==0)? A:(S==1)? B:(S==2)? C: D;
    
endmodule