`timescale 1ns / 1ps


// Module Name: Adder
// Authors: Mohamed Ali & Rafik Yacoub

module Adder #(parameter n=32)(
    input [n-1:0] A,
    input [n-1:0] B,
    input Cin,
    output [n-1:0] S,
    output Cout
    );
    
    wire [n-1:0]b;
    
    assign b = (Cin ==1)? ~B+1:B; 
    assign {Cout, S} = A + b;
    
endmodule
