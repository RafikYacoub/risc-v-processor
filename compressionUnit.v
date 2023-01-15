

// Module Name: compression_unit
// Authors:Rafik Yacoub

module compression_unit(input [31:0] in, output reg [31:0] out, output reg flag);

always @(*) begin
    if (in[1:0]==2'b11) 
        flag = 0;    
    else
        flag = 1;
    end

always @(*) begin
    
    if(in[1:0] == 2'b11)
        out = in;
        
    else begin
        casex(in[15:0])
        //000_1_01001_11111_01           
   		16'b010_x_xxxxx_xxxxx_10: out = {4'b0000,in[3:2],in[12],in[6:4],2'b00,5'b00010,3'b010,in[11:7],7'b0000011}; //c.lwsp = lw rd, offset[7:2](x2)
		16'b110_x_xxxxx_xxxxx_10: out = {4'b0000,in[8:7],in[12],in[6:2],5'b00010,3'b010,in[11:9],2'b00,7'b0100011}; //c.swsp = sw rx2, offset[7:2](x2)
		16'b010_x_xxxxx_xxxxx_00: out = {5'b00000,in[5],in[12:10],in[6],2'b00,2'b01,in[9:7],3'b010,2'b01,in[4:2],7'b0000011}; //c.lw = lw (8+rd), offset[6:2](rs1+8)
		16'b110_x_xxxxx_xxxxx_00: out = {5'b00000,in[5],in[12],2'b01,in[4:2],2'b01,in[9:7],3'b010,in[11:10],in[6],2'b00,7'b0100011}; //c.sw = sw (8+rs2), offset[6:2](8+rs1)
		16'b101_x_xxxxx_xxxxx_01: out = {in[12],in[8],in[10:9],in[6],in[7],in[2],in[11],in[5:3],in[12],{8{in[12]}},5'b00000,7'b1101111}; //c.j = jal x0,offset[11:1]
		16'b001_x_xxxxx_xxxxx_01: out = {in[12],in[8],in[10:9],in[6],in[7],in[2],in[11],in[5:3],in[12],{8{in[12]}},5'b00001,7'b1101111}; //c.jal = jal x1,offset[11:1]
		16'b100_0_xxxxx_00000_10: out = {12'b0,in[11:7],3'b000,5'b00000,7'b1100111}; //c.jr = jalr x0, rs1, 0
		16'b100_1_xxxxx_00000_10: out = {12'b0,in[11:7],3'b000,5'b00001,7'b1100111}; //c.jalr =jalr x1, rs1, 0
		16'b110_x_xxxxx_xxxxx_01: out = {{3{in[12]}},in[12],in[6:5],in[2],5'b00000,2'b01,in[9:7],3'b000,in[11:10],in[4:3],in[12],7'b1100011}; //c.beqz = beq (rs1+8), x0, offset[8:1]
		16'b111_x_xxxxx_xxxxx_01: out = {{3{in[12]}},in[12],in[6:5],in[2],5'b00000,2'b01,in[9:7],3'b001,in[11:10],in[4:3],in[12],7'b1100011}; //c.bnez = bne (rs1+8), x0, offset[8:1]
		16'b010_x_xxxxx_xxxxx_01: out = {{6{in[12]}},in[12],in[6:2],5'b00000,3'b000,in[11:7],7'b0010011}; //c.li = addi rd, x0, imm[5:0]
		16'b011_x_xxxxx_xxxxx_01: out = {{14{in[12]}},in[12],in[6:2],in[11:7],7'b0110111}; //c.lui =lui rd, imm[17:12]
		16'b000_x_xxxxx_xxxxx_01: out = {{6{in[12]}},in[12],in[6:2],in[11:7],3'b000,in[11:7],7'b0010011}; //c.addi = addi rd, rd, imm[5:0]
		16'b011_x_xxxxx_xxxxx_01: out = {{2{in[12]}},in[12],in[4:3],in[5],in[2],in[6],4'b0000,5'b00010,3'b000,5'b00010,7'b0010011}; //c.addi16sp = addi x2, x2, imm[9:4]
		16'b000_x_xxxxx_xxxxx_00: out = {2'b00,in[10:7],in[12:11],in[5],in[6],2'b00,5'b00010,3'b000,2'b01,in[4:2],7'b0010011}; //c.addi4spn = addi (8+rd), x2, imm[9:2]
		16'b010_x_xxxxx_xxxxx_10: out = {6'b0,1'b0,in[6:2],in[11:7],3'b001,in[11:7],7'b0010011}; //c.slli = slli rd, rd, shamt[5:0]
		16'b100_x_00xxx_xxxxx_01: out = {6'b0,1'b0,in[6:2],2'b01,in[9:7],3'b101,2'b01,in[9:7],7'b0010011}; //c.srli = srli (8+rd), (8+rs1), shamt[5:0]
		16'b100_x_01xxx_xxxxx_01: out = {2'b01,4'b0,1'b0,in[6:2],2'b01,in[9:7],3'b101,2'b01,in[9:7],7'b0010011}; //c.srai = srai (8+rd), (8+rs1), shamt[5:0]
		16'b100_x_10xxx_xxxxx_01: out = {{6{in[12]}},in[12],in[6:2],2'b01,in[9:7],3'b111,2'b01,in[9:7],7'b0010011}; //c.andi = andi (8+rd), (8+rd), iimm[5:0]
		16'b100_0_xxxxx_xxxxx_10: out = {7'b0,in[6:2],5'b00000,3'b000,in[11:7],7'b0110011}; //c.mv = add rd, x0, rs2
		16'b100_1_xxxxx_xxxxx_10: out = {7'b0,in[6:2],in[11:7],3'b000,in[11:7],7'b0110011}; //c.add = add rd, rd, rs2
		16'b100_0_11xxx_11xxx_01: out = {7'b0,2'b01,in[4:2],2'b01,in[9:7],3'b111,2'b01,in[9:7],7'b0110011}; //c.and = and (8+rd), (8+rd), (8+rs2)
		16'b100_0_11xxx_10xxx_01: out = {7'b0,2'b01,in[4:2],2'b01,in[9:7],3'b110,2'b01,in[9:7],7'b0110011}; //c.or = or (8+rd), (8+rd), (8+rs2)
		16'b100_0_11xxx_01xxx_01: out = {7'b0,2'b01,in[4:2],2'b01,in[9:7],3'b100,2'b01,in[9:7],7'b0110011}; //c.xor = xor (8+rd), (8+rd), (8+rs2)
		16'b100_0_11xxx_00xxx_01: out = {2'b01,5'b0,2'b01,in[4:2],2'b01,in[9:7],3'b000,2'b01,in[9:7],7'b0110011}; //c.sub = sub (8+rd), (8+rd), (8+rs2)
		16'b100_1_00000_00000_10: out = {11'b0,1'b1,13'b0, 7'b1110011}; //c.ebreak = ebreak
		16'b000_0_00000_00000_01: out = {25'b0,7'b0010011}; //c.nop = addi x0,x0,0
		
		default: out= 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
        endcase
    end
end 
endmodule