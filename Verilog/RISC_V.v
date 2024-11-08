/*******************************************************************
*
* Module: module_name.v
* Project: Project_Name
* Author: name and email
* Description: put your description here
*
* Change history: ??/10/23 - Created Module; ????
                  27/10/2024 added new ALU and ImmGen, added WriteBack logic, added brnach CU, pc logic
*
**********************************************************************/

`timescale 1ns / 1ps
`include "defines.v"

// input [1:0] ledSel, input [3:0] ssdSel, output [15:0] leds, output [12:0] ssd
// seeminglu unknown syntax error with an empty module: check after module definition
module RISC_V(input clk, rst,input [1:0] ledSel, input [3:0] ssdSel, output reg [15:0] leds, output reg [12:0] ssd);

    wire [11:0] pc_in_1, pc_in_2, pc_out;
    reg [11:0] pc_in;
    wire [31:0] inst;
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, cf, zf, vf, sf, branchDec, Jump;
    wire[1:0] ALUOp, WBSrc;
    wire [31:0] rs1, rs2 , imm, ALU_out, mem_out, shift1_out, alu_in2, auipc_res;
    wire  [3:0] ALUSel;
    reg [31:0] write_data;
    wire [4:0] sh;
    
    
    // PC adder 1 (PC + 4)
    RCA #(.n(32)) pc_4 (.A(pc_out), .B(4) , .out(pc_in_1)); 
    // PC adder 2 this computes the value for branch/ jal/ auipc
    RCA #(.n(32)) target_adder (.A(pc_out), .B(imm) , .out(pc_in_2)); 
    // AUIPC adder
    RCA #(.n(32)) AUIPC_adder (.A({20'b0,pc_out}), .B(imm) , .out(auipc_res));
    
    //PC control
    always @* begin
        if(branchDec | inst[3]) // branch decision is yes or a jal function
            pc_in = pc_in_2;
         else if(inst[`IR_opcode] == `OPCODE_JALR) // if jalr
            pc_in = ALU_out;
         else // could make this into two cases for compression
            pc_in = pc_in_1;
         end
//   assign pc_in = (branchDec | inst[3]) ? pc_in_2 :
//    (inst[`IR_opcode] == `OPCODE_JALR) ? ALU_out :
//     pc_in_1; 

    // PC
    Registe_load_rst PC (.clk(clk), .rst(rst), .load(1'b1),.in(pc_in), .out(pc_out));
    
    // Branch control logic
    BranchCu B_Control (.cf(cf), .zf(zf), .sf(sf), .vf(vf), .branch(Branch), .func3(inst[`IR_funct3]), .branchSignal(branchDec));
    
    // Instruction Memory: change if compressed
    InstMem mem_inst(.addr(pc_out[11:2]),.data_out(inst));
    
    // Control Unit
     ControlUnit CU(.inst(inst), .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg),
    .ALUOp(ALUOp), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .Jump(Jump), .WBSrc(WBSrc));

    // Register File
    RegFile RF (.clk(clk), .rst(rst), .RegWrite(RegWrite), .rs1_addr(inst[19:15]), .rs2_addr(inst[24:20]), .rd_addr(inst[11:7]),
     .rd(write_data),.rs1(rs1), .rs2(rs2));
     
    // immediate generator
    rv32_ImmGen immediate(.IR(inst),.Imm(imm));
    
    // ALU control 
    ALUcu alucu(.inst(inst),.ALUOp(ALUOp), .ALUSel(ALUSel));
    
    //ALU
    assign alu_in2 = (ALUSrc)? imm : rs2; // ALUSrc
    assign sh = (inst[`IR_opcode] == `OPCODE_Arith_I)? inst[`IR_shamt]:rs2;
    prv32_ALU ALU(.a(rs1), .b(alu_in2),.shamt(sh),.r(ALU_out), .cf(cf), .zf(zf), .vf(vf), .sf(sf),.alufn(ALUSel)); // ALU
    
    // Data Memory
     DataMem mem_data (.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .addr(ALU_out[11:0]), .data_in(rs2),.func3(inst[`IR_funct3]), .data_out(mem_out));
    
    // Write Back Mux
    always @* begin
    case (WBSrc)
    0: write_data = MemtoReg? mem_out: ALU_out; // data from WB reg
    1: write_data = imm; // LUI
    2: write_data = auipc_res; // AUIPC
    3: write_data = pc_in_1; // Jal/ Jalr
    endcase
    end
    
    // LED out: NEEDS TO BE MODIFIED
    always @ (*) begin
        case (ledSel)
            2'b00: leds = inst[15:0];
            2'b01: leds = inst[31:16];
            2'b10: leds = {2'b00,ALUSel,zf,zf & Branch,Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc};
         endcase
    end
    
    // ssd out
    always @ (*) begin
        case (ssdSel)
            4'b0000: ssd = pc_out; 
            4'b0001: ssd = pc_in_1;
            4'b0010: ssd = pc_in_2;
            4'b0011: ssd = pc_in;
            4'b0100: ssd = rs1;
            4'b0101: ssd = rs2;
            4'b0110: ssd = write_data;
            4'b0111: ssd = imm;
            4'b1000: ssd = shift1_out;
            // add mux later
            4'b1001: ssd = alu_in2;
            4'b1010: ssd = ALU_out;
            4'b1011: ssd = mem_out;
        endcase
    end
    
endmodule
