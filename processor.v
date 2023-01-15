
// Module Name: processor
// Authors: Mohamed Ali & Rafik Yacoub

module processor(input clk, rst, SSD_clk, input [1:0] ledSel, input [3:0] ssdSel,
                    output [15:0] LED, output [6:0] ssdisplay, output  [7:0] active);
    
      
    
    wire [31:0] PCin,PCout, instruction,write_data, readData1,readData2,m_out,
    immediate, ALUinput, ALUout, branchAddr, nextAddr, dataOut;
    wire regWrite, branch, memRead,memWrite,ALUsrc, zeroflag, Cout, cout, memToReg;
    wire [1:0] ALUop,branchOutCome,WB;
    wire [3:0] ALU_sel;
    reg [12:0] ssd_out;
    wire cf, zf, vf, sf,compress;
    wire fowA, fowB;
    wire[31:0] ALU1,ALU2;
    wire[9:0] ctrlSignals;
    wire [6:0]memAddr;
    wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_IMM, MEM_WB_Branch, MEM_WB_Next;
    wire [3:0] MEM_WB_Ctrl;
    wire [4:0] MEM_WB_Rd;
    wire [31:0] IF_ID_PC, IF_ID_Inst,IF_ID_nextAddr;
    wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm,ID_EX_nextAddr;
    wire [9:0] ID_EX_Ctrl;
    wire [8:0] ID_EX_Func;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
    wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_PC, EX_MEM_IMM,EX_MEM_nextAddr;
    wire [6:0] EX_MEM_Ctrl;
    wire [4:0] EX_MEM_Rd;
    wire [7:0] EX_MEM_Func;
    wire EX_MEM_Zero, EX_MEM_over, EX_MEM_carry, EX_MEM_sign;

    reg reset;
    initial begin
        reset=1'b1;
    end
    
    
    always @(*)begin
    
    if((dataOut[6:0]==7'b1110011 && dataOut[20] ==1'b0) || dataOut[6:0]==7'b0001111) //checking for FENCE and ECALL
        reset = 1'b1;
    else
        reset = rst;
    end
    
    PC programcounter(clk, reset,          //(dataOut[6:0]==7'b1110011 || dataOut[6:0]==7'b0001111)? 1:  0
    PCin,PCout);
    compression_unit comp(dataOut,instruction, compress);
    Adder next_addr( PCout, (compress)?8:16, 1'b0, nextAddr, cout); 

    //InstMem instruction_memory (PCout[7:2], instruction);
    
    /////FIRST PIPELINE REGSISTER

    
    registers #(96) IF_ID (1'b1,~clk,rst,
    {PCout, instruction,nextAddr }, //dataOut instead of instruction
    {IF_ID_PC,IF_ID_Inst,IF_ID_nextAddr} );
    
    assign LED = (ledSel == 0) ? instruction[15:0] : (ledSel == 1) ? instruction[31:16] : 
        {2'b00,branch,memRead,memToReg,ALUop,memWrite,ALUsrc,regWrite,ALU_sel,zeroflag,(zeroflag & branch)};
    
    register_file RF(IF_ID_Inst[19:15],IF_ID_Inst[24:20],MEM_WB_Rd,
    ~clk,rst, MEM_WB_Ctrl[2],write_data,readData1,readData2); //writeBack
    
    control_unit controller(IF_ID_Inst [6:2], branch, memRead, memToReg, memWrite, ALUsrc, regWrite, ALUop, WB);
   
    MUX #(10) controlMUX({branch, memRead, memToReg, memWrite, ALUsrc, regWrite, ALUop, WB}, 0, (branchOutCome == 2'b10)? 0:1, ctrlSignals);
    
    ImmGen immediate_generator(immediate,  IF_ID_Inst[31:0]); 
    
    //shift_left1 shifter(immediate,new_imm);
    /////SECOND PIPELINE REGSISTER

    
   
     registers #(194) ID_EX (1'b1,clk,rst,
     {ctrlSignals, IF_ID_PC, readData1,readData2, immediate, {IF_ID_Inst[6:2],IF_ID_Inst[30], IF_ID_Inst[14:12]},
      IF_ID_Inst[19:15], IF_ID_Inst[24:20], IF_ID_Inst[11:7],IF_ID_nextAddr}, //not implementing forwarding (rs1,2)
     {ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2,
     ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd,ID_EX_nextAddr} );
    
    
    
    MUX source1(ID_EX_RegR1, write_data, fowA, ALU1 );
    MUX source2(ID_EX_RegR2, write_data, fowB, ALU2 );
    
    MUX alumux(ALU2, ID_EX_Imm, ID_EX_Ctrl[5],ALUinput);
    
    ALU_control ALUselector(ID_EX_Ctrl[3:2], ID_EX_Func[2:0], ID_EX_Func[3],ALU_sel ); //ALU_sel func3
    
    forward_unit forwarding(fowA, fowB, MEM_WB_Ctrl[2], ID_EX_Rs1, ID_EX_Rs2,
                             MEM_WB_Rd  );

    
    ALU Arth_Logic_unit( ALU_sel, ALU1, ALUinput, ALUout,cf, zf, vf, sf);
    
    Adder branching_addr( ID_EX_PC,ID_EX_Imm, 1'b0, branchAddr, Cout); //branchAddr to be propagated
    
     /////THIRD PIPELINE REGSISTER
    
    
     registers #(216) EX_MEM (1'b1,~clk,rst,
     {{ID_EX_Ctrl[9:6],ID_EX_Ctrl[4], ID_EX_Ctrl[1:0]}, branchAddr, cf, zf, vf, sf ,ALUout, ALU2,ID_EX_Rd, //ID_EX_RegR2
      {ID_EX_Func[8:4],ID_EX_Func[2:0]}, ID_EX_PC, ID_EX_Imm,ID_EX_nextAddr},
     {EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_carry, EX_MEM_Zero, EX_MEM_over, EX_MEM_sign,
     EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd, EX_MEM_Func,EX_MEM_PC, EX_MEM_IMM,EX_MEM_nextAddr } );
    
  
    
    branchingUnit branchctrl(EX_MEM_carry, EX_MEM_Zero, EX_MEM_over, EX_MEM_sign, EX_MEM_Ctrl[6], EX_MEM_Func[2:0], EX_MEM_Func[3], EX_MEM_Func[4], EX_MEM_Func[7:5],branchOutCome);
    
    MUX2x4 branchmux (EX_MEM_PC, EX_MEM_ALU_out,nextAddr, EX_MEM_BranchAddOut, branchOutCome , PCin);
    
   
    
    //DataMem DataMemory (clk, EX_MEM_Ctrl[5], EX_MEM_Ctrl[3], EX_MEM_ALU_out[7:2], EX_MEM_RegR2, EX_MEM_Func[2:0], dataOut); 
    
    
    /////FORTH PIPELINE REGSISTER


     
     registers #(169) MEM_WB (1'b1,clk,rst,
     {{EX_MEM_Ctrl[4],EX_MEM_Ctrl[2:0]},dataOut, EX_MEM_ALU_out, EX_MEM_Rd, EX_MEM_IMM, EX_MEM_BranchAddOut,EX_MEM_nextAddr}, // next address here should be visited
     {MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out,
     MEM_WB_Rd, MEM_WB_IMM, MEM_WB_Branch, MEM_WB_Next} ); 
    
    

    MUX dataOutMux(MEM_WB_ALU_out, MEM_WB_Mem_out, MEM_WB_Ctrl[3] ,m_out);
    
    MUX2x4 writeBack (m_out,MEM_WB_Next,MEM_WB_Branch, MEM_WB_IMM ,MEM_WB_Ctrl[1:0], write_data);

    
    MUX #(7) Memmux( EX_MEM_ALU_out[6:0],PCout[8:2], clk,memAddr); //EX_MEM_ALU_out[8:2]
    DataMem memory (clk, 1'b1, EX_MEM_Ctrl[3], memAddr, EX_MEM_RegR2, EX_MEM_Func[2:0], dataOut);

    always @(*) begin
        case (ssdSel)
        4'b0000: ssd_out = PCout[12:0];
        4'b0001: ssd_out = nextAddr[12:0];
        4'b0010: ssd_out = branchAddr[12:0];
        4'b0011: ssd_out = PCin[12:0];
        4'b0100: ssd_out = readData1[12:0];
        4'b0101: ssd_out = readData2[12:0];
        4'b0110: ssd_out = write_data[12:0];
        4'b0111: ssd_out = immediate[12:0];
        4'b1000: ssd_out = immediate[12:0];
        4'b1001: ssd_out = ALUinput[12:0];
        4'b1010: ssd_out = ALUout[12:0];
        4'b1011: ssd_out = dataOut[12:0];
        default: ssd_out = 13'd0;    
        
        endcase
    end
    ssd Display( SSD_clk, ssd_out, active, ssdisplay);
    
    
endmodule