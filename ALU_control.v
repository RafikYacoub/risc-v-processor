`timescale 1ns / 1ps


// Module Name: ALU_control
// Authors: Mohamed Ali & Rafik Yacoub

module ALU_control(input [1:0] ALUop, input [2:0] funct3, input funct7,
                   output reg [3:0] ALU_sel );


//need awl bit f funct 7 ely hya inst[25] lw ha n3ml l multiplication
// l output ha eb2a 5 bit lw ha n3ml multiplication 3shan ekfy el operations

wire [5:0] sel = {ALUop,funct3,funct7};

always @ (*)
    begin
    casex(sel)
    6'b00xxxx: begin ALU_sel = 4'b0011; end //add 3 (for JALR, stores, loads)
    6'b01xxxx: begin ALU_sel = 4'b0100; end // sub 4 (for branches)

    //R format
    6'b10_111_0: begin ALU_sel = 4'b0000; end //and 0 
    6'b10_110_0: begin ALU_sel = 4'b0001; end //or 1
    6'b10_100_0: begin ALU_sel = 4'b0010; end //xor 2
    6'b10_000_0: begin ALU_sel = 4'b0011; end //add 3
    6'b10_000_1: begin ALU_sel = 4'b0100; end //sub 4
    6'b10_010_0: begin ALU_sel = 4'b0101; end //slt 5
    6'b10_011_0: begin ALU_sel = 4'b0110; end //sltu 6
    6'b10_001_0: begin ALU_sel = 4'b1010; end //sll 10
    6'b10_101_0: begin ALU_sel = 4'b1011; end //srl 11
    6'b10_101_1: begin ALU_sel = 4'b1100; end //sra 12
    
    //I format
    6'b11_111_X: begin ALU_sel = 4'b0000; end //andi 0 
    6'b11_110_X: begin ALU_sel = 4'b0001; end //ori 1
    6'b11_100_X: begin ALU_sel = 4'b0010; end //xori 2
    6'b11_000_X: begin ALU_sel = 4'b0011; end //addi 3
    6'b11_010_X: begin ALU_sel = 4'b0101; end //slti 5
    6'b11_011_X: begin ALU_sel = 4'b0110; end //sltiu 6
    6'b11_001_X: begin ALU_sel = 4'b0111; end //slli 7
    6'b11_101_X: begin ALU_sel = 4'b1000; end //srli 8
    6'b11_101_X: begin ALU_sel = 4'b1001; end //srai 9

    default:   begin ALU_sel = 4'b0000; end

    endcase
    end
endmodule

/*
always @ (*)
    begin
    if (sel[5:4] == 2'b00)
        ALU_sel = 4'b0010;
    else if (sel[5:4] == 2'b01)
        ALU_sel = 4'b0110;
    else if (sel == 6'b100000)
        ALU_sel = 4'b0010;
    else if (sel == 6'b100001)
        ALU_sel = 4'b0110;
    else if (sel == 6'b101110)
        ALU_sel = 4'b0000;
    else if (sel == 6'b101100)
        ALU_sel = 4'b0001;            
    else
        ALU_sel = 4'b0000; 
    end
    */
