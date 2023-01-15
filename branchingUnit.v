`timescale 1ns / 1ps

`include "defines.v"


// Module Name: branchingUnit
// Authors: Mohamed Ali

module branchingUnit(input carry, zero, over, sign, ctrlBranch, [2:0]funct, input inst_2, inst_3, input[2:0] halt, output reg[1:0] branch);
    
    reg flag;
    initial begin
        flag = 0;
    end
    always@(*) begin
	if(~inst_2) begin 
		if(ctrlBranch) begin
       		 case(funct)
            		`BR_BEQ: flag = zero;           //beq
            		`BR_BNE: flag = ~zero;          //bne
            		`BR_BLT: flag = (sign!=over);   //blt
            		`BR_BGE: flag = (sign == over); //bge
            		`BR_BLTU: flag = ~carry;         //bltu 
            		`BR_BGEU: flag = carry;          //bgeu  
            		default: flag = 0;   
        			endcase
		end
	end
end

always@(*) begin
//branch\JAL(pc = pc+offset): 11,   pc = pc: 00,  JALR(pc = rs1+imm): 01,   pc +=4: 10
    if(inst_2 && ctrlBranch && ~inst_3)
        branch = 2'b01; //jalr
    else if((flag && ctrlBranch)||(inst_2 && ctrlBranch && inst_3))
        branch = 2'b11; //jal or branch (branching address)
    else if(halt == 3'b111)
        branch = 2'b00; //pc (ebreak)
    else
        branch = 2'b10; //next address (normal)
end

endmodule
