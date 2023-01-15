`timescale 1ns / 1ps

// Module Name: register_file
// Authors: Mohamed Ali & Rafik Yacoub

module register_file(
    input [4:0] readreg1, readreg2,writereg,
    input clk,rst, regwrite,
    input [31:0] write_data,
    output [31:0] readData1,readData2 
    );
    wire [31:0] q [31:0];    
    reg [31:0] load;
    
    
     
    integer j;
    always @(*) begin
        load = 0;
        for(j = 1; j < 32; j = j + 1)begin    //not enabling write to x0
            if ((j == writereg) && regwrite)
                load[j] = 1;
            else
                load[j] = 0;
        end
    end
    
    

    registers regis0(0,clk,rst,0, q[0]);
    genvar i;
    generate 
        for(i=1;i<32;i=i+1) begin
            registers regis(load[i],clk,rst,write_data, q[i]);
        end
    endgenerate
    
    assign readData1 = q[readreg1];
    assign readData2 = q[readreg2];
    
endmodule
