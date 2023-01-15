`timescale 1ns / 1ps
module RISCV_pipeline_tb();
    reg clk,rst, SSD_clk;
    reg [1:0] ledSel;
    reg [3:0] ssdSel;
    wire [15:0] LED;
    wire [6:0] ssdisplay;
    wire  [7:0] active;
    processor DUT(clk, rst, SSD_clk, ledSel, ssdSel,LED, ssdisplay, active);
    
    initial begin
        clk=0;
        forever #5 clk=~clk;
    end
    
    initial begin
        rst = 1;
        #10 rst=0;
        
        #500;
        $finish;
    end

endmodule
