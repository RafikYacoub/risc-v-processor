`timescale 1ns / 1ps


// Module Name: forward_unit
// Authors: Mohamed Ali

module forward_unit(output reg  fowA, fowB, input  MEM_regWrite, 
                    input [4:0] ID_rs1, ID_rs2, MEM_rd);

      always@(*) begin
        if(MEM_regWrite == 1 && MEM_rd != 0 && MEM_rd == ID_rs1)
            fowA = 1;
        else
            fowA = 0;
      end
      
      always@(*) begin
        if(MEM_regWrite == 1 && MEM_rd != 0 && MEM_rd == ID_rs2)
            fowB = 1;
        else
            fowB = 0;        
      end
      
endmodule
