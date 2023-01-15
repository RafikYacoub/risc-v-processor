/*******************************************************************
*
* Module: defines.v
* Project: RV32IMC Processor
* Author: Provided by Dr. Sherif Salama, very small addition for the bonus by Mohamed Fekry.
* Description: to declare some variables that correspond to some specific hardwired numbers. 
*
*
*
**********************************************************************/


`define     IR_rs1          19:15
`define     IR_rs2          24:20
`define     IR_rd           11:7
`define     IR_opcode       6:2
`define     IR_funct3       14:12
`define     IR_funct7       31:25
`define     IR_shamt        24:20

`define     OPCODE_Branch   5'b11_000
`define     OPCODE_Load     5'b00_000
`define     OPCODE_Store    5'b01_000
`define     OPCODE_JALR     5'b11_001
`define     OPCODE_JAL      5'b11_011
`define     OPCODE_Arith_I  5'b00_100
`define     OPCODE_Arith_R  5'b01_100
`define     OPCODE_AUIPC    5'b00_101
`define     OPCODE_LUI      5'b01_101
`define     OPCODE_SYSTEM   5'b11_100 
`define     OPCODE_Custom   5'b10_001

`define     F3_ADD          3'b000
`define     F3_SLL          3'b001
`define     F3_SLT          3'b010
`define     F3_SLTU         3'b011
`define     F3_XOR          3'b100
`define     F3_SRL          3'b101
`define     F3_OR           3'b110
`define     F3_AND          3'b111

`define     LB              3'b000
`define     LH              3'b001
`define     LW              3'b010
`define     LBU             3'b100
`define     LHU             3'b101
`define     SB              3'b000
`define     SH              3'b001
`define     SW              3'b010

`define     BR_BEQ          3'b000
`define     BR_BNE          3'b001
`define     BR_BLT          3'b100
`define     BR_BGE          3'b101
`define     BR_BLTU         3'b110
`define     BR_BGEU         3'b111

`define     OPCODE          IR[`IR_opcode]

`define     SYS_EC_EB       3'b000
