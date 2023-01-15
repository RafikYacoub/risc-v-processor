`timescale 1ns / 1ps


// Module Name: ALU
// Authors: Rafik Yacoub

module ALU #(parameter n=32)(
    input [3:0] sel,
    input [n-1:0] A,
    input [n-1:0] B,
    output reg [n-1:0] ALUout,
    output cf, zf, vf, sf
    );
    
    wire cout;
    wire[4:0] shamt;
    wire[31:0] add, not_B, right_shifted;


    assign shamt = B[4:0];
    assign not_B = (~B); 
    assign {cf, add} = sel[0] ? (A + B) : (A + (not_B + 1'b1));
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (A[31] ^ (not_B[31]) ^ add[31] ^ cf);
	
    
    right_shifter shift(A, sel[0], shamt, B[4:0], right_shifted);
    
    always@(*) begin
	case(sel) 
		4'b0000:	ALUout = A & B; //and/i 0
		4'b0001:	ALUout = A | B; //or/i 1
		4'b0010:	ALUout = A ^ B; //xor/i 2
		4'b0011:	ALUout = add; //add/i 3
		4'b0100:	ALUout = add; //sub 4
		4'b0101:	ALUout = {31'b0, (sf != vf)}; //slt/i 5
		4'b0110:	ALUout = {31'b0, (~cf)}; //sltu/i 6
		4'b0111:	ALUout = A << shamt; //slli 7
 		4'b1000:	ALUout = A >> shamt; //srli 8
		4'b1001:	ALUout = right_shifted; //srai 9
		4'b1010:	ALUout = A << B[4:0]; //sll 10
		4'b1011:	ALUout = A >> B[4:0]; //srl 11
		4'b1100:	ALUout = right_shifted; //sra 12
		default:	ALUout = 0;
	endcase
	end


endmodule
