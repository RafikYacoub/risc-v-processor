
// Module Name: DataMem
// Authors: Mohamed Ali & Rafik Yacoub

module DataMem 
 (input clk, input MemRead, input MemWrite,
    input [6:0] addr, input [31:0] data_in, input [2:0] func, output reg [31:0] data_out);
    reg [7:0] mem [0:255];

    initial begin
    
    /*  Main test case
        {mem[3],mem[2],mem[1],mem[0]} =   32'h00100093; //addi
        {mem[7],mem[6],mem[5],mem[4]}=    32'h00500113; //addi
        {mem[11],mem[10],mem[9],mem[8]}=  32'h000102b3;
        {mem[15],mem[14],mem[13],mem[12]}=32'h00400193;
        {mem[19],mem[18],mem[17],mem[16]}=32'h00100233;
        {mem[23],mem[22],mem[21],mem[20]}=32'h04320063; //beq out
        {mem[27],mem[26],mem[25],mem[24]}=32'h00510133;
        {mem[31],mem[30],mem[29],mem[28]}=32'h00120233;
        {mem[35],mem[34],mem[33],mem[32]}=32'hfc0008e3; //beq l1
        {mem[39],mem[38],mem[37],mem[36]}=32'h06202c23;//first store
        {mem[43],mem[42],mem[41],mem[40]}=32'h0030c413;
        {mem[47],mem[46],mem[45],mem[44]}=32'h00844433;
        {mem[51],mem[50],mem[49],mem[48]}=32'h03039497;
        //{mem[55],mem[54],mem[53],mem[52]}=32'h00000033;
        {mem[55],mem[54],mem[53],mem[52]}=32'h06901e23;//second store we need to fix the stores as they are overwriting memory locations
        {mem[59],mem[58],mem[57],mem[56]}=32'h07c00303;
        {mem[63],mem[62],mem[61],mem[60]}=32'h00001537;
        {mem[67],mem[66],mem[65],mem[64]}=32'h06a00f23;//third store
        {mem[71],mem[70],mem[69],mem[68]}=32'h00151533;  
        {mem[75],mem[74],mem[73],mem[72]}=32'h00155533;  
        {mem[79],mem[78],mem[77],mem[76]}=32'h00151533;  
        {mem[83],mem[82],mem[81],mem[80]}=32'h40155533;  
        {mem[87],mem[86],mem[85],mem[84]}=32'h0500076f; 
        {mem[91],mem[90],mem[89],mem[88]}=32'h00155533;  
        {mem[95],mem[94],mem[93],mem[92]}=32'h00151533;  
        {mem[99],mem[98],mem[97],mem[96]}=32'h00155533; 
        {mem[103],mem[102],mem[101],mem[100]}=32'h00151533;  
        {mem[107],mem[106],mem[105],mem[104]}=32'hffb00793; //jumping needs fixing
        {mem[111],mem[110],mem[109],mem[108]}=32'h0007a833; 
        {mem[115],mem[114],mem[113],mem[112]}=32'h0007b8b3;
        {mem[119],mem[118],mem[117],mem[116]}=32'h00302913;
        {mem[123],mem[122],mem[121],mem[120]}=32'h00000073;
        */
        //compressed test case
        {mem[1], mem[0]} = 16'b000_0_01001_11111_01;  //addi x9, x9, 31
        {mem[3], mem[2]} = 16'b000_0_01011_10011_01;  //addi x11, x11, 31
        {mem[5], mem[4]} = 16'h8CED;  //and x9, x9, x11



        
        
        




    /*following code is working multiply 4*5
        {mem[3],mem[2],mem[1],mem[0]} =   32'h03802083;
        {mem[7],mem[6],mem[5],mem[4]}=    32'h03c02103;
        {mem[11],mem[10],mem[9],mem[8]}=  32'h000102b3;
        {mem[15],mem[14],mem[13],mem[12]}=32'h04002183;
        {mem[19],mem[18],mem[17],mem[16]}=32'h00100233;
        {mem[23],mem[22],mem[21],mem[20]}=32'h04320063;
        {mem[27],mem[26],mem[25],mem[24]}=32'h00510133;
        {mem[31],mem[30],mem[29],mem[28]}=32'h00120233;
        {mem[35],mem[34],mem[33],mem[32]}=32'hfc0008e3;
        {mem[39],mem[38],mem[37],mem[36]}=32'h04202223;
        */
        
        //{mem[43],mem[42],mem[41],mem[40]}=32'h001373b3;
        //{mem[47],mem[46],mem[45],mem[44]}=32'h40208433;
        //{mem[51],mem[50],mem[49],mem[48]}=32'h00208033;
        //{mem[55],mem[54],mem[53],mem[52]}=32'h001004b3;
        /*
        lw x1, 56(x0) # x1 = 1 where mem[0] =1
    lw x2, 60(x0) # x2 = 5 where mem[1] =5 operand 1
    add x5,x2,x0 # x5 = 5 to be added each cycle
    lw x3, 64(x0) # x3 = 4 where mem[2] =4 operand 2
    add x4, x0, x1 # x4 is counter for addition (how many times we multiplied) x4=1
    L1: beq x4,x3, out
    add x2,x2,x5 #x2 = x2 + x5
    add x4, x4, x1 #x4 = x4 +1
    beq x0,x0,L1
    out: sw x2, 68(x0)*/
        
        //{mem[59],mem[58],mem[57],mem[56]}=32'd1;
        /*{mem[63],mem[62],mem[61],mem[60]}=32'd5;
        {mem[67],mem[66],mem[65],mem[64]}=32'd4;*/
    end

    always @(negedge clk) begin //it was a posedge
        if(MemWrite == 1) begin
            case(func)
                0: mem[addr+128] <= data_in[7:0];
                1: {mem[addr+1+128],mem[addr+128]} <= data_in[15:0];
                2: {mem[addr+3+128], mem[addr+2+128],mem[addr+1+128],mem[addr+128]} <= data_in[31:0];
                default: mem[addr+128] <= mem[addr+128];
            endcase
        end
        else
            mem[addr] = mem[addr];
    end

    always @(*) begin
        if(clk)                                                             
           data_out <= { mem[addr+3], mem[addr+2],mem[addr+1], mem[addr]}; 
        else if (MemRead == 1)
             begin
                case(func)
                    0: data_out <= { {24{mem[addr+128][7]}},mem[addr+128]};
                    1: data_out <= { {16{mem[addr+1+128][7]}},mem[addr+1+128], mem[addr+128]};
                    2: data_out <= { mem[addr+3+128], mem[addr+2+128],mem[addr+1+128], mem[addr+128]};
                    4: data_out <= { {24{1'b0}}, mem[addr+128]};
                    5: data_out <= { {16{1'b0}},mem[addr+1+128], mem[addr+128]};
                    default: data_out <= 0;
                endcase
            end
        else
            data_out <= 0;
    end
endmodule
