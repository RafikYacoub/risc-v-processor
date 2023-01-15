
module right_shifter(input[31:0] in1, input type, input[4:0] shamt, in2, output reg[31:0] shifted);

    integer i;
    always @(*) begin
        shifted = in1;
        
        case (type)    //0:R ,    1:I
        
            1'b0: begin
                for(i=0; i<in2; i=i+1)
                    shifted = {in1[31], shifted[31:1]}; //SRA 
            end
            
            1'b1: begin
                for(i=0; i<shamt; i=i+1)
                    shifted = {in1[31], shifted[31:1]}; //SRAI        
            end
            
        endcase
    end
    
endmodule