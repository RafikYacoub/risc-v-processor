`timescale 1ns / 1ps
`include "defines.v"


// Module Name: processor
// Authors: Rafik Yacoub

module ImmGen (output reg [31:0] Imm, input [31:0] instruction); 

/*
    wire [11:0] imm;
    assign imm = 
	(inst[6] == 1)? {inst[31], inst[7], inst[30:25], inst[11:8]} :  //branches + Jal + Jalr + 
	(inst[5] == 1)? {inst[31:25],inst[11:7]} : 
	(inst[14:12] == 1 || inst[14:12] == 5)? {{7{imm[24]}},inst[24:20]}:
	{inst[31:20]};

    assign gen_out = {{20{imm[11]}}, imm};
    
*/
	//wire[7:0] in = {inst[14:12],inst[6:2]}; //funct 3  + 5 bits of the opcode
	always @(*) begin
		casex (instruction[6:2])
		 `OPCODE_Arith_I   : 	Imm = { {21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20] };                              //arith imm
             `OPCODE_Store     :    Imm = { {21{instruction[31]}}, instruction[30:25], instruction[11:8], instruction[7] };                                 //store
             `OPCODE_Load      : 	Imm = { {21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20] };                               //LOAD
             `OPCODE_LUI       :    Imm = { instruction[31], instruction[30:20], instruction[19:12], 12'b0 };                                              //LUI
             `OPCODE_AUIPC     :    Imm = { instruction[31], instruction[30:20], instruction[19:12], 12'b0 };                                              //AUIPC
             `OPCODE_JAL       : 	Imm = { {12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:25], instruction[24:21], 1'b0 };   //JAL
             `OPCODE_JALR      : 	Imm = { {21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20] };                            //JALR
             `OPCODE_Branch    : 	Imm = { {20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};                         //branch
             default           : 	Imm = { {21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20] };                           // IMM_I

		endcase
	end
endmodule 
