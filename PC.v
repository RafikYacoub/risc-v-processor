`timescale 1ns / 1ps


// Module Name: PC
// Authors: Mohamed Ali

module PC(
    input clk, rst,
    input [31:0] PCin,
    output reg [31:0] count
    );
 
    always@(posedge clk, posedge rst) begin
        if(rst)
            count <= 0;
        else
            count <= PCin;
    end
endmodule
