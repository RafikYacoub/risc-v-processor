`timescale 1ns / 1ps
`include "defines.v"

// Module Name: control_unit
// Authors: Rafik Yacoub

module control_unit(input [4:0]inst, 
                    output reg branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
                    output reg[1:0] ALUOp, WB);
always @ (*)
    begin
    case(inst)
            `OPCODE_Arith_R: {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WB} = 10'b000_10_001_00;   //Arithamtic
            `OPCODE_Load:    {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WB} = 10'b011_00_011_00;   //Load
            `OPCODE_Store:   {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WB} = 10'b00X_00_110_XX;   //store
            `OPCODE_Branch:  {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WB} = 10'b10X_01_000_XX;   //Branch
            `OPCODE_Arith_I: {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WB} = 10'b000_11_011_00;   //Arithmatic Imm
            `OPCODE_LUI:     {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WB} = 10'b000_XX_0X1_11;   //LUI
            `OPCODE_AUIPC:   {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WB} = 10'b000_XX_0X1_10;   //AUIPC
            `OPCODE_JAL:     {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WB} = 10'b100_XX_0X1_01;   //JAL
            `OPCODE_JALR:    {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WB} = 10'b100_00_011_01;   //JALR
            default:         {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WB} = 10'b000_00_000_00;   //Ebreak
    endcase
    end
    
endmodule
